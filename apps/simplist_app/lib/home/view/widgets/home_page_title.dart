import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/extensions/task_filter_view_getters.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_design_system/simplist_design_system.dart';

class HomePageTitle extends HookConsumerWidget {
  const HomePageTitle({
    required this.filter,
    super.key,
  });

  final TaskFilter filter;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ImageIcon(
          const AssetImage('assets/icons/icon.png'),
          size: 20,
          color: context.colorsSemantic.surfaceNeutralOutline,
        ),
        const HSpace.xs(),
        Text(
          "Simplist",
          style: context.typographySemantic.headlineLarge
              .copyWith(color: context.colorsSemantic.surfaceOnNeutral),
        ),
      ],
    );
  }
}
