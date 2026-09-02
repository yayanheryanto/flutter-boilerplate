import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
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
            const AppText(
              'Lupa Password',
              variant: AppTextVariant.headlineLarge,
              color: AppColors.primary500,
              fontWeight: FontWeight.w800,
            ),
            const AppSpacer.sm(),
            const AppText(
              'Mohon isi nomor handphone Anda di bawah ini',
              variant: AppTextVariant.titleSmall,
            ),
            const AppSpacer.xl(),

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
            const AppSpacer.lg(),

            AppButton(
              label: 'Lanjutkan',
              onPressed: () async => context.push(Routes.otp, extra: {'phone': phoneController.text}),
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
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.responsive(mobile: 24.0, tablet: 48.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppSpacer.md(),

          // ── Success icon ─────────────────────────────────────────────────
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success500.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.mark_email_read_rounded,
              size: 44,
              color: AppColors.success500,
            ),
          ),
          const AppSpacer.lg(),

          // ── Success message ──────────────────────────────────────────────
          const AppText(
            'Kode Terkirim!',
            variant: AppTextVariant.headlineSmall,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          const AppSpacer.sm(),
          const AppText(
            'Kode verifikasi telah dikirim ke',
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          const AppSpacer.xs(),
          AppText(
            phone,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const AppSpacer.md(),
          const AppText(
            'Periksa pesan masuk kamu. Kode akan kedaluwarsa dalam 30 menit.',
            variant: AppTextVariant.bodySmall,
            color: AppColors.textSecondary,
            textAlign: TextAlign.center,
          ),
          const AppSpacer.xl(),

          // ── Back to login ─────────────────────────────────────────────────
          AppButton(
            label: 'Kembali ke Login',
            onPressed: () => AppNavigator.go(Routes.login),
          ),
          const AppSpacer.lg(),
        ],
      ),
    );
  }
}
