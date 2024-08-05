import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/domain/auth_repository.dart';
import 'package:simplist_app/auth/domain/user.dart';

final $auth = StreamNotifierProvider.autoDispose<AuthNotifier, User?>(
  AuthNotifier.new,
);

class AuthNotifier extends AutoDisposeStreamNotifier<User?> {
  @override
  Stream<User?> build() async* {
    final repo = await ref.watch($authRepository.future);
    yield* repo.onAuthStateChanged;
  }

  Future<void> signIn({
    required String emailOrUsername,
    required String password,
  }) async {
    if (state case AsyncData(value: null) || AsyncError()) {
      state = const AsyncLoading();
      final repo = await ref.watch($authRepository.future);

      final task = await AsyncValue.guard(() async {
        await repo.signInWithPassword(
          emailOrUsername: emailOrUsername.trim(),
          password: password,
        );
      });
      switch (task) {
        case AsyncError(:final error, :final stackTrace):
          state = AsyncError(error, stackTrace);
      }
    }
  }

  Future<void> signOut() async {
    if (state case AsyncData(value: != null)) {
      final repo = await ref.watch($authRepository.future);
      await repo.signOut();
    }
  }
}
