import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/usecases/base_usecase.dart';
import 'package:emas/features/auth/domain/entities/auth_entity.dart';
import 'package:emas/features/auth/domain/repositories/auth_repository.dart';
import 'package:emas/features/auth/domain/usecases/auth/register_usecase.dart';

class LoginParams extends Equatable {
  final String phone;
  final String password;

  const LoginParams({required this.phone, required this.password});

  // Password tidak dimasukkan ke props agar tidak tercetak di log.
  @override
  List<Object?> get props => [phone];
}

@injectable
class LoginUseCase extends UseCase<AuthEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<AppFailure, AuthEntity>> call(LoginParams params) {
    return _repository.login(
      phone: normalizePhone(params.phone),
      password: params.password,
    );
  }
}
