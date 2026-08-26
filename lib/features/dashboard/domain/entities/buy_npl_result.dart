import 'package:equatable/equatable.dart';
import 'package:emas/features/dashboard/domain/entities/auction_item.dart';

class BuyNplResult extends Equatable {
  final AuctionCategory category;
  final String location;
  final DateTime date;
  final int quantity;
  final int pricePerNpl;
  final int subtotal;

  const BuyNplResult({
    required this.category,
    required this.location,
    required this.date,
    required this.quantity,
    required this.pricePerNpl,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [category, location, date, quantity, pricePerNpl, subtotal];
}
