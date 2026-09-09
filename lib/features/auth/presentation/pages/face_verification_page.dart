import 'dart:io';

import 'package:emas/core/constants/elevations.dart';
import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/utils/account_type.dart';
import 'package:emas/core/utils/app_form_utils.dart';
import 'package:emas/core/constants/images.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:emas/features/auth/presentation/widgets/verification_stepper.dart';
import 'package:sizer/sizer.dart';

class FaceVerificationPage extends StatefulWidget {
  final AccountType accountType;

  const FaceVerificationPage({
    super.key,
    required this.accountType,
  });

  @override
  State<FaceVerificationPage> createState() => FaceVerificationPageState();
}

class FaceVerificationPageState extends State<FaceVerificationPage> with AppFormMixin<FaceVerificationPage> {
  File? _ktpPhoto;
  bool _isLoadingPhoto = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _onSubmit() {
    if (!validateForm()) return;
    if (_ktpPhoto == null) {
      AppSnackbar.error(context, 'Foto KTP wajib dilampirkan');
      return;
    }
    // TODO: dispatch KTP verification event
    context.go(Routes.dashboard);
  }

  Future<void> _openCamera() async {
    final result = await context.push<File?>(Routes.facePick);
    if (result != null && mounted) {
      setState(() => _ktpPhoto = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: AppPageBar(
        title: 'Verifikasi Akun',
        onBack: () => context.pop(),
        elevation: Elevations.xs,
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // 1. Scrollable Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const AppSpacer.md(),
                      VerificationStepper(
                        currentStep: 1,
                        accountType: widget.accountType,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: Spacings.md,
                          vertical: Spacings.sm,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacings.md,
                  vertical: Spacings.md,
                ),
                child: AppButton(
                  label: 'Lanjut',
                  onPressed: () async {
                    await context.push(Routes.addressVerification);
                    // _onSubmit
                  },
                  borderRadius: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        borderRadius: BorderRadius.circular(Rounded.lg),
        border: const Border(
          left: BorderSide(color: AppColors.neutral200, width: 0.8),
          right: BorderSide(color: AppColors.neutral200, width: 0.8),
          bottom: BorderSide(color: AppColors.neutral200, width: 0.8),
          top: BorderSide(color: AppColors.neutral200, width: 0.8),
        ),
      ),
      padding: const EdgeInsets.all(Spacings.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppText('Verifikasi Wajah', variant: AppTextVariant.titleMedium, fontWeight: FontWeight.bold),
          const AppSpacer.md(),
          ClipRRect(
            borderRadius: BorderRadius.circular(Rounded.md),
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
                        Images.sampleCorrectIdCard,
                      ),
                    ),
                  ),
          ),
          const AppSpacer.md(),
          AppButton(
            label: isLoading
                ? 'Memproses...'
                : photo == null
                    ? 'Ambil Foto'
                    : 'Foto Ulang',
            variant: AppButtonVariant.outlined,
            backgroundColor: AppColors.white,
            onPressed: isLoading ? null : onTap,
            isLoading: isLoading,
            foregroundColor: AppColors.textPrimary,
            borderColor: AppColors.primary500,
            borderWidth: 1,
            borderRadius: 25,
          ),
        ],
      ),
    );
  }
}
