import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/config/app_config.dart';
import 'package:emas/core/constants/app_constants.dart';
import 'package:emas/core/network/interceptors/auth_interceptor.dart';
import 'package:emas/core/network/interceptors/logging_interceptor.dart';
import 'package:emas/core/network/interceptors/retry_interceptor.dart';

@singleton
class DioClient {
  late final Dio _dio;

  DioClient(
    AuthInterceptor authInterceptor,
    LoggingInterceptor loggingInterceptor,
    RetryInterceptor retryInterceptor,
  ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(
          milliseconds: AppConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: AppConstants.receiveTimeout,
        ),
        sendTimeout: const Duration(
          milliseconds: AppConstants.sendTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      authInterceptor,
      retryInterceptor,
      loggingInterceptor,
    ]);
  }

  Dio get dio => _dio;
}
