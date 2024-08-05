import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_sliver_list.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Home'),
            actions: [
              IconButton(
                onPressed: () => ref.read($auth.notifier).signOut(),
                icon: const Icon(Icons.exit_to_app_rounded),
              ),
            ],
          ),
          TaskSliverList(filter: TaskFilter.uncompletedAndToday),
          const SliverToBoxAdapter(child: Divider(height: Spacers.l)),
          TaskSliverList(filter: TaskFilter.uncompletedAndNotToday),
          const SliverToBoxAdapter(child: Divider(height: Spacers.l)),
          TaskSliverList(filter: TaskFilter.completedToday),
        ],
      ),
    );
  }
}
