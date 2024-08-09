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
          page: AppRoute.page,
          durationInMilliseconds: Durations.long4.inMilliseconds,
          transitionsBuilder: _fadethroughTransitionBuilder,
          guards: [AuthenticatedGuard(ref)],
          children: [
            CustomRoute<void>(
              path: '',
              page: HomeRoute.page,
              transitionsBuilder: _fadethroughTransitionBuilder,
              children: [
                AutoRoute(
                  path: 'inbox',
                  page: InboxRoute.page,
                ),
                AutoRoute(
                  path: '',
                  page: TodayRoute.page,
                ),
                AutoRoute(
                  path: 'logbook',
                  page: LogbookRoute.page,
                ),
              ],
            ),
            CustomRoute<void>(
              path: 'add',
              page: AddTaskRoute.page,
              durationInMilliseconds: Durations.medium4.inMilliseconds,
              transitionsBuilder: _fadethroughTransitionBuilder,
              opaque: false,
            ),
          ],
        ),
        CustomRoute<void>(
          path: '/welcome',
          page: WelcomeWrapperRoute.page,
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
