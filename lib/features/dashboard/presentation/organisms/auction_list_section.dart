import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/display/app_display.dart';
import 'package:boilerplate/features/dashboard/data/models/auction_item.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/auction_card.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/live_badge.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/section_header.dart';
import 'package:flutter/material.dart';

class EndingSoonSection extends StatelessWidget {
  final List<AuctionItem> items;

  const EndingSoonSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(
          title: 'Segera Berakhir',
          onSeeAll: () {},
          trailing: const LiveBadge(),
        ),
        const AppSpacer.sm(),
        _HorizontalAuctionList(items: items, showTimer: true),
      ],
    );
  }
}

class RecommendedSection extends StatelessWidget {
  final List<AuctionItem> items;

  const RecommendedSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionHeader(
          title: 'Rekomendasi untuk Kamu',
          onSeeAll: () {},
        ),
        const AppSpacer.sm(),
        _HorizontalAuctionList(items: items, showTimer: false),
      ],
    );
  }
}

class _HorizontalAuctionList extends StatelessWidget {
  final List<AuctionItem> items;
  final bool showTimer;

  const _HorizontalAuctionList({
    required this.items,
    required this.showTimer,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.md),
        itemCount: items.length,
        itemBuilder: (_, i) => AuctionCard(item: items[i], showTimer: showTimer),
      ),
    );
  }
}
