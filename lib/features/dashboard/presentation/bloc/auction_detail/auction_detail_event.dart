part of 'auction_detail_bloc.dart';

abstract class AuctionDetailEvent extends Equatable {
  const AuctionDetailEvent();
  @override
  List<Object?> get props => [];
}

class AuctionDetailStarted extends AuctionDetailEvent {
  const AuctionDetailStarted();
}
