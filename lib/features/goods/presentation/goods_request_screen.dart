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
import '../data/mock_goods.dart';
import '../domain/goods_models.dart';

/// Goods Transport — request form (pickup, drop, goods and vehicle).
class GoodsRequestScreen extends ConsumerStatefulWidget {
  const GoodsRequestScreen({super.key});

  @override
  ConsumerState<GoodsRequestScreen> createState() => _GoodsRequestScreenState();
}

class _GoodsRequestScreenState extends ConsumerState<GoodsRequestScreen> {
  final TextEditingController _from = TextEditingController();
  final TextEditingController _to = TextEditingController();
  DateTime _date = DateTime.now();
  int _typeIndex = 0;
  double _weight = 50;
  String? _vehicleId;

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  List<String> _types(AppStrings s) => <String>[
        s.goodsHousehold,
        s.goodsElectronics,
        s.goodsFurniture,
        s.goodsDocuments,
        s.goodsAgriculture,
        s.goodsOther,
      ];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _submit(AppStrings s) {
    final String from = _from.text.trim();
    final String to = _to.text.trim();
    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.enterBothLocations)),
      );
      return;
    }
    context.push(
      AppRoutes.goodsQuotes,
      extra: GoodsRequest(
        from: from,
        to: to,
        date: _date,
        goodsType: _types(s)[_typeIndex],
        weightKg: _weight.round(),
        vehicleId: _vehicleId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;
    final List<String> types = _types(s);

    return Scaffold(
      appBar: AppBar(title: Text(s.goodsTransport)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: <Widget>[
          Text(s.goodsDetails, style: text.titleMedium),
          const SizedBox(height: AppSpacing.xxs),
          Text(s.goodsDetailsDesc, style: text.bodyMedium),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _from,
            textInputAction: TextInputAction.next,
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
          const SizedBox(height: AppSpacing.md),
          _FieldTile(
            icon: Icons.calendar_today_rounded,
            label: s.journeyDate,
            value: DateFormat('d MMM yyyy').format(_date),
            onTap: _pickDate,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(s.goodsType, style: text.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              for (int i = 0; i < types.length; i++)
                ChoiceChip(
                  label: Text(types[i]),
                  selected: i == _typeIndex,
                  showCheckmark: false,
                  selectedColor: AppColors.lightGreen,
                  backgroundColor: AppColors.white,
                  labelStyle: TextStyle(
                    color: i == _typeIndex
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  side: BorderSide(
                    color: i == _typeIndex
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                  onSelected: (_) => setState(() => _typeIndex = i),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: <Widget>[
              Text(s.approxWeight, style: text.titleSmall),
              const Spacer(),
              Text('${_weight.round()} ${s.weightUnit}',
                  style: text.titleSmall?.copyWith(color: AppColors.primary)),
            ],
          ),
          Slider(
            value: _weight,
            min: 10,
            max: 1000,
            divisions: 99,
            label: '${_weight.round()} ${s.weightUnit}',
            activeColor: AppColors.primary,
            onChanged: (double value) => setState(() => _weight = value),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(s.chooseVehicle, style: text.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          for (final GoodsVehicle v in goodsVehicles)
            _VehicleTile(
              vehicle: v,
              selected: _vehicleId == v.id,
              onTap: () => setState(
                () => _vehicleId = _vehicleId == v.id ? null : v.id,
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: s.getQuotes,
            icon: Icons.request_quote_rounded,
            onPressed: () => _submit(s),
          ),
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
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(label, style: text.bodySmall),
                  Text(value, style: text.titleSmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _VehicleTile extends StatelessWidget {
  const _VehicleTile({
    required this.vehicle,
    required this.selected,
    required this.onTap,
  });

  final GoodsVehicle vehicle;
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
            Icon(
              vehicle.icon,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(vehicle.name, style: text.titleSmall),
                  Text(vehicle.capacity, style: text.bodySmall),
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
