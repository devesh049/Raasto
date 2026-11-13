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
import '../../../shared/widgets/state_views.dart';
import '../data/mock_goods.dart';
import '../domain/goods_models.dart';

/// Goods Transport — available vehicles and prices for a request.
class GoodsQuotesScreen extends ConsumerWidget {
  const GoodsQuotesScreen({super.key, required this.request});

  final GoodsRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppStrings s = ref.watch(stringsProvider);
    final List<GoodsQuote> quotes = quotesFor(request);

    return Scaffold(
      appBar: AppBar(title: Text(s.quotesTitle)),
      body: quotes.isEmpty
          ? EmptyStateWidget(
              icon: Icons.local_shipping_outlined,
              title: s.noQuotes,
              message: s.noQuotesDesc,
              primaryActionLabel: s.back,
              onPrimaryAction: () => context.pop(),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.sm,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(s.quotesFound(quotes.length),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.xs,
                      AppSpacing.md,
                      AppSpacing.xxl,
                    ),
                    itemCount: quotes.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) {
                      final GoodsQuote quote = quotes[index];
                      return _QuoteCard(
                        quote: quote,
                        request: request,
                        s: s,
                        onBook: () => context.push(
                          AppRoutes.goodsSuccess,
                          extra: GoodsBooking(
                            id: 'GST${DateTime.now().millisecondsSinceEpoch % 1000000}',
                            request: request,
                            quote: quote,
                            total: quote.price,
                            createdAt: DateTime.now(),
                          ),
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

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.quote,
    required this.request,
    required this.s,
    required this.onBook,
  });

  final GoodsQuote quote;
  final GoodsRequest request;
  final AppStrings s;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
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
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: const Icon(Icons.local_shipping_rounded,
                    color: AppColors.secondary),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(quote.transporter, style: text.titleSmall),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.star_rounded,
                            size: 15, color: AppColors.secondary),
                        const SizedBox(width: 2),
                        Text(quote.rating.toStringAsFixed(1),
                            style: text.bodySmall),
                        Text(' · ${quote.vehicleName}',
                            style: text.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(formatInr(quote.price),
                      style: text.titleMedium?.copyWith(
                        color: AppColors.primary,
                      )),
                  Text('${s.etaPickup} ~${quote.etaMinutes} ${s.minutesShort}',
                      style: text.bodySmall?.copyWith(fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              const Icon(Icons.scale_rounded,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('${s.capacityLabel}: ${quote.capacity}',
                  style: text.bodySmall),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.inventory_2_outlined,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('${request.weightKg} ${s.weightUnit}',
                  style: text.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: s.bookVehicle,
            height: 46,
            onPressed: onBook,
          ),
        ],
      ),
    );
  }
}
