import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:simplist_app/tasks/data/project_repository.dart';
import 'package:simplist_app/tasks/domain/project.dart';
import 'package:simplist_app/tasks/domain/task.dart';

void main() {
  late Directory tempDir;
  late ProjectRepository repository;

  setUp(() async {
    // Create a temporary directory for tests
    tempDir = await Directory.systemTemp.createTemp('project_repo_test_');
    repository = ProjectRepository(directory: tempDir);
  });

  tearDown(() async {
    // Clean up
    await repository.dispose();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('$ProjectRepository', () {
    group('Initialization', () {
      test('initialize creates directory if not exists', () async {
        await repository.initialize();
        expect(tempDir.existsSync(), isTrue);
      });

      test('getAllProjects returns empty list for empty directory', () async {
        await repository.initialize();
        final projects = await repository.getAllProjects();
        expect(projects, isEmpty);
      });
    });

    group('CRUD Operations', () {
      test('createProject saves project to file', () async {
        await repository.initialize();

        const project = Project(
          id: 'test-1',
          title: 'Test Project',
          tasks: [],
        );

        await repository.createProject(project, fileName: 'test.org');

        // Verify file was created
        final file = File(p.join(tempDir.path, 'test.org'));
        expect(file.existsSync(), isTrue);

        // Verify content
        final content = await file.readAsString();
        expect(content, contains('Test Project'));
      });

      test('createProject throws if file already exists', () async {
        await repository.initialize();

        const project = Project(
          id: 'test-1',
          title: 'Test Project',
          tasks: [],
        );

        await repository.createProject(project, fileName: 'test.org');

        // Try to create again
        expect(
          () => repository.createProject(project, fileName: 'test.org'),
          throwsA(isA<ProjectAlreadyExistsException>()),
        );
      });

      test('getProject returns null for non-existent file', () async {
        await repository.initialize();
        final project = await repository.getProject('nonexistent.org');
        expect(project, isNull);
      });

      test('getProject loads project from file', () async {
        await repository.initialize();

        const project = Project(
          id: 'test-1',
          title: 'Test Project',
          author: 'Test Author',
          tasks: [
            Task(
              id: 'task-1',
              title: 'Test Task',
            ),
          ],
        );

        await repository.createProject(project, fileName: 'test.org');

        final loaded = await repository.getProject('test.org');
        expect(loaded, isNotNull);
        expect(loaded!.title, 'Test Project');
        expect(loaded.author, 'Test Author');
        expect(loaded.tasks.length, 1);
        expect(loaded.tasks.first.title, 'Test Task');
      });

      test('updateProject modifies existing file', () async {
        await repository.initialize();

        const project = Project(
          id: 'test-1',
          title: 'Original Title',
          tasks: [],
        );

        await repository.createProject(project, fileName: 'test.org');

        final updated = project.copyWith(title: 'Updated Title');
        await repository.updateProject('test.org', updated, force: true);

        final loaded = await repository.getProject('test.org');
        expect(loaded!.title, 'Updated Title');
      });

      test('updateProject throws for non-existent file', () async {
        await repository.initialize();

        const project = Project(
          id: 'test-1',
          title: 'Test',
          tasks: [],
        );

        expect(
          () => repository.updateProject('nonexistent.org', project),
          throwsA(isA<ProjectNotFoundException>()),
        );
      });

      test('deleteProject removes file', () async {
        await repository.initialize();

        const project = Project(
          id: 'test-1',
          title: 'Test Project',
          tasks: [],
        );

        await repository.createProject(project, fileName: 'test.org');
        await repository.deleteProject('test.org');

        final file = File(p.join(tempDir.path, 'test.org'));
        expect(file.existsSync(), isFalse);
      });

      test('deleteProject throws for non-existent file', () async {
        await repository.initialize();

        expect(
          () => repository.deleteProject('nonexistent.org'),
          throwsA(isA<ProjectNotFoundException>()),
        );
      });
    });

    group('Multiple Projects', () {
      test('getAllProjects returns all projects', () async {
        await repository.initialize();

        const project1 = Project(
          id: 'test-1',
          title: 'Project 1',
          tasks: [],
        );
        const project2 = Project(
          id: 'test-2',
          title: 'Project 2',
          tasks: [],
        );

        await repository.createProject(project1, fileName: 'project1.org');
        await repository.createProject(project2, fileName: 'project2.org');

        final projects = await repository.getAllProjects();
        expect(projects.length, 2);
        expect(
          projects.map((p) => p.title),
          containsAll(['Project 1', 'Project 2']),
        );
      });

      test('reload refreshes all projects from disk', () async {
        await repository.initialize();

        const project = Project(
          id: 'test-1',
          title: 'Original',
          tasks: [],
        );

        await repository.createProject(project, fileName: 'test.org');

        // Modify file externally
        final file = File(p.join(tempDir.path, 'test.org'));
        final content = await file.readAsString();
        final modified = content.replaceAll('Original', 'Modified');
        await file.writeAsString(modified);

        // Reload
        await repository.reload();

        // Verify
        final loaded = await repository.getProject('test.org');
        expect(loaded!.title, 'Modified');
      });
    });

    group('File Watching', () {
      test('startWatching initializes if not already done', () async {
        await repository.startWatching();
        expect(tempDir.existsSync(), isTrue);
      });

      test('stopWatching can be called multiple times', () async {
        await repository.stopWatching();
        await repository.stopWatching();
        // Should not throw
      });
    });

    group('Round-trip Serialization', () {
      test('create and load preserves task structure', () async {
        await repository.initialize();

        const project = Project(
          id: 'test-1',
          title: 'Complex Project',
          author: 'Test Author',
          tasks: [
            Task(
              id: 'task-1',
              title: 'Parent Task',
              priority: 'A',
              tags: ['work', 'urgent'],
              description: 'This is a description',
              subtasks: [
                Task(
                  id: 'subtask-1',
                  title: 'Subtask 1',
                  status: TaskStatus.done,
                  parentId: 'task-1',
                ),
                Task(
                  id: 'subtask-2',
                  title: 'Subtask 2',
                  parentId: 'task-1',
                ),
              ],
            ),
            Task(
              id: 'task-2',
              title: 'Another Task',
              status: TaskStatus.done,
            ),
          ],
        );

        await repository.createProject(project, fileName: 'complex.org');
        final loaded = await repository.getProject('complex.org');

        expect(loaded, isNotNull);
        expect(loaded!.title, project.title);
        expect(loaded.author, project.author);
        expect(loaded.tasks.length, project.tasks.length);

        final task1 = loaded.tasks.first;
        expect(task1.title, 'Parent Task');
        expect(task1.priority, 'A');
        expect(task1.tags, ['work', 'urgent']);
        expect(task1.description, 'This is a description');
        expect(task1.subtasks.length, 2);
        expect(task1.subtasks[0].title, 'Subtask 1');
        expect(task1.subtasks[0].status, TaskStatus.done);
      });
    });
  });
}
