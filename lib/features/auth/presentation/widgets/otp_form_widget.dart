import 'dart:async';

import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/core/utils/phone_number_masker.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/display/app_spacer.dart';
import 'package:emas/shared/widgets/snackbar/app_snackbar.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _kOtpLength = 6;
const _kResendCooldown = 60;
const _kMaxResend = 3;

class OtpFormWidget extends StatefulWidget {
  final String phone;
  const OtpFormWidget({super.key, required this.phone});

  @override
  State<OtpFormWidget> createState() => _OtpFormWidgetState();
}

class _OtpFormWidgetState extends State<OtpFormWidget> {
  final List<TextEditingController> _controllers =
  List.generate(_kOtpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(_kOtpLength, (_) => FocusNode());

  int _resendCount = 0;
  int _secondsLeft = _kResendCooldown;
  Timer? _timer;
  String _phoneNumberMasker = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    _phoneNumberMasker = PhoneNumberMasker.mask(widget.phone);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ── Timer ──────────────────────────────────────────────────────────────────

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _kResendCooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsLeft <= 1) {
        _timer?.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _onResend() {
    if (_secondsLeft > 0 || _resendCount >= _kMaxResend) return;
    setState(() => _resendCount++);
    _startTimer();
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  Future<void> _onDigitChanged(int index, String value) async {
    if (value.length > 1) {
      final digits = value.replaceAll(RegExp(r'\D'), '');

      for (int i = 0; i < _kOtpLength; i++) {
        if (i < digits.length) {
          _controllers[i].text = digits[i];
        } else {
          _controllers[i].text = '';
        }
      }

      final nextFocusIndex = (digits.length).clamp(0, _kOtpLength - 1);
      _focusNodes[nextFocusIndex].requestFocus();

      await _checkOtpCompleted();

      setState(() {});
      return;
    }

    if (value.isNotEmpty) {
      if (index < _kOtpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    await _checkOtpCompleted();

    setState(() {});
  }

  Future<void> _checkOtpCompleted() async {
    final otp = _controllers.map((e) => e.text).join();

    if (otp.length == _kOtpLength) {
      debugPrint('OTP lengkap: $otp');

      await context.push(Routes.changePassword);
      // Trigger API / Bloc
      // context.read<AuthBloc>().add(
      //   VerifyOtpRequested(otp),
      // );
    }
  }

  void _onSubmit() {
    final otp = _otpValue;
    if (otp.length < _kOtpLength) return;
    context.go(Routes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(
            mobile: Spacings.lg,
            tablet: Spacings.xxl,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSpacer.md(),
            const AppText(
              'Masukan Kode OTP',
              variant: AppTextVariant.headlineLarge,
              color: AppColors.primary500,
              fontWeight: FontWeight.w800,
            ),
            const AppSpacer.sm(),

            AppText(
              'Kami akan kirim kode Verifikasi ke $_phoneNumberMasker',
              variant: AppTextVariant.titleSmall,
            ),
            const AppSpacer(40),

            _OtpBoxRow(
              controllers: _controllers,
              focusNodes: _focusNodes,
              onChanged: _onDigitChanged,
            ),
            const AppSpacer.xl(),

            Center(
              child: Column(
                children: [
                  const AppText(
                    'Belum menerima kode OTP?',
                    variant: AppTextVariant.titleMedium,
                  ),
                  const AppSpacer.sm(),
                  _ResendButton(
                    secondsLeft: _secondsLeft,
                    resendCount: _resendCount,
                    maxResend: _kMaxResend,
                    onResend: _onResend,
                  ),
                ],
              ),
            ),
            const AppSpacer(40),
          ],
        ),
      ),
    );
  }
}

class _OtpBoxRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;

  const _OtpBoxRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        _kOtpLength,
        (i) => _OtpBox(
          controller: controllers[i],
          focusNode: focusNodes[i],
          onChanged: (v) => onChanged(i, v),
          previousFocusNode: i > 0 ? focusNodes[i - 1] : null,
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? previousFocusNode;
  final void Function(String) onChanged;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    this.previousFocusNode,
    required this.onChanged,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  @override
  Widget build(BuildContext context) {
    final filled = widget.controller.text.isNotEmpty;

    return SizedBox(
      width: 44,
      height: 52,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.backspace): () {
            if (widget.controller.text.isEmpty &&
                widget.previousFocusNode != null) {
              widget.previousFocusNode!.requestFocus();
            } else {
              widget.controller.clear();
              widget.onChanged('');
            }
          },
        },
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          inputFormatters: [
            LengthLimitingTextInputFormatter(2),
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (value) {
            if (value.isEmpty && widget.previousFocusNode != null) {
              widget.previousFocusNode!.requestFocus();
            } else if (value.length > 1) {
              widget.controller.text = value.substring(value.length - 1);
              widget.controller.selection = TextSelection.fromPosition(
                TextPosition(offset: widget.controller.text.length),
              );
            }
            widget.onChanged(widget.controller.text);
          },
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            filled: true,
            fillColor: filled
                ? AppColors.primary50
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: filled
                    ? AppColors.primary500
                    : Theme.of(context).colorScheme.outline,
                width: filled ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary500,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  final int secondsLeft;
  final int resendCount;
  final int maxResend;
  final VoidCallback onResend;

  const _ResendButton({
    required this.secondsLeft,
    required this.resendCount,
    required this.maxResend,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final exhausted = resendCount >= maxResend;
    final canResend = secondsLeft == 0 && !exhausted;

    if (exhausted) {
      return AppText(
        'Batas pengiriman ulang telah tercapai',
        variant: AppTextVariant.bodySmall,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      );
    }

    return GestureDetector(
      onTap: canResend ? onResend : null,
      child: AppRichText(
        children: [
          TextSpan(
            text: 'Kirim ulang ($resendCount/$maxResend)',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primary500,
              fontWeight: FontWeight.w600,
              decoration: canResend ? TextDecoration.underline : null,
            ),
          ),
          if (secondsLeft > 0)
            TextSpan(
              text: ' dalam $secondsLeft detik',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
}
