enum NPLStatus {
  unpaid,
  active,
}

class NPLItem {
  final String id;
  final String categoryTitle;
  final String nplNumber;
  final String schedule;
  final String location;
  final String? licensePlate;
  final int? year;
  final int? lot;
  final NPLStatus status;
  final DateTime? payBeforeDate;
  final int? totalBill;
  final String? paymentMethodName;
  final int? price;

  const NPLItem({
    required this.id,
    required this.categoryTitle,
    required this.nplNumber,
    required this.schedule,
    required this.location,
    this.licensePlate,
    this.year,
    this.lot,
    required this.status,
    this.payBeforeDate,
    this.totalBill,
    this.paymentMethodName,
    this.price,
  });
}
