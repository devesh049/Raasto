import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/raasto_logo.dart';
import '../../../shared/widgets/secondary_button.dart';
import '../../../shared/widgets/service_card.dart';
import '../../search/domain/models.dart';

/// SCREEN 10 — Passenger Home. The most important screen in the app.
class PassengerHomeScreen extends ConsumerStatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  ConsumerState<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends ConsumerState<PassengerHomeScreen> {
  String? _from;
  String? _to;
  DateTime _date = DateTime.now();
  int _passengers = 1;
  String? _vehicle;

  void _swap() {
    setState(() {
      final String? temp = _from;
      _from = _to;
      _to = temp;
    });
  }

  void _comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ref.read(stringsProvider).comingSoon)),
    );
  }

  void _findRides() {
    final AppStrings s = ref.read(stringsProvider);
    final String from = _from?.trim() ?? '';
    final String to = _to?.trim() ?? '';
    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.enterBothLocations)),
      );
      return;
    }
    final bool anyVehicle = _vehicle == null || _vehicle == s.anyVehicle;
    context.push(
      AppRoutes.search,
      extra: SearchQuery(
        from: from,
        to: to,
        date: _date,
        passengers: _passengers,
        vehicleType: anyVehicle ? null : _vehicle,
      ),
    );
  }

  Future<void> _pickLocation({required bool isFrom}) async {
    final s = ref.read(stringsProvider);
    final List<String> suggestions = <String>[
      'Railway Station',
      'Bus Stand',
      'Main Market',
      'City Hospital',
      'Airport',
    ];

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        final TextEditingController controller = TextEditingController(
          text: isFrom ? (_from ?? '') : (_to ?? ''),
        );
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                isFrom ? s.from : s.to,
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g. Raipur',
                  prefixIcon: const Icon(Icons.search_rounded),
                ),
                onSubmitted: (String value) {
                  if (value.trim().isEmpty) {
                    return;
                  }
                  Navigator.of(ctx).pop();
                  setState(() {
                    if (isFrom) {
                      _from = value.trim();
                    } else {
                      _to = value.trim();
                    }
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              for (final String place in suggestions)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined,
                      color: AppColors.textSecondary),
                  title: Text(place),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      if (isFrom) {
                        _from = place;
                      } else {
                        _to = place;
                      }
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
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

  Future<void> _pickPassengers() async {
    final s = ref.read(stringsProvider);
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (BuildContext ctx, StateSetter setSheet) {
            return Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(s.passengers, style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      IconButton.filledTonal(
                        onPressed: _passengers > 1
                            ? () {
                                setSheet(() {});
                                setState(() => _passengers -= 1);
                              }
                            : null,
                        icon: const Icon(Icons.remove_rounded),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            '$_passengers',
                            style: Theme.of(ctx).textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      IconButton.filled(
                        onPressed: _passengers < 6
                            ? () {
                                setSheet(() {});
                                setState(() => _passengers += 1);
                              }
                            : null,
                        icon: const Icon(Icons.add_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: s.ok,
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _pickVehicle() async {
    final s = ref.read(stringsProvider);
    final List<String> options = <String>[
      s.anyVehicle,
      'Car',
      'SUV',
      'Auto',
      'Bike',
    ];
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(s.vehicleType,
                    style: Theme.of(ctx).textTheme.titleLarge),
              ),
              for (final String option in options)
                ListTile(
                  title: Text(option),
                  trailing: (option == (_vehicle ?? s.anyVehicle))
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary)
                      : null,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() => _vehicle = option);
                  },
                ),
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final AuthState auth = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xxl,
          ),
          children: <Widget>[
            _Header(
              greeting: s.greeting(auth.displayName),
              onNotifications: () => context.go(AppRoutes.notifications),
              onProfile: () => context.go(AppRoutes.profile),
            ),
            const SizedBox(height: AppSpacing.lg),
            _SearchCard(
              s: s,
              from: _from,
              to: _to,
              date: _date,
              passengers: _passengers,
              vehicle: _vehicle,
              onPickFrom: () => _pickLocation(isFrom: true),
              onPickTo: () => _pickLocation(isFrom: false),
              onSwap: _swap,
              onPickDate: _pickDate,
              onPickPassengers: _pickPassengers,
              onPickVehicle: _pickVehicle,
              onFindRides: _findRides,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Expanded(
                  child: ServiceCard(
                    icon: Icons.local_shipping_rounded,
                    title: s.goodsTransport,
                    subtitle: s.sendGoods,
                    actionLabel: s.findVehicle,
                    tint: AppColors.lightOrange,
                    iconColor: AppColors.secondary,
                    onPressed: () => context.push(AppRoutes.goods),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ServiceCard(
                    icon: Icons.sports_motorsports_rounded,
                    title: s.becomeDriver,
                    subtitle: s.earnBySharing,
                    actionLabel: s.startDriving,
                    onPressed: () => context.push(AppRoutes.driver),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _ReturnPromo(
              title: s.returnRideQuestion,
              description: s.returnRideDesc,
              buttonLabel: s.exploreReturn,
              onPressed: _comingSoon,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.onNotifications,
    required this.onProfile,
  });

  final String greeting;
  final VoidCallback onNotifications;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        const RaastoMark(size: 44),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            greeting,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleMedium,
          ),
        ),
        _IconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotifications,
        ),
        const SizedBox(width: AppSpacing.xs),
        GestureDetector(
          onTap: onProfile,
          child: Container(
            height: 42,
            width: 42,
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          height: 42,
          width: 42,
          child: Icon(icon, color: AppColors.textPrimary, size: 22),
        ),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  const _SearchCard({
    required this.s,
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
    required this.vehicle,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onSwap,
    required this.onPickDate,
    required this.onPickPassengers,
    required this.onPickVehicle,
    required this.onFindRides,
  });

  final AppStrings s;
  final String? from;
  final String? to;
  final DateTime date;
  final int passengers;
  final String? vehicle;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onSwap;
  final VoidCallback onPickDate;
  final VoidCallback onPickPassengers;
  final VoidCallback onPickVehicle;
  final VoidCallback onFindRides;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: AppColors.shadow, blurRadius: 18, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(s.whereToGo, style: text.titleMedium),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    _LocationField(
                      dotColor: AppColors.primary,
                      label: s.from,
                      value: from,
                      onTap: onPickFrom,
                    ),
                    const Divider(height: 1),
                    _LocationField(
                      dotColor: AppColors.secondary,
                      label: s.to,
                      value: to,
                      square: true,
                      onTap: onPickTo,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              _SwapButton(onTap: onSwap, tooltip: s.swapLocations),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: _MetaField(
                  icon: Icons.calendar_today_rounded,
                  label: s.journeyDate,
                  value: DateFormat('d MMM yyyy').format(date),
                  onTap: onPickDate,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MetaField(
                  icon: Icons.person_outline_rounded,
                  label: s.passengers,
                  value: '$passengers',
                  onTap: onPickPassengers,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          _MetaField(
            icon: Icons.directions_car_outlined,
            label: s.vehicleType,
            value: vehicle ?? s.anyVehicle,
            onTap: onPickVehicle,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: s.findRides,
            icon: Icons.search_rounded,
            onPressed: onFindRides,
          ),
        ],
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.dotColor,
    required this.label,
    required this.value,
    required this.onTap,
    this.square = false,
  });

  final Color dotColor;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool square;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: <Widget>[
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: dotColor,
                shape: square ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: square ? BorderRadius.circular(3) : null,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label, style: text.bodySmall),
                  const SizedBox(height: 1),
                  Text(
                    value ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleSmall?.copyWith(
                      color: value == null
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onTap, required this.tooltip});

  final VoidCallback onTap;
  final String tooltip;

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
          child: const SizedBox(
            height: 44,
            width: 44,
            child: Icon(Icons.swap_vert_rounded, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

class _MetaField extends StatelessWidget {
  const _MetaField({
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
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
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleSmall?.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReturnPromo extends StatelessWidget {
  const _ReturnPromo({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.lightOrange,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(Icons.sync_alt_rounded, color: AppColors.white),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(title, style: text.titleMedium)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(description, style: text.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: buttonLabel,
            icon: Icons.arrow_forward_rounded,
            color: AppColors.primary,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
