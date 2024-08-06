import 'package:flutter/material.dart';
import 'package:simplist_app/lang/localization/localizations.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';

extension TaskFilterViewGetters on TaskFilter {
  IconData get icon => switch (this) {
        TaskFilter.uncompletedAndToday => Icons.wb_sunny_rounded,
        TaskFilter.uncompletedAndNotToday => Icons.inbox_rounded,
        TaskFilter.completed => Icons.book_rounded,
        _ => Icons.task_rounded,
      };

  String translation(L10n l10n) => switch (this) {
        TaskFilter.uncompletedAndToday => l10n.today,
        TaskFilter.uncompletedAndNotToday => l10n.inbox,
        TaskFilter.completed => l10n.logbook,
        _ => l10n.appName,
      };
}
