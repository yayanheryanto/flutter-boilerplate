import 'package:boilerplate/core/theme/tokens/radius_tokens.dart';
import 'package:boilerplate/core/theme/tokens/spacing_tokens.dart';
import 'package:boilerplate/core/ui/design_system/atoms/input/app_text_field.dart';
import 'package:boilerplate/core/ui/design_system/atoms/typography/app_text.dart';
import 'package:boilerplate/features/dashboard/data/models/auction_item.dart';
import 'package:boilerplate/features/dashboard/data/models/dashboard_dummy_data.dart';
import 'package:boilerplate/features/dashboard/presentation/organisms/category_auction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum _SortOption {
  endingSoon('Segera Berakhir'),
  highestBid('Tawaran Tertinggi'),
  lowestBid('Tawaran Terendah'),
  newest('Terbaru');

  const _SortOption(this.label);
  final String label;
}

class CategoryPage extends StatefulWidget {
  final AuctionCategory category;
  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _searchCtrl = TextEditingController();
  _SortOption _sort = _SortOption.endingSoon;
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<AuctionItem> get _items {
    var list = itemsByCategory(widget.category);

    if (_query.isNotEmpty) {
      list = list
          .where((e) => e.title.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }

    switch (_sort) {
      case _SortOption.endingSoon:
        list.sort((a, b) => a.secs.compareTo(b.secs));
      case _SortOption.highestBid:
        list.sort((a, b) => b.bid.compareTo(a.bid));
      case _SortOption.lowestBid:
        list.sort((a, b) => a.bid.compareTo(b.bid));
      case _SortOption.newest:
        list = list.reversed.toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final items = _items;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            _CategorySliverAppBar(
              category: cat,
              searchCtrl: _searchCtrl,
              onSearch: (v) => setState(() => _query = v),
              onSort: () async => _showSortSheet(context),
            ),
            SliverToBoxAdapter(
              child: _SortPillRow(
                selected: _sort,
                color: cat.color,
                onSelected: (s) => setState(() => _sort = s),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  SpacingTokens.md,
                  SpacingTokens.sm,
                  SpacingTokens.md,
                  0,
                ),
                child: AppText(
                  '${items.length} item tersedia',
                  variant: AppTextVariant.labelMedium,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
            items.isEmpty
                ? SliverFillRemaining(child: _EmptyState(query: _query))
                : SliverList(
              delegate: SliverChildBuilderDelegate(
                    (_, i) => i < items.length
                    ? Padding(
                  padding: const EdgeInsets.only(top: SpacingTokens.xs),
                  child: CategoryAuctionListItem(item: items[i]),
                )
                    : const SizedBox(height: SpacingTokens.xl),
                childCount: items.length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSortSheet(BuildContext ctx) async {
    await showModalBottomSheet<void>(
      context: ctx,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(RadiusTokens.xl)),
      ),
      builder: (_) => _SortSheet(
        selected: _sort,
        color: widget.category.color,
        onSelected: (s) {
          setState(() => _sort = s);
          Navigator.pop(ctx);
        },
      ),
    );
  }
}

// ── Sliver App Bar ────────────────────────────────────────────────────────────

class _CategorySliverAppBar extends StatelessWidget {
  final AuctionCategory category;
  final TextEditingController searchCtrl;
  final ValueChanged<String> onSearch;
  final VoidCallback onSort;

  const _CategorySliverAppBar({
    required this.category,
    required this.searchCtrl,
    required this.onSearch,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final color = category.color;

    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: color,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.tune_rounded, color: Colors.white),
          tooltip: 'Urutkan',
          onPressed: onSort,
        ),
        const SizedBox(width: SpacingTokens.xs),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.82)],
            ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 56,
            left: SpacingTokens.md,
            right: SpacingTokens.md,
            bottom: 48,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(RadiusTokens.md),
                ),
                child: Center(
                  child: Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: SpacingTokens.sm),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    'Kategori',
                    variant: AppTextVariant.labelSmall,
                    color: Colors.white.withOpacity(0.65),
                  ),
                  AppText(
                    category.label,
                    variant: AppTextVariant.titleMedium,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(52),
        child: Container(
          height: 52,
          padding: const EdgeInsets.fromLTRB(
            SpacingTokens.md,
            0,
            SpacingTokens.md,
            SpacingTokens.sm,
          ),
          child: AppSearchField(
            controller: searchCtrl,
            hint: 'Cari di ${category.label.toLowerCase()}...',
            onChanged: onSearch,
          ),
        ),
      ),
    );
  }
}

// ── Sort Pill Row ─────────────────────────────────────────────────────────────

class _SortPillRow extends StatelessWidget {
  final _SortOption selected;
  final Color color;
  final ValueChanged<_SortOption> onSelected;

  const _SortPillRow({
    required this.selected,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        SpacingTokens.md,
        SpacingTokens.sm,
        SpacingTokens.md,
        SpacingTokens.sm,
      ),
      child: Row(
        children: _SortOption.values.map((s) {
          final active = s == selected;
          return GestureDetector(
            onTap: () => onSelected(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: SpacingTokens.xs),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active ? color : Colors.white,
                borderRadius: BorderRadius.circular(RadiusTokens.full),
                border: Border.all(
                  color: active ? color : color.withOpacity(0.18),
                ),
                boxShadow: active
                    ? [
                  BoxShadow(
                    color: color.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: AppText(
                s.label,
                variant: AppTextVariant.labelMedium,
                color: active ? Colors.white : color,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Sort Bottom Sheet ─────────────────────────────────────────────────────────

class _SortSheet extends StatelessWidget {
  final _SortOption selected;
  final Color color;
  final ValueChanged<_SortOption> onSelected;

  const _SortSheet({
    required this.selected,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: SpacingTokens.md),
          // Handle bar
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: SpacingTokens.md),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: SpacingTokens.md),
            child: Row(
              children: [
                AppText(
                  'Urutkan',
                  variant: AppTextVariant.titleSmall,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          ..._SortOption.values.map(
                (s) => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: SpacingTokens.md,
              ),
              title: AppText(s.label),
              trailing: s == selected
                  ? Icon(Icons.check_rounded, color: color, size: 20)
                  : null,
              onTap: () => onSelected(s),
            ),
          ),
          const SizedBox(height: SpacingTokens.sm),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            query.isEmpty ? '📦' : '🔍',
            style: const TextStyle(fontSize: 52),
          ),
          const SizedBox(height: SpacingTokens.md),
          AppText(
            query.isEmpty ? 'Belum ada item' : 'Tidak ditemukan',
            variant: AppTextVariant.titleSmall,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: SpacingTokens.xs),
          AppText(
            query.isEmpty
                ? 'Item lelang untuk kategori ini\nakan segera tersedia.'
                : 'Coba kata kunci yang berbeda.',
            variant: AppTextVariant.bodySmall,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.45),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
