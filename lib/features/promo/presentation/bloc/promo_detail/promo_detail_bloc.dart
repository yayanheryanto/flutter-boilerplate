import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/features/promo/domain/entities/promo.dart';
import 'package:emas/features/promo/domain/usecases/promo_usecases.dart';

part 'promo_detail_event.dart';
part 'promo_detail_state.dart';

/// Detail satu promo. Selalu mengambil dari API berdasarkan id agar halaman
/// juga bisa dibuka langsung lewat deep link `/promo/:id`.
@injectable
class PromoDetailBloc extends Bloc<PromoDetailEvent, PromoDetailState> {
  final GetPromoDetailUseCase _getPromoDetail;

  PromoDetailBloc(this._getPromoDetail) : super(const PromoDetailLoading()) {
    on<PromoDetailRequested>(_onRequested);
  }

  Future<void> _onRequested(PromoDetailRequested event, Emitter<PromoDetailState> emit) async {
    emit(const PromoDetailLoading());

    final result = await _getPromoDetail(event.id);

    result.fold(
      (failure) => emit(PromoDetailFailure(failure.message)),
      (promo) => emit(PromoDetailLoaded(promo)),
    );
  }
}
