import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/input/app_text_field.dart';
import 'package:emas/shared/widgets/snackbar/app_snackbar.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordFormWidget extends StatefulWidget {
  const ForgotPasswordFormWidget({super.key});

  @override
  State<ForgotPasswordFormWidget> createState() => _ForgotPasswordFormWidgetState();
}

class _ForgotPasswordFormWidgetState extends State<ForgotPasswordFormWidget> with AppFormMixin<ForgotPasswordFormWidget> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!validateForm()) return;
    context.read<AuthBloc>().add(
          AuthForgotPasswordRequested(email: _phoneController.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          AppSnackbar.error(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is AuthForgotPasswordSent) {
          return _SuccessView(phone: _phoneController.text.trim());
        }

        return _FormView(
          phoneController: _phoneController,
          formKey: formKey,
          isLoading: state is AuthLoading,
          onSubmit: _onSubmit,
        );
      },
    );
  }
}

// ─── Form View ────────────────────────────────────────────────────────────────

class _FormView extends StatelessWidget {
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _FormView({
    required this.phoneController,
    required this.formKey,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.responsive(mobile: 24.0, tablet: 48.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            const AppText(
              'Lupa Password',
              variant: AppTextVariant.headlineLarge,
              color: AppColors.primary500,
              fontWeight: FontWeight.w800,
            ),
            const SizedBox(height: 8),
            const AppText(
              'Mohon isi nomor handphone Anda di bawah ini',
              variant: AppTextVariant.titleSmall,
            ),
            const SizedBox(height: 32),

            // ── Phone number ─────────────────────────────────────────────────
            AppTextField(
              controller: phoneController,
              label: 'Nomor Handphone',
              hint: 'Masukkan nomor handphone Anda',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: AppInputFormatters.phone(),
              onSubmitted: (_) => onSubmit(),
              validator: AppValidators.compose([
                AppValidators.required(
                  message: 'Nomor handphone belum diisi',
                ),
                AppValidators.phone(
                  message: 'Nomor handphone tidak valid',
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // ── Submit ───────────────────────────────────────────────────────
            AppButton(
              label: 'Lanjutkan',
              onPressed: () async => context.push(AppRoutes.otp, extra: {'phone': phoneController.text}),
              isLoading: isLoading,
              borderRadius: 25,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Success View ─────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  final String phone;

  const _SuccessView({required this.phone});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 24.0, tablet: 48.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),

          // ── Success icon ─────────────────────────────────────────────────
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_rounded,
              size: 44,
              color: Colors.green[600],
            ),
          ),
          const SizedBox(height: 24),

          // ── Success message ──────────────────────────────────────────────
          Text(
            'Kode Terkirim!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Kode verifikasi telah dikirim ke',
            style: TextStyle(color: scheme.onSurface.withOpacity(0.6)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            phone,
            style: const TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Periksa pesan masuk kamu. Kode akan kedaluwarsa dalam 30 menit.',
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurface.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          // ── Back to login ─────────────────────────────────────────────────
          AppButton(
            label: 'Kembali ke Login',
            onPressed: () => AppNavigator.go(AppRoutes.login),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
