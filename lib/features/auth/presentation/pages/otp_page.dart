import 'package:emas/core/di/injection.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/features/auth/presentation/widgets/otp_form_widget.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/color_tokens.dart';
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
      body: SafeArea(
        top: false,
        child: OtpFormWidget(phone: phone),
      ),
    );
  }
}
