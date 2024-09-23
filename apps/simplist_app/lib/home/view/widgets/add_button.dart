import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:simplist_app/common/routing/router.gr.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: const Icon(Icons.add),
      elevation: 0,
      label: const Text('Add Task'),
      onPressed: () => context.router.navigate(
        AddTaskRoute(toFilter: TaskFilter.inbox),
      ),
    );
  }
}
