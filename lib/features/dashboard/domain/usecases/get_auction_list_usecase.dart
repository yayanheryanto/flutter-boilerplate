import 'package:injectable/injectable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:emas/core/errors/app_failure.dart';
import 'package:emas/core/usecases/base_usecase.dart';
import 'package:emas/features/dashboard/domain/entities/auction_list_item.dart';
import 'package:emas/features/dashboard/domain/repositories/auction_repository.dart';

@injectable
class GetAuctionListUseCase extends UseCaseNoParams<List<AuctionListItem>> {
  final AuctionRepository _repository;
  GetAuctionListUseCase(this._repository);

  @override
  Future<Either<AppFailure, List<AuctionListItem>>> call() => _repository.getAuctionList();
}
