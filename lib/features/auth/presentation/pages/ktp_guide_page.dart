import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/color_tokens.dart';
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
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Stepper ────────────────────────────────────────────────────
            const AppSpacer.sm(),
            const _VerificationStepper(currentStep: 0),

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
                  padding: const EdgeInsets.all(SpacingTokens.md),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Card header ──────────────────────────────────────
                      AppText(
                        'Panduan Foto KTP',
                        variant: AppTextVariant.titleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                      AppSpacer.md(),
                      AppText(
                        'Berikut beberapa panduan agar proses verifikasi KTP lebih mudah',
                        variant: AppTextVariant.bodySmall,
                        color: ColorTokens.textPrimary,
                        height: 1.4,
                      ),
                      AppSpacer.md(),

                      // ── KTP example images ───────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: _KtpExampleImage(isCorrect: false),
                          ),
                          AppSpacer.sm(horizontal: true),
                          Expanded(
                            child: _KtpExampleImage(isCorrect: true),
                          ),
                        ],
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
                        boldParts: ['asli, bukan salinan', 'kondisinya baik'],
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
                onPressed: () {
                  // TODO: navigate to KTP camera capture
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

// ─── Verification Stepper ─────────────────────────────────────────────────────

class _VerificationStepper extends StatelessWidget {
  final int currentStep; // 0-indexed

  static const _steps = [
    'Verifikasi KTP',
    'Verifikasi Wajah',
    'Informasi Pribadi',
    'Informasi Pekerjaan',
  ];

  const _VerificationStepper({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.lg,
        vertical: SpacingTokens.sm,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_steps.length * 2 - 1, (i) {
            // Even indices = step, odd = connector line
            if (i.isOdd) {
              return _StepConnector(
                isCompleted: currentStep > i ~/ 2,
              );
            }
            final stepIndex = i ~/ 2;
            return _StepItem(
              index: stepIndex,
              label: _steps[stepIndex],
              state: stepIndex < currentStep
                  ? _StepState.completed
                  : stepIndex == currentStep
                      ? _StepState.active
                      : _StepState.inactive,
            );
          }),
        ),
      ),
    );
  }
}

enum _StepState { completed, active, inactive }

class _StepItem extends StatelessWidget {
  final int index;
  final String label;
  final _StepState state;

  const _StepItem({
    required this.index,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = state == _StepState.active;
    final isCompleted = state == _StepState.completed;
    final isInactive = state == _StepState.inactive;

    final circleColor = isInactive ? Colors.grey.shade300 : ColorTokens.primary500;

    final textColor = isInactive ? Colors.grey.shade400 : Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circle badge
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, size: 13, color: Colors.white)
              : AppText(
                  '${index + 1}',
                  variant: AppTextVariant.labelSmall,
                  fontWeight: FontWeight.bold,
                  color: isInactive ? Colors.grey.shade500 : Colors.white,
                ),
        ),
        const AppSpacer(6, horizontal: true),
        AppText(
          label,
          variant: AppTextVariant.labelMedium,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: textColor,
        ),
      ],
    );
  }
}

class _StepConnector extends StatelessWidget {
  final bool isCompleted;

  const _StepConnector({required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: isCompleted ? ColorTokens.primary500 : Colors.grey.shade300,
    );
  }
}

// ─── KTP Example Image ────────────────────────────────────────────────────────

class _KtpExampleImage extends StatelessWidget {
  final bool isCorrect;

  const _KtpExampleImage({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    final borderColor = isCorrect ? Colors.green : Colors.red;
    final badgeColor = isCorrect ? Colors.green : Colors.red;
    final badgeIcon = isCorrect ? Icons.check_circle : Icons.cancel;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(RadiusTokens.md - 2),
            child: Stack(
              children: [
                // KTP card illustration
                Positioned.fill(
                  child: CustomPaint(painter: _KtpIllustrationPainter(isCorrect: isCorrect)),
                ),
              ],
            ),
          ),
        ),
        // Status badge
        Positioned(
          bottom: -10,
          right: -6,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(badgeIcon, color: badgeColor, size: 24),
          ),
        ),
      ],
    );
  }
}

class _KtpIllustrationPainter extends CustomPainter {
  final bool isCorrect;

  const _KtpIllustrationPainter({required this.isCorrect});

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = isCorrect ? const Color(0xFFDCEDFF) : const Color(0xFFFFDDDD);
    canvas.drawRect(Offset.zero & size, bg);

    // Simulate KTP lines
    final linePaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final shortLine = Paint()
      ..color = Colors.blueGrey.shade200
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Header bar
    final headerPaint = Paint()..color = Colors.blueGrey.shade400;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 14), headerPaint);

    // Photo placeholder
    final photoPaint = Paint()..color = Colors.blueGrey.shade300;
    canvas.drawRect(Rect.fromLTWH(8, 20, 28, 36), photoPaint);

    // Text lines
    for (int i = 0; i < 5; i++) {
      final y = 22.0 + i * 9;
      canvas.drawLine(Offset(44, y), Offset(size.width - 8, y), i == 0 ? linePaint : shortLine);
    }

    if (!isCorrect) {
      // Blur overlay for incorrect
      final blurPaint = Paint()..color = Colors.white.withOpacity(0.45);
      canvas.drawRect(Offset.zero & size, blurPaint);
    }
  }

  @override
  bool shouldRepaint(_KtpIllustrationPainter old) => old.isCorrect != isCorrect;
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
              color: ColorTokens.primary500,
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
