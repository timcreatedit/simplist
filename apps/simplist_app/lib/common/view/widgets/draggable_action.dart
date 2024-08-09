import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rivership/rivership.dart';

class DraggableAction extends HookConsumerWidget {
  const DraggableAction({
    required this.child,
    required this.onActivate,
    this.activateDistance = 200,
    this.previewDistance = 100,
    this.reboundDuration = Durations.long4,
    this.reboundCurve = Easing.emphasizedDecelerate,
    this.previewBuilder,
    this.childWhenDragging,
    super.key,
  });

  final double activateDistance;
  final double previewDistance;
  final Widget Function(BuildContext context, double progress)? previewBuilder;
  final Duration reboundDuration;
  final Curve reboundCurve;
  final FutureOr<bool> Function() onActivate;
  final Widget? childWhenDragging;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startOffset = useState<Offset?>(null);
    final current = useState<Offset>(Offset.zero);
    final targetOffset = current.value - (startOffset.value ?? Offset.zero);

    final offset = useSpringAnimation(
      spring: startOffset.value == null
          ? SimpleSpring.bouncy
          : SimpleSpring.instant,
      value: targetOffset,
    );

    final previewVisible =
        offset.distance > previewDistance && startOffset.value != null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (childWhenDragging != null && offset.distance > 0.05)
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: targetOffset.distance > 0.05 ? 1 : 0,
              duration: Durations.short4,
              child: IgnorePointer(child: childWhenDragging),
            ),
          ),
        Transform.translate(
          offset: offset,
          child: Stack(
            children: [
              Visibility.maintain(
                visible: false,
                child: child,
              ),
              Positioned.fill(
                child: OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: AnimatedSizeSwitcher(
                    clipBehavior: Clip.none,
                    immediateResize: true,
                    child: previewVisible && previewBuilder != null
                        ? previewBuilder!(
                            context,
                            offset.distance / activateDistance,
                          )
                        : Center(
                            key: const ValueKey(true),
                            child: child,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: GestureDetector(
            onVerticalDragStart: (details) {
              startOffset.value = details.localPosition;
              current.value = details.localPosition;
            },
            onVerticalDragUpdate: (details) =>
                current.value = details.localPosition,
            onVerticalDragEnd: (_) async {
              if (targetOffset.distance >= activateDistance) {
                await onActivate();
              }
              startOffset.value = null;
              current.value = Offset.zero;
            },
            onVerticalDragCancel: () {
              current.value = Offset.zero;
              startOffset.value = null;
            },
          ),
        ),
      ],
    );
  }
}
