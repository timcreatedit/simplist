import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';
import 'package:simplist_app/tasks/view/widgets/task_list_tile.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TaskSliverList extends HookConsumerWidget {
  const TaskSliverList({
    this.filter = TaskFilter.none,
    super.key,
  });

  final TaskFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch($tasks(filter));
    final notifier = ref.watch($tasks(filter).notifier);
    return switch (tasks) {
      AsyncData(value: final tasks) => SliverImplicitlyAnimatedList(
          items: tasks,
          areItemsTheSame: (a, b) => a.id == b.id,
          itemBuilder: (context, animation, item, i) {
            final anim = CurvedAnimation(
              curve: Curves.easeInOutCubicEmphasized,
              parent: animation,
              reverseCurve: Curves.easeInOutCubicEmphasized.flipped,
            );
            return SizeTransition(
              sizeFactor: anim,
              child: FadeTransition(
                opacity: anim,
                child: TaskListTile(
                  key: ValueKey(item.id),
                  task: item,
                  notifier: notifier,
                ),
              ),
            );
          },
        ),
      _ => const SliverToBoxAdapter()
    };
  }
}

class SliverAnimatedSizeSwitcher extends HookConsumerWidget {
  const SliverAnimatedSizeSwitcher({
    required this.child,
    this.duration = Durations.short4,
    this.curve = Curves.easeInOutCubicEmphasized,
    super.key,
  });

  final Duration duration;
  final Curve curve;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAnimatedPaintExtent(
      duration: duration,
      curve: curve,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: curve,
        switchOutCurve: curve,
        child: child ?? const SliverToBoxAdapter(),
        layoutBuilder: (currentChild, previousChildren) => SliverStack(
          children: [
            for (final c in previousChildren) SliverPositioned.fill(child: c),
            if (currentChild != null) currentChild,
          ],
        ),
        transitionBuilder: (child, animation) => SliverFadeTransition(
          opacity: animation,
          sliver: child,
        ),
      ),
    );
  }
}
