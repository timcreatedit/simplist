import 'package:org_parser/org_parser.dart';
import 'package:simplist_app/tasks/domain/project.dart';
import 'package:simplist_app/tasks/domain/task.dart';

class OrgParser {
  Project parse(String orgContent) {
    final doc = OrgDocument.parse(orgContent);

    final meta = _extractMetadata(doc);

    if (meta == null) {
      throw Exception('Failed to extract metadata from org document');
    }

    final tasks = _extractTasks(doc);
    return Project(
      id: doc.id,
      title: meta.$1,
      tasks: tasks,
    );
  }

  (String title, String author)? _extractMetadata(OrgDocument doc) {
    final metaSection = switch (doc.children) {
      [OrgContent(children: final meta), ...] => meta,
      _ => <OrgNode>[],
    };

    final metaNodes = metaSection.whereType<OrgMeta>();

    final byKey = {
      for (final node in metaNodes) node.key: node.value,
    };

    try {
      final title = byKey['#+title:']!.toMarkup().trim();
      final author = byKey['#+author:']!.toMarkup().trim();
      return (title, author);
    } on Exception catch (_) {
      return null;
    }
  }

  List<Task> _extractTasks(OrgDocument doc) {
    final tasks = <Task>[];

    bool visitor(OrgSection section) {
      if (section.level == 1) {
        final task = _parseTask(section);
        if (task != null) {
          tasks.add(task);
        }
      }
      return true; // Continue visiting children
    }

    doc.visitSections(visitor);

    return tasks;
  }

  Task? _parseTask(OrgSection section) {
    final headline = section.headline;
    final title = headline.title?.toMarkup();
    final keyword = headline.keyword;

    if (title == null || keyword == null) {
      return null; // Not a valid task
    }

    final status = keyword.done ? TaskStatus.done : TaskStatus.todo;

    DateTime? deadline;
    DateTime? scheduled;
    DateTime? closed;

    bool visitor(OrgNode node) {
      switch (node) {
        case OrgPlanningEntry(
          keyword: OrgPlanningKeyword(content: 'SCHEDULED:'),
          value: OrgSimpleTimestamp(dateTime: final dt),
        ):
          scheduled ??= dt;
        case OrgPlanningEntry(
          keyword: OrgPlanningKeyword(content: 'DEADLINE:'),
          value: OrgSimpleTimestamp(dateTime: final dt),
        ):
          deadline ??= dt;
        case OrgPlanningEntry(
          keyword: OrgPlanningKeyword(content: 'CLOSED:'),
          value: OrgSimpleTimestamp(dateTime: final dt),
        ):
          closed ??= dt;
        default:
          break;
      }

      return true; // Continue visiting children
    }

    section.visit(visitor);

    return Task(
      id: section.id,
      title: title,
      status: status,
      completedAt: closed,
      deadline: deadline,
      scheduled: scheduled,
    );
  }
}
