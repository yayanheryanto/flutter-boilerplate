import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'buy_npl_detail_event.dart';
part 'buy_npl_detail_state.dart';

@injectable
class BuyNplDetailBloc extends Bloc<BuyNplDetailEvent, BuyNplDetailState> {
  BuyNplDetailBloc() : super(const BuyNplDetailState()) {
    on<BuyNplDetailStarted>((event, emit) => emit(state.copyWith(status: BuyNplDetailStatus.loaded)));
  }
}
