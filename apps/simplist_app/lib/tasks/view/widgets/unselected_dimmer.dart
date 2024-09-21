import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';

class UnselectedDimmer extends HookConsumerWidget {
  const UnselectedDimmer({
    required this.child,
    this.exceptForId,
    super.key,
  });

  /// The ID that we *don't* want to dim for.
  ///
  /// If null, child will be dimmed for anything
  final String? exceptForId;

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dim = ref.watch(
      $focusedTaskId.select((id) => id != null && id != exceptForId),
    );
    final dimColor = context.colorScheme.surface;
    final filterColor =
        dim ? dimColor.withOpacity(.6) : dimColor.withOpacity(0);

    return Stack(
      children: [
        TweenAnimationBuilder(
          duration: Durations.short4,
          tween: ColorTween(begin: filterColor, end: filterColor),
          builder: (context, value, child) => ColorFiltered(
            colorFilter: ColorFilter.mode(
              value!,
              switch (context.theme.brightness) {
                Brightness.dark => BlendMode.darken,
                Brightness.light => BlendMode.lighten,
              },
            ),
            child: child,
          ),
          child: IgnorePointer(
            ignoring: dim,
            child: child,
          ),
        ),
        if (dim)
          Positioned.fill(
            child: GestureDetector(
              child: ModalBarrier(
                semanticsLabel: "Close task",
                onDismiss: () => ref.read($focusedTaskId.notifier).state = null,
              ),
            ),
          ),
      ],
    );
  }
}
