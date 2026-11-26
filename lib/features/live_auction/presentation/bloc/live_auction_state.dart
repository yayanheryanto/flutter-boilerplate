part of 'live_auction_bloc.dart';

class LiveAuctionState extends Equatable {
  final int lot;
  final LiveAuctionStatus status;
  final SocketConnectionStatus connectionStatus;
  final int basePrice;
  final int currentPrice;
  final List<BidEntry> bids;
  final int viewerCount;
  final int? endingInSeconds;
  final BidEntry? winningBid;
  final bool isPlacingBid;
  final String? errorMessage;

  const LiveAuctionState({
    required this.lot,
    this.status = LiveAuctionStatus.connecting,
    this.connectionStatus = SocketConnectionStatus.disconnected,
    this.basePrice = 0,
    this.currentPrice = 0,
    this.bids = const [],
    this.viewerCount = 0,
    this.endingInSeconds,
    this.winningBid,
    this.isPlacingBid = false,
    this.errorMessage,
  });

  const LiveAuctionState.initial({required this.lot})
      : status = LiveAuctionStatus.connecting,
        connectionStatus = SocketConnectionStatus.disconnected,
        basePrice = 0,
        currentPrice = 0,
        bids = const [],
        viewerCount = 0,
        endingInSeconds = null,
        winningBid = null,
        isPlacingBid = false,
        errorMessage = null;

  /// Kenaikan tawaran minimum berikutnya — dipakai tombol "Tawar".
  int get nextBidAmount => currentPrice + 250000;

  bool get isLive => status == LiveAuctionStatus.live || status == LiveAuctionStatus.endingSoon;

  LiveAuctionState copyWith({
    LiveAuctionStatus? status,
    SocketConnectionStatus? connectionStatus,
    int? basePrice,
    int? currentPrice,
    List<BidEntry>? bids,
    int? viewerCount,
    int? endingInSeconds,
    BidEntry? winningBid,
    bool? isPlacingBid,
    String? errorMessage,
  }) {
    return LiveAuctionState(
      lot: lot,
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      basePrice: basePrice ?? this.basePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      bids: bids ?? this.bids,
      viewerCount: viewerCount ?? this.viewerCount,
      endingInSeconds: endingInSeconds ?? this.endingInSeconds,
      winningBid: winningBid ?? this.winningBid,
      isPlacingBid: isPlacingBid ?? false,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        lot,
        status,
        connectionStatus,
        basePrice,
        currentPrice,
        bids,
        viewerCount,
        endingInSeconds,
        winningBid,
        isPlacingBid,
        errorMessage,
      ];
}
