import 'dart:async';
import 'dart:math';

import 'package:injectable/injectable.dart';

import 'package:emas/core/services/socket/app_socket_service.dart';

@LazySingleton(as: AppSocketService)
class DummySocketService implements AppSocketService {
  final _statusController = StreamController<SocketConnectionStatus>.broadcast();

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  SocketConnectionStatus _status = SocketConnectionStatus.disconnected;

  _RoomSimulator? _room;
  String? _channel;

  /// Digunakan untuk mencegah race condition ketika connect/disconnect
  /// dipanggil berdekatan.
  int _connectionGeneration = 0;

  bool _disposed = false;

  @override
  SocketConnectionStatus get status => _status;

  @override
  Stream<SocketConnectionStatus> get connectionStatus => _statusController.stream;

  @override
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  @override
  Future<void> connect(String channel) async {
    if (_disposed) return;

    final generation = ++_connectionGeneration;

    _channel = channel;

    _setStatus(SocketConnectionStatus.connecting);

    // Stop room sebelumnya jika ada.
    final oldRoom = _room;
    _room = null;

    if (oldRoom != null) {
      await oldRoom.stop();
    }

    // Simulasi latency handshake.
    await Future<void>.delayed(
      Duration(
        milliseconds: 500 + Random().nextInt(600),
      ),
    );

    // Cek apakah selama proses handshake sudah terjadi
    // disconnect/connect baru.
    if (_disposed || generation != _connectionGeneration) {
      return;
    }

    _setStatus(SocketConnectionStatus.connected);

    final room = _createRoomSimulator(channel);

    if (room == null) {
      return;
    }

    _room = room;
    room.start();
  }

  @override
  void send(Map<String, dynamic> payload) {
    if (_disposed) return;

    if (_status != SocketConnectionStatus.connected) {
      return;
    }

    _room?.handleClientMessage(payload);
  }

  @override
  Future<void> disconnect() async {
    if (_disposed) return;

    // Invalidasi connect() yang mungkin masih menunggu handshake.
    _connectionGeneration++;

    final room = _room;

    _room = null;
    _channel = null;

    if (room != null) {
      await room.stop();
    }

    if (_disposed) return;

    _setStatus(SocketConnectionStatus.disconnected);
  }

  void _setStatus(SocketConnectionStatus status) {
    if (_disposed || _statusController.isClosed) {
      return;
    }

    _status = status;
    _statusController.add(status);
  }

  _RoomSimulator? _createRoomSimulator(String channel) {
    if (channel.startsWith('live-auction:')) {
      final lot = int.tryParse(
            channel.split(':').last,
          ) ??
          0;

      return _LiveAuctionRoomSimulator(
        lot: lot,
        emit: (data) {
          if (_disposed || _messageController.isClosed) {
            return;
          }

          _messageController.add(data);
        },
      );
    }

    return null;
  }

  /// Bersihkan seluruh resource service.
  ///
  /// Karena dispose() tidak boleh async, Future dari stop()
  /// sengaja tidak di-await dan ditandai menggunakan unawaited().
  void dispose() {
    if (_disposed) return;

    _disposed = true;
    _connectionGeneration++;

    final room = _room;

    _room = null;
    _channel = null;

    if (room != null) {
      unawaited(room.stop());
    }

    unawaited(_statusController.close());
    unawaited(_messageController.close());
  }
}

/// Kontrak internal simulator per jenis room.
abstract class _RoomSimulator {
  void start();

  void handleClientMessage(
    Map<String, dynamic> payload,
  );

  Future<void> stop();
}

/// Simulator perilaku server untuk room live auction.
class _LiveAuctionRoomSimulator implements _RoomSimulator {
  _LiveAuctionRoomSimulator({
    required this.lot,
    required this.emit,
  });

  final int lot;

  final void Function(Map<String, dynamic> data) emit;

  final Random _rng = Random();

  final List<Map<String, dynamic>> _bids = [];

  /// Semua timer yang dibuat simulator disimpan di sini.
  final Set<Timer> _timers = {};

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
  bool _stopped = false;

  Timer? _bidTimer;
  Timer? _viewerTimer;
  Timer? _endTimer;

  @override
  void start() {
    if (_stopped) return;

    _ended = false;

    // Seed 1 bid awal agar tabel tidak kosong.
    final seedBid = _makeBid(
      amount: _currentPrice,
      type: 'online_bidder',
      bidderName: _randomName(),
    );

    _bids.add(seedBid);

    _emit({
      'type': 'snapshot',
      'lot': lot,
      'basePrice': _basePrice,
      'currentPrice': _currentPrice,
      'viewerCount': _viewerCount,
      'bids': _bids.reversed.toList(),
    });

    _scheduleNextBid();
    _scheduleViewerTick();

    // Total durasi simulasi:
    // 90 detik + 15 detik ending soon.
    _endTimer = Timer(
      const Duration(seconds: 90),
      () {
        if (_stopped || _ended) return;

        _emit({
          'type': 'ending_soon',
          'secondsLeft': 15,
        });

        _scheduleTimer(
          const Duration(seconds: 15),
          _endAuction,
        );
      },
    );

    _timers.add(_endTimer!);
  }

  @override
  void handleClientMessage(
    Map<String, dynamic> payload,
  ) {
    if (_stopped || _ended) {
      return;
    }

    if (payload['type'] != 'place_bid') {
      return;
    }

    final amount = (payload['amount'] as num?)?.toInt() ?? (_currentPrice + 500000);

    // Jangan menerima bid di bawah current price.
    if (amount <= _currentPrice) {
      return;
    }

    _currentPrice = amount;

    final bid = _makeBid(
      amount: amount,
      type: 'your_bid',
      bidderName: 'Anda',
    );

    _bids.add(bid);

    _emit({
      'type': 'new_bid',
      'bid': bid,
      'currentPrice': _currentPrice,
    });

    // 70% kemungkinan bidder lain menyalip.
    if (_rng.nextDouble() < 0.7) {
      _scheduleTimer(
        Duration(
          seconds: 2 + _rng.nextInt(4),
        ),
        () {
          if (_stopped || _ended) {
            return;
          }

          _pushRivalBid();
        },
      );
    }
  }

  @override
  Future<void> stop() async {
    if (_stopped) {
      return;
    }

    _stopped = true;

    _bidTimer?.cancel();
    _viewerTimer?.cancel();
    _endTimer?.cancel();

    _bidTimer = null;
    _viewerTimer = null;
    _endTimer = null;

    // Cancel semua timer tambahan,
    // termasuk timer rival bid dan ending auction.
    for (final timer in _timers) {
      timer.cancel();
    }

    _timers.clear();
  }

  void _scheduleNextBid() {
    if (_stopped || _ended) {
      return;
    }

    _bidTimer = Timer(
      Duration(
        seconds: 4 + _rng.nextInt(5),
      ),
      () {
        if (_stopped || _ended) {
          return;
        }

        _pushRivalBid();

        _scheduleNextBid();
      },
    );
  }

  void _scheduleViewerTick() {
    if (_stopped || _ended) {
      return;
    }

    _viewerTimer = Timer.periodic(
      const Duration(seconds: 6),
      (_) {
        if (_stopped || _ended) {
          return;
        }

        _viewerCount = (_viewerCount + _rng.nextInt(5) - 2).clamp(12, 120);

        _emit({
          'type': 'viewer_count',
          'count': _viewerCount,
        });
      },
    );
  }

  void _pushRivalBid() {
    if (_stopped || _ended) {
      return;
    }

    final increment = (1 + _rng.nextInt(4)) * 250000;

    _currentPrice += increment;

    final type = _rng.nextBool() ? 'online_bidder' : 'floor_bidder';

    final bid = _makeBid(
      amount: _currentPrice,
      type: type,
      bidderName: _randomName(),
    );

    _bids.add(bid);

    _emit({
      'type': 'new_bid',
      'bid': bid,
      'currentPrice': _currentPrice,
    });
  }

  void _endAuction() {
    if (_stopped || _ended) {
      return;
    }

    _ended = true;

    _emit({
      'type': 'auction_ended',
      'winningBid': _bids.isNotEmpty ? _bids.last : null,
    });

    unawaited(stop());
  }

  Map<String, dynamic> _makeBid({
    required int amount,
    required String type,
    required String bidderName,
  }) {
    _idCounter++;

    return {
      'id': 'bid-$lot-$_idCounter',
      'amount': amount,
      'bidderType': type,
      'bidderName': bidderName,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  String _randomName() {
    return _bidderNames[_rng.nextInt(_bidderNames.length)];
  }

  void _emit(Map<String, dynamic> data) {
    if (_stopped || _ended && data['type'] != 'auction_ended') {
      return;
    }

    emit(data);
  }

  void _scheduleTimer(
    Duration duration,
    void Function() callback,
  ) {
    if (_stopped || _ended) {
      return;
    }

    late final Timer timer;

    timer = Timer(
      duration,
      () {
        _timers.remove(timer);

        if (_stopped) {
          return;
        }

        callback();
      },
    );

    _timers.add(timer);
  }
}
