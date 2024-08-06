import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';
import 'package:simplist_app/tasks/view/widgets/task_list_tile.dart';
import 'package:simplist_app/tasks/view/widgets/unselected_dimmer.dart';
import 'package:sliver_tools/sliver_tools.dart';

class TaskSliverList extends HookConsumerWidget {
  const TaskSliverList({
    this.header,
    this.filter = TaskFilter.none,
    this.maxCount,
    super.key,
  });

  final Widget? header;
  final TaskFilter filter;

  final int? maxCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch($tasks(filter));

    final expanded = useState(maxCount == null);

    return switch (tasks) {
      AsyncData(value: final tasks) => MultiSliver(
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
              child: switch ((header, tasks)) {
                (null, _) || (_, []) => const SizedBox.shrink(),
                (final title?, [...]) => UnselectedDimmer(
                    child: Container(
                      color: context.colorScheme.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacers.m,
                        vertical: Spacers.m,
                      ),
                      child: Row(
                        children: [
                          title,
                          const Expanded(child: Divider(indent: Spacers.s)),
                        ],
                      ),
                    ),
                  ),
              },
            ),
            SliverImplicitlyAnimatedList(
              items: switch (maxCount == null || expanded.value) {
                true => tasks,
                false => tasks.sublist(0, maxCount),
              },
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
                      id: item.id,
                    ),
                  ),
                );
              },
            ),
            if (maxCount != null && tasks.length > maxCount!)
              Center(
                child: UnselectedDimmer(
                  child: TextButton(
                    onPressed: () => expanded.value = !expanded.value,
                    child: AnimatedSwitcher(
                      duration: Durations.short4,
                      child: Text(
                        key: ValueKey(expanded.value),
                        expanded.value
                            ? "Hide"
                            : "Show ${tasks.length - maxCount!} more",
                      ),
                    ),
                  ),
                ),
              ),
          ],
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
