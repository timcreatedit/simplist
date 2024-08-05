import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/auth/view/widgets/sign_in_form.dart';
import 'package:simplist_app/common/routing/router.gr.dart';
import 'package:simplist_app/common/view/spacing.dart';

@RoutePage()
class SignInPage extends HookConsumerWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen($auth, (prev, next) {
      if (next case AsyncData(value: != null)) {
        context.router.replaceAll([const HomeRoute()]);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacers.l),
        children: const [
          Align(child: SignInForm()),
        ],
      ),
    );
  }
}
