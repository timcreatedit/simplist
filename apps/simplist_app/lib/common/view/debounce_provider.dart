import 'dart:async';

import 'package:clock/clock.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Provides an app-wide debounce mechanism for those notifiers that want
/// to debounce their updates.
///
/// Updates that should trigger a debounce should call [Debounce.bump()].
///
/// Notifiers can then `ref.listen` to [$onDebounceFlush] and flush their
/// updates whenever that fires.
final $debounce = NotifierProvider.autoDispose(Debounce.new);

/// Fires whenever all notifiers that depend on this should flush their updates.
///
/// Provides the time of the latest flush.
final $onDebounceFlush = AsyncNotifierProvider.autoDispose(DebounceFlush.new);

class DebounceFlush extends AsyncNotifier<DateTime> {
  @override
  Future<DateTime> build() async {
    ref.listen($debounce, (previous, next) {
      if ((previous ?? false) && true) {
        state = AsyncData(clock.now());
      }
    });
    return Completer<DateTime>().future;
  }
}

class Debounce extends Notifier<bool> {
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
