import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/routing/guards/auth_guards.dart';
import 'package:simplist_app/common/routing/router.gr.dart';

final $router = Provider(AppRouter.new);

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this.ref);

  final Ref ref;

  @override
  List<AutoRoute> get routes => [
        CustomRoute<void>(
          path: '/',
          page: const EmptyShellHeroRoute('/').page,
          durationInMilliseconds: Durations.long4.inMilliseconds,
          transitionsBuilder: _fadethroughTransitionBuilder,
          guards: [AuthenticatedGuard(ref)],
          children: [
            CustomRoute<void>(
              path: '',
              page: HomeRoute.page,
              transitionsBuilder: _fadethroughTransitionBuilder,
            ),
            CustomRoute<void>(
              path: 'add',
              page: AddTaskRoute.page,
              opaque: false,
              transitionsBuilder: _fadethroughTransitionBuilder,
            ),
          ],
        ),
        CustomRoute<void>(
          path: '/welcome',
          page: const EmptyShellHeroRoute('welcome').page,
          durationInMilliseconds: Durations.long4.inMilliseconds,
          transitionsBuilder: _fadethroughTransitionBuilder,
          children: [
            AutoRoute(
              fullscreenDialog: true,
              path: '',
              page: WelcomeRoute.page,
            ),
            AutoRoute(
              fullscreenDialog: true,
              path: 'auth',
              page: SignInRoute.page,
            ),
          ],
        ),
      ];
}

RouteTransitionsBuilder _fadethroughTransitionBuilder =
    (context, animation, secondaryAnimation, child) => FadeTransition(
          opacity: CurvedAnimation(
            curve: Curves.easeInOutCubicEmphasized,
            parent: animation,
          ),
          child: child,
        );

/// A proxy Route page that provides a way to create a [PageRouteInfo]
/// without the need for creating a new Page Widget
class EmptyShellHeroRoute extends PageInfo {
  /// Default constructor
  const EmptyShellHeroRoute(super.name)
      : super(
          builder: _emptyShellHeroBuilder,
        );

  /// Creates a new instance with of [PageRouteInfo]
  PageRouteInfo call({List<PageRouteInfo>? children}) {
    return PageRouteInfo(name, initialChildren: children);
  }

  /// Creates a new instance with of [PageInfo] with an empty shell builder
  /// that returns an [AutoRouter] widget
  PageInfo get page => this;

  static Widget _emptyShellHeroBuilder(RouteData _) {
    return AutoRouter(
      navigatorObservers: () => [HeroController()],
    );
  }
}
