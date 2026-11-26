import 'package:emas/core/services/socket/app_socket_service.dart';
import 'package:emas/features/live_auction/domain/entities/live_auction_event.dart';

/// Kontrak domain untuk sesi lelang live (real-time).
abstract class LiveAuctionRepository {
  /// Event dari server untuk room yang sedang terhubung.
  Stream<LiveAuctionSocketEvent> get events;

  /// Perubahan status koneksi ke room.
  Stream<SocketConnectionStatus> get connectionStatus;

  /// Bergabung ke room lelang untuk [lot].
  Future<void> connect(int lot);

  /// Mengirim penawaran sebesar [amount].
  void placeBid(int amount);

  /// Keluar dari room.
  Future<void> disconnect();
}
