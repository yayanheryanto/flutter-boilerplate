import 'package:equatable/equatable.dart';

// Entity domain untuk lelang live. Parsing JSON dari socket ada di
// `data/models/live_auction_event_mapper.dart` — domain tidak tahu format wire.

// ─── Bidder type ──────────────────────────────────────────────────────────────

enum BidderType { floorBidder, onlineBidder, yourBid }

extension BidderTypeX on BidderType {
  String get label {
    switch (this) {
      case BidderType.floorBidder:
        return 'Floor Bidder';
      case BidderType.onlineBidder:
        return 'Online Bidder';
      case BidderType.yourBid:
        return 'Your Bid';
    }
  }
}

// ─── Bid entry ────────────────────────────────────────────────────────────────

class BidEntry extends Equatable {
  final String id;
  final int amount;
  final BidderType type;
  final String bidderName;
  final DateTime timestamp;

  const BidEntry({
    required this.id,
    required this.amount,
    required this.type,
    required this.bidderName,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, amount, type, bidderName, timestamp];
}

// ─── Status lelang (derived, dipakai di UI) ───────────────────────────────────

enum LiveAuctionStatus { connecting, live, endingSoon, ended, disconnected, error }

// ─── Socket events (server → client) ─────────────────────────────────────────

abstract class LiveAuctionSocketEvent extends Equatable {
  const LiveAuctionSocketEvent();

  @override
  List<Object?> get props => [];
}

/// Snapshot state penuh, dikirim sekali begitu client baru connect.
class LiveAuctionSnapshotEvent extends LiveAuctionSocketEvent {
  final int lot;
  final int basePrice;
  final int currentPrice;
  final int viewerCount;
  final List<BidEntry> bids;

  const LiveAuctionSnapshotEvent({
    required this.lot,
    required this.basePrice,
    required this.currentPrice,
    required this.viewerCount,
    required this.bids,
  });

  @override
  List<Object?> get props => [lot, basePrice, currentPrice, viewerCount, bids];
}

/// Ada bid baru masuk (dari bidder lain, atau echo dari bid milik sendiri).
class LiveAuctionNewBidEvent extends LiveAuctionSocketEvent {
  final BidEntry bid;
  final int currentPrice;

  const LiveAuctionNewBidEvent({required this.bid, required this.currentPrice});

  @override
  List<Object?> get props => [bid, currentPrice];
}

/// Update jumlah penonton yang sedang menyaksikan lelang.
class LiveAuctionViewerCountEvent extends LiveAuctionSocketEvent {
  final int count;

  const LiveAuctionViewerCountEvent({required this.count});

  @override
  List<Object?> get props => [count];
}

/// Lelang akan segera berakhir.
class LiveAuctionEndingSoonEvent extends LiveAuctionSocketEvent {
  final int secondsLeft;

  const LiveAuctionEndingSoonEvent({required this.secondsLeft});

  @override
  List<Object?> get props => [secondsLeft];
}

/// Lelang berakhir, berisi bid pemenang (bisa null kalau tidak ada bid sama sekali).
class LiveAuctionEndedEvent extends LiveAuctionSocketEvent {
  final BidEntry? winningBid;

  const LiveAuctionEndedEvent({this.winningBid});

  @override
  List<Object?> get props => [winningBid];
}

/// Fallback untuk tipe pesan yang tidak dikenali — diabaikan bloc.
class LiveAuctionUnknownEvent extends LiveAuctionSocketEvent {
  const LiveAuctionUnknownEvent();
}
