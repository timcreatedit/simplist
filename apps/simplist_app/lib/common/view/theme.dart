import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final $theme =
    NotifierProvider.autoDispose.family<ThemeNotifier, ThemeData, Brightness>(
  ThemeNotifier.new,
);

class ThemeNotifier extends AutoDisposeFamilyNotifier<ThemeData, Brightness> {
  @override
  ThemeData build(Brightness arg) {
    final colorScheme = SeedColorScheme.fromSeeds(
      primaryKey: const Color(0xFFbcea80),
      brightness: arg,
      variant: FlexSchemeVariant.neutral,
    );
    return ThemeData.from(
      colorScheme: colorScheme,
    ).copyWith(
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
      ),
    );
  }
}
