import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:rxdart/subjects.dart';
import 'package:simplist_app/auth/domain/user.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/common/data/pocketbase_provider.dart';
import 'package:simplist_app/tasks/domain/task.dart';

final $taskRepository = FutureProvider.autoDispose<TaskRepository>((ref) async {
  final user = await ref.watch($auth.future);
  if (user == null) throw Exception("Can't access tasks without user");

  final pb = await ref.watch($pocketbase.future);
  final repo = TaskRepository(pb: pb, user: user);
  ref.onDispose(repo.dispose);
  return repo;
});

interface class TaskRepository {
  TaskRepository({required this.pb, required this.user}) {
    _subscribe();
  }

  final PocketBase pb;

  final User user;

  RecordService get _collection => pb.collection("tasks");

  final BehaviorSubject<List<Task>> _tasksSubject = BehaviorSubject();

  Stream<List<Task>> watchAll() => _tasksSubject.stream;

  void _subscribe() {
    _collection.subscribe("*", (_) {
      _tasksSubject.addStream(Stream.fromFuture(getAll()));
    });
    _tasksSubject.addStream(Stream.fromFuture(getAll()));
  }

  Future<List<Task>> getAll() async {
    final records = await _collection.getFullList();
    return [
      for (final record in records) Task.fromJson(record.toJson()),
    ];
  }

  void dispose() {
    _tasksSubject.close();
    _collection.unsubscribe("*");
  }
}
