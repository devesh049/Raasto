import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';

/// SCREEN 06 — Login / Register with mobile number.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phone = TextEditingController();
  String? _error;
  bool _sending = false;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String value = _phone.text.trim();
    if (value.length != 10) {
      setState(() => _error = ref.read(stringsProvider).invalidMobile);
      return;
    }
    setState(() {
      _error = null;
      _sending = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) {
      return;
    }
    setState(() => _sending = false);
    context.go(AppRoutes.otp, extra: '+91 $value');
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: AppSpacing.xl),
              Text(s.welcomeTitle, style: text.displaySmall),
              const SizedBox(height: AppSpacing.xs),
              Text(s.enterMobile, style: text.bodyMedium),
              const SizedBox(height: AppSpacing.xxl),
              Text(s.mobileNumber, style: text.titleSmall?.copyWith(fontSize: 14)),
              const SizedBox(height: AppSpacing.xs),
              _PhoneField(
                controller: _phone,
                hint: s.mobileHint,
                hasError: _error != null,
                onChanged: (_) {
                  if (_error != null) {
                    setState(() => _error = null);
                  }
                },
                onSubmitted: (_) => _submit(),
              ),
              if (_error != null) ...<Widget>[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: <Widget>[
                    const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Text(
                        _error!,
                        style: text.bodySmall?.copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: s.sendOtp,
                isLoading: _sending,
                onPressed: _submit,
              ),
              const Spacer(),
              Text.rich(
                TextSpan(
                  style: text.bodySmall,
                  children: <TextSpan>[
                    TextSpan(text: '${s.byContinuingPrefix} '),
                    TextSpan(
                      text: s.terms,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: ' ${s.and} '),
                    TextSpan(
                      text: s.privacyPolicy,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.hint,
    required this.hasError,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: hasError ? AppColors.error : AppColors.border,
          width: hasError ? 1.6 : 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text('+91', style: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          ),
          Container(width: 1, height: 28, color: AppColors.border),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: text.bodyLarge?.copyWith(letterSpacing: 1.2),
              cursorColor: AppColors.primary,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
