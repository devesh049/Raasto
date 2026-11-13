import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/widgets/state_views.dart';
import '../data/mock_rides.dart';
import '../domain/models.dart';
import 'widgets/ride_card.dart';

/// SCREEN 12 — Search Results: the rides available for a query.
class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key, required this.query});

  final SearchQuery query;

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  RideSort _sort = RideSort.earliest;

  void _comingSoon(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);
    final List<Ride> rides = sortRides(ridesFor(widget.query), _sort);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.availableRides),
        actions: <Widget>[
          IconButton(
            tooltip: s.filters,
            onPressed: () => _comingSoon(s.comingSoon),
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _QueryBar(
            query: widget.query,
            s: s,
            onEdit: () => context.pop(),
          ),
          _SortBar(
            s: s,
            sort: _sort,
            onChanged: (RideSort value) => setState(() => _sort = value),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                s.ridesFound(rides.length),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: rides.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.search_off_rounded,
                    title: s.noRides,
                    message: s.noRidesDesc,
                    primaryActionLabel: s.tryAgain,
                    onPrimaryAction: () => context.pop(),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.xs,
                      AppSpacing.md,
                      AppSpacing.xxl,
                    ),
                    itemCount: rides.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) {
                      final Ride ride = rides[index];
                      return RideCard(
                        ride: ride,
                        s: s,
                        onTap: () => context.push(AppRoutes.ride, extra: ride),
                        onBook: () => context.push(
                          AppRoutes.bookingConfirm,
                          extra: ride,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _QueryBar extends StatelessWidget {
  const _QueryBar({
    required this.query,
    required this.s,
    required this.onEdit,
  });

  final SearchQuery query;
  final AppStrings s;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const Icon(Icons.trip_origin_rounded,
                        size: 14, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        query.from,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    const Icon(Icons.place_rounded,
                        size: 14, color: AppColors.secondary),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        query.to,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '${formatDay(query.date)} · ${query.passengers} ${s.passengers}',
                  style: text.bodySmall,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: Text(s.edit),
          ),
        ],
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  const _SortBar({
    required this.s,
    required this.sort,
    required this.onChanged,
  });

  final AppStrings s;
  final RideSort sort;
  final ValueChanged<RideSort> onChanged;

  @override
  Widget build(BuildContext context) {
    final List<(RideSort, String)> options = <(RideSort, String)>[
      (RideSort.earliest, s.sortEarliest),
      (RideSort.cheapest, s.sortCheapest),
      (RideSort.nearest, s.sortNearest),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (BuildContext context, int index) {
          final (RideSort value, String label) = options[index];
          final bool selected = value == sort;
          return ChoiceChip(
            label: Text(label),
            selected: selected,
            onSelected: (_) => onChanged(value),
            showCheckmark: false,
            selectedColor: AppColors.lightGreen,
            backgroundColor: AppColors.white,
            labelStyle: TextStyle(
              color: selected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            side: BorderSide(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          );
        },
      ),
    );
  }
}
