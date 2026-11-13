import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/confirmation_dialog.dart';

/// SCREEN 51 — Profile.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(stringsProvider);
    final AuthState auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(s.navProfile)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: <Widget>[
          _ProfileHeader(
            name: auth.name ?? s.navProfile,
            phone: auth.phone ?? '—',
            verifiedLabel: s.notVerifiedYet,
          ),
          const SizedBox(height: AppSpacing.lg),
          _MenuSection(
            items: <_MenuItem>[
              _MenuItem(Icons.person_outline_rounded, s.editProfile),
              _MenuItem(Icons.receipt_long_outlined, s.navBookings),
              _MenuItem(Icons.route_outlined, s.myTrips),
              _MenuItem(Icons.directions_car_outlined, s.myVehicles),
              _MenuItem(Icons.bookmark_border_rounded, s.savedLocations),
              _MenuItem(Icons.emergency_outlined, s.emergencyContacts),
              _MenuItem(Icons.account_balance_wallet_outlined, s.payments),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _MenuSection(
            items: <_MenuItem>[
              _MenuItem(Icons.language_rounded, s.language),
              _MenuItem(Icons.health_and_safety_outlined, s.safety),
              _MenuItem(Icons.help_outline_rounded, s.helpSupport),
              _MenuItem(Icons.privacy_tip_outlined, s.privacyTitle),
              _MenuItem(Icons.description_outlined, s.termsTitle),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _MenuSection(
            items: <_MenuItem>[
              _MenuItem(Icons.logout_rounded, s.logout, isDestructive: true),
              _MenuItem(Icons.delete_outline_rounded, s.deleteAccount,
                  isDestructive: true),
            ],
            onTap: (int index) async {
              if (index == 0) {
                final bool ok = await showConfirmDialog(
                  context,
                  title: s.logout,
                  message: s.logoutConfirm,
                  confirmLabel: s.logout,
                  isDestructive: true,
                );
                if (ok) {
                  await ref.read(authControllerProvider.notifier).signOut();
                }
              }
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Text(
              '${s.appVersion} 1.0.0',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.phone,
    required this.verifiedLabel,
  });

  final String name;
  final String phone;
  final String verifiedLabel;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 68,
            width: 68,
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_rounded,
                size: 36, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(name, style: text.titleMedium),
                const SizedBox(height: 2),
                Text(phone, style: text.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightOrange,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                  child: Text(
                    verifiedLabel,
                    style: text.bodySmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label, {this.isDestructive = false});

  final IconData icon;
  final String label;
  final bool isDestructive;
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.items, this.onTap});

  final List<_MenuItem> items;
  final void Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < items.length; i++) ...<Widget>[
            ListTile(
              leading: Icon(
                items[i].icon,
                color: items[i].isDestructive
                    ? AppColors.error
                    : AppColors.textPrimary,
              ),
              title: Text(
                items[i].label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 15,
                      color: items[i].isDestructive
                          ? AppColors.error
                          : AppColors.textPrimary,
                    ),
              ),
              trailing: items[i].isDestructive
                  ? null
                  : const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textSecondary),
              onTap: () {
                if (onTap != null) {
                  onTap!(i);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(items[i].label)),
                  );
                }
              },
            ),
            if (i != items.length - 1)
              const Divider(height: 1, indent: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
