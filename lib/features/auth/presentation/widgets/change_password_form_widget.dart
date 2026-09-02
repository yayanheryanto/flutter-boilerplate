import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordFormWidget extends StatefulWidget {
  const ChangePasswordFormWidget({super.key});

  @override
  State<ChangePasswordFormWidget> createState() => _ChangePasswordFormWidgetState();
}

class _ChangePasswordFormWidgetState extends State<ChangePasswordFormWidget> with AppFormMixin<ChangePasswordFormWidget> {
  final _passwordConfirmationController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordConfirmationController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!validateForm()) return;

    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _passwordConfirmationController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go(Routes.dashboard);
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
              horizontal: context.responsive(
                mobile: Spacings.lg,
                tablet: Spacings.xxl,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppText(
                  'Ubah Password',
                  variant: AppTextVariant.headlineLarge,
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w800,
                ),
                const AppSpacer.md(),
                const AppText(
                  'Masukan Password Baru',
                  variant: AppTextVariant.titleMedium,
                ),
                const AppSpacer.lg(),
                AppPasswordField(
                  controller: _passwordConfirmationController,
                  hint: 'Masukkan password baru',
                  textInputAction: TextInputAction.done,
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Password belum diisi'),
                    AppValidators.strongPassword(),
                  ]),
                ),
                const AppSpacer.md(),
                AppPasswordField(
                  controller: _passwordController,
                  hint: 'Masukkan password baru',
                  label: 'Konfirmasi Password',
                  textInputAction: TextInputAction.done,
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Konfirmasi password belum diisi'),
                    AppValidators.strongPassword(),
                  ]),
                ),
                const AppSpacer.xxxl(),
                AppButton(
                  label: 'Lanjutkan',
                  onPressed: _onSubmit,
                  isLoading: state is AuthLoading,
                  borderRadius: 25,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
