import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/core/responsive/responsive_context_extension.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> with AppFormMixin<RegisterFormWidget> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!validateForm()) return;

    if (!_agreedToTerms) {
      AppSnackbar.error(
        context,
        'Anda harus menyetujui Syarat & Ketentuan untuk melanjutkan',
      );
      return;
    }

    context.go(AppRoutes.otp, extra: {'phone': _phoneController.text});
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
        final isLoading = state is AuthLoading;

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
                const AppText(
                  'Daftar Sekarang',
                  variant: AppTextVariant.headlineLarge,
                  color: AppColors.primary500,
                  fontWeight: FontWeight.w800,
                ),
                const AppSpacer(10),
                const AppText(
                  'Dengan punya akun, kamu bisa akses semua layanan di EMAS',
                  variant: AppTextVariant.titleSmall,
                ),
                const AppSpacer.xl(),

                AppTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap sesuai KTP',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  inputFormatters: AppInputFormatters.lettersOnly(),
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Nama lengkap belum diisi'),
                    AppValidators.minLength(
                      3,
                      message: 'Nama minimal 3 karakter',
                    ),
                  ]),
                ),
                const AppSpacer.md(),

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

                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Email (contoh: email@gmail.com)',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Email belum diisi'),
                    AppValidators.email(message: 'Format email tidak valid'),
                  ]),
                ),
                const AppSpacer.md(),

                AppPasswordField(
                  controller: _passwordController,
                  hint: 'Masukkan password Anda',
                  textInputAction: TextInputAction.next,
                  validator: AppValidators.compose([
                    AppValidators.required(message: 'Password belum diisi'),
                    AppValidators.minLength(
                      8,
                      message: 'Password minimal 8 karakter',
                    ),
                  ]),
                ),
                const AppSpacer.md(),

                AppPasswordField(
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password',
                  hint: 'Konfirmasi password Anda',
                  textInputAction: TextInputAction.done,
                  validator: AppValidators.compose([
                    AppValidators.required(
                      message: 'Konfirmasi password belum diisi',
                    ),
                    AppValidators.matchesOther(
                      () => _passwordController.text,
                      message: 'Password tidak sama',
                    ),
                  ]),
                ),
                const AppSpacer(20),

                _TermsCheckbox(
                  value: _agreedToTerms,
                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                ),
                const AppSpacer(28),

                AppButton(
                  label: 'Daftar',
                  onPressed: isLoading ? null : _onSubmit,
                  isLoading: isLoading,
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
                      'Masuk',
                      variant: AppTextVariant.titleMedium,
                      color: AppColors.primary500,
                      onTap: () => AppNavigator.go(AppRoutes.login),
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

class _TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _TermsCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    const linkStyle = TextStyle(
      color: Color(0xFF2196F3),
      fontWeight: FontWeight.w600,
    );
    const bodyStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textPrimary,
      height: 1.3,
    );

    return Row( 
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const AppSpacer(10, horizontal: true),
        Expanded(
          child: AppRichText(
            children: [
              const TextSpan(
                text: 'Dengan mendaftar, saya menyetujui ',
                style: bodyStyle,
              ),
              TextSpan(
                text: 'Syarat &\nKetentuan',
                style: linkStyle,
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              const TextSpan(text: ' dan ', style: bodyStyle),
              TextSpan(
                text: 'Kebijakan Privasi',
                style: linkStyle,
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              const TextSpan(text: ' Mega Finance', style: bodyStyle),
            ],
          ),
        ),
      ],
    );
  }
}
