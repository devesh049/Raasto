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
import '../../../shared/widgets/secondary_button.dart';
import '../../search/domain/models.dart';

/// SCREEN 15 — Booking Success: confirmation and receipt.
class BookingSuccessScreen extends ConsumerWidget {
  const BookingSuccessScreen({super.key, required this.receipt});

  final BookingReceipt receipt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;
    final Ride ride = receipt.ride;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(s.bookingConfirmed),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: <Widget>[
          Center(
            child: Container(
              height: 96,
              width: 96,
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  size: 52, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            s.bookingConfirmed,
            textAlign: TextAlign.center,
            style: text.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            s.bookingConfirmedDesc,
            textAlign: TextAlign.center,
            style: text.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: <Widget>[
                _Row(
                  label: s.bookingId,
                  value: receipt.id,
                  emphasize: true,
                ),
                const Divider(height: AppSpacing.lg),
                _Row(
                  label: s.driverInfo,
                  value: ride.driver.name,
                ),
                _Row(
                  label: s.vehicleInfo,
                  value: '${ride.vehicleModel} · ${ride.plate}',
                ),
                _Row(
                  label: s.from,
                  value: ride.from,
                ),
                _Row(
                  label: s.to,
                  value: ride.to,
                ),
                _Row(
                  label: s.departure,
                  value: '${formatDay(ride.departure)} · ${formatTime(ride.departure)}',
                ),
                _Row(
                  label: s.seats,
                  value: '${receipt.seats}',
                ),
                _Row(
                  label: s.paymentMethod,
                  value: receipt.paidOnline ? s.payOnline : s.payCash,
                ),
                const Divider(height: AppSpacing.lg),
                _Row(
                  label: s.totalPayable,
                  value: formatInr(receipt.total),
                  emphasize: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: s.viewTicket,
            icon: Icons.receipt_long_rounded,
            onPressed: () => context.go(AppRoutes.bookings),
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: s.shareTicket,
            icon: Icons.share_rounded,
            onPressed: () {},
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: s.backToHome,
            icon: Icons.home_rounded,
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: emphasize
                  ? text.titleSmall?.copyWith(color: AppColors.primary)
                  : text.titleSmall?.copyWith(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
