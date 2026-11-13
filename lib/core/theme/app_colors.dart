import 'package:flutter/material.dart';

/// Raasto brand palette. Keep this the single source of truth for colour.
class AppColors {
  const AppColors._();

  // Brand
  static const Color primary = Color(0xFF145A43); // Primary Green
  static const Color secondary = Color(0xFFF4A340); // Secondary Orange

  // Surfaces
  static const Color background = Color(0xFFF7F8FA);
  static const Color white = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE5E9ED);

  // Text
  static const Color textPrimary = Color(0xFF222B36);
  static const Color textSecondary = Color(0xFF687385);

  // Semantic
  static const Color success = Color(0xFF23865B);
  static const Color error = Color(0xFFD94343);

  // Tints
  static const Color lightGreen = Color(0xFFE8F2ED);
  static const Color lightOrange = Color(0xFFFFF3E2);

  // Derived helpers (kept minimal and consistent)
  static const Color primaryDark = Color(0xFF0E4433);
  static const Color shadow = Color(0x14222B36);
}
