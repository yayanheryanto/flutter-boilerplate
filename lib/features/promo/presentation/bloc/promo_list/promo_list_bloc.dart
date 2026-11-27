import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/features/promo/domain/entities/promo.dart';
import 'package:emas/features/promo/domain/usecases/promo_usecases.dart';

part 'promo_list_event.dart';
part 'promo_list_state.dart';

/// Daftar promo untuk carousel dashboard.
@injectable
class PromoListBloc extends Bloc<PromoListEvent, PromoListState> {
  final GetPromosUseCase _getPromos;

  PromoListBloc(this._getPromos) : super(const PromoListLoading()) {
    on<PromoListRequested>(_onRequested);
  }

  Future<void> _onRequested(PromoListRequested event, Emitter<PromoListState> emit) async {
    final current = state;
    // Saat pull-to-refresh, promo lama tetap tampil (tanpa skeleton).
    if (current is PromoListLoaded) {
      emit(current.copyWith(isRefreshing: true));
    } else {
      emit(const PromoListLoading());
    }

    final result = await _getPromos();

    result.fold(
      (failure) => emit(
        current is PromoListLoaded
            // Gagal refresh → tetap tampilkan data lama.
            ? current.copyWith(isRefreshing: false)
            : PromoListFailure(failure.message),
      ),
      (promos) => emit(PromoListLoaded(promos)),
    );
  }
}
