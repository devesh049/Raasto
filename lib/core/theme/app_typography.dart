import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../localization/app_locale.dart';
import 'app_colors.dart';

/// Typography scale.
///
/// English uses Inter, Hindi uses Noto Sans Devanagari so Devanagari glyphs
/// render correctly at every size.
class AppTypography {
  const AppTypography._();

  static TextTheme textTheme(AppLocale locale) {
    final TextTheme base = locale.isHindi
        ? GoogleFonts.notoSansDevanagariTextTheme()
        : GoogleFonts.interTextTheme();

    return base.copyWith(
      // Main heading 24–28
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 28,
        height: 1.25,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontSize: 24,
        height: 1.28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      // Section heading 18–20
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      // Card title 16–18
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      // Body 14–16
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      // Supporting 12–14
      bodySmall: base.bodySmall?.copyWith(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Triggers loading of both brand font families and their common weights so
  /// screens never reflow when text first appears. Resolves immediately once
  /// fonts are cached, and is bounded so startup stays fast even on a slow or
  /// offline network (where the bundled fallback font is used).
  ///
  /// The work is started once and shared, so kicking it off from `main()` and
  /// awaiting it from the splash never fetches the same fonts twice.
  static Future<void> warmUp() => _warmUpFuture ??= _runWarmUp();

  static Future<void>? _warmUpFuture;

  static Future<void> _runWarmUp() async {
    for (final FontWeight weight in <FontWeight>[
      FontWeight.w400,
      FontWeight.w500,
      FontWeight.w600,
      FontWeight.w700,
      FontWeight.w800,
    ]) {
      GoogleFonts.inter(fontWeight: weight);
      GoogleFonts.notoSansDevanagari(fontWeight: weight);
    }
    try {
      await GoogleFonts.pendingFonts().timeout(const Duration(seconds: 2));
    } catch (_) {
      // Never block startup on font loading.
    }
  }

  /// Important fare / price style (22–26).
  static TextStyle fare(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        );
  }
}
