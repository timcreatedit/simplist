import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/home/view/widgets/home_page_title.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_sliver_list.dart';
import 'package:simplist_app/tasks/view/widgets/unselected_dimmer.dart';

@RoutePage()
class InboxPage extends HookConsumerWidget {
  const InboxPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: HomePageTitle(filter: TaskFilter.inbox),
        ),
        TaskSliverList(
          filter: TaskFilter.inbox,
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: UnselectedDimmer(child: const VSpace.x4l()),
        )
      ],
    );
  }
}
