import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/state/app_controllers.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../features/splash/presentation/splash_overlay.dart';
import 'router/app_router.dart';

class RaastoApp extends ConsumerStatefulWidget {
  const RaastoApp({super.key});

  @override
  ConsumerState<RaastoApp> createState() => _RaastoAppState();
}

class _RaastoAppState extends ConsumerState<RaastoApp> {
  bool _splashVisible = true;

  @override
  Widget build(BuildContext context) {
    final GoRouter router = ref.watch(routerProvider);
    final locale = ref.watch(effectiveLocaleProvider);

    return MaterialApp.router(
      title: 'Raasto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(locale),
      locale: locale.locale,
      supportedLocales: const <Locale>[Locale('hi'), Locale('en')],
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
      builder: (BuildContext context, Widget? child) {
        // Clamp system font scaling so layouts stay usable on small phones
        // while still honouring accessibility preferences.
        final MediaQueryData data = MediaQuery.of(context);
        final double scale = data.textScaler.scale(1).clamp(0.9, 1.3);
        return MediaQuery(
          data: data.copyWith(textScaler: TextScaler.linear(scale)),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // The real destination renders underneath the whole time, so the
              // splash can simply dissolve to reveal it — no cross-fade blend
              // and no platform window flash.
              ColoredBox(
                color: AppColors.background,
                child: child ?? const SizedBox.shrink(),
              ),
              if (_splashVisible)
                SplashOverlay(
                  onFinished: () {
                    if (mounted) {
                      setState(() => _splashVisible = false);
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
