import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/primary_button.dart';

/// SCREEN 08 — Basic profile setup.
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  String? _gender;
  String? _nameError;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s = ref.read(stringsProvider);
    if (_name.text.trim().isEmpty) {
      setState(() => _nameError = s.nameRequired);
      return;
    }
    setState(() {
      _nameError = null;
      _saving = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await ref.read(authControllerProvider.notifier).saveProfile(
          name: _name.text.trim(),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            0,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          children: <Widget>[
            Text(s.profileTitle, style: text.displaySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(s.profileSubtitle, style: text.bodyMedium),
            const SizedBox(height: AppSpacing.xl),
            Center(child: _AvatarPicker(label: s.addPhoto)),
            const SizedBox(height: AppSpacing.xl),
            CustomTextField(
              controller: _name,
              label: s.fullName,
              hint: s.fullNameHint,
              prefixIcon: Icons.person_outline_rounded,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              errorText: _nameError,
              onChanged: (_) {
                if (_nameError != null) {
                  setState(() => _nameError = null);
                }
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(s.gender, style: text.titleSmall?.copyWith(fontSize: 14)),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: <String>[
                s.genderMale,
                s.genderFemale,
                s.genderOther,
                s.genderPreferNot,
              ].map((String option) {
                final bool selected = _gender == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: selected,
                  onSelected: (_) => setState(() => _gender = option),
                  labelStyle: text.bodyMedium?.copyWith(
                    color: selected ? AppColors.white : AppColors.textPrimary,
                  ),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.white,
                  showCheckmark: false,
                  side: BorderSide(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _email,
              label: '${s.email} (${s.optional})',
              hint: 'name@example.com',
              prefixIcon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: AppSpacing.xxl),
            PrimaryButton(
              label: s.saveContinue,
              isLoading: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 104,
              width: 104,
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 54,
                color: AppColors.primary,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 3),
                ),
                child: const Icon(Icons.camera_alt_rounded,
                    size: 16, color: AppColors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: text.bodySmall),
      ],
    );
  }
}
