import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simplist_app/tasks/domain/task.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
sealed class Project with _$Project {
  const factory Project({
    required String id,
    required String title,
    required String fileName,
    @Default([]) List<Task> tasks,
    String? author,
  }) = SavedProject;

  const factory Project.create({
    required String title,
    @Default([]) List<Task> tasks,
    String? author,
  }) = NewProject;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  const Project._();
}
