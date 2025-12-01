import 'package:flutter_test/flutter_test.dart';
import 'package:simplist_app/tasks/data/org_parsing.dart';
import 'package:simplist_app/tasks/domain/task.dart';

void main() {
  group('$OrgParser', () {
    group('parseProject', () {
      test('parses a basic org project', () {
        final parser = OrgParser();
        final project = parser.parse(basicOrgProject);

        expect(project.title, 'House Renovation');
        expect(project.tasks.length, 2);

        expect(project.tasks[0].title, 'Paint the walls');
        expect(project.tasks[0].status.keyword, 'TODO');
        expect(project.tasks[0].deadline, equals(DateTime(2020, 1, 10)));
        expect(project.tasks[0].scheduled, equals(DateTime(2020, 1, 5)));
        expect(project.tasks[0].subtasks, isEmpty);
      });

      test('parses subtasks', () async {
        final parser = OrgParser();
        final project = parser.parse(basicOrgProject);

        expect(project.tasks[1].title, 'Buy paint');
        expect(project.tasks[1].status.keyword, 'DONE');
        expect(project.tasks[1].completedAt, equals(DateTime(2020, 1, 3)));

        expect(
          project.tasks[1].subtasks,
          containsAllInOrder([
            isA<Task>().having((t) => t.title, 'title', 'Choose color'),
            isA<Task>().having((t) => t.title, 'title', 'Go to store'),
            isA<Task>().having((t) => t.title, 'title', 'Purchase paint'),
          ]),
        );
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
