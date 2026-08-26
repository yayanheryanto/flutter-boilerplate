import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:emas/features/dashboard/domain/entities/auction_list_item.dart';
import 'package:emas/features/dashboard/domain/usecases/get_auction_list_usecase.dart';

part 'auction_list_event.dart';
part 'auction_list_state.dart';

@injectable
class AuctionListBloc extends Bloc<AuctionListEvent, AuctionListState> {
  final GetAuctionListUseCase _getAuctionList;
  List<AuctionListItem> _allItems = const [];

  AuctionListBloc(this._getAuctionList) : super(const AuctionListState()) {
    on<AuctionListStarted>(_onStarted);
    on<AuctionListSearchChanged>(_onSearchChanged);
    on<AuctionListSortChanged>(_onSortChanged);
    on<AuctionListFilterChanged>(_onFilterChanged);
  }

  Future<void> _onStarted(AuctionListStarted event, Emitter<AuctionListState> emit) async {
    emit(state.copyWith(status: AuctionListStatus.loading, errorMessage: null));
    final result = await _getAuctionList();
    result.fold(
      (failure) => emit(state.copyWith(status: AuctionListStatus.failure, errorMessage: failure.message)),
      (items) {
        _allItems = items;
        emit(_buildState(state.copyWith(status: AuctionListStatus.loaded)));
      },
    );
  }

  void _onSearchChanged(AuctionListSearchChanged event, Emitter<AuctionListState> emit) {
    emit(_buildState(state.copyWith(query: event.query)));
  }

  void _onSortChanged(AuctionListSortChanged event, Emitter<AuctionListState> emit) {
    emit(_buildState(state.copyWith(sort: event.sort)));
  }

  void _onFilterChanged(AuctionListFilterChanged event, Emitter<AuctionListState> emit) {
    emit(_buildState(state.copyWith(minimumPrice: event.minimumPrice, maximumPrice: event.maximumPrice)));
  }

  AuctionListState _buildState(AuctionListState base) {
    final query = base.query.trim().toLowerCase();
    final items = _allItems.where((item) {
      final matchesQuery = query.isEmpty || item.name.toLowerCase().contains(query) || item.location.toLowerCase().contains(query);
      final matchesMin = base.minimumPrice == null || item.price >= base.minimumPrice!;
      final matchesMax = base.maximumPrice == null || item.price <= base.maximumPrice!;
      return matchesQuery && matchesMin && matchesMax;
    }).toList();

    switch (base.sort) {
      case AuctionListSort.lowestPrice:
        items.sort((a, b) => a.price.compareTo(b.price));
      case AuctionListSort.highestPrice:
        items.sort((a, b) => b.price.compareTo(a.price));
      case AuctionListSort.newest:
        break;
    }
    return base.copyWith(items: items);
  }
}
