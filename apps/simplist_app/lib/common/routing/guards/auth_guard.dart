import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/domain/user.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/common/routing/router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard(this.ref);

  final Ref ref;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final user = await ref.read($auth.future).catchError((_) => null);
    switch (user) {
      case null:
        router.replace(const HomeRoute()).ignore();
      case User():
        resolver.next();
    }
  }
}
