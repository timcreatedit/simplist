import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';
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

    final isSelected = ref.watch($expandedTaskId.select((id) => id == this.id));
    return AnimatedSize(
      duration: Durations.short4,
      curve: Easing.standard,
      child: AnimatedSwitcher(
        duration: Durations.short4,
        child: switch ((state, isSelected)) {
          (AsyncData(value: final task?), false) => Hero(
              tag: task.id,
              child: UnselectedDimmer(
                exceptForId: id,
                child: Material(
                  child: ListTile(
                    onTap: () => ref.read($expandedTaskId.notifier).state = id,
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
                        completed: value!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          (AsyncData(value: != null), true) => TaskEditTile(id: id),
          _ => const SizedBox.shrink(),
        },
      ),
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
    final state = ref.watch($task(id));
    final notifier = ref.watch($task(id).notifier);
    final title = state.valueOrNull?.title;
    final completed = useState(state.valueOrNull?.completed ?? false);
    final scheduled =
        useState(state.valueOrNull?.scheduled ?? ScheduleType.none);
    final controller = useTextEditingController(text: title, keys: [title]);

    // Save when closed
    ref.listen($expandedTaskId.select((id) => id == this.id), (prev, next) {
      if (next == false) {
        notifier.save(
          title: controller.text,
          scheduled: scheduled.value,
          completed: completed.value,
        );
      }
    });

    return Card(
      margin: const EdgeInsets.all(Spacers.m),
      child: Padding(
        padding: const EdgeInsets.all(Spacers.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CupertinoTextField.borderless(
                    controller: controller,
                    autofocus: Platform.isMacOS,
                  ),
                ),
                const HSpace.s(),
                Checkbox(
                  value: completed.value,
                  onChanged: (value) => completed.value = value!,
                ),
              ],
            ),
            const VSpace.s(),
            SegmentedButton<ScheduleType>(
              segments: [
                ButtonSegment(value: ScheduleType.none, label: Text("Anytime")),
                ButtonSegment(value: ScheduleType.today, label: Text("Today")),
              ],
              selected: {scheduled.value},
              onSelectionChanged: (value) => scheduled.value = value.single,
            ),
          ],
        ),
      ),
    );
  }
}
