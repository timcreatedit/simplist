import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/spacing.dart';

final $theme = NotifierProvider.autoDispose.family(ThemeNotifier.new);

class ThemeNotifier extends Notifier<ThemeData> {
  ThemeNotifier(this.brightness);

  final Brightness brightness;

  @override
  ThemeData build() {
    final colorScheme = SeedColorScheme.fromSeeds(
      primaryKey: const Color.fromARGB(255, 11, 179, 87),
      brightness: brightness,
      variant: FlexSchemeVariant.neutral,
    );
    return ThemeData.from(colorScheme: colorScheme).copyWith(
      cardTheme: CardThemeData(
        margin: const EdgeInsets.all(Spacers.xxs),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Spacers.m),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
      ),
    );
  }
}
