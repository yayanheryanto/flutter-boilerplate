import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/usecases/base_usecase.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/domain/repositories/auction_repository.dart';

class GetAuctionsByCategoryParams extends Equatable {
  final AuctionCategory category;
  const GetAuctionsByCategoryParams(this.category);
  @override
  List<Object?> get props => [category];
}

@injectable
class GetAuctionsByCategoryUseCase
    extends UseCase<List<AuctionItem>, GetAuctionsByCategoryParams> {
  final AuctionRepository _repository;
  GetAuctionsByCategoryUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<AuctionItem>>> call(
    GetAuctionsByCategoryParams params,
  ) => _repository.getAuctionsByCategory(params.category);
}
