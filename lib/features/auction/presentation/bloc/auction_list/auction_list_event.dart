part of 'auction_list_bloc.dart';

abstract class AuctionListEvent extends Equatable {
  const AuctionListEvent();
  @override
  List<Object?> get props => [];
}

class AuctionListStarted extends AuctionListEvent {
  const AuctionListStarted();
}

class AuctionListSearchChanged extends AuctionListEvent {
  final String query;
  const AuctionListSearchChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class AuctionListSortChanged extends AuctionListEvent {
  final AuctionListSort sort;
  const AuctionListSortChanged(this.sort);
  @override
  List<Object?> get props => [sort];
}

class AuctionListFilterChanged extends AuctionListEvent {
  final int? minimumPrice;
  final int? maximumPrice;
  const AuctionListFilterChanged({this.minimumPrice, this.maximumPrice});
  @override
  List<Object?> get props => [minimumPrice, maximumPrice];
}
