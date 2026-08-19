import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/services/socket/app_socket_service.dart';
import 'package:emas/features/dashboard/data/datasources/live_auction_socket_datasource.dart';
import 'package:emas/features/dashboard/data/models/live_auction_models.dart';

part 'live_auction_event.dart';

part 'live_auction_state.dart';

@injectable
class LiveAuctionBloc extends Bloc<LiveAuctionEvent, LiveAuctionState> {
  final LiveAuctionSocketDataSource _socketDataSource;

  StreamSubscription<LiveAuctionSocketEvent>? _eventsSub;
  StreamSubscription<SocketConnectionStatus>? _statusSub;

  LiveAuctionBloc(this._socketDataSource)
      : super(const LiveAuctionState.initial(lot: 0)) {
    on<LiveAuctionStarted>(_onStarted);
    on<LiveAuctionBidPlaced>(_onBidPlaced);
    on<LiveAuctionSocketEventReceived>(_onSocketEventReceived);
    on<LiveAuctionConnectionStatusChanged>(_onConnectionStatusChanged);
    on<LiveAuctionStopped>(_onStopped);
  }

  Future<void> _onStarted(
    LiveAuctionStarted event,
    Emitter<LiveAuctionState> emit,
  ) async {
    emit(LiveAuctionState.initial(lot: event.lot));

    await _eventsSub?.cancel();
    await _statusSub?.cancel();

    _eventsSub = _socketDataSource.events.listen(
      (e) => add(LiveAuctionSocketEventReceived(e)),
    );
    _statusSub = _socketDataSource.connectionStatus.listen(
      (s) => add(LiveAuctionConnectionStatusChanged(s)),
    );

    await _socketDataSource.connect(event.lot);
  }

  void _onBidPlaced(
    LiveAuctionBidPlaced event,
    Emitter<LiveAuctionState> emit,
  ) {
    if (!state.isLive) return;
    emit(state.copyWith(isPlacingBid: true));
    _socketDataSource.placeBid(event.amount);
  }

  void _onSocketEventReceived(
    LiveAuctionSocketEventReceived event,
    Emitter<LiveAuctionState> emit,
  ) {
    final socketEvent = event.event;

    if (socketEvent is LiveAuctionSnapshotEvent) {
      emit(state.copyWith(
        status: LiveAuctionStatus.live,
        basePrice: socketEvent.basePrice,
        currentPrice: socketEvent.currentPrice,
        viewerCount: socketEvent.viewerCount,
        bids: socketEvent.bids,
      ));
      return;
    }

    if (socketEvent is LiveAuctionNewBidEvent) {
      emit(state.copyWith(
        status: LiveAuctionStatus.live,
        currentPrice: socketEvent.currentPrice,
        bids: [socketEvent.bid, ...state.bids],
        isPlacingBid: false,
      ));
      return;
    }

    if (socketEvent is LiveAuctionViewerCountEvent) {
      emit(state.copyWith(viewerCount: socketEvent.count));
      return;
    }

    if (socketEvent is LiveAuctionEndingSoonEvent) {
      emit(state.copyWith(
        status: LiveAuctionStatus.endingSoon,
        endingInSeconds: socketEvent.secondsLeft,
      ));
      return;
    }

    if (socketEvent is LiveAuctionEndedEvent) {
      emit(state.copyWith(
        status: LiveAuctionStatus.ended,
        winningBid: socketEvent.winningBid,
      ));
      return;
    }
    // LiveAuctionUnknownEvent → diabaikan.
  }

  void _onConnectionStatusChanged(
    LiveAuctionConnectionStatusChanged event,
    Emitter<LiveAuctionState> emit,
  ) {
    emit(state.copyWith(connectionStatus: event.status));
  }

  Future<void> _onStopped(
    LiveAuctionStopped event,
    Emitter<LiveAuctionState> emit,
  ) async {
    await _socketDataSource.disconnect();
  }

  @override
  Future<void> close() async {
    await _eventsSub?.cancel();
    await _statusSub?.cancel();
    await _socketDataSource.disconnect();
    return super.close();
  }
}
