import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:simplist_app/tasks/view/task_notifier.dart';

class TaskEditCard extends HookConsumerWidget {
  const TaskEditCard({
    required this.id,
    super.key,
  });

  final String? id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch($task(id));
    final title = task.whenOrNull(data: (t) => t?.title);
    final titleController = useTextEditingController(
      text: title,
      keys: [title],
    );
    final notEmpty = useListenable(titleController).text.isNotEmpty;
    final today = useState(task.valueOrNull?.scheduled == ScheduleType.today);
    return Material(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Spacers.l),
        child: ConstrainedBox(
          constraints: Spacers.formWidthConstraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: titleController,
                decoration: const InputDecoration(
                  label: Text("Title"),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: today.value,
                    onChanged: (v) => today.value = v!,
                  ),
                  const Text("Today"),
                ],
              ),
              const VSpace.l(),
              if (id == null)
                TextButton(
                  onPressed: notEmpty
                      ? () {
                          ref.read($task(id).notifier).create(
                                title: titleController.text,
                                today: today.value,
                              );
                          context.router.back();
                        }
                      : null,
                  child: const Text("Create"),
                ),
              if (id != null)
                TextButton(
                  onPressed: notEmpty
                      ? () {
                          ref.read($task(id).notifier).save(
                                title: titleController.text,
                                today: today.value,
                              );
                          context.router.back();
                        }
                      : null,
                  child: const Text("Save"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
