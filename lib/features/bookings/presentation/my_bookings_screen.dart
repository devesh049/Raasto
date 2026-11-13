import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/confirmation_dialog.dart';
import '../../../shared/widgets/state_views.dart';
import '../../booking/data/bookings_store.dart';
import '../../search/domain/models.dart';

/// SCREEN 47 — My Bookings (passenger), driven by the local bookings store.
class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings s = ref.watch(stringsProvider);

    final List<String> tabs = <String>[
      s.tabUpcoming,
      s.tabPending,
      s.tabCompleted,
      s.tabCancelled,
    ];

    final List<List<BookingReceipt>> groups = <List<BookingReceipt>>[
      ref.watch(upcomingBookingsProvider),
      ref.watch(pendingBookingsProvider),
      ref.watch(completedBookingsProvider),
      ref.watch(cancelledBookingsProvider),
    ];

    final List<String> emptyDesc = <String>[
      s.noUpcomingDesc,
      s.noPendingDesc,
      s.noCompletedDesc,
      s.noCancelledDesc,
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.navBookings),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: Theme.of(context).textTheme.titleSmall,
            tabs: tabs.map((String t) => Tab(text: t)).toList(),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            for (int i = 0; i < groups.length; i++)
              _BookingList(
                bookings: groups[i],
                emptyDesc: emptyDesc[i],
                s: s,
              ),
          ],
        ),
      ),
    );
  }
}

class _BookingList extends ConsumerWidget {
  const _BookingList({
    required this.bookings,
    required this.emptyDesc,
    required this.s,
  });

  final List<BookingReceipt> bookings;
  final String emptyDesc;
  final AppStrings s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (bookings.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: s.noBookings,
        message: emptyDesc,
        primaryActionLabel: s.findRides,
        onPrimaryAction: () => context.go(AppRoutes.home),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xxl,
      ),
      itemCount: bookings.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (BuildContext context, int index) {
        return _BookingCard(receipt: bookings[index], s: s);
      },
    );
  }
}

class _BookingCard extends ConsumerWidget {
  const _BookingCard({required this.receipt, required this.s});

  final BookingReceipt receipt;
  final AppStrings s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextTheme text = Theme.of(context).textTheme;
    final Ride ride = receipt.ride;

    final bool cancelled = receipt.cancelled;
    final bool completed = receipt.completed;

    final (String statusLabel, Color statusColor, Color statusBg) = cancelled
        ? (s.tabCancelled, AppColors.error, AppColors.error.withValues(alpha: 0.1))
        : completed
            ? (s.tabCompleted, AppColors.success,
                AppColors.success.withValues(alpha: 0.12))
            : receipt.paidOnline
                ? (s.tabUpcoming, AppColors.primary, AppColors.lightGreen)
                : (s.pendingPayment, AppColors.secondary, AppColors.lightOrange);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${ride.from} → ${ride.to}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel,
                  style: text.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              const Icon(Icons.schedule_rounded,
                  size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${formatDay(ride.departure)} · ${formatTime(ride.departure)}',
                style: text.bodySmall,
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.event_seat_rounded,
                  size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('${receipt.seats}', style: text.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.lightGreen,
                child: Text(
                  ride.driver.name.substring(0, 1),
                  style: text.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(ride.driver.name,
                    style: text.bodySmall, overflow: TextOverflow.ellipsis),
              ),
              Text(
                formatInr(receipt.total),
                style: text.titleSmall?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Text(
                '#${receipt.id}',
                style: text.bodySmall?.copyWith(fontSize: 11),
              ),
              const Spacer(),
              if (!cancelled && !completed) ...<Widget>[
                TextButton.icon(
                  onPressed: () => context.push(AppRoutes.track, extra: receipt),
                  icon: const Icon(Icons.location_on_outlined, size: 18),
                  label: Text(s.trackRide),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
                TextButton(
                  onPressed: () => _confirmCancel(context, ref),
                  style: TextButton.styleFrom(foregroundColor: AppColors.error),
                  child: Text(s.cancelBooking),
                ),
              ],
              if (completed)
                TextButton.icon(
                  onPressed: () => context.push(AppRoutes.rate, extra: receipt),
                  icon: const Icon(Icons.star_outline_rounded, size: 18),
                  label: Text(s.rateRide),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.secondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, WidgetRef ref) async {
    final bool ok = await showConfirmDialog(
      context,
      title: s.confirmCancelTitle,
      message: s.confirmCancelDesc,
      confirmLabel: s.yesCancel,
      cancelLabel: s.keepBooking,
      isDestructive: true,
    );
    if (!ok) {
      return;
    }
    await ref.read(bookingsProvider.notifier).cancel(receipt.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.bookingCancelledMsg)),
      );
    }
  }
}
