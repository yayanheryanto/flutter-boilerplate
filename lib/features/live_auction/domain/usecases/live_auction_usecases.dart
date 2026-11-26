import 'package:injectable/injectable.dart';

import 'package:emas/core/services/socket/app_socket_service.dart';
import 'package:emas/features/live_auction/domain/entities/live_auction_event.dart';
import 'package:emas/features/live_auction/domain/repositories/live_auction_repository.dart';

// Use case sesi lelang live. Sengaja tidak memakai `UseCase<Either<..>>`
// karena alirannya berbasis stream/real-time, bukan request–response.

@injectable
class WatchLiveAuctionEventsUseCase {
  final LiveAuctionRepository _repository;

  WatchLiveAuctionEventsUseCase(this._repository);

  Stream<LiveAuctionSocketEvent> call() => _repository.events;
}

@injectable
class WatchLiveAuctionConnectionUseCase {
  final LiveAuctionRepository _repository;

  WatchLiveAuctionConnectionUseCase(this._repository);

  Stream<SocketConnectionStatus> call() => _repository.connectionStatus;
}

@injectable
class JoinLiveAuctionUseCase {
  final LiveAuctionRepository _repository;

  JoinLiveAuctionUseCase(this._repository);

  Future<void> call(int lot) => _repository.connect(lot);
}

@injectable
class PlaceLiveBidUseCase {
  final LiveAuctionRepository _repository;

  PlaceLiveBidUseCase(this._repository);

  void call(int amount) => _repository.placeBid(amount);
}

@injectable
class LeaveLiveAuctionUseCase {
  final LiveAuctionRepository _repository;

  LeaveLiveAuctionUseCase(this._repository);

  Future<void> call() => _repository.disconnect();
}
