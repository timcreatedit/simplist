import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Whether the app is running in debug mode.
final $isDebugMode = Provider<bool>((ref) {
  return kDebugMode;
});
