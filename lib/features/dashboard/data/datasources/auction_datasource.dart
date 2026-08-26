import 'package:injectable/injectable.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';
import 'package:emas/features/dashboard/data/models/dashboard_dummy_data.dart';
import 'package:emas/features/dashboard/domain/entities/auction_list_item.dart';

abstract class AuctionDataSource {
  Future<List<AuctionListItem>> getAuctionList();
  Future<List<AuctionItem>> getAuctionsByCategory(AuctionCategory category);
}

@Injectable(as: AuctionDataSource)
class AuctionDummyDataSource implements AuctionDataSource {
  static const _items = <AuctionListItem>[
    AuctionListItem(name: 'DAIHATSU GRAND MAX BV - 1.3', price: 125000000, location: 'Fatmawati', date: '12 Jun 2026', time: '10.00'),
    AuctionListItem(name: 'TOYOTA AVANZA 1.5', price: 145000000, location: 'Fatmawati', date: '13 Jun 2026', time: '10.00'),
    AuctionListItem(name: 'HONDA BRIO SATYA', price: 110000000, location: 'Jakarta Selatan', date: '14 Jun 2026', time: '11.00'),
    AuctionListItem(name: 'MITSUBISHI XPANDER', price: 180000000, location: 'Bekasi', date: '15 Jun 2026', time: '13.00'),
    AuctionListItem(name: 'SUZUKI XL7', price: 155000000, location: 'Depok', date: '16 Jun 2026', time: '10.00'),
    AuctionListItem(name: 'DAIHATSU TERIOS', price: 135000000, location: 'Bogor', date: '17 Jun 2026', time: '09.00'),
  ];

  @override
  Future<List<AuctionListItem>> getAuctionList() async => List.unmodifiable(_items);

  @override
  Future<List<AuctionItem>> getAuctionsByCategory(AuctionCategory category) async {
    return itemsByCategory(category);
  }
}
