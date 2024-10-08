import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class WelcomeWrapperPage extends HookConsumerWidget {
  const WelcomeWrapperPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AutoRouter(
      navigatorObservers: () => [HeroController()],
    );
  }
}
