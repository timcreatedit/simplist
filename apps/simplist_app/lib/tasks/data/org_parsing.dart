import 'package:intl/intl.dart';
import 'package:org_parser/org_parser.dart';
import 'package:simplist_app/tasks/domain/project.dart';
import 'package:simplist_app/tasks/domain/task.dart';

class OrgParser {
  SavedProject parse(String orgContent, {String fileName = 'untitled.org'}) {
    final doc = OrgDocument.parse(orgContent);

    final meta = _extractMetadata(doc);

    if (meta == null) {
      throw Exception('Failed to extract metadata from org document');
    }

    final tasks = _extractTasks(doc);
    return SavedProject(
      id: doc.id,
      title: meta.$1,
      fileName: fileName,
      author: meta.$2,
      tasks: tasks,
    );
  }

  String serialize(Project project) {
    final buffer = StringBuffer()
      // Write metadata
      ..writeln('#+title:  ${project.title}')
      ..writeln('#+author: ${project.author ?? 'Unknown'}')
      ..writeln('#+date:   ${_formatDate(DateTime.now())}')
      ..writeln();

    // Write tasks
    for (final task in project.tasks) {
      _writeTask(buffer, task);
    }

    return buffer.toString();
  }

  void _writeTask(StringBuffer buffer, Task task) {
    // Write headline
    final keyword = task.status.keyword;
    final priority = task.priority != null ? ' [#${task.priority}]' : '';
    final tags = task.tags.isNotEmpty ? ' :${task.tags.join(':')}:' : '';
    buffer.writeln('* $keyword$priority ${task.title}$tags');

    // Write planning line (CLOSED, DEADLINE, SCHEDULED)
    final planningParts = <String>[];
    if (task.completedAt != null) {
      planningParts.add('CLOSED: ${_formatTimestamp(task.completedAt!)}');
    }
    if (task.deadline != null) {
      planningParts.add('DEADLINE: ${_formatTimestamp(task.deadline!)}');
    }
    if (task.scheduled != null) {
      planningParts.add('SCHEDULED: ${_formatTimestamp(task.scheduled!)}');
    }
    if (planningParts.isNotEmpty) {
      buffer.writeln('  ${planningParts.join(' ')}');
    }

    // Write description
    if (task.description != null && task.description!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln(task.description);
    }

    // Write subtasks as checklist
    if (task.subtasks.isNotEmpty) {
      if (task.description != null && task.description!.isNotEmpty) {
        buffer.writeln();
      }
      for (final subtask in task.subtasks) {
        final checkbox = subtask.status == TaskStatus.done ? '[X]' : '[ ]';
        buffer.writeln('  - $checkbox ${subtask.title}');
      }
    }

    buffer.writeln();
  }

  String _formatTimestamp(DateTime date) {
    final weekday = DateFormat.E().format(date);
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    return '<$formatted $weekday>';
  }

  String _formatDate(DateTime date) {
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    return '$formatted';
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
    final title = headline.title?.toMarkup().trim();
    final keyword = headline.keyword;

    if (title == null || title.isEmpty || keyword == null) {
      return null; // Not a valid task
    }

    final status = keyword.done ? TaskStatus.done : TaskStatus.todo;
    final tags = headline.tags?.values ?? [];
    final priority = headline.priority?.value;

    DateTime? deadline;
    DateTime? scheduled;
    DateTime? closed;
    String? description;

    final subtasks = <Task>[];

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
        case OrgParagraph():
          // Extract description from paragraph content
          // Skip paragraphs that only contain planning keywords
          final content = node.toMarkup().trim();
          if (content.isNotEmpty &&
              !content.startsWith('DEADLINE:') &&
              !content.startsWith('SCHEDULED:') &&
              !content.startsWith('CLOSED:')) {
            if (description == null) {
              description = content;
            } else {
              description = '$description\n\n$content';
            }
          }
        case OrgList(:final items):
          for (final item in items) {
            if (item case final OrgListUnorderedItem item) {
              final subtask = _parseSubtask(item, section.id);
              if (subtask != null) {
                subtasks.add(subtask);
              }
            }
          }
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
      subtasks: subtasks,
      tags: tags,
      priority: priority,
      description: description,
      parentId: null, // Top-level tasks don't have parents
    );
  }

  Task? _parseSubtask(OrgListUnorderedItem item, String parentId) {
    final checked = switch (item.checkbox?.trim()) {
      'X' || 'x' || '[x]' || '[X]' => true,
      _ => false,
    };
    final title = item.body?.toMarkup().trim();

    if (title == null) {
      return null;
    }

    return Task(
      id: item.id,
      title: title,
      status: checked ? TaskStatus.done : TaskStatus.todo,
      parentId: parentId,
    );
  }
}
