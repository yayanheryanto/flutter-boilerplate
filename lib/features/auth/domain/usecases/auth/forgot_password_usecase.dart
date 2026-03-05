import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/errors/app_failure.dart';
import 'package:boilerplate/core/usecases/base_usecase.dart';
import 'package:boilerplate/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object?> get props => [email];
}

@injectable
class ForgotPasswordUseCase extends UseCase<Unit, ForgotPasswordParams> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<AppFailure, Unit>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(email: params.email);
  }
}
