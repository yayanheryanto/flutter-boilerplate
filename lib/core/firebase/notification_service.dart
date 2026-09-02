import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:emas/core/config/app_config.dart';
import 'package:emas/core/utils/app_logger.dart';
import 'package:emas/core/utils/navigator_key.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

// ignore_for_file: unreachable_from_main

// ─── Notification Payload Model ───────────────────────────────────────────────
class AppNotificationPayload {
  final String? title;
  final String? body;
  final String? imageUrl;

  /// Route tujuan untuk deep link, e.g. '/notifications/detail'
  final String? route;

  /// ID entitas untuk deep link, e.g. notificationId, orderId, dll.
  final String? entityId;

  /// Tipe notifikasi untuk menentukan cara navigasi, e.g. 'order', 'chat', 'promo'
  final String? type;

  /// Semua data mentah dari FCM [RemoteMessage.data]
  final Map<String, dynamic> rawData;

  const AppNotificationPayload({
    this.title,
    this.body,
    this.imageUrl,
    this.route,
    this.entityId,
    this.type,
    required this.rawData,
  });

  factory AppNotificationPayload.fromMessage(RemoteMessage message) {
    final data = message.data;
    return AppNotificationPayload(
      title: message.notification?.title ?? data['title'] as String?,
      body: message.notification?.body ?? data['body'] as String?,
      imageUrl: message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl ?? data['image'] as String?,
      route: data['route'] as String?,
      entityId: data['entity_id'] as String?,
      type: data['type'] as String?,
      rawData: data,
    );
  }

  @override
  String toString() =>
      'AppNotificationPayload(title: $title, type: $type, route: $route, entityId: $entityId, imageUrl: $imageUrl, rawData: $rawData)';
}

class NotificationChannels {
  NotificationChannels._();

  static const general = AndroidNotificationChannel(
    'general_channel',
    'General',
    description: 'Notifikasi umum dari aplikasi',
  );

  static const order = AndroidNotificationChannel(
    'order_channel',
    'Order Updates',
    description: 'Update status pesanan kamu',
    importance: Importance.high,
  );

  static const chat = AndroidNotificationChannel(
    'chat_channel',
    'Messages',
    description: 'Pesan baru dari chat',
    importance: Importance.high,
  );

  static const promo = AndroidNotificationChannel(
    'promo_channel',
    'Promotions',
    description: 'Promo dan penawaran spesial',
    importance: Importance.low,
  );

  static List<AndroidNotificationChannel> get all => [
        general,
        order,
        chat,
        promo,
      ];

  static AndroidNotificationChannel fromType(String? type) {
    switch (type) {
      case 'order':
        return order;
      case 'chat':
        return chat;
      case 'promo':
        return promo;
      default:
        return general;
    }
  }
}

// ─── Abstract Interface ────────────────────────────────────────────────────────

abstract class NotificationService {
  Future<void> initialize();

  Future<String?> getToken();

  Future<void> subscribeToTopic(String topic);

  Future<void> unsubscribeFromTopic(String topic);

  Stream<AppNotificationPayload> get onNotificationTap;

  Stream<AppNotificationPayload> get onForegroundMessage;

  void close();
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.i(
    'Background message: ${message.messageId} | '
    'title: ${message.notification?.title} | '
    'data: ${message.data}',
    tag: 'FCM-Background',
  );

  if (message.notification == null && message.data.isNotEmpty) {
    await _showLocalNotificationFromBackground(message);
  }
}

Future<void> _showLocalNotificationFromBackground(RemoteMessage message) async {
  final plugin = FlutterLocalNotificationsPlugin();
  const initSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(),
  );
  await plugin.initialize(initSettings);

  final payload = AppNotificationPayload.fromMessage(message);
  final channel = NotificationChannels.fromType(payload.type);

  await plugin.show(
    message.hashCode,
    payload.title ?? 'Notifikasi Baru',
    payload.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
      ),
      iOS: const DarwinNotificationDetails(),
    ),
    payload: jsonEncode(message.data),
  );
}

@LazySingleton(as: NotificationService)
class AppNotificationService implements NotificationService {
  final FirebaseMessaging? _fcm;
  final FlutterLocalNotificationsPlugin _localPlugin;

  // Stream controllers
  final _tapController = StreamController<AppNotificationPayload>.broadcast();
  final _foregroundController = StreamController<AppNotificationPayload>.broadcast();

  AppNotificationService()
      : _fcm = AppConfig.isFirebaseEnabled ? FirebaseMessaging.instance : null,
        _localPlugin = FlutterLocalNotificationsPlugin();

  @override
  Stream<AppNotificationPayload> get onNotificationTap => _tapController.stream;

  @override
  Stream<AppNotificationPayload> get onForegroundMessage => _foregroundController.stream;

  @override
  Future<void> initialize() async {
    if (!AppConfig.isFirebaseEnabled) {
      AppLogger.d('NotificationService: Firebase disabled (dev mode)', tag: 'FCM');
      return;
    }

    await Future.wait([
      _setupLocalNotifications(),
      _requestPermissions(),
    ]);

    _registerBackgroundHandler();
    _listenForeground();
    _listenNotificationTap();
    await _checkInitialMessage();

    AppLogger.i('NotificationService initialized', tag: 'FCM');
  }

  @override
  Future<String?> getToken() async {
    if (_fcm == null) return null;

    try {
      final token = await _fcm.getToken();
      AppLogger.d('FCM Token: $token', tag: 'FCM');

      // Daftarkan listener jika token di-refresh oleh Firebase
      _fcm.onTokenRefresh.listen((newToken) {
        AppLogger.d('FCM Token refreshed: $newToken', tag: 'FCM');
        _onTokenRefreshed(newToken);
      });

      return token;
    } catch (e, st) {
      AppLogger.e('Failed to get FCM token', tag: 'FCM', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    await _fcm?.subscribeToTopic(topic);
    AppLogger.d('Subscribed to topic: $topic', tag: 'FCM');
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcm?.unsubscribeFromTopic(topic);
    AppLogger.d('Unsubscribed from topic: $topic', tag: 'FCM');
  }

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localPlugin.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundLocalNotificationTapped,
    );

    if (Platform.isAndroid) {
      final androidPlugin = _localPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      for (final channel in NotificationChannels.all) {
        await androidPlugin?.createNotificationChannel(channel);
      }
    }
  }

  Future<void> _requestPermissions() async {
    if (_fcm == null) return;

    // iOS + Android 13+
    final settings = await _fcm.requestPermission();

    AppLogger.i(
      'Notification permission: ${settings.authorizationStatus}',
      tag: 'FCM',
    );

    // Android 13+ tambahan: izin POST_NOTIFICATIONS
    if (Platform.isAndroid) {
      await _localPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
  }

  void _registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void _listenForeground() {
    FirebaseMessaging.onMessage.listen((message) async {
      AppLogger.d(
        'Foreground message: ${message.messageId} | '
        'title: ${message.notification?.title}',
        tag: 'FCM-Foreground',
      );

      final payload = AppNotificationPayload.fromMessage(message);
      _foregroundController.add(payload);

      // Tampilkan sebagai local notification
      await _showLocalNotification(message);
    });
  }

  void _listenNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      AppLogger.d(
        'Notification tapped (background→foreground): ${message.messageId}',
        tag: 'FCM-Tap',
      );
      final payload = AppNotificationPayload.fromMessage(message);
      _tapController.add(payload);
      await _navigateFromPayload(payload);
    });
  }

  /// Terminated: app di-launch dari notif tap
  Future<void> _checkInitialMessage() async {
    final initialMessage = await _fcm?.getInitialMessage();
    if (initialMessage != null) {
      AppLogger.d(
        'App launched from notification: ${initialMessage.messageId}',
        tag: 'FCM-Launch',
      );
      final payload = AppNotificationPayload.fromMessage(initialMessage);
      _tapController.add(payload);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateFromPayload(payload);
      });
    }
  }

  // ── Private: Local Notifications ───────────────────────────────────────────

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final payload = AppNotificationPayload.fromMessage(message);
    final channel = NotificationChannels.fromType(payload.type);

    await _localPlugin.show(
      message.hashCode,
      payload.title ?? 'Notifikasi Baru',
      payload.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: channel.importance,
          enableVibration: channel.enableVibration,
          playSound: channel.playSound,
          styleInformation: payload.imageUrl != null
              ? BigPictureStyleInformation(
                  FilePathAndroidBitmap(payload.imageUrl!),
                  hideExpandedLargeIcon: true,
                )
              : null,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: channel.playSound,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Callback saat local notification di-tap (foreground & background)
  Future<void> _onLocalNotificationTapped(NotificationResponse response) async {
    AppLogger.d(
      'Local notification tapped: ${response.id} | payload: ${response.payload}',
      tag: 'FCM-LocalTap',
    );

    if (response.payload == null) return;

    try {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      final payload = AppNotificationPayload(
        route: data['route'] as String?,
        entityId: data['entity_id'] as String?,
        type: data['type'] as String?,
        rawData: data,
      );
      _tapController.add(payload);
      await _navigateFromPayload(payload);
    } catch (e) {
      AppLogger.e('Failed to parse local notification payload', error: e, tag: 'FCM');
    }
  }

  /// Navigate berdasarkan payload.route atau payload.type
  Future<void> _navigateFromPayload(AppNotificationPayload payload) async {
    final route = payload.route;
    if (route == null) {
      AppLogger.d('No route in payload, skipping navigation', tag: 'FCM');
      return;
    }

    AppLogger.i('Navigating to: $route (entityId: ${payload.entityId})', tag: 'FCM');

    await AppNavigator.push<void>(route, extra: payload.entityId);
  }

  void _onTokenRefreshed(String token) {
    // getIt<AuthRepository>().updateFcmToken(token);
    AppLogger.i('FCM token refreshed, update backend: $token', tag: 'FCM');
  }

  @override
  Future<void> close() async {
    await _tapController.close();
    await _foregroundController.close();
  }
}

@pragma('vm:entry-point')
void _onBackgroundLocalNotificationTapped(NotificationResponse response) {
  AppLogger.d(
    'Background local notification tapped: ${response.id}',
    tag: 'FCM-BgLocalTap',
  );
}
