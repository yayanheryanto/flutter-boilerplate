import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/app_spacings.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/core/utils/phone_number_masker.dart';
import 'package:emas/features/auth/domain/entities/otp_purpose.dart';
import 'package:emas/features/auth/presentation/bloc/otp/otp_bloc.dart';
import 'package:emas/features/auth/presentation/models/otp_page_args.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

const _kOtpLength = OtpBloc.codeLength;

/// Halaman input OTP untuk register, lupa password, dan ganti password.
/// Konteks dan tujuan navigasi ditentukan oleh [OtpPageArgs.purpose].
class OtpPage extends StatelessWidget {
  final OtpPageArgs args;

  const OtpPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OtpBloc>()..add(OtpStarted(args)),
      child: const _OtpPageContent(),
    );
  }
}

class _OtpPageContent extends StatefulWidget {
  const _OtpPageContent();

  @override
  State<_OtpPageContent> createState() => _OtpPageContentState();
}

/// State widget hanya mengurus kontrol input (controller & fokus).
/// Aturan bisnis (cooldown, batas kirim ulang, verifikasi) ada di [OtpBloc].
class _OtpPageContentState extends State<_OtpPageContent> {
  final List<TextEditingController> _controllers =
      List.generate(_kOtpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(_kOtpLength, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpValue => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      // Tempel (paste) beberapa digit sekaligus.
      final digits = value.replaceAll(RegExp(r'\D'), '');
      for (int i = 0; i < _kOtpLength; i++) {
        _controllers[i].text = i < digits.length ? digits[i] : '';
      }
      final nextFocusIndex = digits.length.clamp(0, _kOtpLength - 1);
      _focusNodes[nextFocusIndex].requestFocus();
    } else if (value.isNotEmpty) {
      if (index < _kOtpLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    setState(() {});
    _submitIfComplete();
  }

  void _submitIfComplete() {
    final otp = _otpValue;
    if (otp.length == _kOtpLength) {
      context.read<OtpBloc>().add(OtpCodeSubmitted(otp));
    }
  }

  void _clearCode() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    setState(() {});
  }

  Future<void> _onVerified(OtpState state) async {
    switch (state.purpose) {
      case OtpPurpose.register:
        // Sesi sudah disimpan repository → masuk ke aplikasi.
        context.go(AppRoutes.dashboard);
      case OtpPurpose.forgotPassword:
      case OtpPurpose.changePassword:
        await context.push(AppRoutes.changePassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: AppPageBar(
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: BlocConsumer<OtpBloc, OtpState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) async {
            switch (state.status) {
              case OtpStatus.verified:
                await _onVerified(state);
              case OtpStatus.failure:
                AppSnackbar.error(context, state.message ?? 'Terjadi kesalahan');
                _clearCode();
              case OtpStatus.codeSent:
              case OtpStatus.codeResent:
                AppSnackbar.success(context, state.message ?? 'Kode OTP telah dikirim');
                _clearCode();
              case OtpStatus.idle:
              case OtpStatus.requesting:
              case OtpStatus.verifying:
                break;
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.responsive(
                  mobile: AppSpacings.lg,
                  tablet: AppSpacings.xxl,
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
                  const AppSpacer.md(),
                  AppText(
                    'Kami akan kirim kode Verifikasi ke ${_displayDestination(state.destination)}',
                    variant: AppTextVariant.titleSmall,
                  ),
                  const AppSpacer.xxl(),
                  AbsorbPointer(
                    absorbing: state.isVerifying || state.isRequesting,
                    child: _OtpBoxRow(
                      controllers: _controllers,
                      focusNodes: _focusNodes,
                      onChanged: _onDigitChanged,
                    ),
                  ),
                  if (state.isVerifying || state.isRequesting) ...[
                    const AppSpacer.lg(),
                    const Center(child: CircularProgressIndicator()),
                  ],
                  const AppSpacer.xl(),
                  Center(
                    child: Column(
                      children: [
                        const AppText(
                          'Belum menerima kode OTP?',
                          variant: AppTextVariant.titleMedium,
                        ),
                        const AppSpacer.md(),
                        _ResendButton(
                          secondsLeft: state.resendCountdown,
                          resendCount: state.resendCount,
                          maxResend: OtpBloc.maxResend,
                          enabled: state.canResend,
                          onResend: () => context.read<OtpBloc>().add(const OtpResendRequested()),
                        ),
                      ],
                    ),
                  ),
                  const AppSpacer(40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Tujuan dari server sudah disamarkan; nomor mentah (alur lama) disamarkan di sini.
  String _displayDestination(String destination) =>
      destination.contains('*') ? destination : PhoneNumberMasker.mask(destination);
}

// ─── OTP Row Component ────────────────────────────────────────────────────────

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

// ─── Individual OTP Box Component ─────────────────────────────────────────────

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

// ─── Resend Button Component ──────────────────────────────────────────────────

class _ResendButton extends StatelessWidget {
  final int secondsLeft;
  final int resendCount;
  final int maxResend;
  final bool enabled;
  final VoidCallback onResend;

  const _ResendButton({
    required this.secondsLeft,
    required this.resendCount,
    required this.maxResend,
    required this.enabled,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final exhausted = resendCount >= maxResend;
    final canResend = enabled;

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
