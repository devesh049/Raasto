import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// A section title with an optional trailing action (e.g. "See all").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.only(
      left: AppSpacing.md,
      right: AppSpacing.md,
      bottom: AppSpacing.sm,
    ),
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title, style: text.titleLarge)),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                minimumSize: const Size(0, AppSpacing.minTouch),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
