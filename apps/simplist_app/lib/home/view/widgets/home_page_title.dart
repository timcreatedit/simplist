import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/extensions/task_filter_view.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/home/view/home_providers.dart';

class HomePageTitle extends HookConsumerWidget {
  const HomePageTitle({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentList = ref.watch($currentList);
    return Row(
      children: [
        AnimatedSwitcher(
          duration: Durations.short4,
          child: switch (currentList) {
            AsyncData(:final value) => Icon(
                value.icon,
                key: ValueKey(value),
                color: context.colorScheme.tertiary,
              ),
            _ => const SizedBox.shrink(),
          },
        ),
        const HSpace.xs(),
        AnimatedSwitcher(
          duration: Durations.short4,
          child: switch (currentList) {
            AsyncData(:final value) => Text(
                key: ValueKey(value),
                value.translation(context.l10n),
              ),
            _ => const SizedBox.shrink(),
          },
          layoutBuilder: (currentChild, previousChildren) => Stack(
            alignment: Alignment.centerLeft,
            children: [
              ...previousChildren,
              if (currentChild case final current?) current,
            ],
          ),
        ),
      ],
    );
  }
}
