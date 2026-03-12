import 'dart:async';

import 'package:boilerplate/core/theme/tokens/color_tokens.dart';
import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:boilerplate/features/dashboard/data/models/auction_item.dart';
import 'package:boilerplate/features/dashboard/data/models/dashboard_formatters.dart';
import 'package:flutter/material.dart';

class AuctionCard extends StatefulWidget {
  final AuctionItem item;
  final bool showTimer;

  const AuctionCard({
    super.key,
    required this.item,
    required this.showTimer,
  });

  @override
  State<AuctionCard> createState() => _AuctionCardState();
}

class _AuctionCardState extends State<AuctionCard> {
  late int _secs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secs = widget.item.secs;
    if (widget.showTimer) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted && _secs > 0) setState(() => _secs--);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _urgent => _secs < 600;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tint = widget.item.tint ?? scheme.primary;

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: SpacingTokens.sm),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(RadiusTokens.xl),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardImage(
              item: widget.item,
              tint: tint,
              showTimer: widget.showTimer,
              secs: _secs,
              urgent: _urgent,
            ),
            _CardInfo(item: widget.item),
          ],
        ),
      ),
    );
  }
}

// ── Image area ────────────────────────────────────────────────────────────────

class _CardImage extends StatelessWidget {
  final AuctionItem item;
  final Color tint;
  final bool showTimer;
  final int secs;
  final bool urgent;

  const _CardImage({
    required this.item,
    required this.tint,
    required this.showTimer,
    required this.secs,
    required this.urgent,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(RadiusTokens.xl),
      ),
      child: Container(
        height: 100,
        color: tint.withOpacity(0.08),
        child: Stack(
          children: [
            Center(
              child: Text(item.emoji, style: const TextStyle(fontSize: 48)),
            ),
            Positioned(
              top: SpacingTokens.sm,
              right: SpacingTokens.sm,
              child: _WishlistButton(
                isWishlisted: item.wishlisted,
                surfaceColor: scheme.surface,
              ),
            ),
            if (showTimer)
              Positioned(
                bottom: SpacingTokens.sm,
                left: SpacingTokens.sm,
                child: _CountdownChip(secs: secs, urgent: urgent),
              ),
          ],
        ),
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  final bool isWishlisted;
  final Color surfaceColor;

  const _WishlistButton({
    required this.isWishlisted,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4),
        ],
      ),
      child: Center(
        child: Icon(
          isWishlisted
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded,
          size: 14,
          color: isWishlisted ? ColorTokens.error500 : Colors.black38,
        ),
      ),
    );
  }
}

class _CountdownChip extends StatelessWidget {
  final int secs;
  final bool urgent;

  const _CountdownChip({required this.secs, required this.urgent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: urgent ? ColorTokens.error500 : Colors.black54,
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

// ── Info area ─────────────────────────────────────────────────────────────────

class _CardInfo extends StatelessWidget {
  final AuctionItem item;

  const _CardInfo({required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        SpacingTokens.sm,
        SpacingTokens.sm,
        SpacingTokens.sm,
        SpacingTokens.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            item.title,
            variant: AppTextVariant.labelMedium,
            fontWeight: FontWeight.w600,
            maxLines: 2,
            height: 1.35,
          ),
          const SizedBox(height: 6),
          AppText(
            'Tawaran tertinggi',
            variant: AppTextVariant.labelSmall,
            color: scheme.onSurface.withOpacity(0.4),
          ),
          AppText(
            formatRupiah(item.bid),
            variant: AppTextVariant.titleSmall,
            color: scheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
