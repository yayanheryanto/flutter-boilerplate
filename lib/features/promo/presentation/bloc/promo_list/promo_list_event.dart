part of 'promo_list_bloc.dart';

sealed class PromoListEvent extends Equatable {
  const PromoListEvent();

  @override
  List<Object?> get props => [];
}

/// Muat (atau muat ulang) daftar promo.
final class PromoListRequested extends PromoListEvent {
  const PromoListRequested();
}
