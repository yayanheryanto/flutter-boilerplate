import 'package:emas/core/constants/app_radius.dart';
import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/app_spacings.dart';
import 'package:emas/core/constants/app_strings.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:emas/shared/widgets/loading/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with AppFormMixin<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(BuildContext context) async {
    // if (!validateForm()) return;
    //
    // context.read<AuthBloc>().add(
    //       AuthLoginRequested(
    //         email: _phoneController.text.trim(),
    //         password: _passwordController.text,
    //       ),
    //     );
    await context.push(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckCacheRequested()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.dashboard);
          }
          if (state is AuthError) {
            AppSnackbar.error(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Stack(
            children: [
              // ── Form ────────────────────────────────────────────────
              AppScaffoldWrapper(
                backgroundColor: AppColors.white,
                appBar: const AppPageBar(showBackButton: false),
                body: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AppSpacer.md(),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacings.lg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const AppText(
                                  AppStrings.loginTitle,
                                  variant: AppTextVariant.headlineLarge,
                                  color: AppColors.primary500,
                                  fontWeight: FontWeight.w800,
                                ),
                                const AppSpacer.md(),
                                const AppText(
                                  AppStrings.loginDescription,
                                  variant: AppTextVariant.titleMedium,
                                ),
                                const AppSpacer.lg(),
                                AppTextField(
                                  controller: _phoneController,
                                  label: AppStrings.phone,
                                  hint: AppStrings.phoneHint,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: AppInputFormatters.phone(),
                                  validator: AppValidators.compose([
                                    AppValidators.required(
                                      message: AppStrings.phoneRequired,
                                    ),
                                    AppValidators.phone(
                                      message: AppStrings.invalidPhone,
                                    ),
                                  ]),
                                ),
                                const AppSpacer.md(),
                                AppPasswordField(
                                  controller: _passwordController,
                                  hint: AppStrings.passwordHint,
                                  textInputAction: TextInputAction.done,
                                  validator: AppValidators.compose([
                                    AppValidators.required(
                                      message: AppStrings.passwordRequired,
                                    ),
                                    AppValidators.strongPassword(),
                                  ]),
                                ),
                                const AppSpacer.md(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: AppLinkText(
                                    AppStrings.forgotPassword,
                                    variant: AppTextVariant.titleMedium,
                                    color: AppColors.primary500,
                                    onTap: () async => context.push(AppRoutes.forgotPassword),
                                  ),
                                ),
                                const AppSpacer.xxxl(),
                                AppButton(
                                  label: AppStrings.login,
                                  onPressed: () async => _onSubmit(context),
                                  borderRadius: AppRadius.xl,
                                ),
                                const AppSpacer.lg(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const AppText(
                                      AppStrings.noAccountTitle,
                                      variant: AppTextVariant.titleMedium,
                                    ),
                                    AppLinkText(
                                      AppStrings.register,
                                      variant: AppTextVariant.titleMedium,
                                      color: AppColors.primary500,
                                      onTap: () async => context.push(AppRoutes.register),
                                    ),
                                  ],
                                ),
                                const AppSpacer.md(),
                              ],
                            ),
                          ),
                        ),
                        const AppSpacer.xxl(),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Full-screen loading overlay ──────────────────────────
              if (isLoading) const AppLoading(),
            ],
          );
        },
      ),
    );
  }
}
