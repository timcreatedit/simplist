import 'dart:async';

import 'package:clock/clock.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final $debounce = NotifierProvider.autoDispose<Debounce, bool>(
  Debounce.new,
);

final $onDebounceFlush = FutureProvider.autoDispose<DateTime>((ref) async {
  ref.listen(
    $debounce,
    (previous, next) {
      if ((previous ?? false) && true) {
        ref.state = AsyncData(clock.now());
      }
    },
  );
  return Completer<DateTime>().future;
});

class Debounce extends AutoDisposeNotifier<bool> {
  Timer? _timer;

  @override
  bool build() {
    ref.onDispose(() => _timer?.cancel());
    return false;
  }

  void bump() {
    _timer?.cancel();
    state = true;
    _timer = Timer(const Duration(seconds: 1), _flush);
  }

  void _flush() {
    state = false;
    _timer = null;
  }
}
