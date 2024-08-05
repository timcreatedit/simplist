import 'dart:async';

import 'package:clock/clock.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/domain/tasks_repository.dart';

final $tasks =
    StreamNotifierProvider.autoDispose.family<Tasks, List<Task>, TaskFilter>(
  Tasks.new,
);

class Tasks extends AutoDisposeFamilyStreamNotifier<List<Task>, TaskFilter> {
  Timer? _timer;
  Completer<void>? _flushing;

  @override
  Stream<List<Task>> build(TaskFilter arg) async* {
    final repo = await ref.watch($taskRepository.future);
    await for (final e in repo.watchCompleted(filter: arg)) {
      // Ignore updates while debouncing
      if (_timer == null) yield e;
    }
  }

  Future<void> setComplete(Task task, {bool completed = true}) async {
    if (state case AsyncData(value: final tasks)) {
      final toggled = task.copyWith(
        completedOn: completed ? clock.now() : null,
      );

      // Optimistic update
      final updated = [
        for (final t in tasks)
          if (t.id == task.id) toggled else t,
      ];
      if (state case AsyncData(:final value)) state = AsyncData(value);
      state = const AsyncLoading<List<Task>>().copyWithPrevious(
        AsyncData(updated),
      );

      _scheduleUpdate().ignore();
    }
  }

  Future<void> _scheduleUpdate() async {
    await _flushing?.future;
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), _updateAll);
  }

  Future<void> _updateAll() async {
    if (state case AsyncData(:final value)) {
      _flushing = Completer();
      final repo = await ref.read($taskRepository.future);
      try {
        await Future.wait(value.map(repo.update));
      } catch (e, stackTrace) {
        state = AsyncError<List<Task>>(e, stackTrace).copyWithPrevious(state);
      }

      _flushing?.complete(null);
      _timer = null;
    }
  }
}
