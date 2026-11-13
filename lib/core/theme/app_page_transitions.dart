import 'package:flutter/material.dart';

/// A clean cross-fade: the incoming page fades in while the outgoing page
/// fades out, with a subtle upward lift. Because both pages animate together,
/// navigation never shows a hard split between two screens.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final Animation<double> fadeIn = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    final Animation<double> fadeOut = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInCubic,
    ));

    return FadeTransition(
      opacity: fadeIn,
      child: FadeTransition(
        opacity: fadeOut,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.015),
            end: Offset.zero,
          ).animate(fadeIn),
          child: child,
        ),
      ),
    );
  }
}
