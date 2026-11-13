import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/models.dart';

/// Compact ride summary used in the search results list.
class RideCard extends StatelessWidget {
  const RideCard({
    super.key,
    required this.ride,
    required this.s,
    required this.onTap,
    required this.onBook,
  });

  final Ride ride;
  final AppStrings s;
  final VoidCallback onTap;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _Avatar(initial: ride.driver.name.substring(0, 1)),
                  const SizedBox(width: AppSpacing.sm),
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
                                style: text.titleSmall,
                              ),
                            ),
                            if (ride.driver.verified) ...<Widget>[
                              const SizedBox(width: 4),
                              const Icon(Icons.verified_rounded,
                                  size: 16, color: AppColors.primary),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: <Widget>[
                            const Icon(Icons.star_rounded,
                                size: 15, color: AppColors.secondary),
                            const SizedBox(width: 2),
                            Text(
                              ride.driver.rating.toStringAsFixed(1),
                              style: text.bodySmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              ' · ${ride.driver.trips} ${s.tripsLabel}',
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _PriceBlock(ride: ride, s: s),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),
              _Timeline(ride: ride, s: s),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: <Widget>[
                  Icon(
                    ride.ac
                        ? Icons.ac_unit_rounded
                        : Icons.airline_seat_recline_normal_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(ride.ac ? s.ac : s.nonAc, style: text.bodySmall),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs, vertical: 2),
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
                  const Spacer(),
                  Text(
                    s.seatsAvailable(ride.seatsAvailable),
                    style: text.bodySmall?.copyWith(
                      color: ride.seatsAvailable <= 2
                          ? AppColors.error
                          : AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              PrimaryButton(
                label: s.bookNow,
                height: 46,
                onPressed: onBook,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: 46,
      decoration: const BoxDecoration(
        color: AppColors.lightGreen,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
            ),
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.ride, required this.s});

  final Ride ride;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          formatInr(ride.pricePerSeat),
          style: text.titleMedium?.copyWith(color: AppColors.primary),
        ),
        Text(s.perSeat, style: text.bodySmall?.copyWith(fontSize: 11)),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.ride, required this.s});

  final Ride ride;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: _Stop(
            time: formatTime(ride.departure),
            place: ride.from,
            color: AppColors.primary,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Column(
            children: <Widget>[
              Text(formatDuration(ride.duration),
                  style: text.bodySmall?.copyWith(fontSize: 11)),
              const Icon(Icons.arrow_forward_rounded,
                  size: 14, color: AppColors.textSecondary),
            ],
          ),
        ),
        Expanded(
          child: _Stop(
            time: formatTime(ride.arrival),
            place: ride.to,
            color: AppColors.secondary,
            alignEnd: true,
          ),
        ),
      ],
    );
  }
}

class _Stop extends StatelessWidget {
  const _Stop({
    required this.time,
    required this.place,
    required this.color,
    this.alignEnd = false,
  });

  final String time;
  final String place;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(time,
            style: text.titleSmall?.copyWith(color: color, fontSize: 15)),
        Text(
          place,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.bodySmall,
        ),
      ],
    );
  }
}
