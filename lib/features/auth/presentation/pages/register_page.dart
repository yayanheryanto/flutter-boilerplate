import 'package:boilerplate/core/di/injection.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate/features/auth/presentation/organisms/register_form_section.dart';
import 'package:boilerplate/features/auth/presentation/templates/auth_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const _RegisterPageContent(),
    );
  }
}

class _RegisterPageContent extends StatelessWidget {
  const _RegisterPageContent();

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      formSection: const RegisterFormSection(),
      logoSection: _buildLogo(context),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.person_add_rounded,
            size: 40,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Daftar Akun',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
