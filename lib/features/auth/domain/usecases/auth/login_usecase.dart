import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/errors/app_failure.dart';
import 'package:boilerplate/core/usecases/base_usecase.dart';
import 'package:boilerplate/features/auth/domain/entities/auth_entity.dart';
import 'package:boilerplate/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

@injectable
class LoginUseCase extends UseCase<AuthEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<AppFailure, AuthEntity>> call(LoginParams params) {
    return _repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
