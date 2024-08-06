import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/home/view/widgets/home_page_title.dart';
import 'package:simplist_app/home/view/widgets/lists_page_view.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';
import 'package:simplist_app/tasks/view/widgets/unselected_dimmer.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch($tasks(TaskFilter.none));
    final overlapHandle = useMemoized(SliverOverlapAbsorberHandle.new);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverOverlapAbsorber(
            handle: overlapHandle,
            sliver: SliverAppBar.large(
              title: const UnselectedDimmer(
                child: HomePageTitle(),
              ),
              pinned: false,
              leading: AnimatedSwitcher(
                duration: Durations.short4,
                child: switch (allTasks) {
                  AsyncValue(isRefreshing: true) =>
                    const CircularProgressIndicator.adaptive(),
                  _ => const SizedBox(),
                },
              ),
              actions: [
                IconButton(
                  onPressed: () => ref.read($auth.notifier).signOut(),
                  icon: const Icon(Icons.exit_to_app_rounded),
                ),
              ],
            ),
          ),
        ],
        body: const ListsPageView(
          pages: [
            TaskFilter.uncompletedAndNotToday,
            TaskFilter.uncompletedAndToday,
            TaskFilter.completed,
          ],
        ),
      ),
    );
  }
}
