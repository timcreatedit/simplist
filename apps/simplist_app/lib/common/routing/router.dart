import 'package:animations/animations.dart';
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
          page: HomeRoute.page,
          durationInMilliseconds: Durations.long4.inMilliseconds,
          transitionsBuilder: _fadethroughTransitionBuilder,
          guards: [AuthenticatedGuard(ref)],
        ),
        CustomRoute<void>(
          path: '/welcome',
          page: const EmptyShellRoute('welcome').page,
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
    (context, animation, secondaryAnimation, child) => FadeThroughTransition(
          animation: CurvedAnimation(
            curve: Curves.easeInOutCubicEmphasized,
            parent: animation,
          ),
          secondaryAnimation: CurvedAnimation(
            curve: Curves.easeInOutCubicEmphasized,
            parent: secondaryAnimation,
          ),
          child: child,
        );
