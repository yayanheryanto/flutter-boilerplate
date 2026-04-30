import 'package:boilerplate/core/di/injection.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate/features/auth/presentation/layouts/auth_layout.dart';
import 'package:boilerplate/features/auth/presentation/sections/forgot_password_form_section.dart';
import 'package:boilerplate/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const _ForgotPasswordPageContent(),
    );
  }
}

class _ForgotPasswordPageContent extends StatelessWidget {
  const _ForgotPasswordPageContent();

  @override
  Widget build(BuildContext context) {
    return const AuthLayout(
      logoSection: AppLogo(
        icon: Icons.lock_reset_rounded,
        label: 'Lupa Password',
      ),
      formSection: ForgotPasswordFormSection(),
    );
  }
}
