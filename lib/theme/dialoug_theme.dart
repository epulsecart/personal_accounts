import 'package:flutter/material.dart';

DialogTheme getDialogTheme(ColorScheme colors, TextTheme textTheme) {
  return DialogTheme(
    backgroundColor: colors.surface,
    surfaceTintColor: colors.surfaceTint,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    titleTextStyle: textTheme.titleLarge?.copyWith(
      color: colors.onSurface,
      fontWeight: FontWeight.bold,
    ),
    contentTextStyle: textTheme.bodyMedium?.copyWith(
      color: colors.onSurfaceVariant,
    ),
  );
}
