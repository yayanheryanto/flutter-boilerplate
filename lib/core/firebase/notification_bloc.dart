import 'dart:async';

import 'package:boilerplate/core/firebase/notification_service.dart';
import 'package:boilerplate/core/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// ─── Events ───────────────────────────────────────────────────────────────────

sealed class NotificationEvent {}

/// Dipanggil saat app init untuk mulai listen stream notifikasi.
class NotificationStartListening extends NotificationEvent {}

/// Notifikasi baru masuk saat foreground.
class NotificationReceived extends NotificationEvent {
  final AppNotificationPayload payload;

  NotificationReceived(this.payload);
}

/// User tap notifikasi (dari mana saja: foreground, background, terminated).
class NotificationTapped extends NotificationEvent {
  final AppNotificationPayload payload;

  NotificationTapped(this.payload);
}

/// Hapus semua notifikasi yang sudah ditampilkan.
class NotificationClearAll extends NotificationEvent {}

/// Tandai notifikasi sebagai sudah dibaca.
class NotificationMarkRead extends NotificationEvent {
  final String? entityId;

  NotificationMarkRead(this.entityId);
}

// ─── State ────────────────────────────────────────────────────────────────────

class NotificationState {
  /// Daftar notifikasi yang masuk selama app terbuka (in-memory only).
  final List<AppNotificationPayload> notifications;

  /// Jumlah notifikasi yang belum dibaca.
  final int unreadCount;

  /// Payload yang terakhir di-tap — digunakan untuk trigger navigasi di UI.
  final AppNotificationPayload? lastTapped;

  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.lastTapped,
  });

  NotificationState copyWith({
    List<AppNotificationPayload>? notifications,
    int? unreadCount,
    AppNotificationPayload? lastTapped,
    bool clearLastTapped = false,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      lastTapped: clearLastTapped ? null : (lastTapped ?? this.lastTapped),
    );
  }

  bool get hasUnread => unreadCount > 0;
}

// ─── BLoC ─────────────────────────────────────────────────────────────────────

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  StreamSubscription<AppNotificationPayload>? _foregroundSub;
  StreamSubscription<AppNotificationPayload>? _tapSub;

  NotificationBloc(this._notificationService) : super(const NotificationState()) {
    on<NotificationStartListening>(_onStartListening);
    on<NotificationReceived>(_onReceived);
    on<NotificationTapped>(_onTapped);
    on<NotificationClearAll>(_onClearAll);
    on<NotificationMarkRead>(_onMarkRead);
  }

  // ── Handlers ─────────────────────────────────────────────────────────────────

  Future<void> _onStartListening(
    NotificationStartListening event,
    Emitter<NotificationState> emit,
  ) async {
    // Cancel existing subscriptions sebelum buat yang baru
    await _foregroundSub?.cancel();
    await _tapSub?.cancel();

    // Listen notifikasi masuk saat foreground
    _foregroundSub = _notificationService.onForegroundMessage.listen((payload) {
      AppLogger.d('NotificationBloc: foreground received: $payload', tag: 'NotifBloc');
      add(NotificationReceived(payload));
    });

    // Listen tap notifikasi dari mana saja
    _tapSub = _notificationService.onNotificationTap.listen((payload) {
      AppLogger.d('NotificationBloc: notification tapped: $payload', tag: 'NotifBloc');
      add(NotificationTapped(payload));
    });

    AppLogger.i('NotificationBloc: listening started', tag: 'NotifBloc');
  }

  void _onReceived(
    NotificationReceived event,
    Emitter<NotificationState> emit,
  ) {
    final updated = [event.payload, ...state.notifications];
    emit(
      state.copyWith(
        notifications: updated,
        unreadCount: state.unreadCount + 1,
      ),
    );
  }

  void _onTapped(
    NotificationTapped event,
    Emitter<NotificationState> emit,
  ) {
    emit(state.copyWith(lastTapped: event.payload));
  }

  void _onClearAll(
    NotificationClearAll event,
    Emitter<NotificationState> emit,
  ) {
    emit(
      state.copyWith(
        notifications: [],
        unreadCount: 0,
        clearLastTapped: true,
      ),
    );
  }

  void _onMarkRead(
    NotificationMarkRead event,
    Emitter<NotificationState> emit,
  ) {
    if (state.unreadCount > 0) {
      emit(state.copyWith(unreadCount: state.unreadCount - 1));
    }
  }

  @override
  Future<void> close() async {
    await _foregroundSub?.cancel();
    await _tapSub?.cancel();
    return super.close();
  }
}
