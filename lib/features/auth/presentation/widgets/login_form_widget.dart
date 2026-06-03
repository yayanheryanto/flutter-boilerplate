import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/shared/theme/color_tokens.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> with AppFormMixin<LoginFormWidget> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!validateForm()) return;

    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _phoneController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(AppRoutes.dashboard);
        }
        if (state is AuthError) {
          AppSnackbar.error(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const AuthFormSkeleton();
        }

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
                // ── Title ──────────────────────────────────────────────────
                const AppText(
                  'Masuk ke Akun',
                  variant: AppTextVariant.headlineLarge,
                  color: ColorTokens.primary500,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 10),
                const AppText(
                  'Yuk masuk ke akun EMAS kamu sekarang',
                  variant: AppTextVariant.titleMedium,
                ),
                const SizedBox(height: 32),

                // ── Phone number ───────────────────────────────────────────
                AppTextField(
                  controller: _phoneController,
                  label: 'Nomor Handphone',
                  hint: 'Masukkan nomor handphone Anda',
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: AppInputFormatters.phone(),
                  validator: AppValidators.compose([
                    AppValidators.required(
                      message: 'Nomor handphone belum diisi',
                    ),
                    AppValidators.phone(
                      message: 'Nomor handphone tidak valid',
                    ),
                  ]),
                ),
                const SizedBox(height: 16),

                // ── Password ───────────────────────────────────────────────
                AppPasswordField(
                  controller: _passwordController,
                  hint: 'Masukkan password Anda',
                  textInputAction: TextInputAction.done,
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Password belum diisi'),
                  ]),
                ),
                const SizedBox(height: 12),

                // ── Forgot password ────────────────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () async => context.push(AppRoutes.forgotPassword),
                    child: const AppText(
                      'Lupa Password?',
                      variant: AppTextVariant.titleMedium,
                      color: ColorTokens.primary500,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 56),

                // ── Submit button ──────────────────────────────────────────
                AppButton(
                  label: 'Masuk',
                  onPressed: _onSubmit,
                  isLoading: state is AuthLoading,
                  borderRadius: 25,
                ),
                const SizedBox(height: 20),

                // ── Register link ──────────────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText(
                      'Belum punya akun? ',
                      variant: AppTextVariant.titleMedium,
                    ),
                    GestureDetector(
                      onTap: () async => context.push(AppRoutes.register),
                      child: const AppText(
                        'Daftar',
                        variant: AppTextVariant.titleMedium,
                        color: ColorTokens.primary500,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
