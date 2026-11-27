import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:emas/features/promo/data/datasources/promo_endpoints.dart';
import 'package:emas/features/promo/data/models/promo_model.dart';

part 'promo_remote_datasource.g.dart';

/// Kontrak HTTP promo. Selama `AppConfig.useMock` aktif, dijawab oleh
/// `promo_mock_api.dart` lewat `MockInterceptor`.
@RestApi()
abstract class PromoRemoteDataSource {
  factory PromoRemoteDataSource(Dio dio, {String baseUrl}) = _PromoRemoteDataSource;

  /// Promo aktif untuk carousel dashboard.
  @GET(PromoEndpoints.list)
  Future<PromoListModel> getPromos();

  @GET(PromoEndpoints.detail)
  Future<PromoModel> getPromoDetail(@Path('id') String id);
}
