import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_spacer.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

enum _AccountType { personal, perusahaan }

class VerificationPreparationPage extends StatefulWidget {
  const VerificationPreparationPage({super.key});

  @override
  State<VerificationPreparationPage> createState() => _VerificationPreparationPageState();
}

class _VerificationPreparationPageState extends State<VerificationPreparationPage> {
  _AccountType _selected = _AccountType.personal;

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWrapper(
      appBar: AppPageAppBar(
        title: 'Verifikasi Akun',
        elevation: 1,
        onBack: () => context.pop(),
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
                    // ── Header ──────────────────────────────────────────────
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

                    // ── Account type selector ────────────────────────────────
                    _AccountTypeCard(
                      type: _AccountType.personal,
                      title: 'Personal',
                      description: 'Mengikuti lelang atas nama sendiri',
                      selected: _selected == _AccountType.personal,
                      onTap: () => setState(() => _selected = _AccountType.personal),
                    ),
                    const AppSpacer.sm(),
                    _AccountTypeCard(
                      type: _AccountType.perusahaan,
                      title: 'Perusahaan',
                      description: 'Mengikuti lelang atas nama perusahaan',
                      selected: _selected == _AccountType.perusahaan,
                      onTap: () => setState(() => _selected = _AccountType.perusahaan),
                    ),
                    const AppSpacer.xl(),

                    // ── Section label ────────────────────────────────────────
                    const AppText(
                      'Hal yang perlu dipersiapkan',
                      variant: AppTextVariant.titleSmall,
                      fontWeight: FontWeight.bold,
                    ),
                    const AppSpacer.md(),

                    // ── Preparation items ────────────────────────────────────
                    const _PreparationItem(
                      number: 1,
                      title: 'Foto e-KTP',
                      description: 'Melindungi akun Anda dari tindakan penipuan',
                    ),
                    const AppSpacer.sm(),
                    const _PreparationItem(
                      number: 2,
                      title: 'Informasi Alamat',
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
                SpacingTokens.lg,
                SpacingTokens.sm,
                SpacingTokens.lg,
                SpacingTokens.lg,
              ),
              child: AppButton(
                label: 'Mulai Verifikasi Akun',
                onPressed: () async => context.push(AppRoutes.ktpGuide),
                borderRadius: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Account Type Card ────────────────────────────────────────────────────────

class _AccountTypeCard extends StatelessWidget {
  final _AccountType type;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.type,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 10.h,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.md,
          vertical: SpacingTokens.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary500.withOpacity(0.06,) : AppColors.white,
          borderRadius: BorderRadius.circular(
            RadiusTokens.lg,
          ),
          border: Border.all(
            color: selected ? AppColors.primary500 : AppColors.white,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Radio indicator
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
            // Avatar
            _PersonAvatar(selected: selected),
            const AppSpacer.md(horizontal: true),

            // Text
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

// ─── Person Avatar Illustration ───────────────────────────────────────────────

class _PersonAvatar extends StatelessWidget {
  final bool selected;

  const _PersonAvatar({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: Color(0xFFD6EAF8),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Body (shirt)
            Positioned(
              bottom: -4,
              child: Container(
                width: 36,
                height: 24,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary400 : Colors.blueGrey.shade300,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
              ),
            ),
            // Head
            Positioned(
              top: 6,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFDDB4),
                  shape: BoxShape.circle,
                ),
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
        const AppSpacer.sm(horizontal: true),

        // Person avatar illustration
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFD6EAF8),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: -3,
                  child: Container(
                    width: 28,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade300,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFDDB4),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const AppSpacer.sm(horizontal: true),

        // Text
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
