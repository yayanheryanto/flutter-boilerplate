import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/images.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AccountProcessedPage extends StatelessWidget {
  const AccountProcessedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>()..add(const AuthCheckCacheRequested()),
      child: const _AccountProcessedPageContent(),
    );
  }
}

class _AccountProcessedPageContent extends StatelessWidget {
  const _AccountProcessedPageContent();

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: const AppPageBar(
        title: 'Verifikasi Akun',
        showBackButton: false,
        titleSpacing: 16,
        elevation: 1,
      ),
      body: SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.all(Spacings.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AppImage(
                src: Images.accountProcessed,
              ),
              const AppSpacer.lg(),
              const AppText(
                'Verifikasi Akun Anda',
                variant: AppTextVariant.titleLarge,
                fontWeight: FontWeight.w600,
              ),
              const AppText(
                'Sedang Diproses',
                variant: AppTextVariant.titleLarge,
              ),
              const AppSpacer.lg(),
              const AppText(
                'Mohon menunggu maksimal 1 x 24 jam.',
              ),
              const AppText(
                'Kami sedang memproses verifikasi akun Anda.',
              ),
              const Spacer(),
              AppButton(
                label: 'Kembali ke Beranda',
                onPressed: () {
                  context.go(Routes.login);
                  // _onSubmit
                },
                borderRadius: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
