import 'package:emas/core/constants/app_elevations.dart';
import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/app_spacings.dart';
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

class InputOldPasswordPage extends StatelessWidget {
  const InputOldPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckCacheRequested()),
      child: const _InputOldPasswordPageContent(),
    );
  }
}

class _InputOldPasswordPageContent extends StatefulWidget {
  const _InputOldPasswordPageContent();

  @override
  State<_InputOldPasswordPageContent> createState() => _InputOldPasswordPageContentState();
}

class _InputOldPasswordPageContentState extends State<_InputOldPasswordPageContent> with AppFormMixin<_InputOldPasswordPageContent> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    // if (!validateForm()) return;
    //
    // context.read<AuthBloc>().add(
    //   AuthLoginRequested(
    //     email: _passwordController.text.trim(),
    //     password: _confirmPasswordController.text,
    //   ),
    // );
    await context.push(AppRoutes.otp);
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
