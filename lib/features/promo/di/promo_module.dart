import 'package:injectable/injectable.dart';

import 'package:emas/core/network/dio_client.dart';
import 'package:emas/features/promo/data/datasources/promo_remote_datasource.dart';

/// DI module fitur promo — mendaftarkan datasource Retrofit.
@module
abstract class PromoModule {
  @lazySingleton
  PromoRemoteDataSource promoRemoteDataSource(DioClient client) =>
      PromoRemoteDataSource(client.dio);
}
