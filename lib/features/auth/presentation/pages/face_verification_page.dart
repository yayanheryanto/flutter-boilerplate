import 'dart:io';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/core/utils/images/app_images.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';
import 'package:sizer/sizer.dart';

class FaceVerificationPage extends StatelessWidget {
  const FaceVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _KtpVerificationContent();
  }
}

class _KtpVerificationContent extends StatefulWidget {
  const _KtpVerificationContent();

  @override
  State<_KtpVerificationContent> createState() => _KtpVerificationContentState();
}

class _KtpVerificationContentState extends State<_KtpVerificationContent> with AppFormMixin<_KtpVerificationContent> {

  // ── State ─────────────────────────────────────────────────────────────────────
  File? _ktpPhoto;
  bool _isLoadingPhoto = false;


  @override
  void dispose() {
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────────────────────────

  void _onSubmit() {
    if (!validateForm()) return;
    if (_ktpPhoto == null) {
      AppSnackbar.error(context, 'Foto KTP wajib dilampirkan');
      return;
    }
    // TODO: dispatch KTP verification event
    context.go(AppRoutes.dashboard);
  }

  Future<void> _openCamera() async {
    final result = await context.push<File?>(AppRoutes.camerPick);
    if (result != null && mounted) {
      setState(() => _ktpPhoto = result);
    }
  }


  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: AppPageBar(
        title: 'Verifikasi Akun',
        onBack: () => context.pop(),
        elevation: 1,
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AppSpacer.md(),
                const VerificationStepper(currentStep: 1),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: SpacingTokens.md,
                    vertical: SpacingTokens.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppSpacer.sm(),
                      // Card with photo
                      _KtpPhotoCard(
                        photo: _ktpPhoto,
                        isLoading: _isLoadingPhoto,
                        onTap: _openCamera,
                      ),
                      const AppSpacer.lg(),

                      AppButton(
                        label: 'Lanjut',
                        onPressed: () async {
                          await context.push(AppRoutes.addressVerification);
                          // _onSubmit
                        },
                        borderRadius: 25,
                      ),
                      const AppSpacer.md(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── KTP Photo Card ───────────────────────────────────────────────────────────

class _KtpPhotoCard extends StatelessWidget {
  final File? photo;
  final bool isLoading;
  final VoidCallback onTap;

  const _KtpPhotoCard({
    required this.photo,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const AppText('Verifikasi KTP', variant: AppTextVariant.titleMedium, fontWeight: FontWeight.bold),
          const AppSpacer.md(),

          // Photo area
          ClipRRect(
            borderRadius: BorderRadius.circular(RadiusTokens.md),
            child: photo != null
                ? Center(
              child: Image.file(
                photo!,
                height: 18.h,
                width: 58.w,
                fit: BoxFit.cover,
              ),
            )
                : Center(
              child: SizedBox(
                height: 18.h,
                width: 58.w,
                child: Image.asset(
                  AppImages.sampleCorrectIdCard,
                ),
              ),
            ),
          ),
          const AppSpacer.md(),

          // Foto Ulang button
          AppButton(
            label: isLoading ? 'Memproses...' : 'Foto Ulang',
            variant: AppButtonVariant.outlined,
            backgroundColor: AppColors.bgCard,
            onPressed: isLoading ? null : onTap,
            isLoading: isLoading,
            foregroundColor: AppColors.primary500,
            colorSide: AppColors.bgCard,
            borderWidth: 0,
            borderRadius: 25,
          ),
        ],
      ),
    );
  }
}
