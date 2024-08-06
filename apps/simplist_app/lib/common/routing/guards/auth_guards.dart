import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/domain/user.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/common/routing/router.gr.dart';

class AuthenticatedGuard extends AutoRouteGuard {
  AuthenticatedGuard(this.ref);

  final Ref ref;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final user = await ref
        .read($auth.future)
        .timeout(const Duration(seconds: 2))
        .catchError((_) => null);
    switch (user) {
      case null:
        router.replaceAll([const WelcomeWrapperRoute()]).ignore();
      case User():
        resolver.next();
    }
  }
}

class UnauthenticatedGuard extends AutoRouteGuard {
  UnauthenticatedGuard(this.ref);

  final Ref ref;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final user = await ref
        .read($auth.future)
        .timeout(const Duration(seconds: 2))
        .catchError((_) => null);
    switch (user) {
      case null:
        resolver.next();
      case User():
        router.replaceAll([const AppRoute()]).ignore();
    }
  }
}
