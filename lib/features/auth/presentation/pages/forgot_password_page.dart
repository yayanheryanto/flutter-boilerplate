import 'package:emas/core/di/injection.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/features/auth/presentation/widgets/forgot_password_form_widget.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/color_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return AppScaffoldWrapper(
      backgroundColor: ColorTokens.white,
      appBar: AppBar(
        backgroundColor: ColorTokens.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 28,
            color: ColorTokens.primary500,
          ),
          onPressed: () => context.pop(),
        ),
        automaticallyImplyLeading: false,
      ),
      body: const SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              ForgotPasswordFormWidget(),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
