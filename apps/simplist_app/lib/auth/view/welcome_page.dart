import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/widgets/welcome_buttons.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/spacing.dart';

@RoutePage()
class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.colorScheme.primaryContainer,
      body: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                context.l10n.onboardingDisplay,
                style: context.textTheme.displayLarge!.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            ),
            const VSpace.l(),
            const WelcomeButtons(),
          ],
        ),
      ),
    );
  }
}
