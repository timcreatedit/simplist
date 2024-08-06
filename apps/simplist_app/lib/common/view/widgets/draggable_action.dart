import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DraggableAction extends HookConsumerWidget {
  const DraggableAction({
    required this.child,
    required this.onActivate,
    this.activateDistance = 200,
    this.previewDistance = 100,
    this.reboundDuration = Durations.long4,
    this.reboundCurve = Easing.emphasizedDecelerate,
    this.previewBuilder,
    super.key,
  });

  final double activateDistance;
  final double previewDistance;
  final Widget Function(BuildContext context, double progress)? previewBuilder;
  final Duration reboundDuration;
  final Curve reboundCurve;
  final FutureOr<void> Function() onActivate;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startOffset = useState<Offset?>(null);
    final current = useState<Offset>(Offset.zero);
    final targetOffset = current.value - (startOffset.value ?? Offset.zero);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        TweenAnimationBuilder<Offset>(
          tween: Tween(
            begin: targetOffset,
            end: targetOffset,
          ),
          duration: startOffset.value != null ? Duration.zero : Durations.long4,
          curve: Easing.emphasizedDecelerate,
          builder: (context, value, child) {
            final previewOpacity = previewBuilder == null
                ? 0.0
                : (value.distance / previewDistance).clamp(0.0, 1.0);
            return Transform.translate(
              offset: value,
              child: AnimatedSwitcher(
                duration: Durations.long1,
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 1 - previewOpacity,
                      child: this.child,
                    ),
                    if (previewBuilder != null && value.distance > 0)
                      Positioned.fill(
                        child: OverflowBox(
                          maxHeight: double.infinity,
                          maxWidth: double.infinity,
                          child: Opacity(
                            opacity: previewOpacity,
                            child: previewBuilder!(
                              context,
                              value.distance / activateDistance,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
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
