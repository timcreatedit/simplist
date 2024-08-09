// ignore_for_file: strict_raw_type

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// A [NavigatorObserver] that calls [onAny] when any navigation event occurs.
class OnAnyObserver extends AutoRouteObserver {
  OnAnyObserver(this.onAny);

  final VoidCallback onAny;

  @override
  void didPop(Route route, Route? previousRoute) {
    onAny();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    onAny();
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    onAny();
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    onAny();
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    onAny();
  }

  @override
  void didStopUserGesture() {
    onAny();
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    onAny();
  }

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    onAny();
  }
}
