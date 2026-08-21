import 'package:equatable/equatable.dart';

// ─── Bidder type ──────────────────────────────────────────────────────────────

enum BidderType { floorBidder, onlineBidder, yourBid }

extension BidderTypeX on BidderType {
  static BidderType fromJson(String? value) {
    switch (value) {
      case 'floor_bidder':
        return BidderType.floorBidder;
      case 'your_bid':
        return BidderType.yourBid;
      case 'online_bidder':
      default:
        return BidderType.onlineBidder;
    }
  }

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

  factory BidEntry.fromJson(Map<String, dynamic> json) {
    return BidEntry(
      id: json['id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toInt() ?? 0,
      type: BidderTypeX.fromJson(json['bidderType'] as String?),
      bidderName: json['bidderName'] as String? ?? '-',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, amount, type, bidderName, timestamp];
}

// ─── Status lelang (derived, dipakai di UI) ───────────────────────────────────

enum LiveAuctionStatus { connecting, live, endingSoon, ended, disconnected, error }

// ─── Socket events (server → client) ─────────────────────────────────────────

abstract class LiveAuctionSocketEvent extends Equatable {
  const LiveAuctionSocketEvent();

  /// Parse pesan mentah dari [-AppSocketService-] menjadi event bertipe.
  factory LiveAuctionSocketEvent.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String?) {
      case 'snapshot':
        return LiveAuctionSnapshotEvent.fromJson(json);
      case 'new_bid':
        return LiveAuctionNewBidEvent.fromJson(json);
      case 'viewer_count':
        return LiveAuctionViewerCountEvent.fromJson(json);
      case 'ending_soon':
        return LiveAuctionEndingSoonEvent.fromJson(json);
      case 'auction_ended':
        return LiveAuctionEndedEvent.fromJson(json);
      default:
        return const LiveAuctionUnknownEvent();
    }
  }

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

  factory LiveAuctionSnapshotEvent.fromJson(Map<String, dynamic> json) {
    final rawBids = (json['bids'] as List?) ?? const [];
    return LiveAuctionSnapshotEvent(
      lot: (json['lot'] as num?)?.toInt() ?? 0,
      basePrice: (json['basePrice'] as num?)?.toInt() ?? 0,
      currentPrice: (json['currentPrice'] as num?)?.toInt() ?? 0,
      viewerCount: (json['viewerCount'] as num?)?.toInt() ?? 0,
      bids: rawBids.map((e) => BidEntry.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  List<Object?> get props => [lot, basePrice, currentPrice, viewerCount, bids];
}

/// Ada bid baru masuk (dari bidder lain, atau echo dari bid milik sendiri).
class LiveAuctionNewBidEvent extends LiveAuctionSocketEvent {
  final BidEntry bid;
  final int currentPrice;

  const LiveAuctionNewBidEvent({required this.bid, required this.currentPrice});

  factory LiveAuctionNewBidEvent.fromJson(Map<String, dynamic> json) {
    return LiveAuctionNewBidEvent(
      bid: BidEntry.fromJson(json['bid'] as Map<String, dynamic>),
      currentPrice: (json['currentPrice'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [bid, currentPrice];
}

/// Update jumlah penonton yang sedang menyaksikan lelang.
class LiveAuctionViewerCountEvent extends LiveAuctionSocketEvent {
  final int count;

  const LiveAuctionViewerCountEvent({required this.count});

  factory LiveAuctionViewerCountEvent.fromJson(Map<String, dynamic> json) {
    return LiveAuctionViewerCountEvent(count: (json['count'] as num?)?.toInt() ?? 0);
  }

  @override
  List<Object?> get props => [count];
}

/// Lelang akan segera berakhir.
class LiveAuctionEndingSoonEvent extends LiveAuctionSocketEvent {
  final int secondsLeft;

  const LiveAuctionEndingSoonEvent({required this.secondsLeft});

  factory LiveAuctionEndingSoonEvent.fromJson(Map<String, dynamic> json) {
    return LiveAuctionEndingSoonEvent(secondsLeft: (json['secondsLeft'] as num?)?.toInt() ?? 0);
  }

  @override
  List<Object?> get props => [secondsLeft];
}

/// Lelang berakhir, berisi bid pemenang (bisa null kalau tidak ada bid sama sekali).
class LiveAuctionEndedEvent extends LiveAuctionSocketEvent {
  final BidEntry? winningBid;

  const LiveAuctionEndedEvent({this.winningBid});

  factory LiveAuctionEndedEvent.fromJson(Map<String, dynamic> json) {
    final raw = json['winningBid'] as Map<String, dynamic>?;
    return LiveAuctionEndedEvent(winningBid: raw != null ? BidEntry.fromJson(raw) : null);
  }

  @override
  List<Object?> get props => [winningBid];
}

/// Fallback untuk tipe pesan yang tidak dikenali — diabaikan bloc.
class LiveAuctionUnknownEvent extends LiveAuctionSocketEvent {
  const LiveAuctionUnknownEvent();
}
