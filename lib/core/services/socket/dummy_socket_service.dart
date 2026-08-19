import 'dart:async';
import 'dart:math';

import 'package:injectable/injectable.dart';

import 'package:emas/core/services/socket/app_socket_service.dart';

/// Implementasi dummy dari [AppSocketService].
///
/// Tidak ada koneksi jaringan sungguhan — semua event di-generate secara
/// lokal dengan [Timer], meniru perilaku server WebSocket asli (delay
/// connect, status connecting/connected/reconnecting, dan push message
/// berkala). Berguna untuk development UI sebelum backend real-time siap.
///
/// Ganti binding `@LazySingleton(as: AppSocketService)` ke implementasi lain
/// (mis. `RealWebSocketService`) begitu backend sudah tersedia — kode yang
/// memakai [AppSocketService] tidak perlu berubah sama sekali.
@LazySingleton(as: AppSocketService)
class DummySocketService implements AppSocketService {
  final _statusController = StreamController<SocketConnectionStatus>.broadcast();
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  SocketConnectionStatus _status = SocketConnectionStatus.disconnected;

  _RoomSimulator? _room;
  String? _channel;

  @override
  SocketConnectionStatus get status => _status;

  @override
  Stream<SocketConnectionStatus> get connectionStatus => _statusController.stream;

  @override
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  @override
  Future<void> connect(String channel) async {
    _channel = channel;
    _setStatus(SocketConnectionStatus.connecting);

    // Simulasi latency handshake koneksi.
    await Future<void>.delayed(Duration(milliseconds: 500 + Random().nextInt(600)));

    _setStatus(SocketConnectionStatus.connected);

    _room?.stop();
    _room = _createRoomSimulator(channel)?..start();
  }

  @override
  void send(Map<String, dynamic> payload) {
    if (_status != SocketConnectionStatus.connected) return;
    _room?.handleClientMessage(payload);
  }

  @override
  Future<void> disconnect() async {
    _room?.stop();
    _room = null;
    _channel = null;
    _setStatus(SocketConnectionStatus.disconnected);
  }

  void _setStatus(SocketConnectionStatus status) {
    _status = status;
    if (!_statusController.isClosed) _statusController.add(status);
  }

  _RoomSimulator? _createRoomSimulator(String channel) {
    if (channel.startsWith('live-auction:')) {
      final lot = int.tryParse(channel.split(':').last) ?? 0;
      return _LiveAuctionRoomSimulator(
        lot: lot,
        emit: (data) {
          if (!_messageController.isClosed) _messageController.add(data);
        },
      );
    }
    // Channel tidak dikenal — tidak ada simulasi apa pun.
    return null;
  }

  /// Bersihkan resource. Dipanggil saat app di-dispose (jarang perlu, karena
  /// service ini singleton berumur sepanjang hidup aplikasi).
  void dispose() {
    _room?.stop();
    _statusController.close();
    _messageController.close();
  }
}

/// Kontrak internal simulator per-jenis room.
abstract class _RoomSimulator {
  void start();
  void handleClientMessage(Map<String, dynamic> payload);
  void stop();
}

/// Simulator perilaku server untuk room `live-auction:<lot>`.
///
/// Meniru pola bidding lelang langsung:
/// - Kirim `snapshot` begitu client baru connect.
/// - Bidder lain (floor/online) menawar secara berkala dengan kenaikan acak.
/// - Saat client mengirim `place_bid`, langsung di-broadcast sebagai
///   `your_bid`, lalu ada peluang bidder lain "menyalip" beberapa detik
///   kemudian — supaya terasa kompetitif.
/// - Jumlah penonton (`viewer_count`) berfluktuasi kecil secara berkala.
/// - Setelah durasi tertentu, lelang masuk fase `ending_soon` lalu berakhir
///   dengan `auction_ended`.
class _LiveAuctionRoomSimulator implements _RoomSimulator {
  _LiveAuctionRoomSimulator({required this.lot, required this.emit});

  final int lot;
  final void Function(Map<String, dynamic> data) emit;

  final Random _rng = Random();
  final List<Map<String, dynamic>> _bids = [];

  static const int _basePrice = 106000000;
  static const List<String> _bidderNames = [
    'AS.',
    'BP.',
    'CW.',
    'DK.',
    'ER.',
    'FH.',
  ];

  int _currentPrice = _basePrice;
  int _viewerCount = 30;
  int _idCounter = 0;
  bool _ended = false;

  Timer? _bidTimer;
  Timer? _viewerTimer;
  Timer? _endTimer;

  @override
  void start() {
    // Seed 1 bid awal supaya tabel penawaran tidak kosong saat pertama masuk.
    final seedBid = _makeBid(
      amount: _currentPrice,
      type: 'online_bidder',
      bidderName: _randomName(),
    );
    _bids.add(seedBid);

    emit({
      'type': 'snapshot',
      'lot': lot,
      'basePrice': _basePrice,
      'currentPrice': _currentPrice,
      'viewerCount': _viewerCount,
      'bids': _bids.reversed.toList(),
    });

    _scheduleNextBid();
    _scheduleViewerTick();

    // Total durasi simulasi lelang per koneksi: ~2 menit.
    _endTimer = Timer(const Duration(seconds: 90), () {
      emit({'type': 'ending_soon', 'secondsLeft': 15});
      Timer(const Duration(seconds: 15), _endAuction);
    });
  }

  @override
  void handleClientMessage(Map<String, dynamic> payload) {
    if (_ended) return;
    if (payload['type'] != 'place_bid') return;

    final amount = (payload['amount'] as num?)?.toInt() ?? (_currentPrice + 500000);
    _currentPrice = amount;

    final bid = _makeBid(amount: amount, type: 'your_bid', bidderName: 'Anda');
    _bids.add(bid);
    emit({'type': 'new_bid', 'bid': bid, 'currentPrice': _currentPrice});

    // 70% kemungkinan ada bidder lain yang menyalip beberapa detik kemudian.
    if (_rng.nextDouble() < 0.7) {
      Timer(Duration(seconds: 2 + _rng.nextInt(4)), () {
        if (_ended) return;
        _pushRivalBid();
      });
    }
  }

  @override
  void stop() {
    _bidTimer?.cancel();
    _viewerTimer?.cancel();
    _endTimer?.cancel();
  }

  void _scheduleNextBid() {
    _bidTimer = Timer(Duration(seconds: 4 + _rng.nextInt(5)), () {
      if (_ended) return;
      _pushRivalBid();
      _scheduleNextBid();
    });
  }

  void _scheduleViewerTick() {
    _viewerTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_ended) return;
      _viewerCount = (_viewerCount + _rng.nextInt(5) - 2).clamp(12, 120);
      emit({'type': 'viewer_count', 'count': _viewerCount});
    });
  }

  void _pushRivalBid() {
    final increment = (1 + _rng.nextInt(4)) * 250000; // kelipatan 250rb
    _currentPrice += increment;

    final type = _rng.nextBool() ? 'online_bidder' : 'floor_bidder';
    final bid = _makeBid(amount: _currentPrice, type: type, bidderName: _randomName());
    _bids.add(bid);

    emit({'type': 'new_bid', 'bid': bid, 'currentPrice': _currentPrice});
  }

  void _endAuction() {
    if (_ended) return;
    _ended = true;
    stop();
    emit({
      'type': 'auction_ended',
      'winningBid': _bids.isNotEmpty ? _bids.last : null,
    });
  }

  Map<String, dynamic> _makeBid({
    required int amount,
    required String type,
    required String bidderName,
  }) {
    _idCounter += 1;
    return {
      'id': 'bid-$lot-$_idCounter',
      'amount': amount,
      'bidderType': type,
      'bidderName': bidderName,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  String _randomName() => _bidderNames[_rng.nextInt(_bidderNames.length)];
}
