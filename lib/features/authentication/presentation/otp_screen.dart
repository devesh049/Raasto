import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/state/app_controllers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/primary_button.dart';

/// SCREEN 07 — OTP verification.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const int _length = 6;

  String _code = '';
  String? _error;
  bool _verifying = false;
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        return;
      }
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  Future<void> _verify() async {
    final s = ref.read(stringsProvider);
    if (_code.length != _length) {
      setState(() => _error = s.invalidOtp);
      return;
    }
    setState(() {
      _error = null;
      _verifying = true;
    });
    // Prototype: any complete 6-digit code verifies locally.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) {
      return;
    }
    await ref.read(authControllerProvider.notifier).verifyOtp(phone: widget.phone);
    if (!mounted) {
      return;
    }
    setState(() => _verifying = false);
    context.go(AppRoutes.profileSetup);
  }

  void _resend() {
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(ref.read(stringsProvider).otpSentAgain)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(s.verifyNumberTitle, style: text.displaySmall),
              const SizedBox(height: AppSpacing.xs),
              Text(s.otpSentTo(widget.phone), style: text.bodyMedium),
              const SizedBox(height: AppSpacing.xxl),
              _OtpInput(
                length: _length,
                hasError: _error != null,
                onChanged: (String value) {
                  _code = value;
                  if (_error != null) {
                    setState(() => _error = null);
                  }
                },
              ),
              if (_error != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
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
                label: s.verify,
                isLoading: _verifying,
                onPressed: _verify,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: _secondsLeft > 0
                    ? Text(
                        s.resendIn('$_secondsLeft'),
                        style: text.bodyMedium,
                      )
                    : TextButton(
                        onPressed: _resend,
                        style: TextButton.styleFrom(
                          minimumSize: const Size(0, AppSpacing.minTouch),
                        ),
                        child: Text(s.resendOtp),
                      ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, AppSpacing.minTouch),
                  ),
                  child: Text(
                    s.changeNumber,
                    style: text.titleSmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpInput extends StatefulWidget {
  const _OtpInput({
    required this.length,
    required this.hasError,
    required this.onChanged,
  });

  final int length;
  final bool hasError;
  final ValueChanged<String> onChanged;

  @override
  State<_OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<_OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List<TextEditingController>.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List<FocusNode>.generate(widget.length, (int i) {
      final FocusNode node = FocusNode();
      node.addListener(() => setState(() {}));
      return node;
    });
  }

  @override
  void dispose() {
    for (final TextEditingController c in _controllers) {
      c.dispose();
    }
    for (final FocusNode n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _notify() {
    widget.onChanged(_controllers.map((TextEditingController c) => c.text).join());
  }

  void _handleChanged(int index, String value) {
    if (value.length > 1) {
      final String digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < widget.length; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      final int last = (digits.length - 1).clamp(0, widget.length - 1);
      _focusNodes[last].requestFocus();
      _notify();
      setState(() {});
      return;
    }
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    _notify();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List<Widget>.generate(widget.length, (int i) {
        final bool filled = _controllers[i].text.isNotEmpty;
        final bool focused = _focusNodes[i].hasFocus;
        final Color borderColor = widget.hasError
            ? AppColors.error
            : focused
                ? AppColors.primary
                : filled
                    ? AppColors.primary
                    : AppColors.border;

        return SizedBox(
          width: 48,
          height: 58,
          child: TextField(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            autofocus: i == 0,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            style: text.titleLarge,
            cursorColor: AppColors.primary,
            onChanged: (String value) => _handleChanged(i, value),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: focused || filled ? AppColors.lightGreen : AppColors.white,
              contentPadding: EdgeInsets.zero,
              enabledBorder: _border(borderColor),
              focusedBorder: _border(AppColors.primary, width: 1.8),
              border: _border(borderColor),
            ),
          ),
        );
      }),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1.4}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
