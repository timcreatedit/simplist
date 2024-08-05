import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/auth/view/auth_notifier.dart';
import 'package:simplist_app/tasks/view/task_list.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () => ref.read($auth.notifier).signOut(),
            icon: const Icon(Icons.exit_to_app_rounded),
          ),
        ],
      ),
      body: const TaskList(),
    );
  }
}
