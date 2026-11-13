/// Central route path constants. Use these instead of raw strings.
class AppRoutes {
  const AppRoutes._();

  static const String language = '/language';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String profileSetup = '/profile-setup';

  static const String home = '/home';
  static const String bookings = '/home/bookings';
  static const String notifications = '/home/notifications';
  static const String profile = '/home/profile';

  // Passenger booking flow (full-screen, outside the bottom-nav shell).
  static const String search = '/search';
  static const String ride = '/ride';
  static const String bookingConfirm = '/booking/confirm';
  static const String bookingSuccess = '/booking/success';

  // Trip tracking + ratings.
  static const String track = '/track';
  static const String rate = '/rate';

  // Goods transport flow.
  static const String goods = '/goods';
  static const String goodsQuotes = '/goods/quotes';
  static const String goodsSuccess = '/goods/success';

  // Driver mode.
  static const String driver = '/driver';
}
