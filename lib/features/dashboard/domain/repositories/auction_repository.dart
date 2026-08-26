import 'package:fpdart/fpdart.dart';
import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/domain/entities/auction_list_item.dart';

abstract class AuctionRepository {
  Future<Either<AppFailure, List<AuctionListItem>>> getAuctionList();
  Future<Either<AppFailure, List<AuctionItem>>> getAuctionsByCategory(
    AuctionCategory category,
  );
}
