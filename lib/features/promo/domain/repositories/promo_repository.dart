import 'package:fpdart/fpdart.dart';

import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/features/promo/domain/entities/promo.dart';

abstract class PromoRepository {
  /// Promo aktif, urut sesuai prioritas tampil.
  Future<Either<AppFailure, List<Promo>>> getPromos();

  Future<Either<AppFailure, Promo>> getPromoDetail(String id);
}
