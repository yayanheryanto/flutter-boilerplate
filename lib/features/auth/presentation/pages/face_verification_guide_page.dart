import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/utils/account_type.dart';
import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FaceVerificationGuidePage extends StatelessWidget {
  final AccountType accountType;

  const FaceVerificationGuidePage({
    super.key,
    required this.accountType,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      appBar: AppPageBar(
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
            VerificationStepper(
              currentStep: 1,
              accountType: accountType,
            ),

            // ── Content ────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacings.lg,
                  vertical: Spacings.sm,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF6EE),
                    borderRadius: BorderRadius.circular(Rounded.lg),
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
                  padding: const EdgeInsets.all(Spacings.md),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Card header ──────────────────────────────────────
                      AppText(
                        'Verifikasi Wajah',
                        variant: AppTextVariant.titleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      AppSpacer.md(),

                      // ── Tips list ────────────────────────────────────────
                      _TipItem(
                        text: 'Ambil foto KTP ',
                        boldParts: ['dengan jelas', 'di dalam bingkai'],
                        suffix: ' dan ',
                        trailingSuffix: '.',
                      ),
                      AppSpacer.sm(),
                      _TipItem(
                        text: 'Pastikan ',
                        boldParts: ['isi terbaca seluruhnya', 'tidak buram'],
                        suffix: ' dan ',
                        trailingSuffix: '.',
                      ),
                      AppSpacer.sm(),
                      _TipItem(
                        text: 'Pastikan ',
                        boldParts: ['pencahayaan bagus', 'tidak ada pantulan cahaya'],
                        suffix: ' dan ',
                        trailingSuffix: '.',
                      ),
                      AppSpacer.sm(),
                      _TipItem(
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
                Spacings.lg,
                Spacings.sm,
                Spacings.lg,
                Spacings.lg,
              ),
              child: AppButton(
                label: 'Mulai Verifikasi Wajah',
                onPressed: () async {
                  await context.push(Routes.faceVerification);
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
