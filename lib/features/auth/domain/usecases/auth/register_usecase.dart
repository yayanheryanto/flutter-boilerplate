import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/errors/app_failure.dart';
import 'package:boilerplate/core/usecases/base_usecase.dart';
import 'package:boilerplate/features/auth/domain/entities/auth_entity.dart';
import 'package:boilerplate/features/auth/domain/repositories/auth_repository.dart';

// ─── RegisterUseCase ─────────────────────────────────────────────────────────

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

@injectable
class RegisterUseCase extends UseCase<AuthEntity, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<AppFailure, AuthEntity>> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}
