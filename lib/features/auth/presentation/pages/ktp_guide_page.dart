import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KtpGuidePage extends StatelessWidget {
  const KtpGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      appBar: AppPageAppBar(
        title: 'Verifikasi Akun',
        onBack: () => context.pop(),
        elevation: 1,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Stepper ────────────────────────────────────────────────────
            const AppSpacer.sm(),
            const VerificationStepper(currentStep: 0),

            // ── Content ────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.lg,
                  vertical: SpacingTokens.sm,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6EE),
                    borderRadius: BorderRadius.circular(RadiusTokens.lg),
                    border: const Border(
                      left: BorderSide(
                        color: AppColors.neutral200,
                        width: 0.8,
                      ),
                      right: BorderSide(
                        color: AppColors.neutral200,
                        width: 0.8,
                      ),
                      bottom: BorderSide(
                        color: AppColors.neutral200,
                        width: 0.8,
                      ),
                      top: BorderSide(
                        color: AppColors.neutral200,
                        width: 0.8,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Card header ──────────────────────────────────────
                      const AppText(
                        'Panduan Foto KTP',
                        variant: AppTextVariant.titleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      const AppSpacer.md(),
                      const AppText(
                        'Berikut beberapa panduan agar proses verifikasi KTP lebih mudah',
                        variant: AppTextVariant.bodySmall,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                      const AppSpacer.md(),

                      // ── KTP example images ───────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'assets/images/png/sample_incorrect_idcard.png',
                            ),
                          ),
                          const AppSpacer.sm(horizontal: true),
                          Expanded(
                            child: Image.asset(
                              'assets/images/png/sample_correct_idcard.png',
                            ),
                          ),
                        ],
                      ),
                      const AppSpacer.md(),

                      // ── Tips list ────────────────────────────────────────
                      const _TipItem(
                        text: 'Ambil foto KTP ',
                        boldParts: ['dengan jelas', 'di dalam bingkai'],
                        suffix: ' dan ',
                        trailingSuffix: '.',
                      ),
                      const AppSpacer.sm(),
                      const _TipItem(
                        text: 'Pastikan ',
                        boldParts: ['isi terbaca seluruhnya', 'tidak buram'],
                        suffix: ' dan ',
                        trailingSuffix: '.',
                      ),
                      const AppSpacer.sm(),
                      const _TipItem(
                        text: 'Pastikan ',
                        boldParts: ['pencahayaan bagus', 'tidak ada pantulan cahaya'],
                        suffix: ' dan ',
                        trailingSuffix: '.',
                      ),
                      const AppSpacer.sm(),
                      const _TipItem(
                        text: 'KTP harus ',
                        boldParts: ['asli, bukan salinan', '\nkondisinya baik'],
                        suffix: ', dan ',
                        trailingSuffix: '.',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Bottom CTA ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                SpacingTokens.lg,
                SpacingTokens.sm,
                SpacingTokens.lg,
                SpacingTokens.lg,
              ),
              child: AppButton(
                label: 'Mulai Verifikasi KTP',
                onPressed: () async {
                  await context.push(AppRoutes.ktpVerification);
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

// ─── Tip Item ─────────────────────────────────────────────────────────────────

class _TipItem extends StatelessWidget {
  final String text;
  final List<String> boldParts;
  final String suffix; // connector between bold parts
  final String trailingSuffix;

  const _TipItem({
    required this.text,
    required this.boldParts,
    required this.suffix,
    required this.trailingSuffix,
  });

  @override
  Widget build(BuildContext context) {
    final normal = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
          height: 1.5,
        );
    final bold = normal?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface);

    // Build rich text spans
    final spans = <TextSpan>[
      TextSpan(text: text, style: normal),
      TextSpan(text: boldParts[0], style: bold),
      if (boldParts.length > 1) ...[
        TextSpan(text: suffix, style: normal),
        TextSpan(text: boldParts[1], style: bold),
      ],
      TextSpan(text: trailingSuffix, style: normal),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Orange check circle
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.primary500,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, size: 12, color: Colors.white),
          ),
        ),
        const AppSpacer(10, horizontal: true),
        Expanded(
          child: AppRichText(children: spans),
        ),
      ],
    );
  }
}
