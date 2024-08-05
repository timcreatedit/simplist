import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';

class TaskListTile extends HookConsumerWidget {
  const TaskListTile({
    required this.task,
    required this.notifier,
    super.key,
  });

  final Task task;
  final Tasks notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: AnimatedSwitcher(
        duration: Durations.short4,
        child: switch (task.scheduled) {
          ScheduleType.today => const Icon(Icons.star_rounded),
          _ => const SizedBox.square()
        },
      ),
      title: Text(task.title),
      trailing: Checkbox(
        value: task.completed,
        onChanged: (value) => notifier.setComplete(
          task,
          completed: value!,
        ),
      ),
    );
  }
}
