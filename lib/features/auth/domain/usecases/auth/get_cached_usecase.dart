import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/usecases/base_usecase.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/repositories/auth_repository.dart';

@injectable
class GetCachedAuthUseCase extends UseCaseNoParams<AuthEntity?> {
  final AuthRepository _repository;

  GetCachedAuthUseCase(this._repository);

  @override
  Future<Either<AppFailure, AuthEntity?>> call() {
    return _repository.getCachedAuth();
  }
}
