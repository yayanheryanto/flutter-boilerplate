import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
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
                        const SizedBox(height: 16),
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
                                  'Masuk ke Akun',
                                  variant: AppTextVariant.headlineLarge,
                                  color: AppColors.primary500,
                                  fontWeight: FontWeight.w800,
                                ),
                                const AppSpacer(10),
                                const AppText(
                                  'Yuk masuk ke akun EMAS kamu sekarang',
                                  variant: AppTextVariant.titleMedium,
                                ),
                                const AppSpacer.xl(),
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
                                const AppSpacer.md(),
                                AppPasswordField(
                                  controller: _passwordController,
                                  hint: 'Masukkan password Anda',
                                  textInputAction: TextInputAction.done,
                                  validator: AppValidators.compose([
                                    AppValidators.required(
                                      message: 'Password belum diisi',
                                    ),
                                    AppValidators.strongPassword(),
                                  ]),
                                ),
                                const AppSpacer(12),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: AppLinkText(
                                    'Lupa Password?',
                                    variant: AppTextVariant.titleMedium,
                                    color: AppColors.primary500,
                                    onTap: () async => context.push(AppRoutes.forgotPassword),
                                  ),
                                ),
                                const AppSpacer(56),
                                AppButton(
                                  label: 'Masuk',
                                  onPressed: () async => _onSubmit(context),
                                  borderRadius: 25,
                                ),
                                const AppSpacer(20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const AppText(
                                      'Belum punya akun? ',
                                      variant: AppTextVariant.titleMedium,
                                    ),
                                    AppLinkText(
                                      'Daftar',
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
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Full-screen loading overlay ──────────────────────────
              if (isLoading)
                const AppLoading(),
            ],
          );
        },
      ),
    );
  }
}
