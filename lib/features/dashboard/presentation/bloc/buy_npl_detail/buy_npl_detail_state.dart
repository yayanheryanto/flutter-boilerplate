part of 'buy_npl_detail_bloc.dart';

enum BuyNplDetailStatus { initial, loaded }

class BuyNplDetailState extends Equatable {
  final BuyNplDetailStatus status;
  const BuyNplDetailState({this.status = BuyNplDetailStatus.initial});

  BuyNplDetailState copyWith({BuyNplDetailStatus? status}) => BuyNplDetailState(status: status ?? this.status);
  @override
  List<Object?> get props => [status];
}
