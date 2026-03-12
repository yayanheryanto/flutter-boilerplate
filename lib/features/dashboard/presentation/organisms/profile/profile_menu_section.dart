import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
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
              onTap: () {
                //TODO: implement edit profile navigation,
              },
            ),
            _MenuItem(
              icon: Icons.lock_outline_rounded,
              label: 'Ubah Kata Sandi',
              onTap: () {
                //TODO: implement edit profile navigation,
              },
            ),
            _MenuItem(
              icon: Icons.phone_outlined,
              label: 'Verifikasi Nomor HP',
              trailing: const _BadgeChip(label: 'Belum Terverifikasi'),
              onTap: () {
                //TODO: implement edit profile navigation,
              },
            ),
          ],
        ),
        const AppSpacer.md(),
        const _MenuGroup(
          title: 'Preferensi',
          items: [
            _MenuItem(
              icon: Icons.notifications_outlined,
              label: 'Notifikasi',
            ),
            _MenuItem(
              icon: Icons.language_outlined,
              label: 'Bahasa',
              trailing: _ValueLabel(label: 'Indonesia'),
            ),
          ],
        ),
        const AppSpacer.md(),
        const _MenuGroup(
          title: 'Lainnya',
          items: [
            _MenuItem(
              icon: Icons.help_outline_rounded,
              label: 'Bantuan & FAQ',
            ),
            _MenuItem(
              icon: Icons.shield_outlined,
              label: 'Kebijakan Privasi',
            ),
            _MenuItem(
              icon: Icons.info_outline_rounded,
              label: 'Tentang Aplikasi',
              trailing: _ValueLabel(label: 'v1.0.0'),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// _MenuGroup
// ---------------------------------------------------------------------------

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
            left: SpacingTokens.xs,
            bottom: SpacingTokens.xs,
          ),
          child: AppText(
            title,
            variant: AppTextVariant.labelMedium,
            color: Colors.black45,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
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
                      indent: SpacingTokens.md + 36,
                      endIndent: SpacingTokens.md,
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

// ---------------------------------------------------------------------------
// _MenuItem
// ---------------------------------------------------------------------------

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
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(RadiusTokens.lg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.md,
          vertical: SpacingTokens.sm + 2,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6F9),
                borderRadius: BorderRadius.circular(RadiusTokens.md),
              ),
              child: Icon(icon, size: 18, color: Colors.black54),
            ),
            const SizedBox(width: SpacingTokens.sm),
            Expanded(
              child: AppText(
                label,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: SpacingTokens.xs),
              trailing!,
            ] else
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: Colors.black38,
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Trailing widgets
// ---------------------------------------------------------------------------

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(RadiusTokens.full),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: AppText(
        label,
        variant: AppTextVariant.labelSmall,
        color: Colors.orange.shade700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ValueLabel extends StatelessWidget {
  const _ValueLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return AppText(
      label,
      variant: AppTextVariant.bodySmall,
      color: Colors.black38,
    );
  }
}
