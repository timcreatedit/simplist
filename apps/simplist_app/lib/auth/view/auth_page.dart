import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';

@RoutePage()
class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final state = ref.watch($auth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth'),
      ),
      body: ListView(
        children: [
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () => ref.read($auth.notifier).signIn(
                  emailOrUsername: emailController.text,
                  password: passwordController.text,
                ),
            child: const Text('Sign In'),
          ),
          ElevatedButton(
            onPressed: () => ref.read($auth.notifier).signOut(),
            child: const Text('Sign Out'),
          ),
          Text(state.toString()),
        ],
      ),
    );
  }
}
