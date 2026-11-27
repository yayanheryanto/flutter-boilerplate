part of 'promo_detail_bloc.dart';

sealed class PromoDetailEvent extends Equatable {
  const PromoDetailEvent();

  @override
  List<Object?> get props => [];
}

final class PromoDetailRequested extends PromoDetailEvent {
  final String id;

  const PromoDetailRequested(this.id);

  @override
  List<Object?> get props => [id];
}
