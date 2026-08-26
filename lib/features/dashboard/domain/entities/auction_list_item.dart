import 'package:equatable/equatable.dart';

class AuctionListItem extends Equatable {
  final String name;
  final int price;
  final String location;
  final String date;
  final String time;

  const AuctionListItem({
    required this.name,
    required this.price,
    required this.location,
    required this.date,
    required this.time,
  });

  @override
  List<Object?> get props => [name, price, location, date, time];
}
