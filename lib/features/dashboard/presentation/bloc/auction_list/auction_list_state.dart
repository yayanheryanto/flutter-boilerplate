part of 'auction_list_bloc.dart';

enum AuctionListStatus { initial, loading, loaded, failure }
enum AuctionListSort { newest, lowestPrice, highestPrice }

class AuctionListState extends Equatable {
  final AuctionListStatus status;
  final List<AuctionListItem> items;
  final String query;
  final AuctionListSort sort;
  final int? minimumPrice;
  final int? maximumPrice;
  final String? errorMessage;

  const AuctionListState({
    this.status = AuctionListStatus.initial,
    this.items = const [],
    this.query = '',
    this.sort = AuctionListSort.newest,
    this.minimumPrice,
    this.maximumPrice,
    this.errorMessage,
  });

  AuctionListState copyWith({
    AuctionListStatus? status,
    List<AuctionListItem>? items,
    String? query,
    AuctionListSort? sort,
    Object? minimumPrice = _unset,
    Object? maximumPrice = _unset,
    Object? errorMessage = _unset,
  }) {
    return AuctionListState(
      status: status ?? this.status,
      items: items ?? this.items,
      query: query ?? this.query,
      sort: sort ?? this.sort,
      minimumPrice: identical(minimumPrice, _unset) ? this.minimumPrice : minimumPrice as int?,
      maximumPrice: identical(maximumPrice, _unset) ? this.maximumPrice : maximumPrice as int?,
      errorMessage: identical(errorMessage, _unset) ? this.errorMessage : errorMessage as String?,
    );
  }

  static const _unset = Object();

  @override
  List<Object?> get props => [status, items, query, sort, minimumPrice, maximumPrice, errorMessage];
}
