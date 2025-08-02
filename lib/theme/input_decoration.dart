import 'package:flutter/material.dart';

InputDecorationTheme getInputDecorationTheme(ColorScheme colors) {
  final radius = BorderRadius.circular(12);
  return InputDecorationTheme(
    filled: true,
    fillColor: colors.surfaceVariant.withOpacity(0.2),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

    // Borders
    border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: colors.outline, width: 1)),
    enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: colors.outline, width: 1)),
    disabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: colors.outline.withOpacity(0.5), width: 1)),
    focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: colors.primary, width: 2)),
    errorBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: colors.error, width: 1.5)),
    focusedErrorBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: colors.error, width: 2)),

    // Label & floating label
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    floatingLabelStyle: TextStyle(color: colors.primary, fontWeight: FontWeight.w500),
    labelStyle: TextStyle(color: colors.onSurface),

    // Hint, helper, counter, error
    hintStyle: TextStyle(color: colors.onSurfaceVariant, fontWeight: FontWeight.w400),
    helperStyle: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
    counterStyle: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
    errorStyle: TextStyle(color: colors.error, fontSize: 12),

    // Icons
    prefixIconColor: colors.onSurfaceVariant,
    suffixIconColor: colors.onSurfaceVariant,
    // disabledPrefixIconColor: colors.onSurfaceVariant.withOpacity(0.5),
    // disabledSuffixIconColor: colors.onSurfaceVariant.withOpacity(0.5),

    // Misc
    alignLabelWithHint: true,
    hoverColor: colors.surfaceVariant.withOpacity(0.1),
    focusColor: colors.primary.withOpacity(0.1),
  );
}
