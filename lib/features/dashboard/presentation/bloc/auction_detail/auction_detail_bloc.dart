import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'auction_detail_event.dart';
part 'auction_detail_state.dart';

@injectable
class AuctionDetailBloc extends Bloc<AuctionDetailEvent, AuctionDetailState> {
  AuctionDetailBloc() : super(const AuctionDetailState()) {
    on<AuctionDetailStarted>((event, emit) => emit(state.copyWith(status: AuctionDetailStatus.loaded)));
  }
}
