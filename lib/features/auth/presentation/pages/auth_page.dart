import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate/features/auth/presentation/organisms/auth_form_section.dart';
import 'package:boilerplate/features/auth/presentation/templates/auth_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:boilerplate/core/di/injection.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckCacheRequested()),
      child: const _AuthPageContent(),
    );
  }
}

class _AuthPageContent extends StatelessWidget {
  const _AuthPageContent();

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      formSection: const AuthFormSection(),
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
            Icons.bolt_rounded,
            size: 40,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Boilerplate',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
