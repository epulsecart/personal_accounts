// lib/theme/variants/tab_bar_theme.dart

import 'package:flutter/material.dart';

TabBarTheme getTabBarTheme(ColorScheme colors, TextTheme text) {
  return TabBarTheme(
    // Indicator color and size
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: colors.primary,
        width: 3,
      ),
      insets: const EdgeInsets.symmetric(horizontal: 16),
    ),

    // Label styles
    labelColor: colors.primary,
    unselectedLabelColor: colors.onSurface.withOpacity(0.7),
    labelStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w600),
    unselectedLabelStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w400),

    // Padding and layout
    indicatorSize: TabBarIndicatorSize.label,
    overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.hovered)) {
        return colors.primary.withValues(alpha: 25);
      }
      return null;
    }),
    dividerColor: colors.outline.withOpacity(0.2),
    splashFactory: InkRipple.splashFactory,
  );
}
