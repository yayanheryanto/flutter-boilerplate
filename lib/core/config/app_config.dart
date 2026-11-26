import 'package:emas/core/config/env.dart';

class AppConfig {
  AppConfig._();

  static late Environment _environment;
  static late String _baseUrl;
  static late String _appName;
  static late bool _isFirebaseEnabled;
  static late bool _isLoggingEnabled;
  static late LogLevel _logLevel;
  static late bool _useMock;

  /// Override mock lewat `--dart-define=USE_MOCK=true|false`.
  /// Kosong = ikuti default environment di [initialize].
  static const String _useMockOverride = String.fromEnvironment('USE_MOCK');

  static void initialize(Environment env) {
    _environment = env;

    switch (env) {
      case Environment.dev:
        _baseUrl = 'https://api-dev.example.com/v1';
        _appName = '[DEV] Boilerplate';
        _isFirebaseEnabled = false;
        _isLoggingEnabled = true;
        _logLevel = LogLevel.verbose;
        _useMock = true;
      case Environment.stag:
        _baseUrl = 'https://api-staging.example.com/v1';
        _appName = '[STG] Boilerplate';
        _isFirebaseEnabled = true;
        _isLoggingEnabled = true;
        _logLevel = LogLevel.debug;
        _useMock = true; // TODO: false begitu backend staging tersedia
      case Environment.prod:
        _baseUrl = 'https://api.example.com/v1';
        _appName = 'Boilerplate';
        _isFirebaseEnabled = true;
        _isLoggingEnabled = false;
        _logLevel = LogLevel.error;
        _useMock = false;
    }
  }

  static Environment get environment => _environment;
  static String get baseUrl => _baseUrl;
  static String get appName => _appName;
  static bool get isFirebaseEnabled => _isFirebaseEnabled;
  static bool get isLoggingEnabled => _isLoggingEnabled;
  static LogLevel get logLevel => _logLevel;

  /// `true` → request yang punya handler mock dijawab oleh `MockInterceptor`
  /// tanpa menyentuh jaringan. Request tanpa handler tetap ke [baseUrl].
  static bool get useMock => switch (_useMockOverride) {
        'true' => true,
        'false' => false,
        _ => _useMock,
      };

  static bool get isDev => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.stag;
  static bool get isProd => _environment == Environment.prod;
}

enum LogLevel { verbose, debug, info, warning, error }
