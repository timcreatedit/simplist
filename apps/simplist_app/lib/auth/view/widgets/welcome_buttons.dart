import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/routing/router.gr.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/spacing.dart';

class WelcomeButtons extends HookConsumerWidget {
  const WelcomeButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConstrainedBox(
      constraints: Spacers.formWidthConstraints,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
            style: TextButton.styleFrom(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: context.colorScheme.onPrimary,
            ),
            onPressed: () {},
            child: Text(context.l10n.getStartedAction),
          ),
          TextButton(
            onPressed: () => context.router.navigate(const SignInRoute()),
            child: Builder(
              builder: (context) {
                final style = DefaultTextStyle.of(context).style;
                return RichText(
                  text: TextSpan(
                    style: style,
                    children: [
                      TextSpan(text: context.l10n.signInPrompt),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: context.l10n.signInAction,
                        style: style.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
