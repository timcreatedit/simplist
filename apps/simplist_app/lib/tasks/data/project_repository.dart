import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:simplist_app/tasks/data/file_watcher.dart';
import 'package:simplist_app/tasks/data/org_parsing.dart';
import 'package:simplist_app/tasks/domain/project.dart';

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
  Future<List<Project>> getAllProjects() async {
    return _loadAllProjects();
  }

  /// Get a specific project by file name.
  Future<Project?> getProject(String fileName) async {
    final filePath = p.join(_directory.path, fileName);
    final file = File(filePath);

    if (!file.existsSync()) {
      return null;
    }

    try {
      return await _loadProjectFromFile(filePath);
    } catch (e) {
      return null;
    }
  }

  /// Create a new project and save it to disk.
  Future<void> createProject(Project project, {String? fileName}) async {
    final name = fileName ?? '${_sanitizeFileName(project.title)}.org';
    final filePath = p.join(_directory.path, name);

    // Check if file already exists
    final file = File(filePath);
    if (file.existsSync()) {
      throw ProjectAlreadyExistsException(name);
    }

    await _writeProjectToFile(filePath, project);
    _fileHashes[filePath] = await _computeFileHash(filePath);

    // Reload and emit
    final projects = await _loadAllProjects();
    _projectsController.add(projects);
  }

  /// Update an existing project.
  ///
  /// This performs conflict detection:
  /// - If the file has been modified externally since last read, it throws
  /// - Then applies the update and saves
  Future<void> updateProject(
    String fileName,
    Project project, {
    bool force = false,
  }) async {
    final filePath = p.join(_directory.path, fileName);
    final file = File(filePath);

    if (!file.existsSync()) {
      throw ProjectNotFoundException(fileName);
    }

    if (!force) {
      // Check for external modifications
      final currentHash = await _computeFileHash(filePath);
      final cachedHash = _fileHashes[filePath];

      if (cachedHash != null && currentHash != cachedHash) {
        // File was modified externally
        throw ProjectConflictException(
          fileName,
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

  /// Delete a project.
  Future<void> deleteProject(String fileName) async {
    final filePath = p.join(_directory.path, fileName);
    final file = File(filePath);

    if (!file.existsSync()) {
      throw ProjectNotFoundException(fileName);
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

  Future<List<Project>> _loadAllProjects() async {
    final dir = _directory;

    if (!dir.existsSync()) {
      await dir.create(recursive: true);
      return [];
    }

    final projects = <Project>[];

    await for (final entity in dir.list()) {
      if (entity is File && entity.path.endsWith('.org')) {
        try {
          final project = await _loadProjectFromFile(entity.path);
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

  Future<Project> _loadProjectFromFile(String filePath) async {
    final file = File(filePath);
    final content = await file.readAsString();
    return _parser.parse(content);
  }

  Future<void> _writeProjectToFile(String filePath, Project project) async {
    // Cancel any pending write for this file
    _writeTimers[filePath]?.cancel();

    // Debounce the write
    final completer = Completer<void>();
    _writeTimers[filePath] = Timer(_writeDebounceDuration, () async {
      _writeTimers.remove(filePath);

      try {
        final content = _parser.serialize(project);
        final file = File(filePath);

        // Ensure directory exists
        await file.parent.create(recursive: true);

        await file.writeAsString(content);
        completer.complete();
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
    if (!await file.exists()) {
      return '';
    }

    final content = await file.readAsString();
    final bytes = utf8.encode(content);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _sanitizeFileName(String name) {
    // Remove or replace invalid file name characters
    return name
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
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
