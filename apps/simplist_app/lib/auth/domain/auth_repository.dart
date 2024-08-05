import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:rxdart/subjects.dart';
import 'package:simplist_app/auth/domain/user.dart';
import 'package:simplist_app/common/data/pocketbase_provider.dart';

final $authRepository = FutureProvider(
  (ref) async => AuthRepository(await ref.watch($pocketbase.future)),
);

interface class AuthRepository {
  AuthRepository(this.pb) {
    pb.authStore.onChange.listen((r) {
      _onAuthStateChanged.add(_getUserFromAuthStore(pb.authStore));
    });
    _onAuthStateChanged.add(_getUserFromAuthStore(pb.authStore));
  }

  PocketBase pb;

  final BehaviorSubject<User?> _onAuthStateChanged = BehaviorSubject();

  Future<User?> getSignedInUser() async {
    if (pb.authStore.isValid) {
      return _onAuthStateChanged.first;
    } else {
      await pb.collection('users').authRefresh();
      return _onAuthStateChanged.first;
    }
  }

  Stream<User?> get onAuthStateChanged => _onAuthStateChanged.stream;

  FutureOr<void> signInWithPassword({
    required String emailOrUsername,
    required String password,
  }) async {
    try {
      final res = await pb
          .collection('users')
          .authWithPassword(emailOrUsername, password);
      if (res.record == null) throw Exception('Invalid credentials');
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> signOut() async {
    if (pb.authStore.isValid) {
      pb.authStore.clear();
    }
    _onAuthStateChanged.add(null);
  }

  User? _getUserFromAuthStore(AuthStore store) {
    if (store.isValid == false) return null;
    return switch (store.model) {
      final RecordModel model => User.fromJson(model.toJson()),
      _ => null,
    };
  }
}
