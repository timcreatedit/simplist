import 'dart:async';

import 'package:collection/collection.dart';
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

  Future<Task> create({
    required String title,
    required ScheduleType scheduled,
  }) async {
    final repo = await ref.read($taskRepository.future);
    return repo.create(
      title: title,
      scheduled: scheduled,
    );
  }
}

//TODO here
class SelectedTasks extends AutoDisposeFamilyNotifier<Set<String>, TaskFilter> {
  @override
  Set<String> build(TaskFilter arg) {
    return {};
  }

  void toggle(String id) {
    state = state.contains(id)
        ? {...state.whereNot((s) => s == id)}
        : {...state, id};
  }

  void clear() {
    state = {};
  }
}
