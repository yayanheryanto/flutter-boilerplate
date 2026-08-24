import 'package:emas/core/constants/tokens/app_spacings.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';

class JadwalLelangData {
  final String itemName;
  final String locationName;
  final String dateLabel;
  final String timeLabel;
  final String image;
  final Color tint;
  final bool isLive;

  const JadwalLelangData({
    required this.itemName,
    required this.locationName,
    required this.dateLabel,
    required this.timeLabel,
    required this.image,
    this.tint = const Color(0xFFFFE0B2),
    this.isLive = true,
  });
}

class JadwalLelangCard extends StatelessWidget {
  final JadwalLelangData data;

  const JadwalLelangCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.65,
      height: 110,
      margin: const EdgeInsets.only(right: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacings.md),
        border: Border.all(
          color: Colors.black.withOpacity(0.3),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 7,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: FittedBox(
                      child: Text(
                        data.image,
                        style: const TextStyle(
                          fontSize: 38,
                          height: 1,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          data.itemName,
                          variant: AppTextVariant.labelMedium,
                          fontWeight: FontWeight.w600,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          color: AppColors.textPrimary,
                        ),

                        const SizedBox(height: 1),

                        AppText(
                          data.locationName,
                          variant: AppTextVariant.labelSmall,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 2),

                        Row(
                          children: [
                            Flexible(
                              child: AppText(
                                data.dateLabel,
                                variant: AppTextVariant.labelSmall,
                                color: AppColors.textPrimary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            const AppText(
                              ' | ',
                              variant: AppTextVariant.labelSmall,
                              color: AppColors.textPrimary,
                            ),

                            AppText(
                              data.timeLabel,
                              variant: AppTextVariant.labelSmall,
                              color: AppColors.textPrimary,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (data.isLive)
            Expanded(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(7),
                    bottomRight: Radius.circular(7),
                  ),
                ),
                child: const AppText(
                  'Live Auction',
                  variant: AppTextVariant.labelSmall,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
