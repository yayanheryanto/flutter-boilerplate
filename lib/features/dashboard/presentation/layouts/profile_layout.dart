import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';

class _ProfileMenuItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class _ProfileMenuSection {
  final String title;
  final List<_ProfileMenuItem> items;

  const _ProfileMenuSection({
    required this.title,
    required this.items,
  });
}

/// "Profil" page — grouped account menu (account, security, help, and
/// general/legal sections).
class ProfileLayout extends StatelessWidget {
  const ProfileLayout({super.key});

  List<_ProfileMenuSection> _buildSections(BuildContext context) {
    void notImplemented() {
      // TODO: navigasi ke halaman terkait begitu tersedia.
    }

    return [
      _ProfileMenuSection(
        title: 'Informasi Akun',
        items: [
          _ProfileMenuItem(
            label: 'Pengaturan Profil',
            icon: Icons.person_outline,
            onTap: notImplemented,
          ),
          _ProfileMenuItem(
            label: 'Favorit Saya',
            icon: Icons.favorite_border,
            onTap: notImplemented,
          ),
        ],
      ),
      _ProfileMenuSection(
        title: 'Keamanan',
        items: [
          _ProfileMenuItem(
            label: 'Ubah Password',
            icon: Icons.person_outline,
            onTap: notImplemented,
          ),
        ],
      ),
      _ProfileMenuSection(
        title: 'Bantuan',
        items: [
          _ProfileMenuItem(
            label: 'Pusat Bantuan',
            icon: Icons.person_outline,
            onTap: notImplemented,
          ),
          _ProfileMenuItem(
            label: 'Prosedur',
            icon: Icons.favorite_border,
            onTap: notImplemented,
          ),
        ],
      ),
      _ProfileMenuSection(
        title: 'Seputar EMAS',
        items: [
          _ProfileMenuItem(
            label: 'Ketentuan Umum',
            icon: Icons.person_outline,
            onTap: notImplemented,
          ),
          _ProfileMenuItem(
            label: 'Pemberitahuan Privasi',
            icon: Icons.privacy_tip_outlined,
            onTap: notImplemented,
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sections = _buildSections(context);

    return AppScaffoldWrapper(
      backgroundColor: AppColors.neutral50,
      appBar: const AppPageBar(title: 'Profil'),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(
          // horizontal: Spacings.md,
          vertical: Spacings.xs,
        ),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: Spacings.xs),
        itemBuilder: (context, i) => _ProfileMenuCard(section: sections[i]),
      ),
    );
  }
}

// ─── Section card ─────────────────────────────────────────────────────────────

class _ProfileMenuCard extends StatelessWidget {
  final _ProfileMenuSection section;

  const _ProfileMenuCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(Rounded.md),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Spacings.md,
              Spacings.md,
              Spacings.md,
              Spacings.xs,
            ),
            child: AppText(
              section.title,
              fontWeight: FontWeight.w700,
            ),
          ),
          for (var i = 0; i < section.items.length; i++) ...[
            _ProfileMenuRow(item: section.items[i]),
            if (i != section.items.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                indent: Spacings.md,
                endIndent: Spacings.md,
                color: AppColors.neutral200,
              ),
          ],
          const AppSpacer.xs(),
        ],
      ),
    );
  }
}

// ─── Menu row ─────────────────────────────────────────────────────────────────

class _ProfileMenuRow extends StatelessWidget {
  final _ProfileMenuItem item;

  const _ProfileMenuRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacings.md,
          vertical: Spacings.sm + 2,
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 24,
              color: AppColors.textSecondary,
            ),
            const AppSpacer.sm(horizontal: true),
            Expanded(
              child: AppText(
                item.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
