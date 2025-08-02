import 'package:flutter/material.dart';

SnackBarThemeData getSnackBarTheme(ColorScheme colors) {
  return SnackBarThemeData(
    backgroundColor: colors.inverseSurface,
    contentTextStyle: TextStyle(
      color: colors.onInverseSurface,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    actionTextColor: colors.inversePrimary,
    disabledActionTextColor: colors.inversePrimary.withValues(alpha: 100),
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    behavior: SnackBarBehavior.floating,
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}
