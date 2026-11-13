import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys used to persist small pieces of app state locally.
class PrefKeys {
  const PrefKeys._();

  static const String language = 'app.language';
  static const String onboardingDone = 'app.onboarding_done';
  static const String isAuthenticated = 'auth.is_authenticated';
  static const String phone = 'auth.phone';
  static const String userName = 'auth.user_name';
  static const String profileDone = 'auth.profile_done';
  static const String bookings = 'data.bookings';
}

/// Overridden in `main()` once SharedPreferences has been loaded.
final Provider<SharedPreferences> sharedPreferencesProvider =
    Provider<SharedPreferences>((Ref ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});
