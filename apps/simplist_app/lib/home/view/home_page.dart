import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/routing/on_any_observer.dart';
import 'package:simplist_app/home/view/widgets/home_navigation_bar.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';
import 'package:simplist_app/tasks/view/widgets/unselected_dimmer.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch($tasks(TaskFilter.none));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AutoTabsRouter.pageView(
        navigatorObservers: () => [
          HeroController(),
          OnAnyObserver(() => ref.invalidate($focusedTaskId)),
        ],
        builder: (context, child, pageController) => Stack(
          children: [
            child,
            Align(
              alignment: Alignment.bottomCenter,
              child: UnselectedDimmer(
                child: HomeNavigationBar(
                  controller: pageController,
                  pages: const [
                    TaskFilter.inbox,
                    TaskFilter.today,
                    TaskFilter.completed,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
