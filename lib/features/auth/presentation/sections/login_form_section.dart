import 'package:boilerplate/core/constants/app_routes.dart';
import 'package:boilerplate/core/constants/app_strings.dart';
import 'package:boilerplate/core/responsive/responsive_context_extension.dart';
import 'package:boilerplate/shared/widgets/buttons/app_button.dart';
import 'package:boilerplate/shared/widgets/display/app_display.dart';
import 'package:boilerplate/shared/widgets/input/app_text_field.dart';
import 'package:boilerplate/shared/widgets/typography/app_text.dart';
import 'package:boilerplate/shared/widgets/snackbar/app_snackbar.dart';
import 'package:boilerplate/shared/widgets/skeleton/skeleton_organisms.dart';
import 'package:boilerplate/core/utils/app_form_utils.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginFormSection extends StatefulWidget {
  const LoginFormSection({super.key});

  @override
  State<LoginFormSection> createState() => _LoginFormSectionState();
}

class _LoginFormSectionState extends State<LoginFormSection>
    with AppFormMixin<LoginFormSection> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // if (!validateForm()) return;
    //
    // context.read<AuthBloc>().add(
    //   AuthLoginRequested(
    //     email: _emailController.text.trim(),
    //     password: _passwordController.text,
    //   ),
    // );

    context.go(AppRoutes.dashboard);
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
                const AppText(
                  'Welcome Back',
                  variant: AppTextVariant.headlineMedium,
                  fontWeight: FontWeight.bold,
                ),
                const AppSpacer.xs(),
                AppText(
                  'Sign in to continue',
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
                const AppSpacer(40),
                AppTextField(
                  controller: _emailController,
                  label: AppStrings.email,
                  hint: AppStrings.emailHint,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.email_outlined,
                  validator: AppValidators.compose([
                    AppValidators.required(message: AppStrings.invalidEmail),
                    AppValidators.email(message: AppStrings.invalidEmail),
                  ]),
                ),
                const AppSpacer.md(),
                AppPasswordField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  validator: AppValidators.compose([
                    AppValidators.required(message: AppStrings.invalidPassword),
                    AppValidators.minLength(8, message: AppStrings.invalidPassword),
                  ]),
                ),
                const AppSpacer.sm(),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppLinkText(
                    AppStrings.forgotPassword,
                    onTap: () async => context.push(AppRoutes.forgotPassword),
                  ),
                ),
                const AppSpacer(32),
                AppButton(
                  label: AppStrings.login,
                  onPressed: _onSubmit,
                  isLoading: state is AuthLoading,
                ),
                const AppSpacer.md(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppText("Don't have an account? "),
                    AppLinkText(
                      AppStrings.register,
                      onTap: () async => context.push(AppRoutes.register),
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
