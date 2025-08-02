import 'package:flutter/material.dart';

CardTheme getCardTheme(ColorScheme colors) {
  return CardTheme(
    color: colors.surface,
    shadowColor: colors.shadow,
    surfaceTintColor: colors.surfaceTint,
    elevation: 4,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(
        color: colors.outline.withValues(alpha: 60),
        width: 1,
      ),
    ),
    clipBehavior: Clip.antiAlias,
  );
}
