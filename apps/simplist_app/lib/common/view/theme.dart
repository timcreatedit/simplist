import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/spacing.dart';
import 'package:simplist_design_system/simplist_design_system.dart';

final $theme =
    NotifierProvider.autoDispose.family<ThemeNotifier, ThemeData, Brightness>(
  ThemeNotifier.new,
);

class ThemeNotifier extends AutoDisposeFamilyNotifier<ThemeData, Brightness> {
  @override
  ThemeData build(Brightness arg) {
    const semanticColors = ColorsSemantic.standard();
    final typography = TypographySemantic.standard();

    final colorScheme = SeedColorScheme.fromSeeds(
      primaryKey: semanticColors.interactivePrimary,
      variant: FlexSchemeVariant.neutral,
      surface: semanticColors.surfaceNeutral,
    );

    return ThemeData.from(
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: typography.displayLarge,
        displayMedium: typography.displayMedium,
        displaySmall: typography.displaySmall,
        headlineLarge: typography.headlineLarge,
        headlineMedium: typography.headlineMedium,
        headlineSmall: typography.headlineSmall,
        bodyLarge: typography.bodyLarge,
        bodyMedium: typography.bodyMedium,
        bodySmall: typography.bodySmall,
        labelLarge: typography.labelLarge,
        labelMedium: typography.labelMedium,
        labelSmall: typography.labelSmall,
      ),
    ).copyWith(
      cardTheme: CardTheme(
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
      extensions: [
        semanticColors,
        typography,
      ],
    );
  }
}
