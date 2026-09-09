import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/strings.dart';
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
    await context.push(Routes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckCacheRequested()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(Routes.dashboard);
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
                              horizontal: Spacings.lg,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const AppText(
                                  Strings.loginTitle,
                                  variant: AppTextVariant.headlineLarge,
                                  color: AppColors.primary500,
                                  fontWeight: FontWeight.w800,
                                ),
                                const AppSpacer.md(),
                                const AppText(
                                  Strings.loginDescription,
                                  variant: AppTextVariant.titleMedium,
                                ),
                                const AppSpacer.lg(),
                                AppTextField(
                                  controller: _phoneController,
                                  label: Strings.phone,
                                  hint: Strings.phoneHint,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: AppInputFormatters.phone(),
                                  validator: AppValidators.compose([
                                    AppValidators.required(
                                      message: Strings.phoneRequired,
                                    ),
                                    AppValidators.phone(
                                      message: Strings.invalidPhone,
                                    ),
                                  ]),
                                ),
                                const AppSpacer.md(),
                                AppPasswordField(
                                  controller: _passwordController,
                                  hint: Strings.passwordHint,
                                  textInputAction: TextInputAction.done,
                                  validator: AppValidators.compose([
                                    AppValidators.required(
                                      message: Strings.passwordRequired,
                                    ),
                                    AppValidators.strongPassword(),
                                  ]),
                                ),
                                const AppSpacer.md(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: AppLinkText(
                                    Strings.forgotPassword,
                                    variant: AppTextVariant.titleMedium,
                                    color: AppColors.primary500,
                                    onTap: () async => context.push(Routes.forgotPassword),
                                  ),
                                ),
                                const AppSpacer.xxxl(),
                                AppButton(
                                  label: Strings.login,
                                  onPressed: () async => _onSubmit(context),
                                  borderRadius: Rounded.xl,
                                ),
                                const AppSpacer.lg(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const AppText(
                                      Strings.noAccountTitle,
                                      variant: AppTextVariant.titleMedium,
                                    ),
                                    AppLinkText(
                                      Strings.register,
                                      variant: AppTextVariant.titleMedium,
                                      color: AppColors.primary500,
                                      onTap: () async => context.push(Routes.register),
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
