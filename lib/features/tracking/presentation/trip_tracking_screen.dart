import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../search/domain/models.dart';

/// Live trip tracking (mock map + ETA + trip OTP + safety actions).
class TripTrackingScreen extends ConsumerWidget {
  const TripTrackingScreen({super.key, required this.receipt});

  final BookingReceipt receipt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;
    final Ride ride = receipt.ride;

    final int otp = (receipt.id.hashCode.abs() % 9000) + 1000;
    final int eta = 8 + (receipt.id.hashCode.abs() % 12);

    return Scaffold(
      appBar: AppBar(title: Text(s.tripTracking)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: <Widget>[
          SizedBox(
            height: 220,
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(painter: _RouteMapPainter()),
                ),
                Positioned(
                  left: AppSpacing.md,
                  top: AppSpacing.md,
                  child: _StatusPill(
                    icon: Icons.directions_car_filled_rounded,
                    label: s.driverOnTheWay,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.lightGreen,
                        child: Text(
                          ride.driver.name.substring(0, 1),
                          style: text.titleMedium
                              ?.copyWith(color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(ride.driver.name, style: text.titleSmall),
                            Row(
                              children: <Widget>[
                                const Icon(Icons.star_rounded,
                                    size: 15, color: AppColors.secondary),
                                const SizedBox(width: 2),
                                Text(ride.driver.rating.toStringAsFixed(1),
                                    style: text.bodySmall),
                                Text(' · ${ride.vehicleModel} · ${ride.plate}',
                                    style: text.bodySmall,
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () => _snack(context, ride.driver.name),
                        icon: const Icon(Icons.call_rounded),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      IconButton.filledTonal(
                        onPressed: () => _snack(context, s.shareTrip),
                        icon: const Icon(Icons.chat_bubble_outline_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.schedule_rounded,
                        label: s.arrivingIn,
                        value: '~$eta ${s.minutesShort}',
                        tint: AppColors.lightGreen,
                        iconColor: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.route_rounded,
                        label: s.liveLocation,
                        value: '${ride.from} → ${ride.to}',
                        tint: AppColors.lightOrange,
                        iconColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            s.tripOtp,
                            style: text.bodySmall?.copyWith(
                              color: AppColors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            '$otp',
                            style: text.headlineMedium?.copyWith(
                              color: AppColors.white,
                              letterSpacing: 6,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          s.tripOtpDesc,
                          textAlign: TextAlign.right,
                          style: text.bodySmall?.copyWith(
                            color: AppColors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: <Widget>[
                      _Leg(
                        color: AppColors.primary,
                        icon: Icons.trip_origin_rounded,
                        title: s.from,
                        value: ride.from,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _Leg(
                        color: AppColors.secondary,
                        icon: Icons.place_rounded,
                        title: s.to,
                        value: ride.to,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SecondaryButton(
                        label: s.shareTrip,
                        icon: Icons.share_rounded,
                        onPressed: () => _snack(context, s.shareTrip),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: PrimaryButton(
                        label: s.sos,
                        icon: Icons.emergency_share_rounded,
                        backgroundColor: AppColors.error,
                        onPressed: () => _snack(context, s.sos),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: Text(
                    '#${receipt.id}',
                    style: text.bodySmall?.copyWith(fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            height: 8,
            width: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.tint,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.titleSmall),
          Text(label, style: text.bodySmall),
        ],
      ),
    );
  }
}

class _Leg extends StatelessWidget {
  const _Leg({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: text.bodySmall),
              Text(value, style: text.titleSmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint bg = Paint()..color = const Color(0xFFEAF1EC);
    canvas.drawRect(Offset.zero & size, bg);

    final Paint grid = Paint()
      ..color = const Color(0xFFD7E3DA)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final Path route = Path()
      ..moveTo(size.width * 0.12, size.height * 0.78)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.5,
        size.width * 0.6,
        size.height * 0.85,
        size.width * 0.86,
        size.height * 0.28,
      );

    final Paint routePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(route, routePaint);

    final Paint start = Paint()..color = AppColors.secondary;
    canvas.drawCircle(
      Offset(size.width * 0.12, size.height * 0.78),
      9,
      start,
    );
    final Paint end = Paint()..color = AppColors.primary;
    canvas.drawCircle(Offset(size.width * 0.86, size.height * 0.28), 9, end);

    final Paint car = Paint()..color = AppColors.white;
    canvas.drawCircle(Offset(size.width * 0.46, size.height * 0.66), 14, car);
    final Paint carRing = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(size.width * 0.46, size.height * 0.66), 14, carRing);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
