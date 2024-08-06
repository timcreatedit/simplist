import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rivership/rivership.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/home/view/home_providers.dart';
import 'package:simplist_app/home/view/widgets/home_navigation_bar.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/task_sliver_list.dart';
import 'package:simplist_app/tasks/view/widgets/unselected_dimmer.dart';

class ListsPageView extends HookConsumerWidget {
  const ListsPageView({
    required this.pages,
    this.overlapHandle,
    super.key,
  });

  final List<TaskFilter> pages;
  final SliverOverlapAbsorberHandle? overlapHandle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();

    ref.listen($currentList, (prev, next) {
      if ((prev?.isLoadingInitial ?? false) && next.hasValue) {
        pageController.jumpToPage(pages.indexOf(next.requireValue));
      }
    });

    return Stack(
      children: [
        PageView(
          onPageChanged: (value) => ref
              .read($currentList.notifier)
              .onPageChange(filter: pages[value]),
          controller: pageController,
          children: [
            for (final page in pages)
              CustomScrollView(
                slivers: [
                  if (overlapHandle case final handle?)
                    SliverOverlapInjector(handle: handle),
                  TaskSliverList(
                    filter: page,
                  ),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: UnselectedDimmer(child: VSpace.x4l()),
                  ),
                ],
              ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: HomeNavigationBar(
            controller: pageController,
            pages: pages,
          ),
        )
      ],
    );
  }
}
