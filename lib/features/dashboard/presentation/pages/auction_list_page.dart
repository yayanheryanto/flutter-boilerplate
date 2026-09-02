import 'package:emas/core/constants/routes.dart';
import 'package:emas/core/constants/spacings.dart';
import 'package:emas/core/constants/radius_tokens.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/utils/currency_formatter.dart';
import 'package:emas/features/dashboard/domain/entities/auction_list_item.dart';
import 'package:emas/features/dashboard/presentation/bloc/auction_list/auction_list_bloc.dart';
import 'package:emas/gen/assets.gen.dart';
import 'package:emas/shared/layouts/app_scaffold_wrapper.dart';
import 'package:emas/shared/theme/app_colors.dart';
import 'package:emas/shared/widgets/bottomsheets/app_bottom_sheet.dart';
import 'package:emas/shared/widgets/buttons/app_button.dart';
import 'package:emas/shared/widgets/display/app_display.dart';
import 'package:emas/shared/widgets/input/app_text_field.dart';
import 'package:emas/shared/widgets/typography/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuctionListPage extends StatefulWidget {
  const AuctionListPage({super.key});

  @override
  State<AuctionListPage> createState() => _AuctionListPageState();
}

class _AuctionListPageState extends State<AuctionListPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showSortSheet(BuildContext context) async {
    final bloc = context.read<AuctionListBloc>();
    await AppCustomBottomSheet.show<void>(
      context,
      title: 'Urutkan',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: AuctionListSort.values.map((sort) {
          final selected = bloc.state.sort == sort;
          final label = switch (sort) {
            AuctionListSort.newest => 'Terbaru',
            AuctionListSort.lowestPrice => 'Harga Terendah',
            AuctionListSort.highestPrice => 'Harga Tertinggi',
          };
          return ListTile(
            onTap: () {
              bloc.add(AuctionListSortChanged(sort));
              Navigator.pop(context);
            },
            title: AppText(
              label,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              color: selected ? AppColors.primary500 : AppColors.textPrimary,
            ),
            trailing: selected ? const Icon(Icons.check_rounded, color: AppColors.primary500) : null,
          );
        }).toList(),
      ),
    );
  }

  Future<void> _showFilterSheet(BuildContext context) async {
    final bloc = context.read<AuctionListBloc>();
    final minController = TextEditingController(text: bloc.state.minimumPrice?.toString());
    final maxController = TextEditingController(text: bloc.state.maximumPrice?.toString());

    try {
      await AppCustomBottomSheet.show<void>(
        context,
        title: 'Filter',
        content: Padding(
          padding: const EdgeInsets.only(bottom: Spacings.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText('Harga', variant: AppTextVariant.labelMedium, fontWeight: FontWeight.w600),
              const AppSpacer.sm(),
              Row(
                children: [
                  Expanded(child: AppTextField(controller: minController, hint: 'Min', keyboardType: TextInputType.number)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: Spacings.sm), child: AppText('–')),
                  Expanded(child: AppTextField(controller: maxController, hint: 'Maks', keyboardType: TextInputType.number)),
                ],
              ),
              const AppSpacer.lg(),
              AppButton(
                label: 'Terapkan Filter',
                onPressed: () {
                  bloc.add(
                    AuctionListFilterChanged(
                      minimumPrice: int.tryParse(minController.text),
                      maximumPrice: int.tryParse(maxController.text),
                    ),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      );
    } finally {
      minController.dispose();
      maxController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuctionListBloc>()..add(const AuctionListStarted()),
      child: BlocBuilder<AuctionListBloc, AuctionListState>(
        builder: (context, state) {
          return AppScaffoldWrapper(
            backgroundColor: AppColors.white,
            appBar: _SearchAppBar(
              controller: _searchController,
              onChanged: (value) => context.read<AuctionListBloc>().add(AuctionListSearchChanged(value)),
              onBack: () => context.pop(),
              topMargin: MediaQuery.of(context).padding.top,
            ),
            body: Column(
              children: [
                _FilterToolbar(
                  sortLabel: switch (state.sort) {
                    AuctionListSort.newest => 'Terbaru',
                    AuctionListSort.lowestPrice => 'Harga Terendah',
                    AuctionListSort.highestPrice => 'Harga Tertinggi',
                  },
                  filterActive: state.minimumPrice != null || state.maximumPrice != null,
                  onSortTap: () async => _showSortSheet(context),
                  onFilterTap: () async => _showFilterSheet(context),
                ),
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, AuctionListState state) {
    if (state.status == AuctionListStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.status == AuctionListStatus.failure) {
      return Center(child: AppText(state.errorMessage ?? 'Gagal memuat data'));
    }
    if (state.items.isEmpty) return const _EmptyState();

    return GridView.builder(
      padding: const EdgeInsets.all(Spacings.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: Spacings.sm,
        mainAxisSpacing: Spacings.sm,
        childAspectRatio: 0.78,
      ),
      itemCount: state.items.length,
      itemBuilder: (context, index) => _AuctionGridCard(
        data: state.items[index],
        onTap: () async => context.push(Routes.auctionDetail),
      ),
    );
  }
}

class _SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onBack;
  final double topMargin;

  const _SearchAppBar({required this.controller, required this.onChanged, required this.onBack, this.topMargin = 0});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + topMargin);

  @override
  Widget build(BuildContext context) {
    final bar = AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        children: [
          IconButton(icon: const Icon(Icons.chevron_left_rounded, size: 28, color: AppColors.primary500), onPressed: onBack),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: Spacings.md),
              child: AppSearchField(controller: controller, hint: 'Cari', onChanged: onChanged),
            ),
          ),
        ],
      ),
    );
    if (topMargin == 0) return bar;
    return Column(mainAxisSize: MainAxisSize.min, children: [Container(height: topMargin, color: AppColors.white), bar]);
  }
}

class _FilterToolbar extends StatelessWidget {
  final String sortLabel;
  final bool filterActive;
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  const _FilterToolbar({required this.sortLabel, required this.filterActive, required this.onSortTap, required this.onFilterTap});

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: Spacings.md, vertical: Spacings.sm),
        child: Row(
          children: [
            _ToolbarChip(label: sortLabel, active: false, onTap: onSortTap),
            const SizedBox(width: Spacings.sm),
            _ToolbarChip(label: 'Filter', active: filterActive, onTap: onFilterTap),
          ],
        ),
      );
}

class _ToolbarChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _ToolbarChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: Spacings.sm + 4, vertical: Spacings.xs + 2),
          decoration: BoxDecoration(
            color: active ? AppColors.primary100 : AppColors.white,
            borderRadius: BorderRadius.circular(RadiusTokens.full),
            border: Border.all(color: active ? AppColors.primary500 : AppColors.neutral300, width: active ? 1.5 : 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                label,
                variant: AppTextVariant.labelSmall,
                fontWeight: FontWeight.w500,
                color: active ? AppColors.primary500 : AppColors.textPrimary,
              ),
              const SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: active ? AppColors.primary500 : AppColors.textSecondary),
            ],
          ),
        ),
      );
}

class _AuctionGridCard extends StatelessWidget {
  final AuctionListItem data;
  final VoidCallback onTap;

  const _AuctionGridCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(RadiusTokens.lg),
      borderColor: AppColors.neutral300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: AppColors.neutral200,
              child: Image.asset(Assets.images.png.icMotorcycle.path),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacings.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               AppText(
                  data.name,
                  variant: AppTextVariant.labelSmall,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  // height: 1.35,
                ),
                const SizedBox(height: 2),
                AppText(
                  CurrencyFormatter.rupiah(data.price),
                  variant: AppTextVariant.labelMedium,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 2),
                AppText(
                  data.location,
                  variant: AppTextVariant.labelSmall,
                  color: AppColors.textPrimary,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    AppText(
                      data.date,
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textPrimary,
                    ),
                    const AppText(
                      ' | ',
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.neutral300,
                    ),
                    AppText(
                      data.time,
                      variant: AppTextVariant.labelSmall,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 56, color: AppColors.neutral300),
          AppSpacer.sm(),
          AppText('Tidak ada lelang ditemukan', color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
