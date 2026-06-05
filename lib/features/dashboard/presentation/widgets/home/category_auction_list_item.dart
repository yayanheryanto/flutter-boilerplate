import 'dart:async';

import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/core/constants/tokens/radius_tokens.dart';
import 'package:emas/core/constants/tokens/spacing_tokens.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:emas/features/dashboard/data/models/auction_item.dart';
import 'package:emas/features/dashboard/data/models/dashboard_formatters.dart';
import 'package:flutter/material.dart';

class CategoryAuctionListItem extends StatefulWidget {
  final AuctionItem item;
  const CategoryAuctionListItem({super.key, required this.item});

  @override
  State<CategoryAuctionListItem> createState() =>
      _CategoryAuctionListItemState();
}

class _CategoryAuctionListItemState extends State<CategoryAuctionListItem> {
  late int _secs;
  late bool _wishlisted;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secs = widget.item.secs;
    _wishlisted = widget.item.wishlisted;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _secs > 0) setState(() => _secs--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _urgent => _secs < 600;
  Color get _tint => widget.item.tint ?? widget.item.category.color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(RadiusTokens.lg),
          boxShadow: [
            BoxShadow(
              color: _tint.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(RadiusTokens.lg),
              ),
              child: SizedBox(
                width: 110,
                height: 120,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ColoredBox(
                      color: _tint.withOpacity(0.07),
                      child: Center(
                        child: Text(
                          widget.item.emoji,
                          style: const TextStyle(fontSize: 46),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: SpacingTokens.xs,
                      left: SpacingTokens.xs,
                      child: _TimerChip(secs: _secs, urgent: _urgent),
                    ),
                  ],
                ),
              ),
            ),

            // ── Detail ─────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SpacingTokens.sm,
                  SpacingTokens.sm,
                  SpacingTokens.sm,
                  SpacingTokens.sm,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + wishlist button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppText(
                            widget.item.title,
                            variant: AppTextVariant.labelLarge,
                            fontWeight: FontWeight.w600,
                            maxLines: 2,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(width: SpacingTokens.xs),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _wishlisted = !_wishlisted),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              _wishlisted
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey(_wishlisted),
                              size: 18,
                              color: _wishlisted
                                  ? AppColors.error500
                                  : scheme.onSurface.withOpacity(0.28),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: SpacingTokens.xs),

                    // Bid info
                    AppText(
                      'Tawaran tertinggi',
                      variant: AppTextVariant.labelSmall,
                      color: scheme.onSurface.withOpacity(0.4),
                    ),
                    AppText(
                      formatRupiah(widget.item.bid),
                      variant: AppTextVariant.titleSmall,
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),

                    const SizedBox(height: SpacingTokens.sm),

                    // CTA
                    AppButton(
                      label: 'Pasang Tawaran',
                      onPressed: () {},
                      size: AppButtonSize.small,
                      isExpanded: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Countdown chip ────────────────────────────────────────────────────────────

class _TimerChip extends StatelessWidget {
  final int secs;
  final bool urgent;

  const _TimerChip({required this.secs, required this.urgent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: urgent ? AppColors.error500 : Colors.black54,
        borderRadius: BorderRadius.circular(RadiusTokens.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Colors.white, size: 10),
          const SizedBox(width: 3),
          Text(
            formatTimer(secs),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
