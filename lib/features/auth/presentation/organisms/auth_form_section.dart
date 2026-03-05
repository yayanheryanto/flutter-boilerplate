import 'package:boilerplate/core/constants/app_routes.dart';
import 'package:boilerplate/core/constants/app_strings.dart';
import 'package:boilerplate/core/responsive/responsive_context_extension.dart';
import 'package:boilerplate/core/ui/design_system/design_system.dart';
import 'package:boilerplate/core/utils/app_form_utils.dart';
import 'package:boilerplate/core/utils/navigator_key.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthFormSection extends StatefulWidget {
  const AuthFormSection({super.key});

  @override
  State<AuthFormSection> createState() => _AuthFormSectionState();
}

class _AuthFormSectionState extends State<AuthFormSection> with AppFormMixin<AuthFormSection> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!validateForm()) return;

    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          AppNavigator.go(AppRoutes.dashboard);
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
                    AppValidators.required(message: AppStrings.emailRequired),
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
                    onTap: () => AppNavigator.go(AppRoutes.forgotPassword),
                  ),
                ),
                const AppSpacer.xl(),
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
                      onTap: () async => AppNavigator.push<void>(AppRoutes.register),
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
