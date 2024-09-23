import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/routing/on_any_observer.dart';
import 'package:simplist_app/home/view/widgets/add_button.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch($tasks(TaskFilter.none));

    return Scaffold(
      floatingActionButton: const AddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
      body: AutoTabsRouter.pageView(
        navigatorObservers: () => [
          HeroController(),
          OnAnyObserver(() => ref.invalidate($focusedTaskId)),
        ],
        builder: (context, child, pageController) => child,
      ),
    );
  }
}
