import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/primary_button.dart';
import '../domain/models.dart';

/// SCREEN 13 — Ride Details: full information before booking.
class RideDetailsScreen extends ConsumerWidget {
  const RideDetailsScreen({super.key, required this.ride});

  final Ride ride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(s.rideDetails)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: <Widget>[
          _DriverCard(ride: ride, s: s),
          const SizedBox(height: AppSpacing.sm),
          _VehicleCard(ride: ride, s: s),
          const SizedBox(height: AppSpacing.sm),
          _TripCard(ride: ride, s: s),
          const SizedBox(height: AppSpacing.sm),
          _PointsCard(
            title: s.pickupPoint,
            points: ride.pickupPoints,
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.sm),
          _PointsCard(
            title: s.dropPoint,
            points: ride.dropPoints,
            color: AppColors.secondary,
          ),
          const SizedBox(height: AppSpacing.sm),
          _AmenitiesCard(ride: ride, s: s),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      formatInr(ride.pricePerSeat),
                      style: text.headlineMedium?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Text(s.perSeat, style: text.bodySmall),
                  ],
                ),
              ),
              Expanded(
                child: PrimaryButton(
                  label: s.bookNow,
                  onPressed: () =>
                      context.push(AppRoutes.bookingConfirm, extra: ride),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.ride, required this.s});

  final Ride ride;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return _Card(
      child: Row(
        children: <Widget>[
          Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              ride.driver.name.substring(0, 1).toUpperCase(),
              style: text.titleLarge?.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        ride.driver.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleMedium,
                      ),
                    ),
                    if (ride.driver.verified) ...<Widget>[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded,
                          size: 18, color: AppColors.primary),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star_rounded,
                        size: 16, color: AppColors.secondary),
                    const SizedBox(width: 2),
                    Text(ride.driver.rating.toStringAsFixed(1),
                        style: text.bodyMedium),
                    Text(' · ${ride.driver.trips} ${s.tripsLabel}',
                        style: text.bodyMedium),
                  ],
                ),
              ],
            ),
          ),
          _RoundAction(
            icon: Icons.call_rounded,
            tooltip: s.call,
            onTap: () {},
          ),
          const SizedBox(width: AppSpacing.xs),
          _RoundAction(
            icon: Icons.chat_bubble_outline_rounded,
            tooltip: s.message,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.lightGreen,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 42,
            width: 42,
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  const _VehicleCard({required this.ride, required this.s});

  final Ride ride;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return _Card(
      child: Row(
        children: <Widget>[
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: const Icon(Icons.directions_car_rounded,
                color: AppColors.textPrimary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(s.vehicleInfo, style: text.bodySmall),
                Text(ride.vehicleModel, style: text.titleSmall),
                Text('${ride.plate} · ${ride.ac ? s.ac : s.nonAc}',
                    style: text.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            ),
            child: Text(
              ride.vehicleType,
              style: text.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.ride, required this.s});

  final Ride ride;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(s.routeLabel, style: text.titleSmall),
          const SizedBox(height: AppSpacing.md),
          _TimeRow(
            label: s.departure,
            time: formatTime(ride.departure),
            place: ride.from,
            color: AppColors.primary,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: Container(
              width: 2,
              height: 22,
              color: AppColors.border,
            ),
          ),
          _TimeRow(
            label: s.arrival,
            time: formatTime(ride.arrival),
            place: ride.to,
            color: AppColors.secondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              const Icon(Icons.schedule_rounded,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Text('${s.duration}: ${formatDuration(ride.duration)}',
                  style: text.bodySmall),
              const Spacer(),
              Text(s.seatsAvailable(ride.seatsAvailable),
                  style: text.bodySmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.label,
    required this.time,
    required this.place,
    required this.color,
  });

  final String label;
  final String time;
  final String place;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$label · $time',
                  style: text.titleSmall?.copyWith(fontSize: 15)),
              Text(place, style: text.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _PointsCard extends StatelessWidget {
  const _PointsCard({
    required this.title,
    required this.points,
    required this.color,
  });

  final String title;
  final List<String> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: text.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          for (final String point in points)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: <Widget>[
                  Icon(Icons.place_outlined, size: 18, color: color),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(child: Text(point, style: text.bodyMedium)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _AmenitiesCard extends StatelessWidget {
  const _AmenitiesCard({required this.ride, required this.s});

  final Ride ride;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(s.amenities, style: text.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: ride.amenities
                .map(
                  (String a) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusPill),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(a, style: text.bodySmall),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
