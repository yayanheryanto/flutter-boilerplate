part of 'join_auction_bloc.dart';

abstract class JoinAuctionEvent extends Equatable {
  const JoinAuctionEvent();
  @override
  List<Object?> get props => [];
}

class JoinAuctionCategoryChanged extends JoinAuctionEvent {
  final AuctionCategory category;
  const JoinAuctionCategoryChanged(this.category);
  @override
  List<Object?> get props => [category];
}
