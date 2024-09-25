import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/extensions/schedule_type_view_getters.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';
import 'package:simplist_design_system/simplist_design_system.dart';

class TaskEditCard extends HookConsumerWidget {
  const TaskEditCard.existing({
    required String this.id,
    required this.onSave,
    this.onDelete,
    super.key,
  })  : taskFilter = null,
        isNew = false;

  const TaskEditCard.fromFilter({
    required TaskFilter this.taskFilter,
    required this.onSave,
    super.key,
  })  : id = null,
        isNew = true,
        onDelete = null;

  final String? id;

  final TaskFilter? taskFilter;
  final bool isNew;
  final VoidCallback? onDelete;

  final void Function(
    String title,
    // ignore: avoid_positional_boolean_parameters
    bool completed,
    ScheduleType scheduled,
  ) onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = switch (id) {
      null => "",
      _ => ref.watch($task(id)).valueOrNull?.title ?? "",
    };

    final completed = useState(
      switch (id) {
        null => false,
        _ => ref.watch($task(id)).valueOrNull?.completed ?? false,
      },
    );

    final scheduled = useState(
      switch (id) {
        null => taskFilter?.scheduleType ?? ScheduleType.none,
        _ => ref.watch($task(id)).valueOrNull?.scheduled ?? ScheduleType.none,
      },
    );

    final controller = useTextEditingController(text: title, keys: [title]);

    // Save when closed
    ref.listen($focusedTaskId.select((id) => id == this.id && this.id != null),
        (prev, next) {
      if (next == false) {
        onSave(
          controller.text,
          completed.value,
          scheduled.value,
        );
      }
    });

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(Spacers.m),
      child: Padding(
        padding: const EdgeInsets.all(Spacers.m),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: CupertinoTextField.borderless(
                      controller: controller,
                      autofocus: Platform.isMacOS || isNew,
                      placeholder: context.l10n.newTask,
                      style: context.typographySemantic.bodyLarge,
                      onSubmitted: (_) => onSave(
                        controller.text,
                        completed.value,
                        scheduled.value,
                      ),
                    ),
                  ),
                  if (isNew == false) ...[
                    const HSpace.s(),
                    Checkbox(
                      value: completed.value,
                      activeColor: context.colorsSemantic.interactivePrimary,
                      checkColor: context.colorsSemantic.interactiveOnPrimary,
                      onChanged: (value) => completed.value = value!,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleToggle extends HookConsumerWidget {
  const ScheduleToggle({
    required this.value,
    required this.onValueChanged,
    super.key,
  });
  final ScheduleType value;
  final ValueChanged<ScheduleType> onValueChanged;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = context.colorScheme;
    return CupertinoSlidingSegmentedControl(
      groupValue: value,
      children: {
        ScheduleType.none: _buildFor(context, ScheduleType.none),
        ScheduleType.today: _buildFor(context, ScheduleType.today),
      },
      onValueChanged: (v) => onValueChanged(v!),
      backgroundColor: switch (colorScheme.brightness) {
        Brightness.dark => colorScheme.surface,
        Brightness.light => context.colorScheme.surfaceContainerHighest,
      },
      thumbColor: switch (colorScheme.brightness) {
        Brightness.dark => colorScheme.surfaceContainerHighest,
        Brightness.light => context.colorScheme.surface,
      },
    );
  }

  Widget _buildFor(BuildContext context, ScheduleType type) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          type.icon,
          color: context.colorScheme.onSurface.withOpacity(.8),
          size: Spacers.m,
        ),
        const HSpace.xxs(),
        Text(type.translation(context.l10n)),
      ],
    );
  }
}
