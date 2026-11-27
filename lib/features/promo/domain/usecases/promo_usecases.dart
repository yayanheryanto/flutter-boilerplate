import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/usecases/base_usecase.dart';
import 'package:emas/features/promo/domain/entities/promo.dart';
import 'package:emas/features/promo/domain/repositories/promo_repository.dart';

@injectable
class GetPromosUseCase extends UseCaseNoParams<List<Promo>> {
  final PromoRepository _repository;

  GetPromosUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<Promo>>> call() => _repository.getPromos();
}

@injectable
class GetPromoDetailUseCase extends UseCase<Promo, String> {
  final PromoRepository _repository;

  GetPromoDetailUseCase(this._repository);

  /// [params] = id promo.
  @override
  Future<Either<AppFailure, Promo>> call(String params) => _repository.getPromoDetail(params);
}
