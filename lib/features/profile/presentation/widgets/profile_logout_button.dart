import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/features/profile/presentation/bloc/logout/logout_cubit.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/dialogs/app_dialog.dart';

/// Tombol "Keluar" dengan dialog konfirmasi. Menyediakan [LogoutCubit]
/// sendiri sehingga bisa diletakkan di mana saja.
class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LogoutCubit>(),
      child: const _LogoutButtonView(),
    );
  }
}

class _LogoutButtonView extends StatelessWidget {
  const _LogoutButtonView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutCubit, LogoutStatus>(
      listenWhen: (prev, curr) => curr == LogoutStatus.success,
      // go (bukan push) → seluruh stack dibersihkan, tombol back tidak bisa
      // kembali ke halaman yang butuh login.
      listener: (context, _) => context.go(AppRoutes.login),
      builder: (context, status) {
        return AppButton(
          label: 'Keluar',
          variant: AppButtonVariant.danger,
          size: AppButtonSize.large,
          isLoading: status == LogoutStatus.inProgress,
          onPressed: () async => _confirmLogout(context),
        );
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Keluar dari Akun?',
      message: 'Kamu akan keluar dari sesi ini. Pastikan semua data sudah tersimpan.',
      confirmLabel: 'Keluar',
      cancelLabel: 'Batal',
      type: AppDialogType.warning,
    );

    if ((confirmed ?? false) && context.mounted) {
      await context.read<LogoutCubit>().logout();
    }
  }
}
