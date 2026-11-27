part of 'promo_detail_bloc.dart';

sealed class PromoDetailState extends Equatable {
  const PromoDetailState();

  @override
  List<Object?> get props => [];
}

final class PromoDetailLoading extends PromoDetailState {
  const PromoDetailLoading();
}

final class PromoDetailLoaded extends PromoDetailState {
  final Promo promo;

  const PromoDetailLoaded(this.promo);

  @override
  List<Object?> get props => [promo];
}

final class PromoDetailFailure extends PromoDetailState {
  final String message;

  const PromoDetailFailure(this.message);

  @override
  List<Object?> get props => [message];
}
