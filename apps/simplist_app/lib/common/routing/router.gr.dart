// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i9;
import 'package:simplist_app/auth/view/sign_in_page.dart' as _i4;
import 'package:simplist_app/auth/view/welcome_page.dart' as _i5;
import 'package:simplist_app/auth/view/welcome_wrapper_page.dart' as _i6;
import 'package:simplist_app/home/view/app_page.dart' as _i2;
import 'package:simplist_app/home/view/home_page.dart' as _i3;
import 'package:simplist_app/tasks/domain/task_filter.dart' as _i8;
import 'package:simplist_app/tasks/view/add_task_page.dart' as _i1;

/// generated route for
/// [_i1.AddTaskPage]
class AddTaskRoute extends _i7.PageRouteInfo<AddTaskRouteArgs> {
  AddTaskRoute({
    required _i8.TaskFilter toFilter,
    _i9.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          AddTaskRoute.name,
          args: AddTaskRouteArgs(
            toFilter: toFilter,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AddTaskRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AddTaskRouteArgs>();
      return _i1.AddTaskPage(
        toFilter: args.toFilter,
        key: args.key,
      );
    },
  );
}

class AddTaskRouteArgs {
  const AddTaskRouteArgs({
    required this.toFilter,
    this.key,
  });

  final _i8.TaskFilter toFilter;

  final _i9.Key? key;

  @override
  String toString() {
    return 'AddTaskRouteArgs{toFilter: $toFilter, key: $key}';
  }
}

/// generated route for
/// [_i2.AppPage]
class AppRoute extends _i7.PageRouteInfo<void> {
  const AppRoute({List<_i7.PageRouteInfo>? children})
      : super(
          AppRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.AppPage();
    },
  );
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.SignInPage]
class SignInRoute extends _i7.PageRouteInfo<void> {
  const SignInRoute({List<_i7.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.SignInPage();
    },
  );
}

/// generated route for
/// [_i5.WelcomePage]
class WelcomeRoute extends _i7.PageRouteInfo<void> {
  const WelcomeRoute({List<_i7.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.WelcomePage();
    },
  );
}

/// generated route for
/// [_i6.WelcomeWrapperPage]
class WelcomeWrapperRoute extends _i7.PageRouteInfo<void> {
  const WelcomeWrapperRoute({List<_i7.PageRouteInfo>? children})
      : super(
          WelcomeWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeWrapperRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.WelcomeWrapperPage();
    },
  );
}
