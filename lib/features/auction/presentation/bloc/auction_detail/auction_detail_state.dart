part of 'auction_detail_bloc.dart';

enum AuctionDetailStatus { initial, loaded }

class AuctionDetailState extends Equatable {
  final AuctionDetailStatus status;
  const AuctionDetailState({this.status = AuctionDetailStatus.initial});

  AuctionDetailState copyWith({AuctionDetailStatus? status}) => AuctionDetailState(status: status ?? this.status);
  @override
  List<Object?> get props => [status];
}
