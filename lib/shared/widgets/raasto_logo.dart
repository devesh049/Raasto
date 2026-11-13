import 'dart:ui' show PathMetric, PathMetrics;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// The Raasto brand mark: a glossy green squircle with a winding road and a
/// destination pin. Drawn with CustomPaint so it scales crisply at any size.
class RaastoMark extends StatelessWidget {
  const RaastoMark({
    super.key,
    this.size = 88,
    this.withShadow = true,
  });

  final double size;

  /// Soft drop shadow under the tile. Disable when the mark sits on a card.
  final bool withShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppColors.primary,
            AppColors.primaryDark,
          ],
          stops: <double>[0.05, 1.0],
        ),
        borderRadius: BorderRadius.circular(size * 0.285),
        boxShadow: withShadow
            ? <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.32),
                  blurRadius: size * 0.30,
                  spreadRadius: -size * 0.02,
                  offset: Offset(0, size * 0.14),
                ),
              ]
            : null,
      ),
      child: CustomPaint(painter: _MarkPainter()),
    );
  }
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // Glossy highlight across the top-left of the tile.
    final Paint gloss = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.75, -0.95),
        radius: 1.1,
        colors: <Color>[
          Colors.white.withValues(alpha: 0.22),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, gloss);

    final Path road = Path()
      ..moveTo(w * 0.25, h * 0.80)
      ..cubicTo(w * 0.44, h * 0.60, w * 0.55, h * 0.72, w * 0.75, h * 0.28);

    // Soft contact shadow under the road for a lifted look (no blur filter so
    // it repaints cheaply during the splash animation).
    final Paint roadShadow = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: 0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.13
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(road.shift(Offset(0, h * 0.025)), roadShadow);

    final Paint roadPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: <Color>[Color(0xFFFFFFFF), Color(0xFFE9F4EE)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.115
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(road, roadPaint);

    // Dashed centre line.
    final Paint dashPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.026
      ..strokeCap = StrokeCap.round;
    final PathMetrics metrics = road.computeMetrics();
    for (final PathMetric metric in metrics) {
      double distance = w * 0.05;
      final double dash = w * 0.075;
      final double gap = w * 0.085;
      while (distance < metric.length - w * 0.05) {
        final double end = (distance + dash).clamp(0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), dashPaint);
        distance = end + gap;
      }
    }

    // Destination pin with a small drop shadow.
    final Offset pin = Offset(w * 0.75, h * 0.27);
    canvas.drawOval(
      Rect.fromCenter(
        center: pin + Offset(0, h * 0.035),
        width: w * 0.19,
        height: h * 0.075,
      ),
      Paint()..color = AppColors.primaryDark.withValues(alpha: 0.22),
    );
    canvas.drawCircle(pin, w * 0.118, Paint()..color = AppColors.secondary);
    canvas.drawCircle(
      pin,
      w * 0.118,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.016,
    );
    canvas.drawCircle(pin, w * 0.048, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) => false;
}

/// Mark plus the "Raasto" wordmark.
class RaastoLogo extends StatelessWidget {
  const RaastoLogo({
    super.key,
    this.size = 72,
    this.showWordmark = true,
    this.axis = Axis.vertical,
  });

  final double size;
  final bool showWordmark;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final Widget mark = RaastoMark(size: size);
    if (!showWordmark) {
      return mark;
    }
    final Widget word = Text(
      'Raasto',
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
    );
    if (axis == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[mark, const SizedBox(width: 12), word],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[mark, const SizedBox(height: 18), word],
    );
  }
}
