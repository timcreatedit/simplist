import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/common/routing/router.dart';
import 'package:simplist_app/common/routing/router.gr.dart';
import 'package:simplist_app/common/view/theme.dart';
import 'package:simplist_app/lang/localization/localizations.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen($auth, (prev, next) {
      if (prev case AsyncValue(value: != null)) {
        if (next case AsyncData(value: == null)) {
          ref.read($router).replaceAll([const WelcomeRoute()]);
        }
      }
    });

    return MaterialApp.router(
      theme: ref.watch($theme(Brightness.light)),
      darkTheme: ref.watch($theme(Brightness.dark)),
      routerConfig: ref.watch($router).config(),
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
    );
  }
}
