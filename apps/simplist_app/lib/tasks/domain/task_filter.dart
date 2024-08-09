import 'package:simplist_app/tasks/domain/task.dart';

enum TaskFilter {
  none,
  completed,
  completedToday,
  uncompleted,
  inbox,
  today;

  ScheduleType get scheduleType => switch (this) {
        TaskFilter.none ||
        TaskFilter.completed ||
        TaskFilter.uncompleted ||
        TaskFilter.completedToday ||
        TaskFilter.today =>
          ScheduleType.today,
        TaskFilter.inbox => ScheduleType.none,
      };

  bool get canCreate => switch (this) {
        TaskFilter.none ||
        TaskFilter.uncompleted ||
        TaskFilter.inbox ||
        TaskFilter.today =>
          true,
        TaskFilter.completed || TaskFilter.completedToday => false,
      };
}
