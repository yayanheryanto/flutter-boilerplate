import 'package:emas/core/di/injection.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/features/auth/presentation/widgets/change_password_form_widget.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _ChangePasswordPageContent extends StatelessWidget {
  const _ChangePasswordPageContent();

  @override
  Widget build(BuildContext context) {
    return const AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: AppPageBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              ChangePasswordFormWidget(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
