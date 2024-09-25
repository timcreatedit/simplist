// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class TypographySemantic extends ThemeExtension<TypographySemantic> {
  const TypographySemantic({
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  TypographySemantic.standard()
      : bodyLarge = GoogleFonts.getFont(
          'Atkinson Hyperlegible',
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.0,
          height: 1.5,
          decoration: TextDecoration.none,
        ),
        bodyMedium = GoogleFonts.getFont(
          'Atkinson Hyperlegible',
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.0,
          height: 1.4000000272478377,
          decoration: TextDecoration.none,
        ),
        bodySmall = GoogleFonts.getFont(
          'Atkinson Hyperlegible',
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.0,
          height: 1.3300000826517742,
          decoration: TextDecoration.none,
        ),
        displayLarge = GoogleFonts.getFont(
          'Darker Grotesque',
          fontSize: 51.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: -1.53,
          height: 0.7000000149595971,
          decoration: TextDecoration.none,
        ),
        displayMedium = GoogleFonts.getFont(
          'Darker Grotesque',
          fontSize: 45.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: -0.9,
          height: 0.7,
          decoration: TextDecoration.none,
        ),
        displaySmall = GoogleFonts.getFont(
          'Darker Grotesque',
          fontSize: 36.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.0,
          height: 0.6999999682108561,
          decoration: TextDecoration.none,
        ),
        headlineLarge = GoogleFonts.getFont(
          'Darker Grotesque',
          fontSize: 32.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.0,
          height: 0.699999988079071,
          decoration: TextDecoration.none,
        ),
        headlineMedium = GoogleFonts.getFont(
          'Darker Grotesque',
          fontSize: 28.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.0,
          height: 0.7000000136239188,
          decoration: TextDecoration.none,
        ),
        headlineSmall = GoogleFonts.getFont(
          'Darker Grotesque',
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.0,
          height: 0.6999999682108561,
          decoration: TextDecoration.none,
        ),
        labelLarge = GoogleFonts.getFont(
          'Atkinson Hyperlegible',
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.42,
          height: 1.5,
          decoration: TextDecoration.none,
        ),
        labelMedium = GoogleFonts.getFont(
          'Atkinson Hyperlegible',
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.6000000000000001,
          height: 1.3999999364217122,
          decoration: TextDecoration.none,
        ),
        labelSmall = GoogleFonts.getFont(
          'Atkinson Hyperlegible',
          fontSize: 11.0,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.88,
          height: 1.3300000104037197,
          decoration: TextDecoration.none,
        );

  final TextStyle bodyLarge;

  final TextStyle bodyMedium;

  final TextStyle bodySmall;

  final TextStyle displayLarge;

  final TextStyle displayMedium;

  final TextStyle displaySmall;

  final TextStyle headlineLarge;

  final TextStyle headlineMedium;

  final TextStyle headlineSmall;

  final TextStyle labelLarge;

  final TextStyle labelMedium;

  final TextStyle labelSmall;

  @override
  TypographySemantic copyWith([
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  ]) =>
      TypographySemantic(
        bodyLarge: bodyLarge ?? this.bodyLarge,
        bodyMedium: bodyMedium ?? this.bodyMedium,
        bodySmall: bodySmall ?? this.bodySmall,
        displayLarge: displayLarge ?? this.displayLarge,
        displayMedium: displayMedium ?? this.displayMedium,
        displaySmall: displaySmall ?? this.displaySmall,
        headlineLarge: headlineLarge ?? this.headlineLarge,
        headlineMedium: headlineMedium ?? this.headlineMedium,
        headlineSmall: headlineSmall ?? this.headlineSmall,
        labelLarge: labelLarge ?? this.labelLarge,
        labelMedium: labelMedium ?? this.labelMedium,
        labelSmall: labelSmall ?? this.labelSmall,
      );

  @override
  TypographySemantic lerp(
    TypographySemantic? other,
    double t,
  ) {
    if (other is! TypographySemantic) return this;
    return TypographySemantic(
      bodyLarge: TextStyle.lerp(
        bodyLarge,
        other.bodyLarge,
        t,
      )!,
      bodyMedium: TextStyle.lerp(
        bodyMedium,
        other.bodyMedium,
        t,
      )!,
      bodySmall: TextStyle.lerp(
        bodySmall,
        other.bodySmall,
        t,
      )!,
      displayLarge: TextStyle.lerp(
        displayLarge,
        other.displayLarge,
        t,
      )!,
      displayMedium: TextStyle.lerp(
        displayMedium,
        other.displayMedium,
        t,
      )!,
      displaySmall: TextStyle.lerp(
        displaySmall,
        other.displaySmall,
        t,
      )!,
      headlineLarge: TextStyle.lerp(
        headlineLarge,
        other.headlineLarge,
        t,
      )!,
      headlineMedium: TextStyle.lerp(
        headlineMedium,
        other.headlineMedium,
        t,
      )!,
      headlineSmall: TextStyle.lerp(
        headlineSmall,
        other.headlineSmall,
        t,
      )!,
      labelLarge: TextStyle.lerp(
        labelLarge,
        other.labelLarge,
        t,
      )!,
      labelMedium: TextStyle.lerp(
        labelMedium,
        other.labelMedium,
        t,
      )!,
      labelSmall: TextStyle.lerp(
        labelSmall,
        other.labelSmall,
        t,
      )!,
    );
  }
}

extension TypographySemanticBuildContextX on BuildContext {
  TypographySemantic get typographySemantic =>
      Theme.of(this).extension<TypographySemantic>()!;
}

@immutable
class TypographyM3 extends ThemeExtension<TypographyM3> {
  const TypographyM3({
    required this.bodyMedium,
    required this.labelMedium,
    required this.labelSmall,
  });

  TypographyM3.standard()
      : bodyMedium = GoogleFonts.getFont(
          'Roboto',
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.25,
          height: 1.4285714285714286,
          decoration: TextDecoration.none,
        ),
        labelMedium = GoogleFonts.getFont(
          'Roboto',
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.5,
          height: 1.3333333333333333,
          decoration: TextDecoration.none,
        ),
        labelSmall = GoogleFonts.getFont(
          'Roboto',
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.5,
          height: 1.4545454545454546,
          decoration: TextDecoration.none,
        );

  final TextStyle bodyMedium;

  final TextStyle labelMedium;

  final TextStyle labelSmall;

  @override
  TypographyM3 copyWith([
    TextStyle? bodyMedium,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
  ]) =>
      TypographyM3(
        bodyMedium: bodyMedium ?? this.bodyMedium,
        labelMedium: labelMedium ?? this.labelMedium,
        labelSmall: labelSmall ?? this.labelSmall,
      );

  @override
  TypographyM3 lerp(
    TypographyM3? other,
    double t,
  ) {
    if (other is! TypographyM3) return this;
    return TypographyM3(
      bodyMedium: TextStyle.lerp(
        bodyMedium,
        other.bodyMedium,
        t,
      )!,
      labelMedium: TextStyle.lerp(
        labelMedium,
        other.labelMedium,
        t,
      )!,
      labelSmall: TextStyle.lerp(
        labelSmall,
        other.labelSmall,
        t,
      )!,
    );
  }
}

extension TypographyM3BuildContextX on BuildContext {
  TypographyM3 get typographyM3 => Theme.of(this).extension<TypographyM3>()!;
}
