import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/state_views.dart';
import '../data/published_rides_store.dart';
import '../domain/driver_models.dart';

/// Driver Mode — publish rides and manage what you have shared.
class DriverHomeScreen extends ConsumerStatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  ConsumerState<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends ConsumerState<DriverHomeScreen> {
  final TextEditingController _from = TextEditingController();
  final TextEditingController _to = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _vehicle = TextEditingController();
  final TextEditingController _plate = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 7, minute: 0);
  int _seats = 3;

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    _price.dispose();
    _vehicle.dispose();
    _plate.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _publish(AppStrings s) {
    final String from = _from.text.trim();
    final String to = _to.text.trim();
    final String vehicle = _vehicle.text.trim();
    final String plate = _plate.text.trim();
    final double? price = double.tryParse(_price.text.trim());

    if (from.isEmpty || to.isEmpty || vehicle.isEmpty || plate.isEmpty) {
      _snack(s.requiredField);
      return;
    }
    if (price == null || price <= 0) {
      _snack(s.requiredField);
      return;
    }

    final DateTime departure = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );

    ref.read(publishedRidesProvider.notifier).add(
          PublishedRide(
            id: 'D-${DateTime.now().millisecondsSinceEpoch % 1000000}',
            from: from,
            to: to,
            departure: departure,
            seats: _seats,
            pricePerSeat: price,
            vehicleModel: vehicle,
            plate: plate,
          ),
        );

    _from.clear();
    _to.clear();
    _price.clear();
    _vehicle.clear();
    _plate.clear();
    setState(() => _seats = 3);
    _snack(s.ridePublished);
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;
    final List<PublishedRide> rides = ref.watch(publishedRidesProvider);
    final double earnings = ref.watch(potentialEarningsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.driverMode)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _StatCard(
                  icon: Icons.currency_rupee_rounded,
                  label: s.todayEarnings,
                  value: formatInr(earnings),
                  tint: AppColors.lightGreen,
                  iconColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _StatCard(
                  icon: Icons.route_rounded,
                  label: s.myPublishedRides,
                  value: '${rides.length}',
                  tint: AppColors.lightOrange,
                  iconColor: AppColors.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(s.publishRide, style: text.titleMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(s.publishRideDesc, style: text.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _from,
            decoration: InputDecoration(
              labelText: s.from,
              prefixIcon: const Icon(Icons.trip_origin_rounded,
                  color: AppColors.primary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _to,
            decoration: InputDecoration(
              labelText: s.to,
              prefixIcon:
                  const Icon(Icons.place_rounded, color: AppColors.secondary),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: _FieldTile(
                  icon: Icons.calendar_today_rounded,
                  label: s.journeyDate,
                  value: DateFormat('d MMM yyyy').format(_date),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _FieldTile(
                  icon: Icons.schedule_rounded,
                  label: s.departureTime,
                  value: _time.format(context),
                  onTap: _pickTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _vehicle,
                  decoration: InputDecoration(labelText: s.vehicleDetails),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: _plate,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Plate No.'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _price,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: false,
                  ),
                  decoration: InputDecoration(
                    labelText: s.perSeat,
                    prefixText: '₹ ',
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(s.seatsOffered, style: text.bodySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: <Widget>[
                        IconButton.filledTonal(
                          onPressed: _seats > 1
                              ? () => setState(() => _seats -= 1)
                              : null,
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('$_seats', style: text.titleMedium),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: _seats < 6
                              ? () => setState(() => _seats += 1)
                              : null,
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: s.publish,
            icon: Icons.add_road_rounded,
            onPressed: () => _publish(s),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(s.myPublishedRides, style: text.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          if (rides.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.lg),
              child: EmptyStateWidget(
                icon: Icons.route_outlined,
                title: s.noPublishedRides,
                message: s.noPublishedRidesDesc,
              ),
            )
          else
            for (final PublishedRide ride in rides)
              _PublishedCard(
                ride: ride,
                s: s,
                onRemove: () {
                  ref.read(publishedRidesProvider.notifier).remove(ride.id);
                  _snack(s.rideRemoved);
                },
              ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
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
          Icon(icon, color: iconColor),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: text.titleLarge),
          Text(label, style: text.bodySmall),
        ],
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  const _FieldTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label, style: text.bodySmall?.copyWith(fontSize: 11)),
                  Text(value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall?.copyWith(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PublishedCard extends StatelessWidget {
  const _PublishedCard({
    required this.ride,
    required this.s,
    required this.onRemove,
  });

  final PublishedRide ride;
  final AppStrings s;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
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
              Text(
                formatInr(ride.pricePerSeat),
                style: text.titleSmall?.copyWith(color: AppColors.primary),
              ),
              Text(' ${s.perSeat}',
                  style: text.bodySmall?.copyWith(fontSize: 11)),
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
              const Spacer(),
              Text(s.seatsAvailable(ride.seats), style: text.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text('${ride.vehicleModel} · ${ride.plate}', style: text.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: Text(s.removeRide),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
