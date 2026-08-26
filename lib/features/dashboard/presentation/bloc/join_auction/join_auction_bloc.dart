import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';

part 'join_auction_event.dart';
part 'join_auction_state.dart';

@injectable
class JoinAuctionBloc extends Bloc<JoinAuctionEvent, JoinAuctionState> {
  JoinAuctionBloc() : super(const JoinAuctionState()) {
    on<JoinAuctionCategoryChanged>((event, emit) => emit(state.copyWith(selectedCategory: event.category)));
  }
}
