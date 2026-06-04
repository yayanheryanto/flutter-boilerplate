import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/color_tokens.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerificationPreparationPage extends StatelessWidget {
  const VerificationPreparationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      appBar: AppPageAppBar(
        title: 'Verifikasi Akun',
        onBack: () => context.pop(),
        // elevation: 8,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(SpacingTokens.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ───────────────────────────────────────────────
                    const AppText(
                      'Pilih jenis akun lelang Anda',
                      variant: AppTextVariant.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                    const AppSpacer.sm(),
                    const AppText(
                      'Pilih jenis akun untuk mengikuti lelang di EMAS',
                      variant: AppTextVariant.bodySmall,
                      fontWeight: FontWeight.bold,
                      color: ColorTokens.textPrimary,
                    ),
                    const AppSpacer.lg(),

                    // ── Card ─────────────────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        // Cream/off-white background matching screenshot
                        color: const Color(0xFFFDF6EE),
                        borderRadius: BorderRadius.circular(RadiusTokens.lg),
                        border: const Border(
                          left: BorderSide(
                            color: ColorTokens.neutral200,
                            width: 0.8,
                          ),
                          right: BorderSide(
                            color: ColorTokens.neutral200,
                            width: 0.8,
                          ),
                          bottom: BorderSide(
                            color: ColorTokens.neutral200,
                            width: 0.8,
                          ),
                          top: BorderSide(
                            color: ColorTokens.neutral200,
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section label inside card
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              SpacingTokens.md,
                              SpacingTokens.md,
                              SpacingTokens.md,
                              SpacingTokens.sm,
                            ),
                            child: AppText(
                              'Hal yang perlu dipersiapkan',
                              variant: AppTextVariant.titleSmall,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),

                          // Item 1
                          const _PreparationItem(
                            number: 1,
                            title: 'Foto e-KTP',
                            description: 'Melindungi akun Anda dari tindakan penipuan',
                          ),

                          // Item 2
                          const _PreparationItem(
                            number: 2,
                            title: 'Data Bank',
                            description: 'Digunakan untuk pengembalian dana deposit',
                          ),

                          const AppSpacer.sm(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom CTA ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                SpacingTokens.sm,
                SpacingTokens.lg,
                SpacingTokens.lg,
              ),
              child: AppButton(
                label: 'Mulai Verifikasi Akun',
                onPressed: () async {
                  await context.push(AppRoutes.ktpGuide);
                },
                borderRadius: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Preparation Item ─────────────────────────────────────────────────────────

class _PreparationItem extends StatelessWidget {
  final int number;
  final String title;
  final String description;

  const _PreparationItem({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.sm,
      ),
      child: Row(
        children: [
          // ── Number badge ────────────────────────────────────────────────
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: ColorTokens.primary500,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: AppText(
              '$number',
              variant: AppTextVariant.labelSmall,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const AppSpacer.sm(horizontal: true),

          // ── Text ─────────────────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  fontWeight: FontWeight.w700,
                ),
                const AppSpacer.xs(),
                AppText(
                  description,
                  height: 1.4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
