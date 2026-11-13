import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/app_locale.dart';
import '../localization/app_strings.dart';
import '../storage/preferences.dart';

/// Holds the user's chosen language. `null` until the user picks one.
class LocaleController extends Notifier<AppLocale?> {
  @override
  AppLocale? build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final String? code = prefs.getString(PrefKeys.language);
    return code == null ? null : AppLocale.fromCode(code);
  }

  Future<void> select(AppLocale locale) async {
    state = locale;
    await ref.read(sharedPreferencesProvider).setString(PrefKeys.language, locale.code);
  }
}

final NotifierProvider<LocaleController, AppLocale?> localeControllerProvider =
    NotifierProvider<LocaleController, AppLocale?>(LocaleController.new);

/// Convenience: the effective locale (Hindi is the default before selection).
final Provider<AppLocale> effectiveLocaleProvider = Provider<AppLocale>((Ref ref) {
  return ref.watch(localeControllerProvider) ?? AppLocale.hindi;
});

/// Localized strings for the current locale.
final Provider<AppStrings> stringsProvider = Provider<AppStrings>((Ref ref) {
  return AppStrings(ref.watch(effectiveLocaleProvider));
});

/// Whether the user has completed the onboarding walkthrough.
class OnboardingController extends Notifier<bool> {
  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(PrefKeys.onboardingDone) ?? false;
  }

  Future<void> complete() async {
    state = true;
    await ref.read(sharedPreferencesProvider).setBool(PrefKeys.onboardingDone, true);
  }
}

final NotifierProvider<OnboardingController, bool> onboardingControllerProvider =
    NotifierProvider<OnboardingController, bool>(OnboardingController.new);

/// Authentication + light profile state.
class AuthState {
  const AuthState({
    this.isAuthenticated = false,
    this.profileComplete = false,
    this.phone,
    this.name,
  });

  final bool isAuthenticated;
  final bool profileComplete;
  final String? phone;
  final String? name;

  String get displayName {
    final String? value = name;
    if (value == null || value.trim().isEmpty) {
      return 'Friend';
    }
    return value.split(' ').first;
  }

  AuthState copyWith({
    bool? isAuthenticated,
    bool? profileComplete,
    String? phone,
    String? name,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      profileComplete: profileComplete ?? this.profileComplete,
      phone: phone ?? this.phone,
      name: name ?? this.name,
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return AuthState(
      isAuthenticated: prefs.getBool(PrefKeys.isAuthenticated) ?? false,
      profileComplete: prefs.getBool(PrefKeys.profileDone) ?? false,
      phone: prefs.getString(PrefKeys.phone),
      name: prefs.getString(PrefKeys.userName),
    );
  }

  Future<void> verifyOtp({required String phone}) async {
    state = state.copyWith(isAuthenticated: true, phone: phone);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(PrefKeys.isAuthenticated, true);
    await prefs.setString(PrefKeys.phone, phone);
  }

  Future<void> saveProfile({required String name, String? email}) async {
    state = state.copyWith(profileComplete: true, name: name);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(PrefKeys.profileDone, true);
    await prefs.setString(PrefKeys.userName, name);
  }

  Future<void> signOut() async {
    state = const AuthState();
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(PrefKeys.isAuthenticated);
    await prefs.remove(PrefKeys.profileDone);
    await prefs.remove(PrefKeys.phone);
    await prefs.remove(PrefKeys.userName);
  }
}

final NotifierProvider<AuthController, AuthState> authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
