import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/common/view/spacing.dart';

class SignInForm extends HookConsumerWidget {
  const SignInForm({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final state = ref.watch($auth);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    return ConstrainedBox(
      constraints: Spacers.formWidthConstraints,
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              enabled: state.isLoading == false,
              autofillHints: const [
                AutofillHints.username,
                AutofillHints.email,
              ],
              validator: (value) =>
                  value == null || value.isEmpty ? "Please enter" : null,
              onEditingComplete: () => formKey.currentState?.validate(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              enabled: state.isLoading == false,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onEditingComplete: () => formKey.currentState?.validate(),
              onFieldSubmitted: (_) => ref.read($auth.notifier).signIn(
                    emailOrUsername: emailController.text,
                    password: passwordController.text,
                  ),
            ),
            if (state.hasError) Text("Couldn't sign you in"),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () => ref.read($auth.notifier).signIn(
                        emailOrUsername: emailController.text,
                        password: passwordController.text,
                      ),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
