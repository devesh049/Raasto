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
import '../../search/domain/models.dart';
import '../data/bookings_store.dart';

/// SCREEN 14 — Booking Confirmation: seats, fare breakdown and payment.
class BookingConfirmScreen extends ConsumerStatefulWidget {
  const BookingConfirmScreen({super.key, required this.ride});

  final Ride ride;

  @override
  ConsumerState<BookingConfirmScreen> createState() =>
      _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends ConsumerState<BookingConfirmScreen> {
  int _seats = 1;
  bool _online = false;
  bool _submitting = false;

  double get _base => widget.ride.pricePerSeat * _seats;
  double get _fee => (_base * 0.05).roundToDouble();
  double get _tax => (_base * 0.05).roundToDouble();
  double get _total => _base + _fee + _tax;

  Future<void> _confirm() async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) {
      return;
    }
    final BookingReceipt receipt = BookingReceipt(
      id: 'RST${DateTime.now().millisecondsSinceEpoch % 1000000}',
      ride: widget.ride,
      seats: _seats,
      total: _total,
      paidOnline: _online,
      createdAt: DateTime.now(),
    );
    await ref.read(bookingsProvider.notifier).add(receipt);
    if (!mounted) {
      return;
    }
    context.pushReplacement(AppRoutes.bookingSuccess, extra: receipt);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;
    final Ride ride = widget.ride;

    return Scaffold(
      appBar: AppBar(title: Text(s.bookingSummary)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: <Widget>[
          _Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 44,
                      width: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.lightGreen,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        ride.driver.name.substring(0, 1).toUpperCase(),
                        style: text.titleMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(ride.driver.name, style: text.titleSmall),
                          Text(
                            '${ride.vehicleModel} · ${ride.plate}',
                            style: text.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusPill),
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
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.md),
                _TripLine(
                  dotColor: AppColors.primary,
                  place: ride.from,
                  time: formatTime(ride.departure),
                ),
                const SizedBox(height: AppSpacing.xs),
                _TripLine(
                  dotColor: AppColors.secondary,
                  place: ride.to,
                  time: formatTime(ride.arrival),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${formatDay(ride.departure)} · ${formatDuration(ride.duration)}',
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _Panel(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(s.seats, style: text.titleSmall),
                      Text(
                        s.seatsAvailable(ride.seatsAvailable),
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _seats > 1
                      ? () => setState(() => _seats -= 1)
                      : null,
                  icon: const Icon(Icons.remove_rounded),
                ),
                SizedBox(
                  width: 44,
                  child: Center(
                    child: Text('$_seats', style: text.titleMedium),
                  ),
                ),
                IconButton.filled(
                  onPressed: _seats < ride.seatsAvailable
                      ? () => setState(() => _seats += 1)
                      : null,
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(s.fareBreakdown, style: text.titleSmall),
                const SizedBox(height: AppSpacing.sm),
                _FareRow(
                  label: '${s.baseFare} × $_seats',
                  value: formatInr(_base),
                ),
                _FareRow(label: s.serviceFee, value: formatInr(_fee)),
                _FareRow(label: s.taxes, value: formatInr(_tax)),
                const Divider(height: AppSpacing.lg),
                _FareRow(
                  label: s.totalPayable,
                  value: formatInr(_total),
                  emphasize: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _Panel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(s.paymentMethod, style: text.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                _PaymentTile(
                  icon: Icons.payments_outlined,
                  title: s.payCash,
                  subtitle: s.payCashDesc,
                  selected: !_online,
                  onTap: () => setState(() => _online = false),
                ),
                _PaymentTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: s.payOnline,
                  subtitle: s.payOnlineDesc,
                  selected: _online,
                  onTap: () => setState(() => _online = true),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              const Icon(Icons.info_outline_rounded,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(s.cancelAnytime, style: text.bodySmall),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: '${s.confirmBooking} · ${formatInr(_total)}',
            isLoading: _submitting,
            onPressed: _confirm,
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

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

class _TripLine extends StatelessWidget {
  const _TripLine({
    required this.dotColor,
    required this.place,
    required this.time,
  });

  final Color dotColor;
  final String place;
  final String time;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Row(
      children: <Widget>[
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            place,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleSmall?.copyWith(fontSize: 15),
          ),
        ),
        Text(time, style: text.bodySmall),
      ],
    );
  }
}

class _FareRow extends StatelessWidget {
  const _FareRow({
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: emphasize
                  ? text.titleSmall
                  : text.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Text(
            value,
            style: emphasize
                ? text.titleMedium?.copyWith(color: AppColors.primary)
                : text.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        margin: const EdgeInsets.only(top: AppSpacing.xs),
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.lightGreen : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon,
                color: selected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: text.titleSmall?.copyWith(fontSize: 15)),
                  Text(subtitle, style: text.bodySmall),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
