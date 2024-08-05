import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/domain/task_providers.dart';
import 'package:simplist_app/tasks/view/widgets/task_list_tile.dart';

class TaskList extends HookConsumerWidget {
  const TaskList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch($allTasks);
    return CustomScrollView(
      slivers: switch (tasks) {
        AsyncData(value: final tasks) => [
            for (final task in tasks)
              SliverToBoxAdapter(
                child: TaskListTile(task: task),
              ),
          ],
        AsyncError() => [
            const SliverFillRemaining(
              child: Text("Error"),
            ),
          ],
        _ => []
      },
    );
  }
}
