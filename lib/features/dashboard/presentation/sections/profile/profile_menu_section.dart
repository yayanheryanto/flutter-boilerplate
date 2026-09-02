import 'package:emas/core/constants/radius_tokens.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

/// Organism: seluruh grup menu profil (Akun, Preferensi, Lainnya).
class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MenuGroup(
          title: 'Akun',
          items: [
            _MenuItem(
              icon: Icons.person_outline_rounded,
              label: 'Edit Profil',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.lock_outline_rounded,
              label: 'Ubah Kata Sandi',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.phone_outlined,
              label: 'Verifikasi Nomor HP',
              trailing: AppBadge(
                label: 'Belum Terverifikasi',
                backgroundColor: Colors.orange.shade50,
                textColor: Colors.orange.shade700,
              ),
              onTap: () {},
            ),
          ],
        ),
        const AppSpacer.md(),
        _MenuGroup(
          title: 'Preferensi',
          items: [
            _MenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifikasi',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.language_outlined,
              label: 'Bahasa',
              trailing: const AppText(
                'Indonesia',
                variant: AppTextVariant.bodySmall,
                color: Colors.black38,
              ),
              onTap: () {},
            ),
          ],
        ),
        const AppSpacer.md(),
        _MenuGroup(
          title: 'Lainnya',
          items: [
            _MenuItem(
              icon: Icons.help_outline_rounded,
              label: 'Bantuan & FAQ',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.shield_outlined,
              label: 'Kebijakan Privasi',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.info_outline_rounded,
              label: 'Tentang Aplikasi',
              trailing: const AppText(
                'v1.0.0',
                variant: AppTextVariant.bodySmall,
                color: Colors.black38,
              ),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

// ── _MenuGroup ─────────────────────────────────────────────────────────────────

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.title, required this.items});

  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: Spacings.xs,
            bottom: Spacings.xs,
          ),
          child: AppText(
            title,
            variant: AppTextVariant.labelMedium,
            color: Colors.black45,
            fontWeight: FontWeight.w600,
          ),
        ),
        // AppCard handles the white surface + border-radius + shadow
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: List.generate(items.length, (index) {
              final isLast = index == items.length - 1;
              return Column(
                children: [
                  items[index],
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: Spacings.md + 36,
                      endIndent: Spacings.md,
                      color: Colors.black.withOpacity(0.06),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ── _MenuItem ──────────────────────────────────────────────────────────────────

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // AppCard with onTap provides the InkWell splash + rounded clip
    return AppCard(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.symmetric(
        horizontal: Spacings.md,
        vertical: Spacings.sm + 2,
      ),
      child: Row(
        children: [
          // Icon badge — reuses AppCard's surface pattern at small scale
          AppCard(
            padding: const EdgeInsets.all(Spacings.xs),
            backgroundColor: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            child: Icon(icon, size: 18, color: Colors.black54),
          ),
          const AppSpacer(Spacings.sm, horizontal: true),
          Expanded(
            child: AppText(label, fontWeight: FontWeight.w500),
          ),
          if (trailing != null) ...[
            const AppSpacer(Spacings.xs, horizontal: true),
            trailing!,
          ] else
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Colors.black38,
            ),
        ],
      ),
    );
  }
}
