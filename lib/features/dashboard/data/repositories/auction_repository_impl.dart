import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/features/dashboard/data/datasources/auction_datasource.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/domain/entities/auction_list_item.dart';
import 'package:emas/features/dashboard/domain/repositories/auction_repository.dart';

@LazySingleton(as: AuctionRepository)
class AuctionRepositoryImpl implements AuctionRepository {
  final AuctionDataSource _dataSource;

  AuctionRepositoryImpl(this._dataSource);

  @override
  Future<Either<AppFailure, List<AuctionListItem>>> getAuctionList() async {
    try {
      return Right(await _dataSource.getAuctionList());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<AuctionItem>>> getAuctionsByCategory(
    AuctionCategory category,
  ) async {
    try {
      return Right(await _dataSource.getAuctionsByCategory(category));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
