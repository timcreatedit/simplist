import 'package:flutter/material.dart';
import 'package:simplist_app/lang/localization/localizations.dart';
import 'package:simplist_app/tasks/domain/task_filter.dart';

extension TaskFilterViewGetters on TaskFilter {
  IconData get icon => switch (this) {
        TaskFilter.today => Icons.wb_sunny_rounded,
        TaskFilter.inbox => Icons.inbox_rounded,
        TaskFilter.completed => Icons.book_rounded,
        _ => Icons.task_rounded,
      };

  String translation(L10n l10n) => switch (this) {
        TaskFilter.today => l10n.today,
        TaskFilter.inbox => l10n.inbox,
        TaskFilter.completed => l10n.logbook,
        _ => l10n.logbook,
      };
}
