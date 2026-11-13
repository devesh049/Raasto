import 'package:flutter/widgets.dart';

/// The languages Raasto supports at launch.
enum AppLocale {
  english(code: 'en', nativeName: 'English', englishName: 'English'),
  hindi(code: 'hi', nativeName: 'हिन्दी', englishName: 'Hindi');

  const AppLocale({
    required this.code,
    required this.nativeName,
    required this.englishName,
  });

  final String code;
  final String nativeName;
  final String englishName;

  bool get isHindi => this == AppLocale.hindi;

  Locale get locale => Locale(code);

  static AppLocale fromCode(String? code) {
    return AppLocale.values.firstWhere(
      (AppLocale value) => value.code == code,
      orElse: () => AppLocale.english,
    );
  }
}
