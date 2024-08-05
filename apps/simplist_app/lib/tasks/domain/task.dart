import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simplist_app/common/data/json_converters/pb_date_converter.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum ScheduleType {
  /// The task is not scheduled and can be completed anytime
  none,

  /// The task is scheduled for today
  today,

  /// The task is scheduled for a specific day.
  on,
}

@freezed
sealed class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    required DateTime created,
    required DateTime updated,
    @Default(ScheduleType.none) ScheduleType scheduled,
    @NullablePbDateConverter() DateTime? completedOn,
    @NullablePbDateConverter() DateTime? scheduledOn,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  const Task._();

  bool get completed => completedOn != null;
}
