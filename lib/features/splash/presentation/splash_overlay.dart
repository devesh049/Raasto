import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/raasto_logo.dart';

/// Full-screen splash that sits above the live app during startup and simply
/// dissolves once the brand moment is over. The real destination is already
/// painted underneath, so the reveal never shows a cross-fade blend or a blank
/// window flash.
class SplashOverlay extends ConsumerStatefulWidget {
  const SplashOverlay({super.key, required this.onFinished});

  /// Called after the exit fade completes; the host removes the overlay.
  final VoidCallback onFinished;

  @override
  ConsumerState<SplashOverlay> createState() => _SplashOverlayState();
}

class _SplashOverlayState extends ConsumerState<SplashOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _exit;

  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _loaderFade;

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _exit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _logoFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    _textFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.30, 0.75, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.30, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _loaderFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
    );

    _intro.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  @override
  void dispose() {
    _intro.dispose();
    _exit.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    // Hold the brand moment long enough to read while fonts (already loading
    // since app start) finish, so the revealed screen never reflows. Bounded so
    // a slow network can never stall the splash.
    await Future.wait<void>(<Future<void>>[
      Future<void>.delayed(const Duration(milliseconds: 700)),
      _warmFonts(),
    ]);
    if (!mounted) {
      return;
    }
    await _exit.forward();
    if (!mounted) {
      return;
    }
    widget.onFinished();
  }

  Future<void> _warmFonts() async {
    try {
      await AppTypography.warmUp().timeout(const Duration(milliseconds: 1200));
    } catch (_) {
      // Never block the splash on font loading.
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);

    return AbsorbPointer(
      child: FadeTransition(
        opacity: ReverseAnimation(_exit),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.primary,
                Color(0xFF0C3D2E),
                AppColors.primaryDark,
              ],
              stops: <double>[0.0, 0.55, 1.0],
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: -120,
                right: -90,
                child: _Glow(
                  size: 320,
                  color: AppColors.secondary.withValues(alpha: 0.28),
                ),
              ),
              Positioned(
                bottom: -140,
                left: -110,
                child: _Glow(
                  size: 360,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
              SafeArea(
                child: Column(
                  children: <Widget>[
                    const Spacer(flex: 7),
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: const RaastoMark(size: 116),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    FadeTransition(
                      opacity: _textFade,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          children: <Widget>[
                            Text(
                              s.appName,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 34,
                                    letterSpacing: -0.6,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              s.tagline,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: AppColors.white.withValues(alpha: 0.88),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 4),
                    FadeTransition(
                      opacity: _loaderFade,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 132,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: const LinearProgressIndicator(
                                minHeight: 3,
                                backgroundColor: Color(0x33FFFFFF),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            s.appName,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.6),
                                  letterSpacing: 3,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[color, color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}
