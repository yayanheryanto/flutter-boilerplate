import 'package:emas/core/constants/app_elevations.dart';
import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/app_spacings.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/features/auth/domain/entities/otp_purpose.dart';
import 'package:emas/features/auth/presentation/models/otp_page_args.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifyOldPasswordPage extends StatelessWidget {
  const VerifyOldPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Tanpa AuthCheckCacheRequested: user di halaman ini sudah login, dan
      // listener AuthAuthenticated di bawah akan langsung melempar ke dashboard.
      create: (_) => getIt<AuthBloc>(),
      child: const _VerifyOldPasswordPageContent(),
    );
  }
}

class _VerifyOldPasswordPageContent extends StatefulWidget {
  const _VerifyOldPasswordPageContent();

  @override
  State<_VerifyOldPasswordPageContent> createState() => _VerifyOldPasswordPageContentState();
}

class _VerifyOldPasswordPageContentState extends State<_VerifyOldPasswordPageContent> with AppFormMixin<_VerifyOldPasswordPageContent> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    // TODO(api): verifikasi password lama ke server sebelum kirim OTP.
    // TODO(api): ambil nomor HP user dari sesi/profil.
    await context.push(
      AppRoutes.otp,
      extra: const OtpPageArgs(purpose: OtpPurpose.changePassword, destination: '').toExtra(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: const AppPageBar(
        title: 'Ubah Password',
        elevation: AppElevations.xs,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppSpacer.md(),
              BlocConsumer<AuthBloc, AuthState>(
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
                        horizontal: context.responsive(
                          mobile: AppSpacings.lg,
                          tablet: AppSpacings.xxl,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppSpacer.md(),
                          const AppText(
                            'Masukan Password Lama',
                            variant: AppTextVariant.titleMedium,
                          ),
                          const AppSpacer.lg(),
                          AppPasswordField(
                            controller: _passwordController,
                            hint: 'Masukkan password lama',
                            textInputAction: TextInputAction.next,
                            validator: AppValidators.compose([
                              AppValidators.required(
                                message: 'Password belum diisi',
                              ),
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
              ),
              const AppSpacer.xxxl(),
            ],
          ),
        ),
      ),
    );
  }
}
