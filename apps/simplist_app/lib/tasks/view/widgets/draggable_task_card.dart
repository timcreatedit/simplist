import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/routing/router.gr.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';

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
    final startOffset = useState<Offset?>(null);
    final current = useState<Offset>(Offset.zero);
    final targetOffset = current.value - (startOffset.value ?? Offset.zero);

    const minDistance = 200;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: TweenAnimationBuilder<Offset>(
            tween: Tween(
              begin: targetOffset,
              end: targetOffset,
            ),
            duration:
                startOffset.value != null ? Duration.zero : Durations.long4,
            curve: Easing.emphasizedDecelerate,
            builder: (context, value, child) {
              return Transform.translate(
                offset: value,
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: Hero(
                    tag: taskFilter,
                    child: _NewTaskPreview(
                      distanceProgress: targetOffset.distance / minDistance,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onVerticalDragStart: (details) {
            startOffset.value = details.localPosition;
            current.value = details.localPosition;
          },
          onVerticalDragUpdate: (details) =>
              current.value = details.localPosition,
          onVerticalDragEnd: (_) async {
            if (targetOffset.distance > minDistance) {
              await context.router.navigate(AddTaskRoute(toFilter: taskFilter));
            }
            startOffset.value = null;
            current.value = Offset.zero;
          },
          onVerticalDragCancel: () {
            current.value = Offset.zero;
            startOffset.value = null;
          },
          child: child,
        ),
      ],
    );
  }
}

class _NewTaskPreview extends HookConsumerWidget {
  const _NewTaskPreview({
    required this.distanceProgress,
    super.key,
  });

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

    return AnimatedOpacity(
      duration: duration,
      opacity: switch (distanceProgress) {
        < .5 => 0,
        < 1.0 => .5,
        _ => 1.0,
      },
      child: Card(
        shape: const StadiumBorder(),
        child: AnimatedContainer(
          duration: Durations.long4,
          curve: Easing.emphasizedDecelerate,
          width: switch (distanceProgress) {
            < 1 => 100,
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
                      duration: duration,
                      curve: Easing.emphasizedDecelerate,
                      alignment: distanceProgress > 1.0
                          ? Alignment.centerLeft
                          : Alignment.center,
                      child: Text("New Task"),
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
