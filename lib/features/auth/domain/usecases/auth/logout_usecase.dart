import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/errors/app_failure.dart';
import 'package:boilerplate/core/usecases/base_usecase.dart';
import 'package:boilerplate/features/auth/domain/repositories/auth_repository.dart';

// ─── LogoutUseCase ────────────────────────────────────────────────────────────

@injectable
class LogoutUseCase extends UseCaseNoParams<Unit> {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call() {
    return _repository.logout();
  }
}
