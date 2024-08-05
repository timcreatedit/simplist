import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/domain/tasks_repository.dart';

final $task = AsyncNotifierProvider.autoDispose
    .family<TaskNotifier, Task?, String?>(TaskNotifier.new);

class TaskNotifier extends AutoDisposeFamilyAsyncNotifier<Task?, String?> {
  @override
  FutureOr<Task?> build(String? arg) async {
    if (arg == null) return null;
    final repo = await ref.watch($taskRepository.future);
    return repo.get(arg);
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
    required bool today,
  }) async {
    if (state case AsyncData(:final value?)) {
      final repo = await ref.watch($taskRepository.future);
      await repo.update(
        value.copyWith(
          title: title,
          scheduled: today ? ScheduleType.today : ScheduleType.none,
        ),
      );
    }
  }
}
