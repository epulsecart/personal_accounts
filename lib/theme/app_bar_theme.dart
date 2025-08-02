import 'package:flutter/material.dart';

AppBarTheme getAppBarTheme(ColorScheme colors, TextTheme textTheme) {
  return AppBarTheme(
    backgroundColor: colors.surface,
    foregroundColor: colors.onSurface,
    elevation: 0,
    shadowColor: colors.shadow,
    centerTitle: true,
    surfaceTintColor: colors.surfaceTint,
    iconTheme: IconThemeData(color: colors.onSurface),
    actionsIconTheme: IconThemeData(color: colors.onSurface),

    titleTextStyle: textTheme.titleLarge?.copyWith(
      color: colors.onSurface,
      fontWeight: FontWeight.bold,
    ),
    toolbarTextStyle: textTheme.bodyMedium?.copyWith(
      color: colors.onSurface,
    ),
  );
}
