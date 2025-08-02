import 'package:flutter/material.dart';

ElevatedButtonThemeData getElevatedButtonTheme(ColorScheme colors) {
  final overlay = WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.pressed)) return colors.primary.withOpacity(0.12);
    if (states.contains(WidgetState.hovered)) return colors.primary.withOpacity(0.08);
    return null;
  });

  return ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return colors.onSurface.withOpacity(0.12);
        return colors.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return colors.onSurface.withOpacity(0.38);
        return colors.onPrimary;
      }),
      overlayColor: overlay,
      elevation: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.pressed) ? 2 : 0),
      minimumSize: MaterialStateProperty.all(const Size(64, 48)),
      tapTargetSize: MaterialTapTargetSize.padded,
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
    ),
  );
}

OutlinedButtonThemeData getOutlinedButtonTheme(ColorScheme colors) {
  const _btnRadius  = BorderRadius.all(Radius.circular(12));
  const _btnPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 14);

  final overlay = WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.pressed)) return colors.primary.withValues(alpha: 30);
    if (states.contains(WidgetState.hovered)) return colors.primary.withValues(alpha: 20);
    return null;
  });

  return OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return colors.onSurface.withValues(alpha: 97);
        return colors.primary;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return colors.surfaceContainerHighest.withValues(alpha: 10);
        }
        return null;
      }),
      overlayColor: overlay,
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: colors.outline.withValues(alpha: 76), width: 1.5);
        }
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colors.primary, width: 2.0);
        }
        return BorderSide(color: colors.primary, width: 1.5);
      }),
      shape:    WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: _btnRadius)),
      padding:  WidgetStateProperty.all(_btnPadding),
      minimumSize: WidgetStateProperty.all(const Size(64, 48)),
      textStyle:   WidgetStateProperty.all(const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      tapTargetSize: MaterialTapTargetSize.padded,
      enableFeedback: true,
    ),
  );
}


TextButtonThemeData getTextButtonTheme(ColorScheme colors) {
  const radius = BorderRadius.all(Radius.circular(12));
  const padding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);

  final overlay = WidgetStateProperty.resolveWith<Color?>((states) {
    if (states.contains(WidgetState.pressed)) return colors.primary.withValues(alpha: 24);
    if (states.contains(WidgetState.hovered)) return colors.primary.withValues(alpha: 16);
    return null;
  });

  return TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return colors.onSurface.withValues(alpha: 97);
        return colors.primary;
      }),
      overlayColor: overlay,
      padding: WidgetStateProperty.all(padding),
      minimumSize: WidgetStateProperty.all(const Size(64, 40)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: radius),
      ),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      tapTargetSize: MaterialTapTargetSize.padded,
      enableFeedback: true,
    ),
  );
}


