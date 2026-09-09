import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckCacheRequested()),
      child: const _ChangePasswordPageContent(),
    );
  }
}

class _ChangePasswordPageContent extends StatefulWidget {
  const _ChangePasswordPageContent();

  @override
  State<_ChangePasswordPageContent> createState() => _ChangePasswordPageContentState();
}

class _ChangePasswordPageContentState extends State<_ChangePasswordPageContent> with AppFormMixin<_ChangePasswordPageContent> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!validateForm()) return;

    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _passwordController.text.trim(),
            password: _confirmPasswordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: const AppPageBar(),
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
                            controller: _passwordController,
                            hint: 'Masukkan password baru',
                            textInputAction: TextInputAction.next,
                            validator: AppValidators.compose([
                              AppValidators.required(
                                message: 'Password belum diisi',
                              ),
                              AppValidators.strongPassword(),
                            ]),
                          ),
                          const AppSpacer.md(),
                          AppPasswordField(
                            controller: _confirmPasswordController,
                            label: 'Konfirmasi Password',
                            hint: 'Masukkan password baru',
                            textInputAction: TextInputAction.done,
                            validator: AppValidators.compose([
                              AppValidators.required(
                                message: 'Konfirmasi password belum diisi',
                              ),
                              AppValidators.strongPassword(),
                              AppValidators.matchesOther(
                                () => _passwordController.text,
                                message: 'Password tidak sama',
                              ),
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
