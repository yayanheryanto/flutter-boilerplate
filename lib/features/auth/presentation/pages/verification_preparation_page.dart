import 'package:emas/core/constants/elevations.dart';
import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/utils/account_type.dart';
import 'package:emas/core/constants/images.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_image.dart';
import 'package:emas/shared/widgets/display/app_spacer.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

class VerificationPreparationPage extends StatefulWidget {
  const VerificationPreparationPage({super.key});

  @override
  State<VerificationPreparationPage> createState() => _VerificationPreparationPageState();
}

class _VerificationPreparationPageState extends State<VerificationPreparationPage> {
  AccountType _selected = AccountType.personal;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      appBar: AppPageBar(
        title: 'Verifikasi Akun',
        elevation: Elevations.xs,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacings.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      'Pilih jenis akun lelang Anda',
                      variant: AppTextVariant.titleLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    const AppSpacer.xs(),
                    const AppText(
                      'Pilih jenis akun untuk mengikuti lelang di EMAS',
                      variant: AppTextVariant.titleSmall,
                    ),
                    const AppSpacer.lg(),

                    _AccountTypeCard(
                      type: AccountType.personal,
                      title: 'Personal',
                      description: 'Mengikuti lelang atas nama sendiri',
                      selected: _selected == AccountType.personal,
                      image: Images.personalIcon,
                      onTap: () => setState(
                            () => _selected = AccountType.personal,
                      ),
                    ),
                    const AppSpacer.sm(),
                    _AccountTypeCard(
                      type: AccountType.company,
                      title: 'Perusahaan',
                      description: 'Mengikuti lelang atas nama perusahaan',
                      selected: _selected == AccountType.company,
                      image: Images.companyIcon,
                      onTap: () => setState(
                            () => _selected = AccountType.company,
                      ),
                    ),
                    const AppSpacer.xl(),

                    const AppText(
                      'Hal yang perlu dipersiapkan',
                      variant: AppTextVariant.titleSmall,
                      fontWeight: FontWeight.bold,
                    ),
                    const AppSpacer.md(),

                    _PreparationItem(
                      number: 1,
                      title: _selected == AccountType.personal ? 'Foto e-KTP' : 'Foto NPWP',
                      description: 'Melindungi akun Anda dari tindakan penipuan',
                    ),
                    const AppSpacer.sm(),
                    _PreparationItem(
                      number: 2,
                      title: _selected == AccountType.personal ? 'Informasi Alamat' : 'Dokumen Perusahaan',
                      description: 'Digunakan untuk verifikasi identitas saat pengambilan barang lelang',
                    ),
                    const AppSpacer.sm(),
                    const _PreparationItem(
                      number: 3,
                      title: 'Data Bank',
                      description: 'Digunakan untuk pengembalian dana deposit',
                    ),
                  ],
                ),
              ),
            ),

            // ── Bottom CTA ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Spacings.lg,
                Spacings.sm,
                Spacings.lg,
                Spacings.lg,
              ),
              child: AppButton(
                label: 'Mulai Verifikasi Akun',
                onPressed: () async => context.push(
                  Routes.idCardGuide,
                  extra: _selected,
                ),
                borderRadius: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final AccountType type;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final String image;

  const _AccountTypeCard({
    required this.type,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 10.h,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacings.md,
          vertical: Spacings.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary500.withOpacity(
                  0.06,
                )
              : AppColors.white,
          borderRadius: BorderRadius.circular(
            Rounded.lg,
          ),
          border: Border.all(
            color: selected ? AppColors.primary500 : AppColors.white,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary500 : Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
                color: selected ? AppColors.primary500 : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, size: 13, color: Colors.white) : null,
            ),
            const AppSpacer.md(
              horizontal: true,
            ),
            AppImage.circle(
              src: image,
              size: 44,
            ),
            const AppSpacer.md(horizontal: true),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    title,
                    fontWeight: FontWeight.w700,
                  ),
                  const AppSpacer.xs(),
                  AppText(
                    description,
                    variant: AppTextVariant.bodySmall,
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Number badge
        Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            color: AppColors.primary500,
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

        const AppSpacer.md(horizontal: true),

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
                variant: AppTextVariant.bodySmall,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.55),
                height: 1.4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
