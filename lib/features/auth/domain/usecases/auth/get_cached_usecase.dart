import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/errors/app_failure.dart';
import 'package:boilerplate/core/usecases/base_usecase.dart';
import 'package:boilerplate/features/auth/domain/entities/auth_entity.dart';
import 'package:boilerplate/features/auth/domain/repositories/auth_repository.dart';

@injectable
class GetCachedAuthUseCase extends UseCaseNoParams<AuthEntity?> {
  final AuthRepository _repository;

  GetCachedAuthUseCase(this._repository);

  @override
  Future<Either<AppFailure, AuthEntity?>> call() {
    return _repository.getCachedAuth();
  }
}
