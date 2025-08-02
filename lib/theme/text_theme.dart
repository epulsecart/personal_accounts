// lib/theme/text_theme.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cached M3 base text styles for light/dark
final _material3BaseTextThemes = {
  Brightness.light: Typography.material2021(platform: defaultTargetPlatform).black,
  Brightness.dark:  Typography.material2021(platform: defaultTargetPlatform).white,
};

/// Returns a full TextTheme based on locale + color scheme
TextTheme getTextTheme(Locale locale, ColorScheme colors) {
  final bool isArabic = locale.languageCode == 'ar';

  final brightness = colors.brightness;

  // 1. Pick M3 base
  final base = _material3BaseTextThemes[brightness]!;

  // 2. Load the right GoogleFont family
  TextTheme theme = isArabic
      ? GoogleFonts.tajawalTextTheme(base)
      : GoogleFonts.interTextTheme(base);

  // 3. Bulk override sizes, weights, spacing
  theme = theme.copyWith(
    displayLarge:  theme.displayLarge?.copyWith(height: 1.3, letterSpacing: isArabic ? 0 : 0.15),
    displayMedium: theme.displayMedium?.copyWith(height: 1.3),
    displaySmall:  theme.displaySmall?.copyWith(height: 1.2),
    headlineLarge: theme.headlineLarge?.copyWith(height: 1.2, letterSpacing: isArabic ? 0 : 0.15),
    headlineMedium:theme.headlineMedium?.copyWith(height: 1.2),
    headlineSmall: theme.headlineSmall?.copyWith(height: 1.1),
    titleLarge:    theme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold, height: 1.2),
    titleMedium:   theme.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
    titleSmall:    theme.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge:     theme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
    bodyMedium:    theme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
    bodySmall:     theme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge:    theme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.25),
    labelMedium:   theme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4),
    labelSmall:    theme.labelSmall?.copyWith(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5),
  );

  // 4. Ensure text uses onBackground for best contrast
  return theme.apply(
    displayColor: colors.onBackground,
    bodyColor:    colors.onBackground,
    decorationColor: colors.onBackground,
  );
}
