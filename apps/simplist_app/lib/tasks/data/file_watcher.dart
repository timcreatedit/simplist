import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:watcher/watcher.dart';

/// File system event that indicates a change to an org file.
class OrgFileEvent {
  const OrgFileEvent({
    required this.type,
    required this.path,
  });

  final OrgFileEventType type;
  final String path;

  String get fileName => p.basename(path);

  @override
  String toString() => 'OrgFileEvent($type, $path)';
}

enum OrgFileEventType {
  added,
  modified,
  removed,
}

/// Watches a directory for changes to .org files with debouncing.
///
/// This class wraps the `package:watcher` functionality and provides:
/// - Filtering to only .org files
/// - Debouncing to avoid rapid successive events
/// - Clean stream interface
class OrgFileWatcher {
  OrgFileWatcher({
    required this.directory,
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : _watcher = DirectoryWatcher(directory.absolute.path);

  final Directory directory;
  final Duration debounceDuration;
  final DirectoryWatcher _watcher;

  StreamSubscription<WatchEvent>? _subscription;
  final _controller = StreamController<OrgFileEvent>.broadcast();
  final _debounceTimers = <String, Timer>{};

  /// Stream of org file events.
  Stream<OrgFileEvent> get events => _controller.stream;

  /// Start watching the directory.
  void start() {
    if (_subscription != null) {
      return; // Already watching
    }

    _subscription = _watcher.events.listen(
      _handleWatchEvent,
      onError: _controller.addError,
    );
  }

  /// Stop watching the directory.
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;

    // Cancel all pending debounce timers
    for (final timer in _debounceTimers.values) {
      timer.cancel();
    }
    _debounceTimers.clear();
  }

  /// Dispose of resources.
  Future<void> dispose() async {
    await stop();
    await _controller.close();
  }

  void _handleWatchEvent(WatchEvent event) {
    // Only process .org files
    if (!event.path.endsWith('.org')) {
      return;
    }

    final path = event.path;

    // Cancel existing timer for this file if any
    _debounceTimers[path]?.cancel();

    // Create new debounce timer
    _debounceTimers[path] = Timer(debounceDuration, () {
      _debounceTimers.remove(path);

      final orgEventType = switch (event.type) {
        ChangeType.ADD => OrgFileEventType.added,
        ChangeType.MODIFY => OrgFileEventType.modified,
        ChangeType.REMOVE => OrgFileEventType.removed,
        _ => throw UnimplementedError('Unknown change type: ${event.type}'),
      };

      _controller.add(
        OrgFileEvent(
          type: orgEventType,
          path: path,
        ),
      );
    });
  }
}
