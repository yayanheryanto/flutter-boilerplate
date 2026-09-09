import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_spacer.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfirmationVerificationPage extends StatefulWidget {
  const ConfirmationVerificationPage({super.key});

  @override
  State<ConfirmationVerificationPage> createState() => _ConfirmationVerificationPageState();
}

class _ConfirmationVerificationPageState extends State<ConfirmationVerificationPage> {
  bool _agreedToTerms = false;

  void _onVerify() {
    if (!_agreedToTerms) return;
    // TODO: dispatch final verification submit event
    context.go(Routes.accountProcessed);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: AppPageBar(
        elevation: 1,
        title: 'Verifikasi Akun',
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppSpacer.md(),
            const VerificationStepper(currentStep: 4),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacings.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const AppText(
                      'Cek kembali apakah data di bawah ini sudah benar?',
                      variant: AppTextVariant.titleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                    const AppSpacer.lg(),

                    _ReviewItem(
                      label: 'Verifikasi KTP',
                      onTap: () => context.go(Routes.idCardVerification),
                    ),
                    const AppSpacer.sm(),
                    _ReviewItem(
                      label: 'Informasi Pribadi',
                      onTap: () {
                        // TODO: navigate to personal info page
                      },
                    ),
                    const AppSpacer.sm(),
                    _ReviewItem(
                      label: 'Informasi Data Bank',
                      onTap: () {
                        // TODO: navigate to bank data page
                      },
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom section ────────────────────────────────────────────
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.fromLTRB(
                Spacings.lg,
                Spacings.md,
                Spacings.lg,
                Spacings.lg,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: _agreedToTerms,
                          onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                          activeColor: AppColors.primary500,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            children: [
                              const TextSpan(text: 'Saya menyetujui '),
                              TextSpan(
                                text: 'syarat dan ketentuan lelang',
                                style: const TextStyle(
                                  color: AppColors.primary500,
                                  fontWeight: FontWeight.w600,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // TODO: open terms page
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const AppSpacer.md(),

                  AppButton(
                    label: 'Verifikasi Akun',
                    onPressed: _agreedToTerms ? _onVerify : null,
                    borderRadius: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ReviewItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(Spacings.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Spacings.md),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacings.md,
            vertical: Spacings.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Spacings.md),
            border: Border.all(
              color: AppColors.border,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              // Checkmark badge
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primary500,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const AppSpacer.md(horizontal: true),

              // Label
              Expanded(
                child: AppText(
                  label,
                  fontWeight: FontWeight.w500,
                ),
              ),

              // Chevron
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
