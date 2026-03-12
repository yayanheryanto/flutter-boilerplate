import 'package:boilerplate/core/constants/app_routes.dart';
import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/buttons/app_button.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Organism: tombol keluar dengan dialog konfirmasi.
class ProfileLogoutButton extends StatelessWidget {
  const ProfileLogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: 'Keluar',
      size: AppButtonSize.large,
      onPressed: () async => _showLogoutDialog(context),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
        ),
        title: const AppText(
          'Keluar dari Akun?',
          variant: AppTextVariant.titleMedium,
          fontWeight: FontWeight.w700,
        ),
        content: const AppText(
          'Kamu akan keluar dari sesi ini. Pastikan semua data sudah tersimpan.',
          color: Colors.black54,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const AppText(
              'Batal',
              variant: AppTextVariant.labelMedium,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: dispatch AuthLogoutRequested BLoC event
              // context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go(AppRoutes.login);
            },
            child: const AppText(
              'Keluar',
              variant: AppTextVariant.labelMedium,
              color: Color(0xFFD32F2F),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
