import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/domain/task_repository.dart';

final $allTasks = StreamProvider.autoDispose((ref) async* {
  final repo = await ref.watch($taskRepository.future);
  yield* repo.watchAll();
});
