// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:simplist_app/tasks/data/file_watcher.dart';
import 'package:simplist_app/tasks/data/org_parsing.dart';
import 'package:simplist_app/tasks/domain/project.dart';

final $projectsDirectory = FutureProvider<Directory>((ref) {
  return getApplicationDocumentsDirectory();
});

final $projectRepository = FutureProvider<ProjectRepository>((ref) async {
  return ProjectRepository(
    directory: await ref.watch($projectsDirectory.future),
  );
});

/// Repository that syncs projects between file system and memory.
///
/// Features:
/// - File system is the source of truth
/// - File watching with automatic reload
/// - Simple conflict resolution (last-write-wins with hash comparison)
/// - Debounced writes to prevent thrashing
/// - Directory agnostic (works with any base path)
///
/// Design:
/// - Each .org file = one Project
/// - Project.fileName always matches the actual file
/// - Repository emits `Stream<List<Project>>` for reactive UI
/// - Caching is handled by Riverpod consumers
class ProjectRepository {
  ProjectRepository({
    required Directory directory,
    Duration writeDebounceDuration = const Duration(milliseconds: 500),
  }) : _directory = directory,
       _writeDebounceDuration = writeDebounceDuration,
       _parser = OrgParser(),
       _watcher = OrgFileWatcher(directory: directory);

  final Directory _directory;
  final Duration _writeDebounceDuration;
  final OrgParser _parser;
  final OrgFileWatcher _watcher;

  final _projectsController = StreamController<List<Project>>.broadcast();
  final _writeTimers = <String, Timer>{};
  final _fileHashes = <String, String>{};

  bool _isInitialized = false;
  bool _isWatching = false;

  /// Stream of all projects. Emits when projects change.
  Stream<List<Project>> get projects => _projectsController.stream;

  /// Initialize the repository by loading all projects from disk.
  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    final projects = await _loadAllProjects();
    _isInitialized = true;

    // Emit initial state
    _projectsController.add(projects);
  }

  /// Start watching the directory for changes.
  Future<void> startWatching() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isWatching) {
      return;
    }

    _watcher.start();
    _watcher.events.listen(_handleFileEvent);
    _isWatching = true;
  }

  /// Stop watching the directory.
  Future<void> stopWatching() async {
    if (!_isWatching) {
      return;
    }

    await _watcher.stop();
    _isWatching = false;
  }

  /// Get all projects (loads fresh from disk).
  Future<List<SavedProject>> getAllProjects() async {
    return _loadAllProjects();
  }

  /// Get a specific project by file name.
  Future<SavedProject?> getProject(String fileName) async {
    final filePath = p.join(_directory.path, fileName);
    final file = File(filePath);

    if (!file.existsSync()) {
      return null;
    }

    try {
      return await _loadProjectFromFile(filePath, fileName);
    } catch (e) {
      return null;
    }
  }

  /// Create a new project and save it to disk.
  ///
  /// The project's fileName property is used as the file name.
  /// If the file already exists, throws [ProjectAlreadyExistsException].
  Future<SavedProject> createProject(
    NewProject project, {
    String? fileName,
  }) async {
    final name = fileName ?? '${project.title}.org';
    final filePath = p.join(_directory.path, name);

    // Check if file already exists
    final file = File(filePath);
    if (file.existsSync()) {
      throw ProjectAlreadyExistsException(name);
    }

    final saved = await _writeProjectToFile(
      filePath,
      project,
    );
    _fileHashes[filePath] = await _computeFileHash(filePath);

    // Reload and emit
    final projects = await _loadAllProjects();
    _projectsController.add(projects);

    return saved;
  }

  /// Update an existing project.
  ///
  /// The project's fileName property is used to locate the file.
  ///
  /// This performs conflict detection:
  /// - If the file has been modified externally since last read, it throws
  /// - Use `force: true` to overwrite anyway
  Future<void> updateProject(
    SavedProject project, {
    bool force = false,
  }) async {
    final filePath = p.join(_directory.path, project.fileName);
    final file = File(filePath);

    if (!file.existsSync()) {
      throw ProjectNotFoundException(project.fileName);
    }

    if (!force) {
      // Check for external modifications
      final currentHash = await _computeFileHash(filePath);
      final cachedHash = _fileHashes[filePath];

      if (cachedHash != null && currentHash != cachedHash) {
        // File was modified externally
        throw ProjectConflictException(
          project.fileName,
          'File has been modified externally. Use force=true to overwrite.',
        );
      }
    }

    // Write the update
    await _writeProjectToFile(filePath, project);
    _fileHashes[filePath] = await _computeFileHash(filePath);

    // Reload and emit
    final projects = await _loadAllProjects();
    _projectsController.add(projects);
  }

  /// Rename a project file.
  ///
  /// This changes the fileName on disk and updates the project.
  /// Returns the updated project with the new fileName.
  Future<SavedProject> renameProject(
    SavedProject project,
    String newFileName,
  ) async {
    final oldFilePath = p.join(_directory.path, project.fileName);
    final newFilePath = p.join(_directory.path, newFileName);

    final oldFile = File(oldFilePath);
    if (!oldFile.existsSync()) {
      throw ProjectNotFoundException(project.fileName);
    }

    final newFile = File(newFilePath);
    if (newFile.existsSync()) {
      throw ProjectAlreadyExistsException(newFileName);
    }

    // Create updated project with new fileName
    final updatedProject = project.copyWith(fileName: newFileName);

    // Write to new location
    await _writeProjectToFile(newFilePath, updatedProject);

    // Delete old file
    await oldFile.delete();

    // Update hashes
    _fileHashes.remove(oldFilePath);
    _fileHashes[newFilePath] = await _computeFileHash(newFilePath);

    // Reload and emit
    final projects = await _loadAllProjects();
    _projectsController.add(projects);

    return updatedProject;
  }

  /// Delete a project.
  ///
  /// The project's fileName property is used to locate the file.
  Future<void> deleteProject(SavedProject project) async {
    final filePath = p.join(_directory.path, project.fileName);
    final file = File(filePath);

    if (!file.existsSync()) {
      throw ProjectNotFoundException(project.fileName);
    }

    await file.delete();

    _fileHashes.remove(filePath);
    _writeTimers[filePath]?.cancel();
    _writeTimers.remove(filePath);

    // Reload and emit
    final projects = await _loadAllProjects();
    _projectsController.add(projects);
  }

  /// Reload all projects from disk and emit.
  Future<void> reload() async {
    _fileHashes.clear();
    final projects = await _loadAllProjects();
    _projectsController.add(projects);
  }

  /// Dispose of resources.
  Future<void> dispose() async {
    await stopWatching();
    await _watcher.dispose();
    await _projectsController.close();

    for (final timer in _writeTimers.values) {
      timer.cancel();
    }
    _writeTimers.clear();
  }

  // Private methods

  Future<List<SavedProject>> _loadAllProjects() async {
    final dir = _directory;

    if (!dir.existsSync()) {
      await dir.create(recursive: true);
      return [];
    }

    final projects = <SavedProject>[];

    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.org')) {
        try {
          final fileName = p.basename(entity.path);
          final project = await _loadProjectFromFile(entity.path, fileName);
          projects.add(project);
          _fileHashes[entity.path] = await _computeFileHash(entity.path);
        } catch (e) {
          // Log error but continue loading other files
          // In production, use proper logging
          // ignore: avoid_print
          print('Error loading ${entity.path}: $e');
        }
      }
    }

    return projects;
  }

  Future<SavedProject> _loadProjectFromFile(
    String filePath,
    String fileName,
  ) async {
    final file = File(filePath);
    final content = await file.readAsString();
    final project = _parser.parse(content, fileName: fileName);

    return project;
  }

  Future<SavedProject> _writeProjectToFile(
    String filePath,
    Project project,
  ) async {
    // Cancel any pending write for this file
    _writeTimers[filePath]?.cancel();

    // Debounce the write
    final completer = Completer<SavedProject>();
    _writeTimers[filePath] = Timer(_writeDebounceDuration, () async {
      _writeTimers.remove(filePath);

      try {
        final content = _parser.serialize(project);
        final file = File(filePath);

        // Ensure directory exists
        await file.parent.create(recursive: true);

        await file.writeAsString(content);

        final saved = _parser.parse(content, fileName: p.basename(filePath));
        completer.complete(saved);
      } catch (e) {
        completer.completeError(e);
      }
    });

    return completer.future;
  }

  Future<void> _handleFileEvent(OrgFileEvent event) async {
    final filePath = event.path;

    switch (event.type) {
      case OrgFileEventType.added:
      case OrgFileEventType.modified:
        // Check if this was a write we initiated
        final currentHash = await _computeFileHash(filePath);
        final cachedHash = _fileHashes[filePath];

        if (cachedHash == currentHash) {
          // This was our own write, ignore
          return;
        }

        // External change - reload all and emit
        final projects = await _loadAllProjects();
        _projectsController.add(projects);

      case OrgFileEventType.removed:
        // File was deleted externally - reload all and emit
        _fileHashes.remove(filePath);
        final projects = await _loadAllProjects();
        _projectsController.add(projects);
    }
  }

  Future<String> _computeFileHash(String filePath) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      return '';
    }

    final content = await file.readAsString();
    final bytes = utf8.encode(content);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

/// Exception thrown when a project is not found.
class ProjectNotFoundException implements Exception {
  ProjectNotFoundException(this.fileName);

  final String fileName;

  @override
  String toString() => 'ProjectNotFoundException: Project $fileName not found';
}

/// Exception thrown when a project already exists.
class ProjectAlreadyExistsException implements Exception {
  ProjectAlreadyExistsException(this.fileName);

  final String fileName;

  @override
  String toString() =>
      'ProjectAlreadyExistsException: Project $fileName already exists';
}

/// Exception thrown when there's a conflict (file modified externally).
class ProjectConflictException implements Exception {
  ProjectConflictException(this.fileName, this.message);

  final String fileName;
  final String message;

  @override
  String toString() => 'ProjectConflictException: $fileName - $message';
}
