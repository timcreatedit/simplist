// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

import 'package:flutter/material.dart';

@immutable
class ColorsSemantic extends ThemeExtension<ColorsSemantic> {
  const ColorsSemantic({
    required this.interactiveOnPositive,
    required this.interactiveOnPrimary,
    required this.interactiveOnSecondary,
    required this.interactivePositive,
    required this.interactivePrimary,
    required this.interactiveSecondary,
    required this.surfaceNeutral,
    required this.surfaceNeutralOutline,
    required this.surfaceOnNeutral,
    required this.textPrimary,
    required this.textSecondary,
  });

  const ColorsSemantic.standard()
      : interactiveOnPositive = const Color(0xff276e31),
        interactiveOnPrimary = const Color(0xffffffff),
        interactiveOnSecondary = const Color(0xff274592),
        interactivePositive = const Color(0xffe1f7e4),
        interactivePrimary = const Color(0xff7d7be7),
        interactiveSecondary = const Color(0xffe0ecfc),
        surfaceNeutral = const Color(0xfff9f9f9),
        surfaceNeutralOutline = const Color(0xff535550),
        surfaceOnNeutral = const Color(0xff21241f),
        textPrimary = const Color(0xff21241f),
        textSecondary = const Color(0xff8b9184);

  final Color interactiveOnPositive;

  final Color interactiveOnPrimary;

  final Color interactiveOnSecondary;

  final Color interactivePositive;

  final Color interactivePrimary;

  final Color interactiveSecondary;

  final Color surfaceNeutral;

  final Color surfaceNeutralOutline;

  final Color surfaceOnNeutral;

  final Color textPrimary;

  final Color textSecondary;

  @override
  ColorsSemantic copyWith([
    Color? interactiveOnPositive,
    Color? interactiveOnPrimary,
    Color? interactiveOnSecondary,
    Color? interactivePositive,
    Color? interactivePrimary,
    Color? interactiveSecondary,
    Color? surfaceNeutral,
    Color? surfaceNeutralOutline,
    Color? surfaceOnNeutral,
    Color? textPrimary,
    Color? textSecondary,
  ]) =>
      ColorsSemantic(
        interactiveOnPositive:
            interactiveOnPositive ?? this.interactiveOnPositive,
        interactiveOnPrimary: interactiveOnPrimary ?? this.interactiveOnPrimary,
        interactiveOnSecondary:
            interactiveOnSecondary ?? this.interactiveOnSecondary,
        interactivePositive: interactivePositive ?? this.interactivePositive,
        interactivePrimary: interactivePrimary ?? this.interactivePrimary,
        interactiveSecondary: interactiveSecondary ?? this.interactiveSecondary,
        surfaceNeutral: surfaceNeutral ?? this.surfaceNeutral,
        surfaceNeutralOutline:
            surfaceNeutralOutline ?? this.surfaceNeutralOutline,
        surfaceOnNeutral: surfaceOnNeutral ?? this.surfaceOnNeutral,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
      );

  @override
  ColorsSemantic lerp(
    ColorsSemantic? other,
    double t,
  ) {
    if (other is! ColorsSemantic) return this;
    return ColorsSemantic(
      interactiveOnPositive: Color.lerp(
        interactiveOnPositive,
        other.interactiveOnPositive,
        t,
      )!,
      interactiveOnPrimary: Color.lerp(
        interactiveOnPrimary,
        other.interactiveOnPrimary,
        t,
      )!,
      interactiveOnSecondary: Color.lerp(
        interactiveOnSecondary,
        other.interactiveOnSecondary,
        t,
      )!,
      interactivePositive: Color.lerp(
        interactivePositive,
        other.interactivePositive,
        t,
      )!,
      interactivePrimary: Color.lerp(
        interactivePrimary,
        other.interactivePrimary,
        t,
      )!,
      interactiveSecondary: Color.lerp(
        interactiveSecondary,
        other.interactiveSecondary,
        t,
      )!,
      surfaceNeutral: Color.lerp(
        surfaceNeutral,
        other.surfaceNeutral,
        t,
      )!,
      surfaceNeutralOutline: Color.lerp(
        surfaceNeutralOutline,
        other.surfaceNeutralOutline,
        t,
      )!,
      surfaceOnNeutral: Color.lerp(
        surfaceOnNeutral,
        other.surfaceOnNeutral,
        t,
      )!,
      textPrimary: Color.lerp(
        textPrimary,
        other.textPrimary,
        t,
      )!,
      textSecondary: Color.lerp(
        textSecondary,
        other.textSecondary,
        t,
      )!,
    );
  }
}

extension ColorsSemanticBuildContextX on BuildContext {
  ColorsSemantic get colorsSemantic =>
      Theme.of(this).extension<ColorsSemantic>()!;
}
