import 'package:flutter/material.dart';
import 'package:simplist_app/lang/localization/localizations.dart';

extension ContextConvenience on BuildContext {
  L10n get l10n => L10n.of(this);

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;
}
