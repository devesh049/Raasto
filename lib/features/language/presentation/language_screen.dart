import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/localization/app_locale.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';

/// SCREEN 02 — Language selection.
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  AppLocale _selected = AppLocale.hindi;

  @override
  void initState() {
    super.initState();
    _selected = ref.read(localeControllerProvider) ?? AppLocale.hindi;
  }

  Future<void> _continue() async {
    await ref.read(localeControllerProvider.notifier).select(_selected);
    if (!mounted) {
      return;
    }
    context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppSpacing.lg),
              Text(s.chooseLanguageTitle,
                  style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: AppSpacing.xs),
              Text(s.chooseLanguageSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xxl),
              _LanguageCard(
                locale: AppLocale.hindi,
                selected: _selected == AppLocale.hindi,
                onTap: () => setState(() => _selected = AppLocale.hindi),
              ),
              const SizedBox(height: AppSpacing.md),
              _LanguageCard(
                locale: AppLocale.english,
                selected: _selected == AppLocale.english,
                onTap: () => setState(() => _selected = AppLocale.english),
              ),
              const Spacer(),
              PrimaryButton(label: s.continueText, onPressed: _continue),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  const _LanguageCard({
    required this.locale,
    required this.selected,
    required this.onTap,
  });

  final AppLocale locale;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? AppColors.lightGreen : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 2 : 1,
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  height: 52,
                  width: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: Text(
                    locale == AppLocale.hindi ? 'अ' : 'A',
                    style: text.titleLarge?.copyWith(
                      color: selected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(locale.nativeName,
                          style: text.titleMedium?.copyWith(fontSize: 20)),
                      const SizedBox(height: 2),
                      Text(locale.englishName, style: text.bodySmall),
                    ],
                  ),
                ),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: selected ? AppColors.primary : AppColors.border,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
