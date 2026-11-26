import 'package:emas/features/live_auction/domain/entities/live_auction_event.dart';

/// Mengubah pesan mentah socket (Map hasil decode JSON) menjadi entity domain.
class LiveAuctionEventMapper {
  const LiveAuctionEventMapper._();

  static LiveAuctionSocketEvent fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String?) {
      case 'snapshot':
        final rawBids = (json['bids'] as List?) ?? const [];
        return LiveAuctionSnapshotEvent(
          lot: _int(json['lot']),
          basePrice: _int(json['basePrice']),
          currentPrice: _int(json['currentPrice']),
          viewerCount: _int(json['viewerCount']),
          bids: rawBids.map((e) => bidFromJson(e as Map<String, dynamic>)).toList(),
        );
      case 'new_bid':
        return LiveAuctionNewBidEvent(
          bid: bidFromJson(json['bid'] as Map<String, dynamic>),
          currentPrice: _int(json['currentPrice']),
        );
      case 'viewer_count':
        return LiveAuctionViewerCountEvent(count: _int(json['count']));
      case 'ending_soon':
        return LiveAuctionEndingSoonEvent(secondsLeft: _int(json['secondsLeft']));
      case 'auction_ended':
        final raw = json['winningBid'] as Map<String, dynamic>?;
        return LiveAuctionEndedEvent(winningBid: raw != null ? bidFromJson(raw) : null);
      default:
        return const LiveAuctionUnknownEvent();
    }
  }

  static BidEntry bidFromJson(Map<String, dynamic> json) {
    return BidEntry(
      id: json['id'] as String? ?? '',
      amount: _int(json['amount']),
      type: bidderTypeFromJson(json['bidderType'] as String?),
      bidderName: json['bidderName'] as String? ?? '-',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
    );
  }

  static BidderType bidderTypeFromJson(String? value) {
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

  static int _int(Object? value) => (value as num?)?.toInt() ?? 0;
}
