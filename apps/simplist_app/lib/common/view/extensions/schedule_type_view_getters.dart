import 'package:flutter/material.dart';
import 'package:simplist_app/lang/localization/localizations.dart';
import 'package:simplist_app/tasks/domain/task.dart';

extension TaskFilterViewGetters on ScheduleType {
  IconData get icon => switch (this) {
        ScheduleType.none || ScheduleType.on => Icons.inbox_rounded,
        ScheduleType.today => Icons.wb_sunny_rounded,
      };

  String translation(L10n l10n) => switch (this) {
        ScheduleType.today => l10n.today,
        ScheduleType.none || ScheduleType.on => l10n.inbox,
      };
}
