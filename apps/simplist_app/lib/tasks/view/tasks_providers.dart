import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/debounce_provider.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/domain/tasks_repository.dart';

final $tasks =
    StreamNotifierProvider.autoDispose.family<Tasks, List<Task>, TaskFilter>(
  Tasks.new,
);

class Tasks extends AutoDisposeFamilyStreamNotifier<List<Task>, TaskFilter> {
  @override
  Stream<List<Task>> build(TaskFilter arg) async* {
    final repo = await ref.watch($taskRepository.future);

    await for (final e in repo.watchAll(filter: arg)) {
      // Ignore updates while debouncing
      if (ref.read($debounce) == false) yield e;
    }
  }

  Future<void> create({
    required String title,
    required bool today,
  }) async {
    final repo = await ref.read($taskRepository.future);
    await repo.create(
      title: title,
      scheduled: today ? ScheduleType.today : ScheduleType.none,
    );
  }
}
