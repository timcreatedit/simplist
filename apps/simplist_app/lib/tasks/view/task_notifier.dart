import 'dart:async';

import 'package:clock/clock.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/debounce_provider.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/domain/tasks_repository.dart';

final $expandedTaskId = StateProvider.autoDispose<String?>((ref) => null);

final $task = StreamNotifierProvider.autoDispose
    .family<TaskNotifier, Task?, String?>(TaskNotifier.new);

class TaskNotifier extends AutoDisposeFamilyStreamNotifier<Task?, String?> {
  @override
  Stream<Task?> build(String? arg) async* {
    if (arg == null) {
      yield null;
      return;
    }

    ref.listen($onDebounceFlush, (_, __) => _flush());

    final repo = await ref.watch($taskRepository.future);
    await for (final e in repo.watch(arg)) {
      yield e;
    }
  }

  Future<void> create({
    required String title,
    bool today = false,
  }) async {
    if (arg != null) throw StateError("Can't create from existing");
    final repo = await ref.watch($taskRepository.future);
    state = const AsyncLoading();
    final result = await repo.create(
      title: title,
      scheduled: today ? ScheduleType.today : ScheduleType.none,
    );
    state = AsyncData(result);
  }

  Future<void> save({
    required String title,
    required ScheduleType scheduled,
    required bool completed,
  }) async {
    if (state case AsyncData(:final value?)) {
      final repo = await ref.watch($taskRepository.future);
      await repo.update(
        value.copyWith(
          title: title,
          scheduled: scheduled,
          completedOn: completed ? value.completedOn ?? clock.now() : null,
        ),
      );
      ref.invalidateSelf();
    }
  }

  Future<void> setComplete({bool completed = true}) async {
    if (state case AsyncData(value: final task?)) {
      state =
          AsyncData(task.copyWith(completedOn: completed ? clock.now() : null));
      ref.read($debounce.notifier).bump();
    }
  }

  Future<void> _flush() async {
    final task = await future;
    if (task == null) return;
    final repo = await ref.watch($taskRepository.future);
    await repo.update(task);
  }
}
