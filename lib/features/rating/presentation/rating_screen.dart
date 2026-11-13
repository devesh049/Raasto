import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_strings.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../search/domain/models.dart';

/// Rate a completed ride (stars + optional review).
class RatingScreen extends ConsumerStatefulWidget {
  const RatingScreen({super.key, required this.receipt});

  final BookingReceipt receipt;

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  final TextEditingController _review = TextEditingController();
  int _rating = 0;

  @override
  void dispose() {
    _review.dispose();
    super.dispose();
  }

  List<String> _labels(AppStrings s) => <String>[
        s.ratingPoor,
        s.ratingFair,
        s.ratingGood,
        s.ratingGreat,
        s.ratingExcellent,
      ];

  void _submit(AppStrings s) {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.requiredField)),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s.thanksRating)),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;
    final Ride ride = widget.receipt.ride;
    final List<String> labels = _labels(s);

    return Scaffold(
      appBar: AppBar(title: Text(s.rateYourRide)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.lightGreen,
              child: Text(
                ride.driver.name.substring(0, 1),
                style: text.headlineMedium?.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(child: Text(ride.driver.name, style: text.titleMedium)),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              '${ride.from} → ${ride.to}',
              style: text.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(s.rateDesc,
              textAlign: TextAlign.center, style: text.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              for (int i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _rating = i),
                  iconSize: 40,
                  icon: Icon(
                    i <= _rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: AppColors.secondary,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 24,
            child: Center(
              child: Text(
                _rating == 0 ? '' : labels[_rating - 1],
                style: text.titleSmall?.copyWith(color: AppColors.secondary),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _review,
            maxLines: 4,
            maxLength: 300,
            decoration: InputDecoration(
              hintText: s.writeReview,
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          PrimaryButton(
            label: s.submitRating,
            icon: Icons.send_rounded,
            onPressed: () => _submit(s),
          ),
        ],
      ),
    );
  }
}
