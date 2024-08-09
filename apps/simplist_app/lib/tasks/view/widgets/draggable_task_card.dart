import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rivership/rivership.dart';
import 'package:simplist_app/common/routing/router.gr.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/extensions/task_filter_view_getters.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/common/view/widgets/draggable_action.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';

class DraggableTaskCard extends HookConsumerWidget {
  const DraggableTaskCard({
    required this.child,
    required this.taskFilter,
    super.key,
  });

  final Widget child;
  final TaskFilter taskFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableAction(
      previewDistance: 50,
      onActivate: () async {
        ref.read($selectedTaskId.notifier).state = null;
        return await context.router
                .push<bool>(AddTaskRoute(toFilter: taskFilter)) ??
            false;
      },
      previewBuilder: (context, progress) => _NewTaskPreview(
        taskFilter: taskFilter,
        distanceProgress: progress,
      ),
      childWhenDragging: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Material(
          shape: const StadiumBorder(),
          color: context.colorScheme.surfaceContainerHighest,
        ),
      ),
      child: child,
    );
  }
}

class _NewTaskPreview extends HookConsumerWidget {
  const _NewTaskPreview({
    required this.taskFilter,
    required this.distanceProgress,
  });
  final TaskFilter taskFilter;
  final double distanceProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    const duration = Durations.short4;
    final haptic = distanceProgress >= 1.0;
    useEffect(
      () {
        if (haptic) HapticFeedback.selectionClick();
        return null;
      },
      [haptic],
    );

    return Hero(
      flightShuttleBuilder: fadeShuttle,
      tag: taskFilter,
      child: Card(
        elevation: distanceProgress < 1 ? 0 : CardTheme.of(context).elevation,
        child: AnimatedContainer(
          duration: Durations.long4,
          curve: Easing.emphasizedDecelerate,
          width: switch (distanceProgress) {
            < 1 => 150,
            _ => screenWidth - Spacers.l * 2,
          },
          padding: switch (distanceProgress) {
            < 1 => const EdgeInsets.all(Spacers.xs),
            _ => const EdgeInsets.all(Spacers.l),
          },
          child: IgnorePointer(
            child: ExcludeFocus(
              child: Row(
                children: [
                  Expanded(
                    child: AnimatedAlign(
                      heightFactor: 1,
                      duration: duration,
                      curve: Easing.emphasizedDecelerate,
                      alignment: distanceProgress > 1.0
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            taskFilter.icon,
                            color:
                                context.colorScheme.onSurface.withOpacity(0.5),
                          ),
                          const HSpace.xxs(),
                          Flexible(
                            child: AnimatedText(
                              distanceProgress < 1.0
                                  ? context.l10n.keepDraggingForTask
                                  : context.l10n.newTask,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: duration,
                    child: distanceProgress >= 1.0
                        ? Checkbox(
                            value: false,
                            onChanged: (_) {},
                          )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
