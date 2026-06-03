import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/config/app_config.dart';
import 'package:emas/core/utils/app_logger.dart';

// ─── Analytics Service ─────────────────────────────────────────────────────

abstract class AnalyticsService {
  Future<void> logEvent(String name, {Map<String, Object>? parameters});
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty({required String name, required String? value});
  Future<void> logLogin({String method = 'email'});
  Future<void> logSignUp({String method = 'email'});
}

@LazySingleton(as: AnalyticsService)
class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics? _analytics;

  FirebaseAnalyticsService()
      : _analytics = AppConfig.isFirebaseEnabled
            ? FirebaseAnalytics.instance
            : null;

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (_analytics == null) {
      AppLogger.d('Analytics [DEV]: $name | $parameters', tag: 'Analytics');
      return;
    }
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setUserId(String? userId) async {
    await _analytics?.setUserId(id: userId);
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    await _analytics?.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> logLogin({String method = 'email'}) async {
    await _analytics?.logLogin(loginMethod: method);
  }

  @override
  Future<void> logSignUp({String method = 'email'}) async {
    await _analytics?.logSignUp(signUpMethod: method);
  }
}

// ─── Crashlytics Service ─────────────────────────────────────────────────────

abstract class CrashlyticsService {
  Future<void> recordError(dynamic exception, StackTrace? stack, {bool fatal = false});
  Future<void> setUserId(String userId);
  Future<void> log(String message);
}

@LazySingleton(as: CrashlyticsService)
class FirebaseCrashlyticsService implements CrashlyticsService {
  final FirebaseCrashlytics? _crashlytics;

  FirebaseCrashlyticsService()
      : _crashlytics = AppConfig.isFirebaseEnabled
            ? FirebaseCrashlytics.instance
            : null;

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    bool fatal = false,
  }) async {
    if (_crashlytics == null) {
      AppLogger.e(
        'Crashlytics [DEV]: $exception',
        error: exception,
        stackTrace: stack,
      );
      return;
    }
    await _crashlytics.recordError(exception, stack, fatal: fatal);
  }

  @override
  Future<void> setUserId(String userId) async {
    await _crashlytics?.setUserIdentifier(userId);
  }

  @override
  Future<void> log(String message) async {
    if (_crashlytics == null) {
      AppLogger.d('Crashlytics log: $message');
      return;
    }
    await _crashlytics.log(message);
  }
}

// ─── Remote Config Service ────────────────────────────────────────────────────

abstract class RemoteConfigService {
  Future<void> initialize();
  Future<void> fetchAndActivate();
  bool getBool(String key, {bool defaultValue = false});
  String getString(String key, {String defaultValue = ''});
  int getInt(String key, {int defaultValue = 0});
  double getDouble(String key, {double defaultValue = 0.0});
}

@LazySingleton(as: RemoteConfigService)
class FirebaseRemoteConfigService implements RemoteConfigService {
  FirebaseRemoteConfig? _remoteConfig;

  static const _defaults = <String, dynamic>{
    'enable_social_login': false,
    'maintenance_mode': false,
    'min_app_version': '1.0.0',
    'feature_dark_mode': true,
  };

  @override
  Future<void> initialize() async {
    if (!AppConfig.isFirebaseEnabled) return;

    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig!.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: AppConfig.isDev
            ? Duration.zero
            : const Duration(hours: 1),
      ),
    );
    await _remoteConfig!.setDefaults(_defaults);
    await fetchAndActivate();
  }

  @override
  Future<void> fetchAndActivate() async {
    await _remoteConfig?.fetchAndActivate();
  }

  @override
  bool getBool(String key, {bool defaultValue = false}) {
    if (_remoteConfig == null) {
      return _defaults[key] as bool? ?? defaultValue;
    }
    return _remoteConfig!.getBool(key);
  }

  @override
  String getString(String key, {String defaultValue = ''}) {
    if (_remoteConfig == null) {
      return _defaults[key] as String? ?? defaultValue;
    }
    return _remoteConfig!.getString(key);
  }

  @override
  int getInt(String key, {int defaultValue = 0}) {
    if (_remoteConfig == null) {
      return _defaults[key] as int? ?? defaultValue;
    }
    return _remoteConfig!.getInt(key);
  }

  @override
  double getDouble(String key, {double defaultValue = 0.0}) {
    if (_remoteConfig == null) {
      return _defaults[key] as double? ?? defaultValue;
    }
    return _remoteConfig!.getDouble(key);
  }
}
