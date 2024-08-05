import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';
import 'package:simplist_app/tasks/view/widgets/task_edit_card.dart';

@RoutePage()
class AddTaskPage extends HookConsumerWidget {
  const AddTaskPage({
    this.id,
    super.key,
  });

  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskId = ref.watch($task(id)).valueOrNull?.id ?? id;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: ModalBarrier(
              color: Colors.black45,
              onDismiss: () => context.router.back(),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(Spacers.l),
              child: Hero(
                tag: taskId ?? 'add_task',
                child: TaskEditCard(id: id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
