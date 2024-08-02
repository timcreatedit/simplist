import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/routing/guards/auth_guard.dart';
import 'package:simplist_app/common/routing/router.gr.dart';

final $router = Provider(AppRouter.new);

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

  final Ref ref;

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          guards: [AuthGuard(ref)],
        ),
        AutoRoute(
          path: '/welcome',
          page: AuthRoute.page,
        ),
      ];
}
