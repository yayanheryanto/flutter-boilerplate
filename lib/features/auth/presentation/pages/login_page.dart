import 'package:emas/core/constants/app_radius.dart';
import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/app_spacings.dart';
import 'package:emas/core/constants/app_strings.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/features/auth/domain/entities/otp_purpose.dart';
import 'package:emas/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:emas/features/auth/presentation/models/otp_page_args.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:emas/shared/widgets/loading/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginBloc>()..add(const LoginStarted()),
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent();

  @override
  State<_LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent> with AppFormMixin<_LoginPageContent> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    // Tombol selalu aktif; validasi form dijalankan saat ditekan.
    if (!validateForm()) return;
    FocusScope.of(context).unfocus();

    context.read<LoginBloc>().add(
          LoginSubmitted(
            phone: _phoneController.text,
            password: _passwordController.text,
          ),
        );
  }

  void _clearServerError(String field) {
    context.read<LoginBloc>().add(LoginFieldEdited(field));
  }

  Future<void> _onNeedsVerification(LoginNeedsVerification state) async {
    AppSnackbar.warning(context, state.message);
    // OtpBloc me-request OTP (purpose register) begitu halaman dibuka.
    await context.push(
      AppRoutes.otp,
      extra: OtpPageArgs(purpose: OtpPurpose.register, destination: state.phone).toExtra(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listenWhen: (prev, curr) =>
            curr is LoginSuccess ||
            curr is LoginNeedsVerification ||
            (curr is LoginFailure && prev is LoginInProgress),
        listener: (context, state) async {
          switch (state) {
            case LoginSuccess():
              // go → stack dibersihkan; back dari dashboard tidak kembali ke login.
              context.go(AppRoutes.dashboard);
            case final LoginNeedsVerification needsVerification:
              await _onNeedsVerification(needsVerification);
            case LoginFailure(:final message):
              AppSnackbar.error(context, message);
            case LoginInitial() || LoginCheckingSession() || LoginInProgress():
              break;
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginInProgress || state is LoginCheckingSession;
          final fieldErrors = state.fieldErrors;

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
                                  errorText: fieldErrors['phone'],
                                  onChanged: (_) => _clearServerError('phone'),
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
                                  errorText: fieldErrors['password'],
                                  onChanged: (_) => _clearServerError('password'),
                                  // Login cukup cek terisi; aturan kekuatan password
                                  // hanya berlaku saat membuat password (register).
                                  validator: AppValidators.required(
                                    message: AppStrings.passwordRequired,
                                  ),
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
                                  onPressed: isLoading ? null : _onSubmit,
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
    );
  }
}
