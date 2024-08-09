import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';

class CurrentListNotifier extends AutoDisposeAsyncNotifier<TaskFilter> {
  @override
  FutureOr<TaskFilter> build() {
    return TaskFilter.inbox;
  }

  void onPageChange({required TaskFilter filter}) => state = AsyncData(filter);
}
