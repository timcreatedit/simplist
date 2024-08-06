import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';

final $currentList =
    AsyncNotifierProvider.autoDispose<CurrentListNotifier, TaskFilter>(
  CurrentListNotifier.new,
);

class CurrentListNotifier extends AutoDisposeAsyncNotifier<TaskFilter> {
  @override
  FutureOr<TaskFilter> build() {
    return TaskFilter.uncompletedAndToday;
  }

  void onPageChange({required TaskFilter filter}) => state = AsyncData(filter);
}
