// lib/theme/color_schemes.dart

import 'package:flutter/material.dart';

/// Full Material 3 ColorSchemes for “محاسبي” app

/// Dark mode color scheme (neon-teal primary, purple secondary, orange tertiary)
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  // Primary
  primary: Color(0xFF00FFC6),
  onPrimary: Color(0xFF000000),
  primaryContainer: Color(0xFF00695C),
  onPrimaryContainer: Color(0xFFFFFFFF),

  // Secondary
  secondary: Color(0xFF9B59B6),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFF512DA8),
  onSecondaryContainer: Color(0xFFFFFFFF),

  // Tertiary
  tertiary: Color(0xFFFFA726),
  onTertiary: Color(0xFF000000),
  tertiaryContainer: Color(0xFFEF6C00),
  onTertiaryContainer: Color(0xFFFFFFFF),

  // Error
  error: Color(0xFFFF4C4C),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFB00020),
  onErrorContainer: Color(0xFFFFFFFF),

  // Background & Surface
  background: Color(0xFF121212),
  onBackground: Color(0xFFE0E0E0),
  surface: Color(0xFF1F1F1F),
  onSurface: Color(0xFFE0E0E0),
  surfaceVariant: Color(0xFF2E2E2E),
  onSurfaceVariant: Color(0xFFCCCCCC),

  // Others
  outline: Color(0xFF3C3C3C),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF00FFC6),

  inverseSurface: Color(0xFFE0E0E0),
  onInverseSurface: Color(0xFF1A1A1A),
  inversePrimary: Color(0xFF00BFA5),
);

/// Light mode color scheme (iOS blue primary, green secondary, amber tertiary)
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  // Primary
  primary: Color(0xFF007AFF),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFDCEBFF),
  onPrimaryContainer: Color(0xFF002B50),

  // Secondary
  secondary: Color(0xFF4CAF50),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFC8E6C9),
  onSecondaryContainer: Color(0xFF003B00),

  // Tertiary
  tertiary: Color(0xFFFFC107),
  onTertiary: Color(0xFF000000),
  tertiaryContainer: Color(0xFFFFF8E1),
  onTertiaryContainer: Color(0xFF000000),

  // Error
  error: Color(0xFFD32F2F),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFCDD2),
  onErrorContainer: Color(0xFF410002),

  // Background & Surface
  background: Color(0xFFFFFFFF),
  onBackground: Color(0xFF121212),
  surface: Color(0xFFF5F5F5),
  onSurface: Color(0xFF121212),
  surfaceVariant: Color(0xFFE0E0E0),
  onSurfaceVariant: Color(0xFF4F4F4F),

  // Others
  outline: Color(0xFFBDBDBD),
  shadow: Color(0x33000000),
  surfaceTint: Color(0xFF007AFF),

  inverseSurface: Color(0xFF303030),
  onInverseSurface: Color(0xFFF5F5F5),
  inversePrimary: Color(0xFF0051A2),
);
