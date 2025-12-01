import 'package:flutter_test/flutter_test.dart';
import 'package:simplist_app/tasks/data/org_parsing.dart';
import 'package:simplist_app/tasks/domain/task.dart';

void main() {
  group('$OrgParser', () {
    late OrgParser parser;

    setUp(() {
      parser = OrgParser();
    });

    group('parse', () {
      test('parses a basic org project', () {
        final project = parser.parse(basicOrgProject);

        expect(project.title, 'House Renovation');
        expect(project.author, 'Tim');
        expect(project.tasks.length, 2);

        expect(project.tasks[0].title, 'Paint the walls');
        expect(project.tasks[0].status.keyword, 'TODO');
        expect(project.tasks[0].deadline, equals(DateTime(2020, 1, 10)));
        expect(project.tasks[0].scheduled, equals(DateTime(2020, 1, 5)));
        expect(project.tasks[0].subtasks, isEmpty);
      });

      test('parses subtasks with parent IDs', () {
        final project = parser.parse(basicOrgProject);

        expect(project.tasks[1].title, 'Buy paint');
        expect(project.tasks[1].status.keyword, 'DONE');
        expect(project.tasks[1].completedAt, equals(DateTime(2020, 1, 3)));

        expect(project.tasks[1].subtasks.length, 3);

        final subtask1 = project.tasks[1].subtasks[0];
        expect(subtask1.title, 'Choose color');
        expect(subtask1.status, TaskStatus.done);
        expect(subtask1.parentId, isNotNull);
        expect(subtask1.parentId, equals(project.tasks[1].id));

        final subtask2 = project.tasks[1].subtasks[1];
        expect(subtask2.title, 'Go to store');
        expect(subtask2.status, TaskStatus.done);
        expect(subtask2.parentId, equals(project.tasks[1].id));

        final subtask3 = project.tasks[1].subtasks[2];
        expect(subtask3.title, 'Purchase paint');
        expect(subtask3.status, TaskStatus.done);
        expect(subtask3.parentId, equals(project.tasks[1].id));
      });

      test('parses tags', () {
        final project = parser.parse(projectWithTags);

        expect(project.tasks[0].title, 'Call plumber');
        expect(project.tasks[0].tags, ['urgent', 'home']);
      });

      test('parses priority', () {
        final project = parser.parse(projectWithPriority);

        expect(project.tasks[0].title, 'Fix critical bug');
        expect(project.tasks[0].priority, 'A');
      });

      test('parses description', () {
        final project = parser.parse(projectWithDescription);

        expect(project.tasks[0].title, 'Write documentation');
        expect(
          project.tasks[0].description,
          contains('Need to document the new API endpoints'),
        );
      });

      test('parses mixed subtask statuses', () {
        final project = parser.parse(projectWithMixedSubtasks);

        expect(project.tasks[0].subtasks.length, 3);
        expect(project.tasks[0].subtasks[0].status, TaskStatus.done);
        expect(project.tasks[0].subtasks[1].status, TaskStatus.todo);
        expect(project.tasks[0].subtasks[2].status, TaskStatus.done);
      });

      test('handles tasks without scheduled or deadline dates', () {
        final project = parser.parse(projectWithoutDates);

        expect(project.tasks[0].title, 'Simple task');
        expect(project.tasks[0].scheduled, isNull);
        expect(project.tasks[0].deadline, isNull);
        expect(project.tasks[0].completedAt, isNull);
      });
    });

    group('serialize', () {
      test('serializes a basic project', () {
        final project = parser.parse(basicOrgProject);
        final serialized = parser.serialize(project);

        expect(serialized, contains('#+title:  House Renovation'));
        expect(serialized, contains('* TODO Paint the walls'));
        expect(serialized, contains('* DONE Buy paint'));
      });

      test('serializes tasks with deadlines and scheduled dates', () {
        final project = parser.parse(basicOrgProject);
        final serialized = parser.serialize(project);

        expect(serialized, contains('DEADLINE: <2020-01-10 Fri>'));
        expect(serialized, contains('SCHEDULED: <2020-01-05 Sun>'));
      });

      test('serializes completed tasks with CLOSED timestamp', () {
        final project = parser.parse(basicOrgProject);
        final serialized = parser.serialize(project);

        expect(serialized, contains('CLOSED: <2020-01-03 Fri>'));
      });

      test('serializes subtasks as checklist', () {
        final project = parser.parse(basicOrgProject);
        final serialized = parser.serialize(project);

        expect(serialized, contains('- [X] Choose color'));
        expect(serialized, contains('- [X] Go to store'));
        expect(serialized, contains('- [X] Purchase paint'));
      });

      test('serializes tags', () {
        final project = parser.parse(projectWithTags);
        final serialized = parser.serialize(project);

        expect(serialized, contains(':urgent:home:'));
      });

      test('serializes priority', () {
        final project = parser.parse(projectWithPriority);
        final serialized = parser.serialize(project);

        expect(serialized, contains('[#A]'));
      });

      test('serializes description', () {
        final project = parser.parse(projectWithDescription);
        final serialized = parser.serialize(project);

        expect(
          serialized,
          contains('Need to document the new API endpoints'),
        );
      });
    });

    group('round-trip', () {
      test('basic project survives parse -> serialize -> parse', () {
        final original = parser.parse(basicOrgProject);
        final serialized = parser.serialize(original);
        final reparsed = parser.parse(serialized);

        expect(reparsed.title, original.title);
        expect(reparsed.tasks.length, original.tasks.length);

        for (var i = 0; i < original.tasks.length; i++) {
          final originalTask = original.tasks[i];
          final reparsedTask = reparsed.tasks[i];

          expect(reparsedTask.title, originalTask.title);
          expect(reparsedTask.status, originalTask.status);
          expect(reparsedTask.deadline, originalTask.deadline);
          expect(reparsedTask.scheduled, originalTask.scheduled);
          expect(reparsedTask.completedAt, originalTask.completedAt);
          expect(reparsedTask.subtasks.length, originalTask.subtasks.length);

          for (var j = 0; j < originalTask.subtasks.length; j++) {
            expect(
              reparsedTask.subtasks[j].title,
              originalTask.subtasks[j].title,
            );
            expect(
              reparsedTask.subtasks[j].status,
              originalTask.subtasks[j].status,
            );
          }
        }
      });

      test('project with tags survives round-trip', () {
        final original = parser.parse(projectWithTags);
        final serialized = parser.serialize(original);
        final reparsed = parser.parse(serialized);

        expect(reparsed.tasks[0].tags, original.tasks[0].tags);
      });

      test('project with priority survives round-trip', () {
        final original = parser.parse(projectWithPriority);
        final serialized = parser.serialize(original);
        final reparsed = parser.parse(serialized);

        expect(reparsed.tasks[0].priority, original.tasks[0].priority);
      });

      test('project with description survives round-trip', () {
        final original = parser.parse(projectWithDescription);
        final serialized = parser.serialize(original);
        final reparsed = parser.parse(serialized);

        expect(reparsed.tasks[0].description, original.tasks[0].description);
      });

      test('project author survives round-trip', () {
        final original = parser.parse(basicOrgProject);
        final serialized = parser.serialize(original);
        final reparsed = parser.parse(serialized);

        expect(reparsed.author, original.author);
        expect(reparsed.author, 'Tim');
      });
    });
  });
}

const basicOrgProject = '''
#+title:  House Renovation
#+author: Tim
#+date:   2020-01-01

* TODO Paint the walls
  DEADLINE: <2020-01-10 Fri>
  SCHEDULED: <2020-01-05 Sun>

* DONE Buy paint
  CLOSED: <2020-01-03 Fri>
  - [X] Choose color
  - [X] Go to store
  - [X] Purchase paint
''';

const projectWithTags = '''
#+title:  Home Maintenance
#+author: Tim
#+date:   2020-01-01

* TODO Call plumber :urgent:home:
  DEADLINE: <2020-01-15 Wed>
''';

const projectWithPriority = '''
#+title:  Bug Fixes
#+author: Tim
#+date:   2020-01-01

* TODO [#A] Fix critical bug
  DEADLINE: <2020-01-12 Sun>
''';

const projectWithDescription = '''
#+title:  Documentation
#+author: Tim
#+date:   2020-01-01

* TODO Write documentation
  DEADLINE: <2020-01-20 Mon>

Need to document the new API endpoints for the client library.
Include examples and common use cases.
''';

const projectWithMixedSubtasks = '''
#+title:  Shopping
#+author: Tim
#+date:   2020-01-01

* TODO Buy groceries
  - [X] Milk
  - [ ] Bread
  - [X] Eggs
''';

const projectWithoutDates = '''
#+title:  Simple Tasks
#+author: Tim
#+date:   2020-01-01

* TODO Simple task
''';
