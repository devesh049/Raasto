import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// The main call-to-action button used across Raasto.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = true,
    this.backgroundColor,
    this.foregroundColor,
    this.height = AppSpacing.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool expand;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null && !isLoading;
    final Color bg = backgroundColor ?? AppColors.primary;
    final Color fg = foregroundColor ?? AppColors.white;

    final Widget child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(fg),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 20, color: fg),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: fg),
              ),
            ],
          );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: SizedBox(
        width: expand ? double.infinity : null,
        height: height,
        child: Material(
          color: bg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm + 2),
            onTap: enabled ? onPressed : null,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
