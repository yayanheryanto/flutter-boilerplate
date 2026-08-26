import 'package:equatable/equatable.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';

class NplOrderItem extends Equatable {
  final AuctionCategory category;
  final String location;
  final String date;
  final String time;
  final int nplQuantity;
  final int pricePerNpl;

  const NplOrderItem({
    required this.category,
    required this.location,
    required this.date,
    required this.time,
    required this.nplQuantity,
    required this.pricePerNpl,
  });

  int get subtotal => nplQuantity * pricePerNpl;

  @override
  List<Object?> get props => [category, location, date, time, nplQuantity, pricePerNpl];
}
