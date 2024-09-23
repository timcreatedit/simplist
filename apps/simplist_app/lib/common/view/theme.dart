import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simplist_app/common/view/spacing.dart';

final $theme =
    NotifierProvider.autoDispose.family<ThemeNotifier, ThemeData, Brightness>(
  ThemeNotifier.new,
);

class ThemeNotifier extends AutoDisposeFamilyNotifier<ThemeData, Brightness> {
  @override
  ThemeData build(Brightness arg) {
    final colorScheme = SeedColorScheme.fromSeeds(
      primaryKey: Colors.blue,
    );
    return ThemeData.from(
      colorScheme: colorScheme,
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
    );
  }
}
