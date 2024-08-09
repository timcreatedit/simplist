// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i12;
import 'package:simplist_app/auth/view/sign_in_page.dart' as _i6;
import 'package:simplist_app/auth/view/welcome_page.dart' as _i8;
import 'package:simplist_app/auth/view/welcome_wrapper_page.dart' as _i9;
import 'package:simplist_app/home/view/app_page.dart' as _i2;
import 'package:simplist_app/home/view/home_page.dart' as _i3;
import 'package:simplist_app/inbox/view/inbox_page.dart' as _i4;
import 'package:simplist_app/logbook/view/logbook_page.dart' as _i5;
import 'package:simplist_app/tasks/domain/task_filter.dart' as _i11;
import 'package:simplist_app/tasks/view/add_task_page.dart' as _i1;
import 'package:simplist_app/today/view/today_page.dart' as _i7;

/// generated route for
/// [_i1.AddTaskPage]
class AddTaskRoute extends _i10.PageRouteInfo<AddTaskRouteArgs> {
  AddTaskRoute({
    required _i11.TaskFilter toFilter,
    _i12.Key? key,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          AddTaskRoute.name,
          args: AddTaskRouteArgs(
            toFilter: toFilter,
            key: key,
          ),
          initialChildren: children,
        );

  static const String name = 'AddTaskRoute';

  static _i10.PageInfo page = _i10.PageInfo(
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

  final _i11.TaskFilter toFilter;

  final _i12.Key? key;

  @override
  String toString() {
    return 'AddTaskRouteArgs{toFilter: $toFilter, key: $key}';
  }
}

/// generated route for
/// [_i2.AppPage]
class AppRoute extends _i10.PageRouteInfo<void> {
  const AppRoute({List<_i10.PageRouteInfo>? children})
      : super(
          AppRoute.name,
          initialChildren: children,
        );

  static const String name = 'AppRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i2.AppPage();
    },
  );
}

/// generated route for
/// [_i3.HomePage]
class HomeRoute extends _i10.PageRouteInfo<void> {
  const HomeRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomePage();
    },
  );
}

/// generated route for
/// [_i4.InboxPage]
class InboxRoute extends _i10.PageRouteInfo<void> {
  const InboxRoute({List<_i10.PageRouteInfo>? children})
      : super(
          InboxRoute.name,
          initialChildren: children,
        );

  static const String name = 'InboxRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.InboxPage();
    },
  );
}

/// generated route for
/// [_i5.LogbookPage]
class LogbookRoute extends _i10.PageRouteInfo<void> {
  const LogbookRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LogbookRoute.name,
          initialChildren: children,
        );

  static const String name = 'LogbookRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i5.LogbookPage();
    },
  );
}

/// generated route for
/// [_i6.SignInPage]
class SignInRoute extends _i10.PageRouteInfo<void> {
  const SignInRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SignInRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignInRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i6.SignInPage();
    },
  );
}

/// generated route for
/// [_i7.TodayPage]
class TodayRoute extends _i10.PageRouteInfo<void> {
  const TodayRoute({List<_i10.PageRouteInfo>? children})
      : super(
          TodayRoute.name,
          initialChildren: children,
        );

  static const String name = 'TodayRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.TodayPage();
    },
  );
}

/// generated route for
/// [_i8.WelcomePage]
class WelcomeRoute extends _i10.PageRouteInfo<void> {
  const WelcomeRoute({List<_i10.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i8.WelcomePage();
    },
  );
}

/// generated route for
/// [_i9.WelcomeWrapperPage]
class WelcomeWrapperRoute extends _i10.PageRouteInfo<void> {
  const WelcomeWrapperRoute({List<_i10.PageRouteInfo>? children})
      : super(
          WelcomeWrapperRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeWrapperRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.WelcomeWrapperPage();
    },
  );
}
