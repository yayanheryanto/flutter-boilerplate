import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/config/app_config.dart';
import 'package:emas/core/utils/app_logger.dart';

@singleton
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.isLoggingEnabled) {
      AppLogger.d(
        '→ ${options.method} ${options.uri}\n'
        'Headers: ${options.headers}\n'
        'Data: ${options.data}',
        tag: 'HTTP',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (AppConfig.isLoggingEnabled) {
      AppLogger.d(
        '← ${response.statusCode} ${response.requestOptions.uri}\n'
        'Data: ${response.data}',
        tag: 'HTTP',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (AppConfig.isLoggingEnabled) {
      AppLogger.e(
        '✗ ${err.response?.statusCode} ${err.requestOptions.uri}\n'
        'Error: ${err.message}\n'
        'Response: ${err.response?.data}',
        tag: 'HTTP',
        error: err,
      );
    }
    handler.next(err);
  }
}
