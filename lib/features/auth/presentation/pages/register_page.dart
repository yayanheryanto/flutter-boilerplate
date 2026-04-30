import 'package:boilerplate/core/di/injection.dart';
import 'package:boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate/features/auth/presentation/layouts/auth_layout.dart';
import 'package:boilerplate/features/auth/presentation/sections/register_form_section.dart';
import 'package:boilerplate/shared/widgets/design_system.dart';
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
    return AuthLayout(
      logoSection: const AppLogo(
        icon: Icons.person_add_rounded,
        label: 'Daftar Akun',
      ),
      formSection: const RegisterFormSection(),
    );
  }
}
