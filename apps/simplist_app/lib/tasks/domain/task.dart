import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simplist_app/common/data/json_converters/pb_date_converter.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@JsonEnum(valueField: 'keyword')
enum TaskStatus {
  todo('TODO'),
  done('DONE');

  const TaskStatus(this.keyword);
  final String keyword;
}

@freezed
sealed class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    @Default(TaskStatus.todo) TaskStatus status,
    @NullablePbDateConverter() DateTime? completedAt,
    @Default([]) List<String> tags,
    String? description,
    @NullablePbDateConverter() DateTime? deadline,
    @NullablePbDateConverter() DateTime? scheduled,
    String? parentId,
    @Default([]) List<Task> subtasks,
    String? priority,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  const Task._();

  bool get isCompleted => status == TaskStatus.done;

  bool get hasSubtasks => subtasks.isNotEmpty;

  String get searchString {
    final buffer = StringBuffer()..writeln(title);
    if (description != null) {
      buffer.writeln(description);
    }
    tags.forEach(buffer.writeln);
    for (final subtask in subtasks) {
      buffer.writeln(subtask.searchString);
    }
    return buffer.toString();
  }
}
