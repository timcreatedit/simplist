import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rivership/rivership.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';
import 'package:simplist_app/tasks/view/widgets/task_edit_card.dart';
import 'package:simplist_app/tasks/view/widgets/unselected_dimmer.dart';

class TaskListTile extends HookConsumerWidget {
  const TaskListTile({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch($task(id));
    final notifier = ref.watch($task(id).notifier);
    final completionFormat = useDateFormat(format: DateFormat.NUM_MONTH_DAY);

    final isSelected = ref.watch($selectedTaskId.select((id) => id == this.id));
    return AnimatedSizeSwitcher(
      clipBehavior: Clip.none,
      immediateResize: true,
      child: switch ((state, isSelected)) {
        (AsyncData(value: final task?), false) => Hero(
            tag: task.id,
            key: const ValueKey(true),
            child: UnselectedDimmer(
              exceptForId: id,
              child: Material(
                child: ListTile(
                  iconColor: context.colorScheme.tertiary,
                  onTap: task.completed
                      ? null
                      : () => ref.read($selectedTaskId.notifier).state = id,
                  title: AnimatedDefaultTextStyle(
                    duration: Durations.short4,
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: task.completed
                          ? context.colorScheme.onSurface.withOpacity(.5)
                          : context.colorScheme.onSurface,
                    ),
                    child: Text(task.title),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSizeSwitcher(
                        child: switch (task.completedOn) {
                          final date? => Text(completionFormat.format(date)),
                          null => null
                        },
                      ),
                      Checkbox(
                        value: task.completed,
                        onChanged: (value) => notifier.setComplete(
                          completed: value!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        (AsyncData(value: != null), true) => TaskEditTile(
            key: const ValueKey(false),
            id: id,
          ),
        _ => const HSpace.expand(),
      },
    );
  }
}

class TaskEditTile extends HookConsumerWidget {
  const TaskEditTile({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TaskEditCard.existing(
      id: id,
      onSave: (title, completed, scheduled) {
        ref.read($task(id).notifier).save(
              title: title,
              completed: completed,
              scheduled: scheduled,
            );
        ref.read($selectedTaskId.notifier).state = null;
      },
    );
  }
}
