import 'dart:async';

import 'package:emas/core/firebase/notification_service.dart';
import 'package:emas/core/utils/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

// ─── Events ───────────────────────────────────────────────────────────────────

sealed class NotificationEvent {}

class NotificationStartListening extends NotificationEvent {}

class NotificationReceived extends NotificationEvent {
  final AppNotificationPayload payload;

  NotificationReceived(this.payload);
}

class NotificationTapped extends NotificationEvent {
  final AppNotificationPayload payload;

  NotificationTapped(this.payload);
}

class NotificationClearAll extends NotificationEvent {}

class NotificationMarkRead extends NotificationEvent {
  final String? entityId;

  NotificationMarkRead(this.entityId);
}

class NotificationState {
  final List<AppNotificationPayload> notifications;

  final int unreadCount;

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

  Future<void> _onStartListening(
    NotificationStartListening event,
    Emitter<NotificationState> emit,
  ) async {
    await _foregroundSub?.cancel();
    await _tapSub?.cancel();

    _foregroundSub = _notificationService.onForegroundMessage.listen((payload) {
      AppLogger.d('NotificationBloc: foreground received: $payload', tag: 'NotifBloc');
      add(NotificationReceived(payload));
    });

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
