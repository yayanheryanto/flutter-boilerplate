import 'package:injectable/injectable.dart';

import 'package:emas/core/services/socket/app_socket_service.dart';
import 'package:emas/features/live_auction/data/datasources/live_auction_socket_datasource.dart';
import 'package:emas/features/live_auction/domain/entities/live_auction_event.dart';
import 'package:emas/features/live_auction/domain/repositories/live_auction_repository.dart';

@Injectable(as: LiveAuctionRepository)
class LiveAuctionRepositoryImpl implements LiveAuctionRepository {
  final LiveAuctionSocketDataSource _dataSource;

  LiveAuctionRepositoryImpl(this._dataSource);

  @override
  Stream<LiveAuctionSocketEvent> get events => _dataSource.events;

  @override
  Stream<SocketConnectionStatus> get connectionStatus => _dataSource.connectionStatus;

  @override
  Future<void> connect(int lot) => _dataSource.connect(lot);

  @override
  void placeBid(int amount) => _dataSource.placeBid(amount);

  @override
  Future<void> disconnect() => _dataSource.disconnect();
}
