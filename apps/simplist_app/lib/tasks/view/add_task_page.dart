import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/extensions/context_convenience.dart';
import 'package:simplist_app/common/view/extensions/task_filter_view.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';
import 'package:simplist_app/tasks/view/tasks_providers.dart';

@RoutePage()
class AddTaskPage extends HookConsumerWidget {
  const AddTaskPage({
    required this.toFilter,
    super.key,
  });

  final TaskFilter toFilter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final scheduleType = useState(toFilter.scheduleType);

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
              tag: toFilter,
              child: Card(
                elevation: 10,
                margin: const EdgeInsets.all(Spacers.m),
                child: Padding(
                  padding: const EdgeInsets.all(Spacers.m),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CupertinoTextField.borderless(
                                padding: EdgeInsets.zero,
                                placeholder: "New Task",
                                controller: titleController,
                                autofocus: true,
                                style: context.textTheme.bodyMedium,
                                onSubmitted: (value) {
                                  context.router.maybePop();
                                  notifier.create(
                                    title: value,
                                    scheduled: scheduleType.value,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const VSpace.xs(),
                        Row(
                          children: [
                            Icon(
                              toFilter.icon,
                              size: Spacers.s,
                              color:
                                  context.colorScheme.onSurface.withOpacity(.5),
                            ),
                            const HSpace.xxs(),
                            Text(
                              toFilter.translation(context.l10n),
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.onSurface
                                    .withOpacity(.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
