import 'package:fpdart/fpdart.dart';

import 'package:emas/core/errors/app_failure.dart';

/// Base use case with parameters
abstract class UseCase<Type, Params> {
  Future<Either<AppFailure, Type>> call(Params params);
}

/// Base use case without parameters
abstract class UseCaseNoParams<Type> {
  Future<Either<AppFailure, Type>> call();
}

/// Base stream use case with parameters
abstract class StreamUseCase<Type, Params> {
  Stream<Either<AppFailure, Type>> call(Params params);
}

/// No params placeholder
class NoParams {
  const NoParams();
}
