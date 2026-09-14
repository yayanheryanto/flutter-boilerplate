import 'package:emas/core/constants/app_radius.dart';
import 'package:emas/core/constants/app_spacings.dart';
import 'package:emas/features/auth/data/models/profile_settings_data.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/appbar/app_page_bar.dart';
import 'package:emas/shared/widgets/design_system.dart';
import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const account = dummyAccountInfo;
    const profile = dummyProfileInfo;
    const address = dummyAddressInfo;
    const bank = dummyBankInfo;

    return AppScaffoldWrapper(
      backgroundColor: AppColors.white,
      appBar: const AppPageBar(title: 'Pengaturan Profil'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacings.md),
        children: [
          _SectionHeader(
            title: 'Informasi Akun',
            actionLabel: 'Ubah Akun',
            // TODO: navigasi ke halaman ubah akun
            onAction: () {},
          ),
          const AppSpacer.md(),
          _FieldRow(label: 'Email', value: account.email),
          const AppSpacer.md(),
          _FieldRow(label: 'Nomor Telepon', value: account.phoneNumber),

          const AppSpacer.lg(),
          const Divider(height: 1, color: AppColors.neutral200),
          const AppSpacer.lg(),

          _SectionHeader(
            title: 'Informasi Profil',
            actionLabel: 'Ubah Profil',
            // TODO: navigasi ke halaman ubah profil
            onAction: () {},
          ),
          const AppSpacer.md(),
          _FieldRow(label: 'Mendaftar Lelang Sebagai', value: profile.registeredAs),
          const AppSpacer.md(),
          const _KtpPhotoField(),
          const AppSpacer.md(),
          _FieldRow(label: 'NIK KTP', value: profile.nik),
          const AppSpacer.md(),
          _FieldRow(label: 'Nama Lengkap Sesuai KTP', value: profile.fullName),
          const AppSpacer.md(),
          _FieldRow(label: 'Jenis Kelamin', value: profile.gender),
          const AppSpacer.md(),
          _FieldRow(label: 'Tempat Lahir', value: profile.birthPlace),
          const AppSpacer.md(),
          _FieldRow(label: 'Tanggal Lahir', value: profile.birthDate),
          const AppSpacer.md(),
          _FieldRow(label: 'Pekerjaan', value: profile.occupation),
          const AppSpacer.md(),
          _FieldRow(label: 'Kewarganegaraan', value: profile.nationality),

          const AppSpacer.lg(),
          const Divider(height: 1, color: AppColors.neutral200),
          const AppSpacer.lg(),

          _SectionHeader(
            title: 'Informasi Alamat',
            actionLabel: 'Ubah Alamat',
            // TODO: navigasi ke halaman ubah alamat
            onAction: () {},
          ),
          const AppSpacer.md(),
          _FieldRow(label: 'Alamat', value: address.address),
          const AppSpacer.md(),
          Row(
            children: [
              Expanded(child: _FieldRow(label: 'RT', value: address.rt)),
              const AppSpacer.md(horizontal: true,),
              Expanded(child: _FieldRow(label: 'RW', value: address.rw)),
            ],
          ),
          const AppSpacer.md(),
          _FieldRow(label: 'Provinsi', value: address.province),
          const AppSpacer.md(),
          _FieldRow(label: 'Kota', value: address.city),
          const AppSpacer.md(),
          _FieldRow(label: 'Kecamatan', value: address.district),
          const AppSpacer.md(),
          _FieldRow(label: 'Kelurahan', value: address.subDistrict),

          const AppSpacer.lg(),
          const Divider(height: 1, color: AppColors.neutral200),
          const AppSpacer.lg(),

          _SectionHeader(
            title: 'Informasi Data Bank',
            actionLabel: 'Ubah Data Bank',
            // TODO: navigasi ke halaman ubah data bank
            onAction: () {},
          ),
          const AppSpacer.md(),
          _FieldRow(label: 'Bank', value: bank.bankName),
          const AppSpacer.md(),
          _FieldRow(label: 'Nomor Rekening', value: bank.accountNumber),
          const AppSpacer.md(),
          _FieldRow(label: 'Atas Nama', value: bank.accountHolderName),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(title, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          child: AppButton(
            label: actionLabel,
            size: AppButtonSize.small,
            isExpanded: false,
            borderRadius: AppRadius.full,
            prefixIcon: Icons.edit_outlined,
            onPressed: onAction,
          ),
        ),
      ],
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String value;

  const _FieldRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          variant: AppTextVariant.labelSmall,
          color: AppColors.textPrimary,
        ),
        const AppSpacer.xxs(),
        AppText(value, fontWeight: FontWeight.w700),
      ],
    );
  }
}

class _KtpPhotoField extends StatelessWidget {
  const _KtpPhotoField();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppText(
          'Foto KTP',
          variant: AppTextVariant.labelSmall,
          color: AppColors.textPrimary,
        ),
        const AppSpacer.sm(),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacings.sm),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.neutral200),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Container(
                  width: 200,
                  height: 120,
                  color: AppColors.neutral100,
                  child: const Icon(
                    Icons.badge_outlined,
                    size: 36,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const AppSpacer.md(),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      // TODO: buka preview foto KTP
                    },
                    icon: const Icon(
                      Icons.search_off_outlined,
                      size: 16,
                      color: AppColors.blue200,
                    ),
                    label: const AppText(
                      'Lihat Foto',
                      variant: AppTextVariant.labelMedium,
                      color: AppColors.blue200,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
