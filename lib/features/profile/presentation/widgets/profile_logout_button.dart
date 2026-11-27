import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/features/profile/presentation/bloc/logout/logout_cubit.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/dialogs/app_dialog.dart';
import 'package:emas/shared/widgets/loading/app_loading.dart';

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

class _LogoutButtonView extends StatefulWidget {
  const _LogoutButtonView();

  @override
  State<_LogoutButtonView> createState() => _LogoutButtonViewState();
}

class _LogoutButtonViewState extends State<_LogoutButtonView> {
  /// Overlay loading layar penuh — sama seperti saat login. Lewat
  /// OverlayPortal karena tombol ini berada di dalam list tab Profil.
  final _loadingOverlay = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _loadingOverlay,
      overlayChildBuilder: (_) => const Stack(children: [AppLoading()]),
      child: BlocConsumer<LogoutCubit, LogoutStatus>(
        listener: (context, status) {
          switch (status) {
            case LogoutStatus.inProgress:
              _loadingOverlay.show();
            case LogoutStatus.success:
              _loadingOverlay.hide();
              // go (bukan push) → seluruh stack dibersihkan, tombol back tidak
              // bisa kembali ke halaman yang butuh login.
              context.go(AppRoutes.login);
            case LogoutStatus.idle:
              _loadingOverlay.hide();
          }
        },
        builder: (context, status) {
          return AppButton(
            label: 'Keluar',
            size: AppButtonSize.large,
            onPressed: status == LogoutStatus.inProgress ? null : () async => _confirmLogout(context),
          );
        },
      ),
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
