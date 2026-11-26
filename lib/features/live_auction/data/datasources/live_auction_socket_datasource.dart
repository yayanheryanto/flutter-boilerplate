import 'package:injectable/injectable.dart';

import 'package:emas/core/services/socket/app_socket_service.dart';
import 'package:emas/features/live_auction/domain/entities/live_auction_event.dart';
import 'package:emas/features/live_auction/data/models/live_auction_event_mapper.dart';

abstract class LiveAuctionSocketDataSource {
  Stream<LiveAuctionSocketEvent> get events;

  Stream<SocketConnectionStatus> get connectionStatus;

  Future<void> connect(int lot);

  void placeBid(int amount);

  Future<void> disconnect();
}

@Injectable(as: LiveAuctionSocketDataSource)
class LiveAuctionSocketDataSourceImpl implements LiveAuctionSocketDataSource {
  final AppSocketService _socket;

  LiveAuctionSocketDataSourceImpl(this._socket);

  @override
  Stream<LiveAuctionSocketEvent> get events => _socket.messages.map(LiveAuctionEventMapper.fromJson);

  @override
  Stream<SocketConnectionStatus> get connectionStatus => _socket.connectionStatus;

  @override
  Future<void> connect(int lot) => _socket.connect('live-auction:$lot');

  @override
  void placeBid(int amount) => _socket.send({'type': 'place_bid', 'amount': amount});

  @override
  Future<void> disconnect() => _socket.disconnect();
}
