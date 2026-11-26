import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String logoAsset;
  final int logoColorValue;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.logoAsset,
    this.logoColorValue = 0x00000000,
  });

  @override
  List<Object?> get props => [id, name, logoAsset, logoColorValue];
}
