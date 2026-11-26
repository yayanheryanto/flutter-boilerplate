part of 'live_auction_bloc.dart';

abstract class LiveAuctionEvent extends Equatable {
  const LiveAuctionEvent();

  @override
  List<Object?> get props => [];
}

/// Mulai konek ke room lelang untuk [lot] tertentu. Dispatch sekali saat
/// halaman dibuka.
class LiveAuctionStarted extends LiveAuctionEvent {
  final int lot;

  const LiveAuctionStarted({required this.lot});

  @override
  List<Object?> get props => [lot];
}

/// User menekan tombol tawar.
class LiveAuctionBidPlaced extends LiveAuctionEvent {
  final int amount;

  const LiveAuctionBidPlaced({required this.amount});

  @override
  List<Object?> get props => [amount];
}

/// Internal — dipicu tiap kali ada pesan baru dari socket.
class LiveAuctionSocketEventReceived extends LiveAuctionEvent {
  final LiveAuctionSocketEvent event;

  const LiveAuctionSocketEventReceived(this.event);

  @override
  List<Object?> get props => [event];
}

/// Internal — dipicu tiap kali status koneksi socket berubah.
class LiveAuctionConnectionStatusChanged extends LiveAuctionEvent {
  final SocketConnectionStatus status;

  const LiveAuctionConnectionStatusChanged(this.status);

  @override
  List<Object?> get props => [status];
}

/// Dispatch saat halaman ditutup, memutus koneksi socket.
class LiveAuctionStopped extends LiveAuctionEvent {
  const LiveAuctionStopped();
}
