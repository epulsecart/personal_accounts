import 'package:flutter/material.dart';

BottomSheetThemeData getBottomSheetTheme(ColorScheme colors) {
  return BottomSheetThemeData(
    backgroundColor: colors.surface,
    surfaceTintColor: colors.surfaceTint,
    modalBackgroundColor: colors.surface,
    elevation: 8,
    modalElevation: 12,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    showDragHandle: true,
    dragHandleColor: colors.onSurfaceVariant,
    dragHandleSize: const Size(32, 4),
  );
}
