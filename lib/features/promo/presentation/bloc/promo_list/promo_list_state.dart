part of 'promo_list_bloc.dart';

sealed class PromoListState extends Equatable {
  const PromoListState();

  @override
  List<Object?> get props => [];
}

final class PromoListLoading extends PromoListState {
  const PromoListLoading();
}

final class PromoListLoaded extends PromoListState {
  final List<Promo> promos;
  final bool isRefreshing;

  const PromoListLoaded(this.promos, {this.isRefreshing = false});

  PromoListLoaded copyWith({bool? isRefreshing}) =>
      PromoListLoaded(promos, isRefreshing: isRefreshing ?? this.isRefreshing);

  @override
  List<Object?> get props => [promos, isRefreshing];
}

final class PromoListFailure extends PromoListState {
  final String message;

  const PromoListFailure(this.message);

  @override
  List<Object?> get props => [message];
}
