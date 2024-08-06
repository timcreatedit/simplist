// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:simplist_app/auth/view/sign_in_page.dart' as _i3;
import 'package:simplist_app/auth/view/welcome_page.dart' as _i4;
import 'package:simplist_app/auth/view/welcome_wrapper_page.dart' as _i5;
import 'package:simplist_app/home/view/app_page.dart' as _i1;
import 'package:simplist_app/home/view/home_page.dart' as _i2;

/// generated route for
/// [_i1.AppPage]
class AppRoute extends _i6.PageRouteInfo<void> {
  const AppRoute({List<_i6.PageRouteInfo>? children})
      : super(
          AppRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppPage();
    },
  );
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomePage();
    },
  );
}

/// generated route for
/// [_i3.SignInPage]
class SignInRoute extends _i6.PageRouteInfo<void> {
  const SignInRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i3.SignInPage();
    },
  );
}

/// generated route for
/// [_i4.WelcomePage]
class WelcomeRoute extends _i6.PageRouteInfo<void> {
  const WelcomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i4.WelcomePage();
    },
  );
}

/// generated route for
/// [_i5.WelcomeWrapperPage]
class WelcomeWrapperRoute extends _i6.PageRouteInfo<void> {
  const WelcomeWrapperRoute({List<_i6.PageRouteInfo>? children})
      : super(
          WelcomeWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeWrapperRoute';

  static _i6.PageInfo page = _i6.PageInfo(
    name,
    builder: (data) {
      return const _i5.WelcomeWrapperPage();
    },
  );
}
