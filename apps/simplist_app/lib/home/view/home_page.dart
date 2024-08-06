import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';
import 'package:simplist_app/tasks/view/task_sliver_list.dart';
import 'package:simplist_app/tasks/view/widgets/unselected_dimmer.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: switch (ref.watch($selectedTaskId)) {
        == null => FloatingActionButton(
            heroTag: "add_task",
            onPressed: () {},
            child: const Icon(Icons.add_rounded),
          ),
        _ => null,
      },
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const UnselectedDimmer(child: Text('Home')),
            pinned: false,
            actions: [
              IconButton(
                onPressed: () => ref.read($auth.notifier).signOut(),
                icon: const Icon(Icons.exit_to_app_rounded),
              ),
            ],
          ),
          const TaskSliverList(
            header: Text("Today"),
            filter: TaskFilter.uncompletedAndToday,
          ),
          const TaskSliverList(
            header: Text("Anytime"),
            filter: TaskFilter.uncompletedAndNotToday,
          ),
          const TaskSliverList(
            header: Text("Logbook"),
            filter: TaskFilter.completedToday,
            maxCount: 1,
          ),
          const SliverToBoxAdapter(
            child: VSpace.x4l(),
          ),
        ],
      ),
    );
  }
}
