import 'package:simplist_app/tasks/domain/task.dart';

enum TaskFilter {
  none,
  completed,
  completedToday,
  uncompleted,
  uncompletedAndToday,
  uncompletedAndNotToday;

  ScheduleType get scheduleType => switch (this) {
        TaskFilter.none ||
        TaskFilter.completed ||
        TaskFilter.uncompleted ||
        TaskFilter.completedToday ||
        TaskFilter.uncompletedAndNotToday =>
          ScheduleType.none,
        TaskFilter.uncompletedAndToday => ScheduleType.today,
      };

  bool get canCreate => switch (this) {
        TaskFilter.none ||
        TaskFilter.uncompleted ||
        TaskFilter.uncompletedAndToday ||
        TaskFilter.uncompletedAndNotToday =>
          true,
        TaskFilter.completed || TaskFilter.completedToday => false,
      };
}
