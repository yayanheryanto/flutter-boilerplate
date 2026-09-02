import 'package:emas/core/constants/rounded.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/presentation/bloc/category/category_bloc.dart';
import 'package:emas/features/dashboard/presentation/widgets/home/category_auction_list_item.dart';
import 'package:emas/shared/widgets/input/app_text_field.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryPage extends StatefulWidget {
  final AuctionCategory category;
  const CategoryPage({super.key, required this.category});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _showSortSheet(BuildContext ctx) async {
    final bloc = context.read<CategoryBloc>();
    await showModalBottomSheet<void>(
      context: ctx,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Rounded.xl)),
      ),
      builder: (_) => _SortSheet(
        selected: bloc.state.sort,
        color: widget.category.color,
        onSelected: (sort) {
          bloc.add(CategorySortChanged(sort));
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoryBloc>()..add(CategoryStarted(widget.category)),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          final cat = widget.category;
          final items = state.items;
          return Scaffold(
            backgroundColor: const Color(0xFFF4F6F9),
            body: RefreshIndicator(
              onRefresh: () async => context.read<CategoryBloc>().add(CategoryStarted(cat)),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                  _CategorySliverAppBar(
                    category: cat,
                    searchCtrl: _searchCtrl,
                    onSearch: (value) => context.read<CategoryBloc>().add(CategorySearchChanged(value)),
                    onSort: () async => _showSortSheet(context),
                  ),
                  SliverToBoxAdapter(
                    child: _SortPillRow(
                      selected: state.sort,
                      color: cat.color,
                      onSelected: (sort) => context.read<CategoryBloc>().add(CategorySortChanged(sort)),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(Spacings.md, Spacings.sm, Spacings.md, 0),
                      child: AppText('${items.length} item tersedia', variant: AppTextVariant.labelMedium, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                    ),
                  ),
                  if (state.status == CategoryStatus.loading)
                    const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                  else if (state.status == CategoryStatus.failure)
                    SliverFillRemaining(child: Center(child: AppText(state.errorMessage ?? 'Gagal memuat data')))
                  else if (items.isEmpty)
                    SliverFillRemaining(child: _EmptyState(query: state.query))
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => i < items.length
                            ? Padding(padding: const EdgeInsets.only(top: Spacings.xs), child: CategoryAuctionListItem(item: items[i]))
                            : const SizedBox(height: Spacings.xl),
                        childCount: items.length + 1,
                      ),
                    ),
                ],
              ),
            ),
          );
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
        const SizedBox(width: Spacings.xs),
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
            left: Spacings.md,
            right: Spacings.md,
            bottom: 48,
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Rounded.md),
                ),
                child: Center(
                  child: Text(
                    category.image,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: Spacings.sm),
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
            Spacings.md,
            0,
            Spacings.md,
            Spacings.sm,
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
  final CategorySort selected;
  final Color color;
  final ValueChanged<CategorySort> onSelected;

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
        Spacings.md,
        Spacings.sm,
        Spacings.md,
        Spacings.sm,
      ),
      child: Row(
        children: CategorySort.values.map((s) {
          final active = s == selected;
          return GestureDetector(
            onTap: () => onSelected(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: Spacings.xs),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: active ? color : Colors.white,
                borderRadius: BorderRadius.circular(Rounded.full),
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
  final CategorySort selected;
  final Color color;
  final ValueChanged<CategorySort> onSelected;

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
          const SizedBox(height: Spacings.md),
          // Handle bar
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(Rounded.xxs),
            ),
          ),
          const SizedBox(height: Spacings.md),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacings.md),
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
          const SizedBox(height: Spacings.xs),
          ...CategorySort.values.map(
                (s) => ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacings.md,
              ),
              title: AppText(s.label),
              trailing: s == selected
                  ? Icon(Icons.check_rounded, color: color, size: 20)
                  : null,
              onTap: () => onSelected(s),
            ),
          ),
          const SizedBox(height: Spacings.sm),
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
          const SizedBox(height: Spacings.md),
          AppText(
            query.isEmpty ? 'Belum ada item' : 'Tidak ditemukan',
            variant: AppTextVariant.titleSmall,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: Spacings.xs),
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
