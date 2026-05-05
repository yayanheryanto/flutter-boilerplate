import 'package:boilerplate/core/di/injection.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate/features/auth/presentation/layouts/auth_layout.dart';
import 'package:boilerplate/features/auth/presentation/sections/login_form_section.dart';
import 'package:boilerplate/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckCacheRequested()),
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatelessWidget {
  const _LoginPageContent();

  @override
  Widget build(BuildContext context) {
    return const AuthLayout(
      logoSection: AppLogo(
        icon: Icons.bolt_rounded,
        label: 'Boilerplate',
      ),
      formSection: LoginFormSection(),
    );
  }
}
