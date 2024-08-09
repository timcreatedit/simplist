import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:pocketbased/pocketbased.dart';
import 'package:simplist_app/auth/domain/user.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/common/data/pocketbase_provider.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';

final $taskRepository =
    FutureProvider.autoDispose<TasksRepository>((ref) async {
  final user = await ref.watch($auth.future);
  if (user == null) throw Exception("Can't access tasks without user");

  final pb = await ref.watch($pocketbase.future);
  final repo = TasksRepository(pb: pb, user: user);
  return repo;
});

interface class TasksRepository {
  TasksRepository({required this.pb, required this.user});

  final PocketBase pb;

  final User user;

  RecordService get _collection => pb.collection("tasks");

  final _sorting = "completedOn,-scheduled";

  Stream<List<Task>> watchAll({
    TaskFilter filter = TaskFilter.none,
  }) =>
      _collection
          .watchFullList(
        sort: _sorting,
        filter: _filterQuery(filter),
      )
          .map((l) {
        return [for (final record in l) Task.fromJson(record.toJson())];
      });

  Future<List<Task>> getAll({TaskFilter filter = TaskFilter.none}) async {
    final records = await _collection.getFullList(
      sort: _sorting,
      filter: _filterQuery(filter),
    );
    return [for (final record in records) Task.fromJson(record.toJson())];
  }

  Future<Task?> get(String id) async {
    try {
      final record = await _collection.getOne(id);
      return Task.fromJson(record.toJson());
    } catch (_) {
      return null;
    }
  }

  Stream<Task?> watch(String id) {
    return _collection
        .watchOne(id)
        .map((r) => Task.fromJson(r.toJson()))
        .handleError((_) => Stream.value(null));
  }

  Future<Task> create({
    required String title,
    ScheduleType scheduled = ScheduleType.none,
  }) async {
    final model = await _collection.create(
      body: {
        'title': title,
        'scheduled': scheduled.name,
        'owner': user.id,
      },
    );
    return Task.fromJson(model.toJson());
  }

  Future<Task> update(Task task) async {
    final model = await _collection.update(task.id, body: task.toJson());
    return Task.fromJson(model.toJson());
  }

  Future<void> delete(Task task) async {
    await _collection.delete(task.id);
  }

  String? _filterQuery(TaskFilter filter) {
    return switch (filter) {
      TaskFilter.none => null,
      TaskFilter.completed => 'completedOn != null',
      TaskFilter.completedToday =>
        'completedOn >= @todayStart && completedOn <= @todayEnd',
      TaskFilter.uncompleted => 'completedOn = null',
      TaskFilter.today => 'completedOn = null && scheduled = "today"',
      TaskFilter.inbox => 'completedOn = null && scheduled != "today"',
    };
  }
}
