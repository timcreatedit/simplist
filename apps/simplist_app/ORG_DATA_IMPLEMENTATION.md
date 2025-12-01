# Things 3-like App with Org-mode File-First Implementation

## Overview

This document outlines the implementation of a Things 3-inspired task management app that stores all data locally in Emacs org-mode format using a folder-based structure. The focus is on the data layer, parsing, and serialization, with no UI considerations for the MVP.

## File System Structure

### Folder-Based Organization

```
/data/
  Inbox.org                    # Special file for inbox tasks (no area, no project)
  Personal/                    # Area folder
    Fitness Project.org        # Project file
    Home Maintenance.org       # Another project file
    _area_tasks.org           # Tasks in area but not in specific project
  Work/                        # Another area folder
    Q4 Launch.org             # Work project
    Team Management.org       # Another work project
    _area_tasks.org           # Work tasks not in specific projects
  Someday/                     # Area for future projects
    _area_tasks.org           # Someday tasks
```

### Design Benefits

1. **Natural Organization**: Folders = Areas, Files = Projects mirrors real-world thinking
2. **File System Navigation**: Easy to browse and find projects in file managers
3. **Atomic Operations**: Each project can be edited independently
4. **Version Control Friendly**: Git-friendly with meaningful diffs per project
5. **Performance**: Only parse files that changed
6. **Scalable**: No single large file to manage

## Core Concepts

### Things 3 Features to Support
- **Areas**: Represented as folders containing projects and area-specific tasks
- **Projects**: Individual org files with tasks and optional deadlines
- **Tasks**: Headlines within org files with optional subtasks, descriptions, and due dates
- **Inbox**: Special `Inbox.org` file for unorganized tasks
- **Deadlines**: Hard deadlines for tasks and projects
- **Due Dates**: Soft deadlines for when something should ideally be completed

### Org-mode Mapping Strategy
- **Areas**: Folder names
- **Projects**: File names (without .org extension) + file-level properties
- **Tasks**: Headlines with TODO keywords
- **Properties**: Store metadata like IDs, due dates, deadlines, creation dates
- **Content**: Task descriptions and notes
- **Sub-headlines**: Represent subtasks
- **Tags**: Categories and contexts

## Data Models

### Core Domain Models

```dart
// lib/org_data/domain/models/task.dart
@freezed
sealed class OrgTask with _$OrgTask {
  const factory OrgTask({
    required String id,
    required String title,
    required DateTime created,
    required DateTime updated,
    @Default(TaskStatus.todo) TaskStatus status,
    @Default([]) List<String> tags,
    String? description,
    DateTime? dueDate,
    DateTime? deadline,
    DateTime? completedAt,
    DateTime? scheduledDate,
    String? parentId, // Reference to parent task
    @Default([]) List<OrgTask> subtasks,
    @Default({}) Map<String, String> customProperties,
    
    // Org-mode specific fields for preservation
    @Default('TODO') String todoKeyword,
    String? priority, // A, B, C
    @Default({}) Map<String, dynamic> rawOrgData, // Preserve unsupported org data
  }) = _OrgTask;

  factory OrgTask.fromJson(Map<String, dynamic> json) => _$OrgTaskFromJson(json);
  
  const OrgTask._();
  
  bool get isCompleted => status == TaskStatus.done;
  bool get hasSubtasks => subtasks.isNotEmpty;
}

enum TaskStatus { todo, next, done, cancelled }
```

```dart
// lib/org_data/domain/models/project.dart
@freezed
sealed class OrgProject with _$OrgProject {
  const factory OrgProject({
    required String id,
    required String title,
    required String fileName, // e.g., "Fitness Project.org"
    required String areaName, // Folder name, or "Inbox" for inbox projects
    required DateTime created,
    required DateTime updated,
    @Default(ProjectStatus.active) ProjectStatus status,
    @Default([]) List<String> tags,
    String? description,
    DateTime? dueDate,
    DateTime? deadline,
    DateTime? completedAt,
    @Default([]) List<OrgTask> tasks,
    @Default({}) Map<String, String> customProperties,
    
    // Org-mode specific fields for preservation
    String? priority,
    @Default({}) Map<String, dynamic> rawOrgData,
  }) = _OrgProject;

  factory OrgProject.fromJson(Map<String, dynamic> json) => _$OrgProjectFromJson(json);
  
  const OrgProject._();
  
  bool get isInInbox => areaName == 'Inbox';
  String get filePath => isInInbox ? 'Inbox.org' : '$areaName/$fileName';
}

enum ProjectStatus { active, onHold, completed, cancelled }
```

```dart
// lib/org_data/domain/models/area.dart
@freezed
sealed class OrgArea with _$OrgArea {
  const factory OrgArea({
    required String name, // Folder name
    required DateTime lastModified,
    @Default(true) bool isActive,
    @Default([]) List<OrgProject> projects,
    @Default([]) List<OrgTask> tasks, // From _area_tasks.org
  }) = _OrgArea;

  factory OrgArea.fromJson(Map<String, dynamic> json) => _$OrgAreaFromJson(json);
  
  const OrgArea._();
  
  String get folderPath => name;
  String get areaTasksFilePath => '$name/_area_tasks.org';
}
```

```dart
// lib/org_data/domain/models/workspace.dart
@freezed
sealed class OrgWorkspace with _$OrgWorkspace {
  const factory OrgWorkspace({
    required String basePath,
    required DateTime lastScanned,
    @Default([]) List<OrgArea> areas,
    @Default([]) List<OrgTask> inboxTasks, // From Inbox.org
    @Default([]) List<OrgProject> inboxProjects, // Projects in Inbox.org
  }) = _OrgWorkspace;

  factory OrgWorkspace.fromJson(Map<String, dynamic> json) => _$OrgWorkspaceFromJson(json);
  
  const OrgWorkspace._();
  
  String get inboxFilePath => '$basePath/Inbox.org';
}
```

## Sample File Contents

### Inbox.org
```org
#+TITLE: Inbox
#+FILETAGS: inbox

* TODO Call dentist
:PROPERTIES:
:ID: task-1234
:CREATED: [2024-01-15 Mon]
:DUE: <2024-01-25 Thu>
:END:

Need to schedule annual cleaning and checkup.

* TODO Research vacation destinations
:PROPERTIES:
:ID: task-5678
:CREATED: [2024-01-16 Tue]
:END:

Looking for somewhere warm for March.

* PROJECT Plan wedding
:PROPERTIES:
:ID: project-9999
:CREATED: [2024-01-10 Wed]
:DEADLINE: <2024-08-15 Thu>
:END:

Major project that needs its own file eventually.

** TODO Find venue
:PROPERTIES:
:ID: task-1010
:PARENT_ID: project-9999
:CREATED: [2024-01-10 Wed]
:END:

*** TODO Research 5 potential venues
:PROPERTIES:
:ID: task-1011
:PARENT_ID: task-1010
:CREATED: [2024-01-10 Wed]
:END:
```

### Personal/_area_tasks.org
```org
#+TITLE: Personal Area Tasks
#+FILETAGS: personal

* TODO Schedule annual physical
:PROPERTIES:
:ID: task-9999
:CREATED: [2024-01-15 Mon]
:DUE: <2024-02-15 Thu>
:END:

Time for yearly checkup.

* TODO Update emergency contacts
:PROPERTIES:
:ID: task-8888
:CREATED: [2024-01-16 Tue]
:END:

Need to add new family members to contact list.

* DONE Renew driver's license
:PROPERTIES:
:ID: task-7777
:CREATED: [2024-01-10 Wed]
:COMPLETED: [2024-01-20 Sat]
:END:
```

### Personal/Fitness Project.org
```org
#+TITLE: Fitness Project
#+FILETAGS: personal health fitness
#+DEADLINE: <2024-06-01 Sat>
#+PROPERTY: AREA Personal

Get back in shape and establish sustainable fitness routine.

* TODO Research gym memberships
DEADLINE: <2024-02-01 Thu>
:PROPERTIES:
:ID: task-1111
:CREATED: [2024-01-15 Mon]
:DUE: <2024-01-30 Tue>
:END:

Need to find a gym close to home with good equipment.

** TODO Visit 3 local gyms
:PROPERTIES:
:ID: task-2222
:PARENT_ID: task-1111
:CREATED: [2024-01-15 Mon]
:END:

Get tours and pricing information.

** TODO Compare membership costs
:PROPERTIES:
:ID: task-2223
:PARENT_ID: task-1111
:CREATED: [2024-01-15 Mon]
:END:

* DONE Sign up for nutrition app
:PROPERTIES:
:ID: task-3333
:CREATED: [2024-01-10 Wed]
:COMPLETED: [2024-01-20 Sat]
:END:

Downloaded MyFitnessPal and set up profile.

* TODO Create workout schedule
:PROPERTIES:
:ID: task-4444
:CREATED: [2024-01-16 Tue]
:END:

Plan 3x per week routine.
```

## Parsing Strategy

### File System Scanner

```dart
// lib/org_data/infrastructure/scanner/file_system_scanner.dart
class FileSystemScanner {
  final String basePath;
  
  FileSystemScanner(this.basePath);
  
  Future<OrgWorkspace> scanWorkspace() async {
    final baseDir = Directory(basePath);
    if (!await baseDir.exists()) {
      throw Exception('Base path does not exist: $basePath');
    }
    
    final areas = <OrgArea>[];
    final inboxTasks = <OrgTask>[];
    final inboxProjects = <OrgProject>[];
    
    // Scan for areas (subdirectories)
    await for (final entity in baseDir.list()) {
      if (entity is Directory) {
        final areaName = path.basename(entity.path);
        final area = await _scanArea(areaName, entity.path);
        areas.add(area);
      }
    }
    
    // Scan Inbox.org
    final inboxFile = File(path.join(basePath, 'Inbox.org'));
    if (await inboxFile.exists()) {
      final (tasks, projects) = await _parseInboxFile(inboxFile);
      inboxTasks.addAll(tasks);
      inboxProjects.addAll(projects);
    }
    
    return OrgWorkspace(
      basePath: basePath,
      lastScanned: DateTime.now(),
      areas: areas,
      inboxTasks: inboxTasks,
      inboxProjects: inboxProjects,
    );
  }
  
  Future<OrgArea> _scanArea(String areaName, String areaPath) async {
    final areaDir = Directory(areaPath);
    final projects = <OrgProject>[];
    final areaTasks = <OrgTask>[];
    DateTime? lastModified;
    
    await for (final entity in areaDir.list()) {
      if (entity is File && entity.path.endsWith('.org')) {
        final fileName = path.basename(entity.path);
        final fileStat = await entity.stat();
        
        if (lastModified == null || fileStat.modified.isAfter(lastModified)) {
          lastModified = fileStat.modified;
        }
        
        if (fileName == '_area_tasks.org') {
          // Parse area tasks
          final tasks = await _parseAreaTasksFile(entity);
          areaTasks.addAll(tasks);
        } else {
          // Parse project file
          final project = await _parseProjectFile(entity, areaName);
          projects.add(project);
        }
      }
    }
    
    return OrgArea(
      name: areaName,
      lastModified: lastModified ?? DateTime.now(),
      projects: projects,
      tasks: areaTasks,
    );
  }
}
```

### Org File Parser

```dart
// lib/org_data/infrastructure/parsers/org_file_parser.dart
class OrgFileParser {
  static const Map<String, TaskStatus> statusMapping = {
    'TODO': TaskStatus.todo,
    'NEXT': TaskStatus.next,
    'DONE': TaskStatus.done,
    'CANCELLED': TaskStatus.cancelled,
  };
  
  Future<OrgProject> parseProjectFile(File file, String areaName) async {
    final content = await file.readAsString();
    final orgDoc = OrgDocument.parse(content);
    
    // Extract file-level properties
    final fileProperties = _extractFileProperties(orgDoc);
    final fileName = path.basename(file.path);
    
    final project = OrgProject(
      id: fileProperties['ID'] ?? _generateId(),
      title: fileProperties['TITLE'] ?? path.basenameWithoutExtension(file.path),
      fileName: fileName,
      areaName: areaName,
      created: _parseDate(fileProperties['CREATED']) ?? DateTime.now(),
      updated: _parseDate(fileProperties['UPDATED']) ?? DateTime.now(),
      description: _extractFileDescription(orgDoc),
      deadline: _parseDate(fileProperties['DEADLINE']),
      dueDate: _parseDate(fileProperties['DUE']),
      tasks: _extractTasks(orgDoc),
      customProperties: fileProperties,
      rawOrgData: _preserveFileData(orgDoc),
    );
    
    return project;
  }
  
  Future<List<OrgTask>> parseTasksFile(File file) async {
    final content = await file.readAsString();
    final orgDoc = OrgDocument.parse(content);
    
    return _extractTasks(orgDoc);
  }
  
  List<OrgTask> _extractTasks(OrgDocument doc) {
    final tasks = <OrgTask>[];
    
    for (final section in doc.children.whereType<OrgSection>()) {
      final task = _sectionToTask(section);
      if (task != null) {
        tasks.add(task);
      }
    }
    
    return tasks;
  }
  
  OrgTask? _sectionToTask(OrgSection section) {
    final headline = section.headline;
    if (headline == null) return null;
    
    // Only process sections with TODO keywords
    final keyword = headline.keyword?.value;
    if (keyword == null) return null;
    
    final properties = _extractProperties(section);
    final subtasks = <OrgTask>[];
    
    // Process subsections as subtasks
    for (final child in section.children.whereType<OrgSection>()) {
      final subtask = _sectionToTask(child);
      if (subtask != null) {
        subtasks.add(subtask);
      }
    }
    
    return OrgTask(
      id: properties['ID'] ?? _generateId(),
      title: _cleanTitle(headline.rawTitle),
      created: _parseDate(properties['CREATED']) ?? DateTime.now(),
      updated: _parseDate(properties['UPDATED']) ?? DateTime.now(),
      status: statusMapping[keyword] ?? TaskStatus.todo,
      description: _extractContent(section),
      tags: headline.tags?.map((t) => t.value).toList() ?? [],
      dueDate: _parseDate(properties['DUE']),
      deadline: _parseScheduledOrDeadline(section),
      scheduledDate: _parseScheduled(section),
      completedAt: _parseDate(properties['COMPLETED']),
      parentId: properties['PARENT_ID'],
      subtasks: subtasks,
      todoKeyword: keyword,
      priority: headline.priority?.value,
      customProperties: properties,
      rawOrgData: _preserveSectionData(section),
    );
  }
  
  Map<String, String> _extractProperties(OrgSection section) {
    final properties = <String, String>{};
    
    for (final child in section.children) {
      if (child is OrgDrawer && child.name.toUpperCase() == 'PROPERTIES') {
        for (final property in child.children.whereType<OrgProperty>()) {
          properties[property.key] = property.value;
        }
        break;
      }
    }
    
    return properties;
  }
  
  Map<String, String> _extractFileProperties(OrgDocument doc) {
    final properties = <String, String>{};
    
    for (final child in doc.children) {
      if (child is OrgMeta) {
        properties[child.keyword] = child.value;
      }
    }
    
    return properties;
  }
  
  String? _extractContent(OrgSection section) {
    final contentParts = <String>[];
    
    for (final child in section.children) {
      if (child is OrgParagraph) {
        contentParts.add(child.body);
      } else if (child is OrgPlainText) {
        contentParts.add(child.content);
      }
      // Skip drawers and subsections
    }
    
    final content = contentParts.join('\n').trim();
    return content.isEmpty ? null : content;
  }
  
  DateTime? _parseDate(String? dateString) {
    if (dateString == null) return null;
    
    // Parse org-mode date formats like [2024-01-15 Mon] or <2024-01-15 Mon 10:00>
    final isoMatch = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(dateString);
    if (isoMatch != null) {
      try {
        return DateTime.parse(isoMatch.group(1)!);
      } catch (_) {
        return null;
      }
    }
    
    return null;
  }
  
  DateTime? _parseScheduledOrDeadline(OrgSection section) {
    // Look for DEADLINE: or SCHEDULED: lines
    for (final child in section.children) {
      if (child is OrgPlainText) {
        final deadlineMatch = RegExp(r'DEADLINE:\s*<([^>]+)>').firstMatch(child.content);
        if (deadlineMatch != null) {
          return _parseDate(deadlineMatch.group(1));
        }
      }
    }
    return null;
  }
  
  DateTime? _parseScheduled(OrgSection section) {
    for (final child in section.children) {
      if (child is OrgPlainText) {
        final scheduledMatch = RegExp(r'SCHEDULED:\s*<([^>]+)>').firstMatch(child.content);
        if (scheduledMatch != null) {
          return _parseDate(scheduledMatch.group(1));
        }
      }
    }
    return null;
  }
  
  String _cleanTitle(String rawTitle) {
    // Remove TODO keyword, priority, and tags from title
    return rawTitle
        .replaceAll(RegExp(r'^\s*(TODO|NEXT|DONE|CANCELLED)\s*'), '')
        .replaceAll(RegExp(r'\s*\[#[ABC]\]\s*'), '')
        .replaceAll(RegExp(r'\s*:[^:]+:\s*$'), '')
        .trim();
  }
  
  String _generateId() {
    return 'id-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}';
  }
}
```

## Serialization Strategy

### Org File Serializer

```dart
// lib/org_data/infrastructure/serializers/org_file_serializer.dart
class OrgFileSerializer {
  String serializeProject(OrgProject project) {
    final buffer = StringBuffer();
    
    // File-level properties
    buffer.writeln('#+TITLE: ${project.title}');
    if (project.tags.isNotEmpty) {
      buffer.writeln('#+FILETAGS: ${project.tags.join(' ')}');
    }
    if (project.deadline != null) {
      buffer.writeln('#+DEADLINE: ${_formatOrgDate(project.deadline!)}');
    }
    buffer.writeln('#+PROPERTY: AREA ${project.areaName}');
    
    // Custom file properties
    for (final entry in project.customProperties.entries) {
      if (!_isStandardProperty(entry.key)) {
        buffer.writeln('#+PROPERTY: ${entry.key} ${entry.value}');
      }
    }
    
    buffer.writeln();
    
    // Project description
    if (project.description?.isNotEmpty == true) {
      buffer.writeln(project.description);
      buffer.writeln();
    }
    
    // Tasks
    for (final task in project.tasks) {
      _writeTask(buffer, task, level: 1);
    }
    
    return buffer.toString();
  }
  
  String serializeTasks(List<OrgTask> tasks, {String? title}) {
    final buffer = StringBuffer();
    
    if (title != null) {
      buffer.writeln('#+TITLE: $title');
      buffer.writeln();
    }
    
    for (final task in tasks) {
      _writeTask(buffer, task, level: 1);
    }
    
    return buffer.toString();
  }
  
  void _writeTask(StringBuffer buffer, OrgTask task, {required int level}) {
    final stars = '*' * level;
    final priority = task.priority != null ? ' [#${task.priority}]' : '';
    final tags = task.tags.isNotEmpty ? ' :${task.tags.join(':')}:' : '';
    
    buffer.writeln('$stars ${task.todoKeyword}$priority ${task.title}$tags');
    
    // Scheduled/Deadline dates
    if (task.scheduledDate != null) {
      buffer.writeln('SCHEDULED: ${_formatOrgDate(task.scheduledDate!)}');
    }
    if (task.deadline != null) {
      buffer.writeln('DEADLINE: ${_formatOrgDate(task.deadline!)}');
    }
    
    // Properties drawer
    final properties = <String, String>{
      'ID': task.id,
      'CREATED': _formatDate(task.created),
      'UPDATED': _formatDate(task.updated),
      if (task.dueDate != null) 'DUE': _formatDate(task.dueDate!),
      if (task.completedAt != null) 'COMPLETED': _formatDate(task.completedAt!),
      if (task.parentId != null) 'PARENT_ID': task.parentId!,
      ...task.customProperties,
    };
    
    _writePropertiesDrawer(buffer, properties);
    
    // Description
    if (task.description?.isNotEmpty == true) {
      buffer.writeln();
      buffer.writeln(task.description);
      buffer.writeln();
    }
    
    // Subtasks
    for (final subtask in task.subtasks) {
      _writeTask(buffer, subtask, level: level + 1);
    }
  }
  
  void _writePropertiesDrawer(StringBuffer buffer, Map<String, String> properties) {
    if (properties.isEmpty) return;
    
    buffer.writeln(':PROPERTIES:');
    for (final entry in properties.entries) {
      buffer.writeln(':${entry.key}: ${entry.value}');
    }
    buffer.writeln(':END:');
  }
  
  String _formatOrgDate(DateTime date) {
    final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
    return '<${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $weekday>';
  }
  
  String _formatDate(DateTime date) {
    final weekday = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1];
    return '[${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} $weekday]';
  }
  
  bool _isStandardProperty(String key) {
    const standardProperties = {
      'TITLE', 'FILETAGS', 'DEADLINE', 'AREA', 'ID', 'CREATED', 'UPDATED',
      'DUE', 'COMPLETED', 'PARENT_ID'
    };
    return standardProperties.contains(key);
  }
}
```

## Repository Layer

### File-based Repository

```dart
// lib/org_data/infrastructure/repositories/org_file_repository.dart
class OrgFileRepository {
  final String basePath;
  final FileSystemScanner _scanner;
  final OrgFileParser _parser;
  final OrgFileSerializer _serializer;

  OrgFileRepository(this.basePath)
      : _scanner = FileSystemScanner(basePath),
        _parser = OrgFileParser(),
        _serializer = OrgFileSerializer();

  Future<OrgWorkspace> loadWorkspace() async {
    return await _scanner.scanWorkspace();
  }

  Future<OrgProject> loadProject(String areaName, String fileName) async {
    final filePath = path.join(basePath, areaName, fileName);
    final file = File(filePath);
    
    if (!await file.exists()) {
      throw Exception('Project file not found: $filePath');
    }
    
    return await _parser.parseProjectFile(file, areaName);
  }

  Future<List<OrgTask>> loadAreaTasks(String areaName) async {
    final filePath = path.join(basePath, areaName, '_area_tasks.org');
    final file = File(filePath);
    
    if (!await file.exists()) {
      return [];
    }
    
    return await _parser.parseTasksFile(file);
  }

  Future<List<OrgTask>> loadInboxTasks() async {
    final filePath = path.join(basePath, 'Inbox.org');
    final file = File(filePath);
    
    if (!await file.exists()) {
      return [];
    }
    
    return await _parser.parseTasksFile(file);
  }

  Future<void> saveProject(OrgProject project) async {
    final content = _serializer.serializeProject(project);
    final filePath = path.join(basePath, project.areaName, project.fileName);
    
    // Ensure directory exists
    final directory = Directory(path.dirname(filePath));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    final file = File(filePath);
    await file.writeAsString(content);
  }

  Future<void> saveAreaTasks(String areaName, List<OrgTask> tasks) async {
    final content = _serializer.serializeTasks(tasks, title: '$areaName Area Tasks');
    final filePath = path.join(basePath, areaName, '_area_tasks.org');
    
    // Ensure directory exists
    final directory = Directory(path.dirname(filePath));
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    final file = File(filePath);
    await file.writeAsString(content);
  }

  Future<void> saveInboxTasks(List<OrgTask> tasks) async {
    final content = _serializer.serializeTasks(tasks, title: 'Inbox');
    final filePath = path.join(basePath, 'Inbox.org');
    
    final file = File(filePath);
    await file.writeAsString(content);
  }

  Future<void> createArea(String areaName) async {
    final areaPath = path.join(basePath, areaName);
    final directory = Directory(areaPath);
    
    if (await directory.exists()) {
      throw Exception('Area already exists: $areaName');
    }
    
    await directory.create(recursive: true);
    
    // Create empty _area_tasks.org file
    final areaTasksFile = File(path.join(areaPath, '_area_tasks.org'));
    await areaTasksFile.writeAsString('#+TITLE: $areaName Area Tasks\n#+FILETAGS: ${areaName.toLowerCase()}\n\n');
  }

  Future<void> deleteArea(String areaName) async {
    final areaPath = path.join(basePath, areaName);
    final directory = Directory(areaPath);
    
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  Future<void> deleteProject(String areaName, String fileName) async {
    final filePath = path.join(basePath, areaName, fileName);
    final file = File(filePath);
    
    if (await file.exists()) {
      await file.delete();
    }
  }

  Stream<OrgWorkspace> watchWorkspace() async* {
    final directory = Directory(basePath);
    final watcher = DirectoryWatcher(basePath);
    
    // Initial load
    yield await loadWorkspace();
    
    // Watch for changes
    await for (final event in watcher.events) {
      if (event.path.endsWith('.org') || 
          event.type == ChangeType.ADD && 
          await Directory(event.path).exists()) {
        // Reload on any org file change or directory creation
        try {
          yield await loadWorkspace();
        } catch (e) {
          // Log error but continue watching
          print('Error reloading workspace: $e');
        }
      }
    }
  }
}
```

## Service Layer

### Unified Data Service

```dart
// lib/org_data/application/org_data_service.dart
class OrgDataService {
  final OrgFileRepository _repository;
  
  OrgDataService(this._repository);

  // Workspace
  Stream<OrgWorkspace> watchWorkspace() {
    return _repository.watchWorkspace();
  }

  Future<OrgWorkspace> getWorkspace() {
    return _repository.loadWorkspace();
  }

  // Areas
  Stream<List<OrgArea>> watchAreas() {
    return watchWorkspace().map((workspace) => workspace.areas);
  }

  Future<OrgArea> createArea(String name) async {
    await _repository.createArea(name);
    final workspace = await _repository.loadWorkspace();
    return workspace.areas.firstWhere((area) => area.name == name);
  }

  Future<void> deleteArea(String name) async {
    await _repository.deleteArea(name);
  }

  // Projects
  Stream<List<OrgProject>> watchProjects({String? areaName}) {
    return watchWorkspace().map((workspace) {
      if (areaName != null) {
        final area = workspace.areas.firstWhereOrNull((a) => a.name == areaName);
        return area?.projects ?? [];
      }
      
      return [
        ...workspace.inboxProjects,
        ...workspace.areas.expand((area) => area.projects),
      ];
    });
  }

  Future<OrgProject> createProject({
    required String title,
    required String areaName,
    String? description,
    DateTime? deadline,
  }) async {
    final project = OrgProject(
      id: _generateId(),
      title: title,
      fileName: '$title.org',
      areaName: areaName,
      created: DateTime.now(),
      updated: DateTime.now(),
      description: description,
      deadline: deadline,
    );

    await _repository.saveProject(project);
    return project;
  }

  Future<void> updateProject(OrgProject project) async {
    final updatedProject = project.copyWith(updated: DateTime.now());
    await _repository.saveProject(updatedProject);
  }

  Future<void> deleteProject(OrgProject project) async {
    await _repository.deleteProject(project.areaName, project.fileName);
  }

  // Tasks
  Stream<List<OrgTask>> watchTasks({
    String? projectId,
    String? areaName,
    TaskStatus? status,
    bool includeSubtasks = true,
    bool includeInbox = true,
  }) {
    return watchWorkspace().map((workspace) {
      final allTasks = <OrgTask>[];
      
      // Inbox tasks
      if (includeInbox) {
        allTasks.addAll(workspace.inboxTasks);
        
        // Tasks from inbox projects
        for (final project in workspace.inboxProjects) {
          allTasks.addAll(project.tasks);
        }
      }
      
      // Area tasks
      for (final area in workspace.areas) {
        if (areaName == null || area.name == areaName) {
          // Direct area tasks
          allTasks.addAll(area.tasks);
          
          // Tasks from projects in area
          for (final project in area.projects) {
            if (projectId == null || project.id == projectId) {
              allTasks.addAll(project.tasks);
            }
          }
        }
      }
      
      // Flatten subtasks if requested
      if (includeSubtasks) {
        final flatTasks = <OrgTask>[];
        for (final task in allTasks) {
          flatTasks.add(task);
          flatTasks.addAll(_flattenSubtasks(task));
        }
        allTasks.clear();
        allTasks.addAll(flatTasks);
      }
      
      // Apply status filter
      if (status != null) {
        return allTasks.where((task) => task.status == status).toList();
      }
      
      return allTasks;
    });
  }

  Future<OrgTask> createTask({
    required String title,
    String? description,
    String? projectId,
    String? areaName,
    String? parentTaskId,
    DateTime? dueDate,
    DateTime? deadline,
    List<String> tags = const [],
  }) async {
    final task = OrgTask(
      id: _generateId(),
      title: title,
      description: description,
      dueDate: dueDate,
      deadline: deadline,
      tags: tags,
      parentId: parentTaskId,
      created: DateTime.now(),
      updated: DateTime.now(),
    );

    if (projectId != null) {
      // Add to project
      final workspace = await _repository.loadWorkspace();
      final project = _findProjectById(workspace, projectId);
      if (project != null) {
        final updatedProject = project.copyWith(
          tasks: [...project.tasks, task],
          updated: DateTime.now(),
        );
        await _repository.saveProject(updatedProject);
      }
    } else if (areaName != null) {
      // Add to area tasks
      final areaTasks = await _repository.loadAreaTasks(areaName);
      await _repository.saveAreaTasks(areaName, [...areaTasks, task]);
    } else {
      // Add to inbox
      final inboxTasks = await _repository.loadInboxTasks();
      await _repository.saveInboxTasks([...inboxTasks, task]);
    }

    return task;
  }

  Future<void> updateTask(OrgTask task) async {
    final updatedTask = task.copyWith(updated: DateTime.now());
    
    // Find where this task belongs and update it
    final workspace = await _repository.loadWorkspace();
    
    // Try to find in projects first
    for (final area in workspace.areas) {
      for (final project in area.projects) {
        if (_updateTaskInList(project.tasks, updatedTask)) {
          final updatedProject = project.copyWith(
            tasks: project.tasks,
            updated: DateTime.now(),
          );
          await _repository.saveProject(updatedProject);
          return;
        }
      }
      
      // Try area tasks
      final areaTasks = await _repository.loadAreaTasks(area.name);
      if (_updateTaskInList(areaTasks, updatedTask)) {
        await _repository.saveAreaTasks(area.name, areaTasks);
        return;
      }
    }
    
    // Try inbox
    final inboxTasks = await _repository.loadInboxTasks();
    if (_updateTaskInList(inboxTasks, updatedTask)) {
      await _repository.saveInboxTasks(inboxTasks);
      return;
    }
    
    throw Exception('Task not found: ${task.id}');
  }

  Future<void> deleteTask(String taskId) async {
    final workspace = await _repository.loadWorkspace();
    
    // Similar logic to updateTask but for deletion
    // Implementation would recursively search and remove task
  }

  Future<void> completeTask(String taskId) async {
    final workspace = await _repository.loadWorkspace();
    final task = _findTaskById(workspace, taskId);
    
    if (task != null) {
      final completedTask = task.copyWith(
        status: TaskStatus.done,
        completedAt: DateTime.now(),
        updated: DateTime.now(),
      );
      await updateTask(completedTask);
    }
  }

  // Helper methods
  List<OrgTask> _flattenSubtasks(OrgTask task) {
    final subtasks = <OrgTask>[];
    for (final subtask in task.subtasks) {
      subtasks.add(subtask);
      subtasks.addAll(_flattenSubtasks(subtask));
    }
    return subtasks;
  }

  OrgProject? _findProjectById(OrgWorkspace workspace, String projectId) {
    for (final project in workspace.inboxProjects) {
      if (project.id == projectId) return project;
    }
    
    for (final area in workspace.areas) {
      for (final project in area.projects) {
        if (project.id == projectId) return project;
      }
    }
    
    return null;
  }

  OrgTask? _findTaskById(OrgWorkspace workspace, String taskId) {
    // Search through all tasks recursively
    // Implementation would search inbox, area tasks, and project tasks
    return null; // Placeholder
  }

  bool _updateTaskInList(List<OrgTask> tasks, OrgTask updatedTask) {
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].id == updatedTask.id) {
        tasks[i] = updatedTask;
        return true;
      }
      
      // Check subtasks recursively
      if (_updateTaskInList(tasks[i].subtasks, updatedTask)) {
        return true;
      }
    }
    return false;
  }

  String _generateId() {
    return 'id-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000)}';
  }
}
```

## Provider Layer

```dart
// lib/org_data/presentation/providers/org_data_providers.dart
final orgFileRepositoryProvider = Provider<OrgFileRepository>((ref) {
  // Get base path from app configuration or user preferences
  const basePath = '/Users/username/Documents/OrgData'; // This should be configurable
  return OrgFileRepository(basePath);
});

final orgDataServiceProvider = Provider<OrgDataService>((ref) {
  final repository = ref.watch(orgFileRepositoryProvider);
  return OrgDataService(repository);
});

final workspaceProvider = StreamProvider<OrgWorkspace>((ref) {
  final service = ref.watch(orgDataServiceProvider);
  return service.watchWorkspace();
});

final areasProvider = StreamProvider<List<OrgArea>>((ref) {
  final service = ref.watch(orgDataServiceProvider);
  return service.watchAreas();
});

final projectsProvider = StreamProvider.family<List<OrgProject>, String?>((ref, areaName) {
  final service = ref.watch(orgDataServiceProvider);
  return service.watchProjects(areaName: areaName);
});

final tasksProvider = StreamProvider.family<List<OrgTask>, TaskFilter>((ref, filter) {
  final service = ref.watch(orgDataServiceProvider);
  return service.watchTasks(
    projectId: filter.projectId,
    areaName: filter.areaName,
    status: filter.status,
    includeSubtasks: filter.includeSubtasks,
    includeInbox: filter.includeInbox,
  );
});

@freezed
class TaskFilter with _$TaskFilter {
  const factory TaskFilter({
    String? projectId,
    String? areaName,
    TaskStatus? status,
    @Default(true) bool includeSubtasks,
    @Default(true) bool includeInbox,
  }) = _TaskFilter;
}
```

## File Structure

```
lib/
  org_data/
    domain/
      models/
        task.dart
        project.dart
        area.dart
        workspace.dart
        enums.dart
      
    application/
      org_data_service.dart
      
    infrastructure/
      scanner/
        file_system_scanner.dart
      parsers/
        org_file_parser.dart
        date_parser.dart
      serializers/
        org_file_serializer.dart
      repositories/
        org_file_repository.dart
    
    presentation/
      providers/
        org_data_providers.dart
```

## Implementation Phases

### Phase 1: Core Data Models and File Structure
1. Define Freezed models for Task, Project, Area, Workspace
2. Set up JSON serialization
3. Create basic enums and constants
4. Set up folder structure

### Phase 2: File System Scanner
1. Implement FileSystemScanner to traverse directory structure
2. Identify areas (folders) and projects (org files)
3. Handle special files (Inbox.org, _area_tasks.org)

### Phase 3: Basic Org File Parsing
1. Implement OrgFileParser using org_parser package
2. Extract headlines as tasks with proper hierarchy
3. Parse properties drawers and file-level metadata
4. Handle TODO keywords and task status

### Phase 4: Serialization
1. Implement OrgFileSerializer
2. Generate proper org-mode format from data models
3. Preserve original formatting where possible
4. Handle properties drawers and timestamps

### Phase 5: Repository Layer
1. File-based repository implementation
2. CRUD operations for projects and tasks
3. File watching and change detection
4. Error handling and validation

### Phase 6: Service Layer
1. Unified data service with filtering and querying
2. Business logic for Things 3 features
3. Complex operations like moving tasks between projects

### Phase 7: Provider Layer
1. Riverpod providers for reactive data access
2. Stream-based updates
3. Error handling and loading states

## Testing Strategy

### Unit Tests
- File system scanner with mock directory structures
- Org file parser with various org-mode inputs
- Serializer output validation
- Data model validation and transformations

### Integration Tests  
- Round-trip parsing and serialization
- File repository operations
- Service layer business logic
- Provider layer stream handling

### Test File Structure
Create comprehensive test org files covering:
- Basic tasks, projects, areas
- Complex hierarchies with subtasks
- Various org-mode features (properties, deadlines, tags)
- Edge cases and malformed content

This implementation provides a robust foundation for a Things 3-like app with a clean, file-system-based org-mode data structure that's both human-readable and tool-friendly.