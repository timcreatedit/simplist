import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rivership/rivership.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';
import 'package:simplist_app/tasks/view/widgets/task_edit_card.dart';

@RoutePage()
class AddTaskPage extends HookConsumerWidget {
  const AddTaskPage({
    required this.toFilter,
    super.key,
  });

  final TaskFilter toFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch($tasks(toFilter).notifier);

    return Scaffold(
      backgroundColor: context.colorScheme.surface.withOpacity(.8),
      body: Stack(
        children: [
          Positioned.fill(
            child: ModalBarrier(
              onDismiss: () => context.router.maybePop(),
            ),
          ),
          Center(
            child: Hero(
              flightShuttleBuilder: fadeShuttle,
              tag: toFilter,
              child: TaskEditCard.fromFilter(
                taskFilter: toFilter,
                onSave: (title, _, scheduled) {
                  notifier.create(
                    title: title,
                    scheduled: scheduled,
                  );
                  context.router.maybePop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
