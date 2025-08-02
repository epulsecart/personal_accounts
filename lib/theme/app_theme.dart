// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

import 'button_app_bar_theme.dart';
import 'color_schemes.dart';
import 'text_theme.dart';
import 'theme_consts.dart';
import 'theme_extensions.dart';
import 'app_bar_theme.dart';
import 'bottom_sheet_theme.dart';
import 'buttons_theme.dart';
import 'card_theme.dart';
import 'dialoug_theme.dart';
import 'input_decoration.dart';
import 'snack_bar_theme.dart';
import 'tab_bar_theme.dart';

class AppTheme {
  static ThemeData buildTheme({
    required ColorScheme colorScheme,
    required Locale locale,
  }) {
    final textTheme = getTextTheme(locale, colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      primaryTextTheme: textTheme,    // أو في M2: `accentTextTheme`

      // Typography & Fonts
      typography: Typography.material2021(),

      // Components
      appBarTheme: getAppBarTheme(colorScheme, textTheme),
      bottomSheetTheme: getBottomSheetTheme(colorScheme),
      bottomNavigationBarTheme: getBottomNavigationBarTheme(colorScheme),
      cardTheme: getCardTheme(colorScheme),
      dialogTheme: getDialogTheme(colorScheme, textTheme),
      inputDecorationTheme: getInputDecorationTheme(colorScheme),
      snackBarTheme: getSnackBarTheme(colorScheme),
      tabBarTheme: getTabBarTheme(colorScheme, textTheme),

      // Buttons
      elevatedButtonTheme: getElevatedButtonTheme(colorScheme),
      outlinedButtonTheme: getOutlinedButtonTheme(colorScheme),
      textButtonTheme: getTextButtonTheme(colorScheme),

      // Constants (radius, durations, etc.) via extensions
      extensions: <ThemeExtension<dynamic>>[
        const AppThemeExtension(
          mainGradient: LinearGradient(
            colors: [Color(0xFF00FFC6), Color(0xFF512DA8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          cardShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          cardRadius: AppConstants.radiusL,
        ),
      ],
    );
  }

  /// Light theme
  static ThemeData light(Locale locale) => buildTheme(
    colorScheme: lightColorScheme,
    locale: locale,
  );

  /// Dark theme
  static ThemeData dark(Locale locale) => buildTheme(
    colorScheme: darkColorScheme,
    locale: locale,
  );
}
