import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/tasks/data/project_repository.dart';
import 'package:simplist_app/tasks/domain/project.dart';
import 'package:simplist_app/tasks/domain/task.dart';

final $projects = StreamNotifierProvider.autoDispose(
  Projects.new,
);

class Projects extends StreamNotifier<List<SavedProject>> {
  Projects();

  @override
  Stream<List<SavedProject>> build() async* {
    final repo = await ref.watch($projectRepository.future);

    yield* repo.projects;
  }

  Future<void> create(NewProject project) async {
    final repo = await ref.watch($projectRepository.future);
    state = const AsyncLoading();
    await repo.createProject(project);
  }
}

final $project = AsyncNotifierProvider.autoDispose.family(
  ProjectNotifier.new,
);

class ProjectNotifier extends AsyncNotifier<Project?> {
  ProjectNotifier(this.id);

  final String id;

  @override
  Future<Project?> build() async {
    final projects = await ref.watch($projects.future);
    return projects.firstWhereOrNull((p) => p.id == id);
  }

  Future<void> save(SavedProject project) async {
    await future;
    if (project.id != id) {
      throw StateError("Can't save project with different id");
    }

    final repo = await ref.watch($projectRepository.future);
    state = AsyncData(project);
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repo.updateProject(project, force: true);
      return project;
    });
  }
}

final $allTasks = AsyncNotifierProvider.autoDispose(
  AllTasksNotifier.new,
);

class AllTasksNotifier extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    final projects = await ref.watch($projects.future);
    final tasks = projects.expand((p) => p.tasks).toList();
    return tasks;
  }
}

final $searchTasks = FutureProvider.autoDispose.family<List<Task>, String>((
  ref,
  query,
) async {
  final allTasks = await ref.watch($allTasks.future);
  if (query.isEmpty) {
    return [];
  }

  final searchResult = await compute((tasksAndQuery) async {
    final (allTasks, query) = tasksAndQuery;
    return extractAllSorted(
      query: query,
      choices: allTasks,
      getter: (obj) => obj.searchString,
    );
  }, (allTasks, query));

  return searchResult.map((e) => e.choice).toList();
});
