import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/section_header.dart';
import 'package:flutter/material.dart';

const _categories = [
  (emoji: '🏍️', label: 'Motor',      color: Color(0xFFFF6F00)),
  (emoji: '🚗',  label: 'Mobil',      color: Color(0xFF1565C0)),
  (emoji: '📱',  label: 'Elektronik', color: Color(0xFF6A1B9A)),
  (emoji: '🏠',  label: 'Properti',   color: Color(0xFF2E7D32)),
  (emoji: '💎',  label: 'Mewah',      color: Color(0xFFAD1457)),
  (emoji: '🛠️',  label: 'Lainnya',    color: Color(0xFF546E7A)),
];

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(title: 'Kategori', onSeeAll: () {}),
        const SizedBox(height: SpacingTokens.sm),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: SpacingTokens.sm,
              crossAxisSpacing: SpacingTokens.sm,
              childAspectRatio: 1.1,
            ),
            itemCount: _categories.length,
            itemBuilder: (_, i) => _CategoryCard(
              emoji: _categories[i].emoji,
              label: _categories[i].label,
              color: _categories[i].color,
            ),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _CategoryCard({
    required this.emoji,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(RadiusTokens.lg),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(RadiusTokens.lg),
        splashColor: color.withOpacity(0.12),
        highlightColor: color.withOpacity(0.06),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusTokens.lg),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.sm,
            vertical: SpacingTokens.sm,
          ),
          child: Stack(
            children: [
              // Chevron di pojok kanan atas
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 14,
                  color: scheme.onSurface.withOpacity(0.25),
                ),
              ),
              // Konten utama
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(RadiusTokens.md),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  AppText(
                    label,
                    variant: AppTextVariant.labelMedium,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface.withOpacity(0.8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}