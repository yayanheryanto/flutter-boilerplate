import 'package:dio/dio.dart';

import 'package:emas/core/errors/app_exception.dart';
import 'package:emas/core/errors/app_failure.dart';

class ErrorMapper {
  ErrorMapper._();

  static AppFailure mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = _extractMessage(e.response?.data);

        switch (statusCode) {
          case 400:
            return ServerFailure(message: message, statusCode: statusCode);
          case 401:
            return UnauthorizedFailure(message: message);
          case 404:
            return NotFoundFailure(message: message);
          case 422:
            final errors = _extractValidationErrors(e.response?.data);
            return ValidationFailure(
              message: message,
              statusCode: statusCode,
              errors: errors,
            );
          case 500:
          case 502:
          case 503:
            return ServerFailure(
              message: 'Server error. Please try again later.',
              statusCode: statusCode,
            );
          default:
            return ServerFailure(message: message, statusCode: statusCode);
        }

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled');

      default:
        return const UnknownFailure();
    }
  }

  static AppFailure mapException(AppException e) {
    if (e is ServerException) {
      return ServerFailure(message: e.message, statusCode: e.statusCode);
    } else if (e is NetworkException) {
      return NetworkFailure(message: e.message);
    } else if (e is CacheException) {
      return CacheFailure(message: e.message);
    } else if (e is UnauthorizedException) {
      return UnauthorizedFailure(message: e.message);
    } else if (e is NotFoundException) {
      return NotFoundFailure(message: e.message);
    } else if (e is TimeoutException) {
      return const TimeoutFailure();
    }
    return UnknownFailure(message: e.message);
  }

  static String _extractMessage(dynamic data) {
    if (data == null) return 'An error occurred';
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          'An error occurred';
    }
    return 'An error occurred';
  }

  static Map<String, List<String>>? _extractValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic>) {
        return errors.map((key, value) {
          if (value is List) {
            return MapEntry(key, value.map((e) => e.toString()).toList());
          }
          return MapEntry(key, [value.toString()]);
        });
      }
    }
    return null;
  }
}
