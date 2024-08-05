import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
sealed class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required bool completed,
    required DateTime created,
    required DateTime updated,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  const Task._();
}
