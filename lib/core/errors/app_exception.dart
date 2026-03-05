class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => 'AppException: $message (status: $statusCode)';
}

class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No internet connection'});
}

class CacheException extends AppException {
  const CacheException({required super.message});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized', super.statusCode = 401});
}

class NotFoundException extends AppException {
  const NotFoundException({super.message = 'Not found', super.statusCode = 404});
}

class TimeoutException extends AppException {
  const TimeoutException({super.message = 'Request timed out'});
}
