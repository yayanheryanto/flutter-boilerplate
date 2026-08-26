import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/domain/usecases/get_auctions_by_category_usecase.dart';

part 'category_event.dart';
part 'category_state.dart';

enum CategorySort { endingSoon, highestBid, lowestBid, newest }

extension CategorySortLabel on CategorySort {
  String get label => switch (this) {
    CategorySort.endingSoon => 'Segera Berakhir',
    CategorySort.highestBid => 'Tawaran Tertinggi',
    CategorySort.lowestBid => 'Tawaran Terendah',
    CategorySort.newest => 'Terbaru',
  };
}

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAuctionsByCategoryUseCase _getAuctions;
  List<AuctionItem> _allItems = const [];

  CategoryBloc(this._getAuctions) : super(const CategoryState()) {
    on<CategoryStarted>(_onStarted);
    on<CategorySearchChanged>(_onSearchChanged);
    on<CategorySortChanged>(_onSortChanged);
  }

  Future<void> _onStarted(CategoryStarted event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: CategoryStatus.loading));
    final result = await _getAuctions(GetAuctionsByCategoryParams(event.category));
    result.fold(
      (failure) => emit(state.copyWith(status: CategoryStatus.failure, errorMessage: failure.message)),
      (items) {
        _allItems = items;
        emit(_apply(state.copyWith(status: CategoryStatus.loaded)));
      },
    );
  }

  void _onSearchChanged(CategorySearchChanged event, Emitter<CategoryState> emit) {
    emit(_apply(state.copyWith(query: event.query)));
  }

  void _onSortChanged(CategorySortChanged event, Emitter<CategoryState> emit) {
    emit(_apply(state.copyWith(sort: event.sort)));
  }

  CategoryState _apply(CategoryState value) {
    var items = _allItems.where((item) {
      final query = value.query.trim().toLowerCase();
      return query.isEmpty || item.title.toLowerCase().contains(query);
    }).toList();
    switch (value.sort) {
      case CategorySort.endingSoon:
        items.sort((a, b) => a.secs.compareTo(b.secs));
      case CategorySort.highestBid:
        items.sort((a, b) => b.bid.compareTo(a.bid));
      case CategorySort.lowestBid:
        items.sort((a, b) => a.bid.compareTo(b.bid));
      case CategorySort.newest:
        items = items.reversed.toList();
    }
    return value.copyWith(items: items);
  }
}
