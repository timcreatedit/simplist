import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/widgets/end_of_list_padding_sliver.dart';
import 'package:simplist_app/home/view/widgets/home_page_title.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_sliver_list.dart';

@RoutePage()
class LogbookPage extends HookConsumerWidget {
  const LogbookPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: HomePageTitle(filter: TaskFilter.completed),
          ),
          TaskSliverList(
            header: Text("Completed today"),
            filter: TaskFilter.completedToday,
          ),
          EndOfListPaddingSliver(),
        ],
      ),
    );
  }
}
