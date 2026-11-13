import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// Outlined, lower-emphasis action. Used beside [PrimaryButton].
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = true,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final Color tint = color ?? AppColors.primary;

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: SizedBox(
        width: expand ? double.infinity : null,
        height: AppSpacing.buttonHeight,
        child: Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
            onTap: enabled ? onPressed : null,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
                border: Border.all(color: tint.withValues(alpha: 0.45), width: 1.4),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (icon != null) ...<Widget>[
                    Icon(icon, size: 20, color: tint),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: tint),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
