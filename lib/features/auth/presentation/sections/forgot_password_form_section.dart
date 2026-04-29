import 'package:boilerplate/core/constants/app_routes.dart';
import 'package:boilerplate/core/constants/app_strings.dart';
import 'package:boilerplate/core/responsive/responsive_context_extension.dart';
import 'package:boilerplate/shared/widgets/buttons/app_button.dart';
import 'package:boilerplate/shared/widgets/display/app_display.dart';
import 'package:boilerplate/shared/widgets/input/app_text_field.dart';
import 'package:boilerplate/shared/widgets/typography/app_text.dart';
import 'package:boilerplate/shared/widgets/snackbar/app_snackbar.dart';
import 'package:boilerplate/core/utils/app_form_utils.dart';
import 'package:boilerplate/core/utils/navigator_key.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordFormSection extends StatefulWidget {
  const ForgotPasswordFormSection({super.key});

  @override
  State<ForgotPasswordFormSection> createState() =>
      _ForgotPasswordFormSectionState();
}

class _ForgotPasswordFormSectionState
    extends State<ForgotPasswordFormSection>
    with AppFormMixin<ForgotPasswordFormSection> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!validateForm()) return;
    context.read<AuthBloc>().add(
      AuthForgotPasswordRequested(email: _emailController.text.trim()),
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
        // Tampilkan halaman sukses setelah email terkirim
        if (state is AuthForgotPasswordSent) {
          return _SuccessView(email: _emailController.text.trim());
        }

        return _FormView(
          emailController: _emailController,
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
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _FormView({
    required this.emailController,
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
            // ── Header ───────────────────────────────────────────────────────
            const AppText(
              'Reset Password',
              variant: AppTextVariant.headlineMedium,
              fontWeight: FontWeight.bold,
            ),
            const AppSpacer.xs(),
            AppText(
              'Masukkan email yang terdaftar. Kami akan mengirimkan link untuk mereset password kamu.',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const AppSpacer(40),

            // ── Email ─────────────────────────────────────────────────────────
            AppTextField(
              controller: emailController,
              label: AppStrings.email,
              hint: AppStrings.emailHint,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => onSubmit(),
              validator: AppValidators.compose([
                AppValidators.required(message: AppStrings.invalidEmail),
                AppValidators.email(message: AppStrings.invalidEmail),
              ]),
            ),
            const AppSpacer(32),

            // ── Submit ────────────────────────────────────────────────────────
            AppButton(
              label: 'Kirim Link Reset',
              onPressed: onSubmit,
              isLoading: isLoading,
            ),
            const AppSpacer.md(),

            // ── Kembali ke login ──────────────────────────────────────────────
            Center(
              child: AppLinkText(
                'Kembali ke Login',
                onTap: () => AppNavigator.go(AppRoutes.login),
              ),
            ),
            const AppSpacer.lg(),
          ],
        ),
      ),
    );
  }
}

// ─── Success View ─────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  final String email;

  const _SuccessView({required this.email});

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
          const AppSpacer(16),

          // ── Icon sukses ───────────────────────────────────────────────────
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
          const AppSpacer(24),

          // ── Pesan sukses ──────────────────────────────────────────────────
          const AppText(
            'Email Terkirim!',
            variant: AppTextVariant.headlineSmall,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.center,
          ),
          const AppSpacer.sm(),
          AppText(
            'Link reset password telah dikirim ke',
            color: scheme.onSurface.withOpacity(0.6),
            textAlign: TextAlign.center,
          ),
          const AppSpacer.xs(),
          AppText(
            email,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          const AppSpacer.sm(),
          AppText(
            'Periksa inbox atau folder spam kamu. Link akan kedaluwarsa dalam 30 menit.',
            variant: AppTextVariant.bodySmall,
            color: scheme.onSurface.withOpacity(0.5),
            textAlign: TextAlign.center,
          ),
          const AppSpacer(40),

          // ── Kembali ke login ──────────────────────────────────────────────
          AppButton(
            label: 'Kembali ke Login',
            onPressed: () => AppNavigator.go(AppRoutes.login),
          ),
          const AppSpacer.lg(),
        ],
      ),
    );
  }
}
