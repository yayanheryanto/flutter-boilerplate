part of 'buy_npl_detail_bloc.dart';

abstract class BuyNplDetailEvent extends Equatable {
  const BuyNplDetailEvent();
  @override
  List<Object?> get props => [];
}

class BuyNplDetailStarted extends BuyNplDetailEvent {
  const BuyNplDetailStarted();
}
