// lib/theme/theme_extensions.dart

import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Gradient mainGradient;
  final List<BoxShadow> cardShadow;
  final BorderRadius cardRadius;

  const AppThemeExtension({
    required this.mainGradient,
    required this.cardShadow,
    required this.cardRadius,
  });

  @override
  AppThemeExtension copyWith({
    Gradient? mainGradient,
    List<BoxShadow>? cardShadow,
    BorderRadius? cardRadius,
  }) {
    return AppThemeExtension(
      mainGradient: mainGradient ?? this.mainGradient,
      cardShadow: cardShadow ?? this.cardShadow,
      cardRadius: cardRadius ?? this.cardRadius,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;

    return AppThemeExtension(
      mainGradient: LinearGradient.lerp(mainGradient as LinearGradient, other.mainGradient as LinearGradient, t)!,
      cardShadow: BoxShadow.lerpList(cardShadow, other.cardShadow, t)!,
      cardRadius: BorderRadius.lerp(cardRadius, other.cardRadius, t)!,
    );
  }
}
