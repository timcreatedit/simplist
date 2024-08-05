import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/routing/router.gr.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
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
    return Hero(
      tag: task.id,
      child: Material(
        child: ListTile(
          onTap: () => context.router.navigate(AddTaskRoute(id: task.id)),
          leading: AnimatedSwitcher(
            duration: Durations.short4,
            child: switch (task.scheduled) {
              ScheduleType.today => const Icon(Icons.star_rounded),
              _ => const SizedBox.square()
            },
          ),
          title: AnimatedDefaultTextStyle(
            duration: Durations.short4,
            style: context.textTheme.bodyMedium!.copyWith(
              color: task.completed
                  ? context.colorScheme.onSurface.withOpacity(.5)
                  : context.colorScheme.onSurface,
            ),
            child: Text(task.title),
          ),
          trailing: Checkbox(
            value: task.completed,
            onChanged: (value) => notifier.setComplete(
              task,
              completed: value!,
            ),
          ),
        ),
      ),
    );
  }
}
