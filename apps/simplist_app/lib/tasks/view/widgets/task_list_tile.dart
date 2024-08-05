import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/domain/task.dart';

class TaskListTile extends HookConsumerWidget {
  const TaskListTile({
    required this.task,
    super.key,
  });

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CheckboxListTile(
      title: Text(task.title),
      value: task.completed,
      onChanged: (_) {},
    );
  }
}
