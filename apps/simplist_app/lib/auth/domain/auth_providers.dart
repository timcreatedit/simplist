import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/domain/auth_repository.dart';
import 'package:simplist_app/auth/domain/user.dart';

/// Provides the current auth state
final $authState = StreamProvider<User?>(
  (ref) => ref.watch($authRepository).onAuthStateChanged,
);
