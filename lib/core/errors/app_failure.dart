import 'package:equatable/equatable.dart';

abstract class AppFailure extends Equatable {
  final String message;
  final int? statusCode;

  const AppFailure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends AppFailure {
  const ServerFailure({
    required super.message,
    super.statusCode,
  });
}

class NetworkFailure extends AppFailure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.statusCode,
  });
}

class CacheFailure extends AppFailure {
  const CacheFailure({
    required super.message,
    super.statusCode,
  });
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
  });
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.statusCode = 404,
  });
}

class ValidationFailure extends AppFailure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    required super.message,
    super.statusCode = 422,
    this.errors,
  });

  @override
  List<Object?> get props => [message, statusCode, errors];
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure({
    super.message = 'Request timed out',
    super.statusCode,
  });
}

class UnknownFailure extends AppFailure {
  const UnknownFailure({
    super.message = 'An unknown error occurred',
    super.statusCode,
  });
}
