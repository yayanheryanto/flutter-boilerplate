import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

/// Organism: sticky app bar yang expand jadi header profil.
/// Dipasang sebagai [SliverToBoxAdapter] pertama di [CustomScrollView].
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita pakai SliverAppBar langsung — tapi karena dipanggil dari
    // SliverToBoxAdapter kita kembalikan sebagai CustomScrollView inner.
    // Untuk menjaga konsistensi dengan DashboardHeader yang juga StatelessWidget
    // biasa di dalam SliverToBoxAdapter, kita render sebagai widget biasa.
    return _ProfileHeaderContent();
  }
}

class _ProfileHeaderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      color: const Color(0xFFF4F6F9),
      padding: EdgeInsets.only(
        top: topPadding + SpacingTokens.md,
        bottom: SpacingTokens.lg,
        left: SpacingTokens.md,
        right: SpacingTokens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul halaman — konsisten dengan DashboardHeader style
          const AppText(
            'Profil Saya',
            variant: AppTextVariant.headlineSmall,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: SpacingTokens.lg),
          // Avatar row
          Row(
            children: [
              _Avatar(),
              const SizedBox(width: SpacingTokens.md),
              Expanded(child: _UserInfo()),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8C42), Color(0xFFFF6B00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B00).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: AppText(
              'AR',
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.edit_rounded,
              size: 13,
              color: Color(0xFFFF6B00),
            ),
          ),
        ),
      ],
    );
  }
}

class _UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Taro Misaki',
          variant: AppTextVariant.titleLarge,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: SpacingTokens.xs / 2),
        AppText(
          'taromisaki@email.com',
          variant: AppTextVariant.bodySmall,
          color: Colors.black54,
        ),
        AppSpacer.xs(),
        AppBadge(
          label: 'Member Aktif',
          backgroundColor: Color(0xFFFF6B00),
          textColor: Colors.white,
        ),
      ],
    );
  }
}
