import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/errors/app_exception.dart';
import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/errors/error_mapper.dart';
import 'package:emas/features/promo/data/datasources/promo_remote_datasource.dart';
import 'package:emas/features/promo/domain/entities/promo.dart';
import 'package:emas/features/promo/domain/repositories/promo_repository.dart';

@LazySingleton(as: PromoRepository)
class PromoRepositoryImpl implements PromoRepository {
  final PromoRemoteDataSource _remote;

  PromoRepositoryImpl(this._remote);

  @override
  Future<Either<AppFailure, List<Promo>>> getPromos() {
    return _guard(() async {
      final model = await _remote.getPromos();
      return model.items.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<AppFailure, Promo>> getPromoDetail(String id) {
    return _guard(() async {
      final model = await _remote.getPromoDetail(id);
      return model.toEntity();
    });
  }

  Future<Either<AppFailure, T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } on AppException catch (e) {
      return Left(ErrorMapper.mapException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
