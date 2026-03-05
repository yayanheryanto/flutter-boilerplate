import 'package:boilerplate/core/di/injection.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate/features/auth/presentation/organisms/forgot_password_form_section.dart';
import 'package:boilerplate/features/auth/presentation/templates/auth_template.dart';
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
    return AuthTemplate(
      formSection: const ForgotPasswordFormSection(),
      logoSection: _buildLogo(context),
    );
  }

  Widget _buildLogo(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            size: 40,
            color: scheme.onPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Lupa Password',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
