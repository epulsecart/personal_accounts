// lib/theme/variants/bottom_nav_theme.dart

import 'package:flutter/material.dart';

const _kNavElevation            = 12.0;
const _kNavSelectedFontSize     = 12.0;
const _kNavUnselectedFontSize   = 12.0;
const _kNavSelectedFontWeight   = FontWeight.w600;
const _kNavUnselectedFontWeight = FontWeight.w400;
const _kNavSelectedIconSize     = 24.0;
const _kNavUnselectedIconSize   = 22.0;
const _kUnselectedAlpha         = 150 / 255;
const _kInactiveAlpha           = 130 / 255;

TextStyle _labelStyle(double size, FontWeight weight) =>
    TextStyle(fontSize: size, fontWeight: weight);

IconThemeData _iconTheme(Color color, double size) =>
    IconThemeData(color: color, size: size);

BottomNavigationBarThemeData getBottomNavigationBarTheme(ColorScheme colors, { bool showLabels = true }) {
  final unselectedColor = colors.onSurface.withValues(alpha: 150);
  final inactiveColor   = colors.onSurface.withValues(alpha: 130);

  return BottomNavigationBarThemeData(
    backgroundColor: colors.surface,
    elevation: _kNavElevation,

    selectedItemColor: colors.primary,
    unselectedItemColor: unselectedColor,

    selectedLabelStyle:   _labelStyle(_kNavSelectedFontSize, _kNavSelectedFontWeight),
    unselectedLabelStyle: _labelStyle(_kNavUnselectedFontSize, _kNavUnselectedFontWeight),
    showUnselectedLabels: showLabels,

    type: BottomNavigationBarType.fixed,

    selectedIconTheme:   _iconTheme(colors.primary, _kNavSelectedIconSize),
    unselectedIconTheme: _iconTheme(inactiveColor,   _kNavUnselectedIconSize),

    landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
  );
}
