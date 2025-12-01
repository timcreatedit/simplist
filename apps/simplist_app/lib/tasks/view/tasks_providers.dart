import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/debounce_provider.dart';
import 'package:simplist_app/tasks/data/project_repository.dart';
import 'package:simplist_app/tasks/domain/project.dart';
import 'package:simplist_app/tasks/domain/task.dart';
import 'package:uuid/uuid.dart';

final $projects = StreamNotifierProvider.autoDispose(
  Projects.new,
);

class Projects extends StreamNotifier<List<Project>> {
  Projects();

  @override
  Stream<List<Project>> build() async* {
    final repo = await ref.watch($projectRepository.future);

    yield* repo.projects;
  }

  Future<void> create({required String title}) async {
    final repo = await ref.watch($projectRepository.future);
    state = const AsyncLoading();
    await repo.createProject(
      Project(
        id: const Uuid().v7(),
        title: title,
        tasks: [],
      ),
    );
  }
}

final $singleProject = AsyncNotifierProvider.autoDispose.family(
  SingleProject.new,
);

class SingleProject extends AsyncNotifier<Project?> {
  SingleProject(this.id);

  final String id;

  @override
  Future<Project?> build() async {
    final projects = await ref.watch($projects.future);
    return projects.firstWhereOrNull((p) => p.id == id);
  }

  Future<void> save(Project project) async {
    final repo = await ref.watch($projectRepository.future);
    state = const AsyncLoading();
    await repo.updateProject(project);
  }
}
