import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rivership/rivership.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/extensions/task_filter_view_getters.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';
import 'package:simplist_app/tasks/view/widgets/draggable_task_card.dart';

class HomeNavigationBar extends HookConsumerWidget {
  const HomeNavigationBar({
    required this.pages,
    required this.controller,
    super.key,
  });

  final List<TaskFilter> pages;
  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = usePage(controller).round();
    final expanded = useDelayed(
      delay: const Duration(seconds: 2),
      before: true,
      after: false,
      keys: [...Colors.primaries, page],
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(Spacers.l),
        child: Material(
          color: context.colorScheme.surfaceContainerLow,
          shape: const StadiumBorder(),
          child: AnimatedPadding(
            duration: Durations.long4,
            curve: Easing.standard,
            padding: expanded
                ? const EdgeInsets.symmetric(
                    vertical: Spacers.s,
                    horizontal: Spacers.l,
                  )
                : const EdgeInsets.all(Spacers.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (index, filter) in pages.indexed)
                  _ListNavigationItem(
                    filter: filter,
                    expanded: expanded,
                    selected: page == index,
                    onPressed: () => controller.animateToPage(
                      index,
                      duration: Durations.short4,
                      curve: Curves.easeInOutCubicEmphasized,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ListNavigationItem extends HookConsumerWidget {
  const _ListNavigationItem({
    required this.filter,
    required this.expanded,
    required this.selected,
    required this.onPressed,
    super.key,
  });
  final TaskFilter filter;
  final bool expanded;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bounceController = useAnimationController(
      duration: Durations.short2,
      reverseDuration: Durations.short4,
    );

    ref.listen($tasks(filter).select((t) => t.value?.length), (prev, next) {
      if (prev != null && next != null && prev < next) {
        HapticFeedback.lightImpact();
        bounceController.stop();
        bounceController
            .forward(from: 0)
            .then((_) => bounceController.reverse())
            .then((_) => HapticFeedback.heavyImpact());
      }
    });

    final expansion = useTweenedValue(expanded ? 1.0 : 0.0);

    final color = useTweenedValue<Color?>(
      selected
          ? context.colorScheme.tertiary
          : context.colorScheme.onSurfaceVariant,
    );

    final backgroundColor = useTweenedValue<Color?>(
      selected
          ? context.colorScheme.tertiaryContainer
          : context.colorScheme.tertiaryContainer.withOpacity(0),
    );

    final button = AnimatedPadding(
      duration: Durations.long4,
      curve: Easing.standard,
      padding: expanded
          ? const EdgeInsets.symmetric(horizontal: Spacers.xs)
          : const EdgeInsets.symmetric(horizontal: Spacers.xxs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: color,
              padding: const EdgeInsets.symmetric(horizontal: Spacers.l),
            ),
            tooltip: filter.translation(context.l10n),
            onPressed: onPressed,
            icon: ScaleTransition(
              scale: Tween<double>(begin: 1, end: 1.5).animate(
                CurvedAnimation(
                  curve: Easing.standard,
                  parent: bounceController,
                ),
              ),
              child: Icon(filter.icon),
            ),
          ),
          SizedOverflowBox(
            size: Size.square(Spacers.s * expansion),
            child: Opacity(
              opacity: expansion,
              child: Text(
                filter.translation(context.l10n),
                style: context.textTheme.labelMedium,
              ),
            ),
          ),
        ],
      ),
    );

    if (filter.canCreate) {
      return DraggableTaskCard(
        taskFilter: filter,
        child: button,
      );
    } else {
      return button;
    }
  }
}
