// lib/theme/theme_constants.dart

import 'package:flutter/material.dart';

/// 🧩 Padding, Radius, Gaps, Durations, Elevations...
class AppConstants {
  // 🔲 Border Radius
  static const BorderRadius radiusXS = BorderRadius.all(Radius.circular(4));
  static const BorderRadius radiusS  = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusM  = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusL  = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXL = BorderRadius.all(Radius.circular(24));

  // 📏 Spacing (margins / padding / gaps)
  static const double spaceXS = 4;
  static const double spaceS  = 8;
  static const double spaceM  = 16;
  static const double spaceL  = 24;
  static const double spaceXL = 32;

  // ⏱ Durations
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 400);
  static const Duration longDuration = Duration(milliseconds: 700);

  // 🧱 Elevation
  static const double elevationLow    = 2;
  static const double elevationMedium = 6;
  static const double elevationHigh   = 12;

  // 🎨 Animation Curve
  static const Curve animationCurve = Curves.easeInOut;

  static const gap8 = SizedBox(width: 8);
  static const vGap16 = SizedBox(height: 16);
}
