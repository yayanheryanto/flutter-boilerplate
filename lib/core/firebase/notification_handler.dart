import 'package:boilerplate/core/firebase/notification_bloc.dart';
import 'package:boilerplate/core/firebase/notification_service.dart';
import 'package:boilerplate/core/ui/design_system/molecules/toast/app_toast.dart';
import 'package:boilerplate/core/utils/app_logger.dart';
import 'package:boilerplate/core/utils/navigator_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ─── NotificationListener Mixin ───────────────────────────────────────────────

/// Mixin untuk State yang ingin handle notifikasi secara manual.
///
/// ```dart
/// class _HomePageState extends State<HomePage>
///     with NotificationHandlerMixin<HomePage> {
///
///   @override
///   void onNotificationTapped(AppNotificationPayload payload) {
///     // Handle navigasi berdasarkan type/route dari payload
///     if (payload.type == 'order') {
///       context.push('/orders/${payload.entityId}');
///     }
///   }
///
///   @override
///   void onForegroundNotification(AppNotificationPayload payload) {
///     AppToast.info(payload.title ?? 'Notifikasi baru');
///   }
/// }
/// ```
mixin NotificationHandlerMixin<T extends StatefulWidget> on State<T> {
  /// Override untuk handle saat notifikasi di-tap.
  void onNotificationTapped(AppNotificationPayload payload) {}

  /// Override untuk handle notifikasi masuk saat foreground.
  void onForegroundNotification(AppNotificationPayload payload) {
    // Default: tampilkan toast
    AppToast.info(payload.title ?? 'Notifikasi baru');
  }
}

// ─── AppNotificationWrapper ───────────────────────────────────────────────────

/// Widget yang mendengarkan [NotificationBloc] dan menampilkan in-app toast
/// secara otomatis saat notifikasi masuk di foreground.
///
/// Wrap widget tree utama (biasanya di root page atau shell) dengan ini.
///
/// ```dart
/// // Di AppScaffold / shell route:
/// AppNotificationWrapper(
///   onNotificationTapped: (payload) {
///     // Navigasi dari tap notifikasi
///     if (payload.route != null) {
///       context.push(payload.route!);
///     }
///   },
///   child: child,
/// )
/// ```
class AppNotificationWrapper extends StatelessWidget {
  final Widget child;

  /// Dipanggil saat user tap notifikasi dari mana saja.
  final void Function(AppNotificationPayload payload)? onNotificationTapped;

  /// Override default foreground behavior (tampilkan toast).
  final void Function(AppNotificationPayload payload)? onForegroundNotification;

  const AppNotificationWrapper({
    super.key,
    required this.child,
    this.onNotificationTapped,
    this.onForegroundNotification,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Listen tap notifikasi
        BlocListener<NotificationBloc, NotificationState>(
          listenWhen: (prev, curr) => curr.lastTapped != prev.lastTapped && curr.lastTapped != null,
          listener: (context, state) {
            final payload = state.lastTapped!;
            AppLogger.d('AppNotificationWrapper: tap received: $payload', tag: 'NotifWrapper');

            if (onNotificationTapped != null) {
              onNotificationTapped!(payload);
            } else {
              _defaultNavigate(payload);
            }
          },
        ),

        // Listen foreground messages
        BlocListener<NotificationBloc, NotificationState>(
          listenWhen: (prev, curr) =>
          curr.notifications.length > prev.notifications.length,
          listener: (context, state) {
            if (state.notifications.isEmpty) return;
            final payload = state.notifications.first;

            if (onForegroundNotification != null) {
              onForegroundNotification!(payload);
            } else {
              _defaultForegroundToast(payload);
            }
          },
        ),
      ],
      child: child,
    );
  }

  void _defaultNavigate(AppNotificationPayload payload) async{
    final route = payload.route;
    if (route == null) return;
    await AppNavigator.push<void>(route, extra: payload.entityId);
  }

  void _defaultForegroundToast(AppNotificationPayload payload) {
    AppToast.show(
      payload.title ?? 'Notifikasi baru',
      duration: const Duration(seconds: 4),
    );
  }
}

// ─── NotificationBadge ────────────────────────────────────────────────────────

/// Widget badge yang otomatis menampilkan jumlah notifikasi belum dibaca
/// dari [NotificationBloc].
///
/// ```dart
/// NotificationBadge(
///   child: Icon(Icons.notifications_outlined),
///   onTap: () => context.push('/notifications'),
/// )
/// ```
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? badgeColor;
  final Color? textColor;

  const NotificationBadge({
    super.key,
    required this.child,
    this.onTap,
    this.badgeColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      buildWhen: (prev, curr) => prev.unreadCount != curr.unreadCount,
      builder: (context, state) {
        return GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              child,
              if (state.unreadCount > 0)
                Positioned(
                  top: -4,
                  right: -4,
                  child: _BadgeCount(
                    count: state.unreadCount,
                    badgeColor: badgeColor ?? Theme.of(context).colorScheme.error,
                    textColor: textColor ?? Theme.of(context).colorScheme.onError,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BadgeCount extends StatelessWidget {
  final int count;
  final Color badgeColor;
  final Color textColor;

  const _BadgeCount({
    required this.count,
    required this.badgeColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final label = count > 99 ? '99+' : '$count';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: badgeColor.withOpacity(0.4), blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
