part of 'join_auction_bloc.dart';

class JoinAuctionState extends Equatable {
  final AuctionCategory selectedCategory;
  const JoinAuctionState({this.selectedCategory = AuctionCategory.mobil});

  JoinAuctionState copyWith({AuctionCategory? selectedCategory}) =>
      JoinAuctionState(selectedCategory: selectedCategory ?? this.selectedCategory);

  @override
  List<Object?> get props => [selectedCategory];
}
