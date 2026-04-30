import 'package:boilerplate/core/constants/app_routes.dart';
import 'package:boilerplate/shared/widgets/buttons/app_button.dart';
import 'package:boilerplate/shared/widgets/dialogs/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Organism: logout button with confirmation dialog.
class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Keluar',
      variant: AppButtonVariant.danger,
      size: AppButtonSize.large,
      onPressed: () async => _showLogoutDialog(context),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Keluar dari Akun?',
      message:
          'Kamu akan keluar dari sesi ini. Pastikan semua data sudah tersimpan.',
      confirmLabel: 'Keluar',
      cancelLabel: 'Batal',
      type: AppDialogType.warning,
    );

    if (confirmed == true && context.mounted) {
      // TODO: dispatch AuthLogoutRequested BLoC event
      // context.read<AuthBloc>().add(const AuthLogoutRequested());
      context.go(AppRoutes.login);
    }
  }
}
