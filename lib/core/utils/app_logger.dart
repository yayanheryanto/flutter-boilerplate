import 'package:logger/logger.dart';

import 'package:boilerplate/core/config/app_config.dart';

class AppLogger {
  AppLogger._();

  static Logger? _logger;

  static Logger get _instance {
    _logger ??= Logger(
      printer: PrettyPrinter(
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      filter: AppConfig.isLoggingEnabled ? ProductionFilter() : null,
      level: _mapLogLevel(AppConfig.logLevel),
    );
    return _logger!;
  }

  static Level _mapLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return Level.trace;
      case LogLevel.debug:
        return Level.debug;
      case LogLevel.info:
        return Level.info;
      case LogLevel.warning:
        return Level.warning;
      case LogLevel.error:
        return Level.error;
    }
  }

  static void v(String message, {String? tag}) {
    _instance.t(tag != null ? '[$tag] $message' : message);
  }

  static void d(String message, {String? tag}) {
    _instance.d(tag != null ? '[$tag] $message' : message);
  }

  static void i(String message, {String? tag}) {
    _instance.i(tag != null ? '[$tag] $message' : message);
  }

  static void w(String message, {String? tag}) {
    _instance.w(tag != null ? '[$tag] $message' : message);
  }

  static void e(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _instance.e(
      tag != null ? '[$tag] $message' : message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
