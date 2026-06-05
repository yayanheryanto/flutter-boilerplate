import 'package:emas/core/di/injection.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/features/auth/presentation/widgets/otp_form_widget.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OtpPage extends StatelessWidget {
  /// The phone number the OTP was sent to — shown in the subtitle.
  final String phone;

  const OtpPage({super.key, required this.phone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: _OtpPageContent(phone: phone),
    );
  }
}

class _OtpPageContent extends StatelessWidget {
  final String phone;
  const _OtpPageContent({required this.phone});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: AppPageAppBar(
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: OtpFormWidget(phone: phone),
      ),
    );
  }
}
