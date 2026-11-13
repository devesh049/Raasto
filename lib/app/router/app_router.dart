import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_locale.dart';
import '../../core/state/app_controllers.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/otp_screen.dart';
import '../../features/booking/presentation/booking_confirm_screen.dart';
import '../../features/booking/presentation/booking_success_screen.dart';
import '../../features/bookings/presentation/my_bookings_screen.dart';
import '../../features/driver/presentation/driver_home_screen.dart';
import '../../features/goods/domain/goods_models.dart';
import '../../features/goods/presentation/goods_quotes_screen.dart';
import '../../features/goods/presentation/goods_request_screen.dart';
import '../../features/goods/presentation/goods_success_screen.dart';
import '../../features/home/presentation/passenger_home_screen.dart';
import '../../features/language/presentation/language_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/profile_setup_screen.dart';
import '../../features/rating/presentation/rating_screen.dart';
import '../../features/search/domain/models.dart';
import '../../features/search/presentation/ride_details_screen.dart';
import '../../features/search/presentation/search_results_screen.dart';
import '../../features/tracking/presentation/trip_tracking_screen.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

/// Bridges Riverpod state changes to GoRouter's refresh mechanism.
class _RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}

/// The destination the app should open on, computed synchronously from the
/// already-loaded preferences so the real screen can render underneath the
/// splash from the very first frame.
String _startLocation(Ref ref) {
  if (ref.read(localeControllerProvider) == null) {
    return AppRoutes.language;
  }
  if (!ref.read(onboardingControllerProvider)) {
    return AppRoutes.onboarding;
  }
  final AuthState auth = ref.read(authControllerProvider);
  if (!auth.isAuthenticated) {
    return AppRoutes.login;
  }
  if (!auth.profileComplete) {
    return AppRoutes.profileSetup;
  }
  return AppRoutes.home;
}

final Provider<GoRouter> routerProvider = Provider<GoRouter>((Ref ref) {
  final _RouterRefresh refresh = _RouterRefresh();
  ref.onDispose(refresh.dispose);

  ref.listen<AppLocale?>(localeControllerProvider, (_, _) => refresh.ping());
  ref.listen<bool>(onboardingControllerProvider, (_, _) => refresh.ping());
  ref.listen<AuthState>(authControllerProvider, (_, _) => refresh.ping());

  return GoRouter(
    initialLocation: _startLocation(ref),
    refreshListenable: refresh,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.language,
        builder: (_, _) => const LanguageScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (BuildContext context, GoRouterState state) {
          final String phone =
              state.extra is String ? state.extra! as String : '';
          return OtpScreen(phone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (_, _) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (BuildContext context, GoRouterState state) {
          final SearchQuery query = state.extra! as SearchQuery;
          return SearchResultsScreen(query: query);
        },
      ),
      GoRoute(
        path: AppRoutes.ride,
        builder: (BuildContext context, GoRouterState state) {
          final Ride ride = state.extra! as Ride;
          return RideDetailsScreen(ride: ride);
        },
      ),
      GoRoute(
        path: AppRoutes.bookingConfirm,
        builder: (BuildContext context, GoRouterState state) {
          final Ride ride = state.extra! as Ride;
          return BookingConfirmScreen(ride: ride);
        },
      ),
      GoRoute(
        path: AppRoutes.bookingSuccess,
        builder: (BuildContext context, GoRouterState state) {
          final BookingReceipt receipt = state.extra! as BookingReceipt;
          return BookingSuccessScreen(receipt: receipt);
        },
      ),
      GoRoute(
        path: AppRoutes.track,
        builder: (BuildContext context, GoRouterState state) {
          final BookingReceipt receipt = state.extra! as BookingReceipt;
          return TripTrackingScreen(receipt: receipt);
        },
      ),
      GoRoute(
        path: AppRoutes.rate,
        builder: (BuildContext context, GoRouterState state) {
          final BookingReceipt receipt = state.extra! as BookingReceipt;
          return RatingScreen(receipt: receipt);
        },
      ),
      GoRoute(
        path: AppRoutes.goods,
        builder: (_, _) => const GoodsRequestScreen(),
      ),
      GoRoute(
        path: AppRoutes.goodsQuotes,
        builder: (BuildContext context, GoRouterState state) {
          final GoodsRequest request = state.extra! as GoodsRequest;
          return GoodsQuotesScreen(request: request);
        },
      ),
      GoRoute(
        path: AppRoutes.goodsSuccess,
        builder: (BuildContext context, GoRouterState state) {
          final GoodsBooking booking = state.extra! as GoodsBooking;
          return GoodsSuccessScreen(booking: booking);
        },
      ),
      GoRoute(
        path: AppRoutes.driver,
        builder: (_, _) => const DriverHomeScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const PassengerHomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.bookings,
                builder: (_, _) => const MyBookingsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.notifications,
                builder: (_, _) => const NotificationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final String loc = state.matchedLocation;
      final AppLocale? locale = ref.read(localeControllerProvider);
      final bool onboarded = ref.read(onboardingControllerProvider);
      final AuthState auth = ref.read(authControllerProvider);

      final bool atLanguage = loc == AppRoutes.language;
      final bool atOnboarding = loc == AppRoutes.onboarding;
      final bool atAuth = loc == AppRoutes.login ||
          loc == AppRoutes.otp ||
          loc == AppRoutes.profileSetup;

      if (locale == null) {
        return atLanguage ? null : AppRoutes.language;
      }
      if (!onboarded) {
        return atOnboarding ? null : AppRoutes.onboarding;
      }
      if (!auth.isAuthenticated) {
        return atAuth ? null : AppRoutes.login;
      }
      if (!auth.profileComplete) {
        return loc == AppRoutes.profileSetup ? null : AppRoutes.profileSetup;
      }
      if (atAuth || atOnboarding || atLanguage) {
        return AppRoutes.home;
      }
      return null;
    },
  );
});
