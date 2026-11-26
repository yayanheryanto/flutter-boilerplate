/// Payment status of an NPL/auction transaction.
enum TransactionStatus { unpaid, pendingPayment }

class TransactionItem {
  final String id;
  final String vehicleName;
  final String licensePlate;
  final int year;
  final int lot;
  final int formedPrice;
  final TransactionStatus status;

  /// The fields below are only populated for [TransactionStatus.pendingPayment].
  final DateTime? payBeforeDate;
  final int? totalBill;
  final String? paymentMethodName;

  const TransactionItem({
    required this.id,
    required this.vehicleName,
    required this.licensePlate,
    required this.year,
    required this.lot,
    required this.formedPrice,
    required this.status,
    this.payBeforeDate,
    this.totalBill,
    this.paymentMethodName,
  });
}
