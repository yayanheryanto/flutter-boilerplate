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

/// Dummy transaction data — replace with API results once the endpoint is available.
final dummyTransactionItems = [
  const TransactionItem(
    id: 'trx-001',
    vehicleName: 'DAIHATSU GRAND MAX BV - 1.3',
    licensePlate: 'BK8769ET',
    year: 2021,
    lot: 15,
    formedPrice: 150000000,
    status: TransactionStatus.unpaid,
  ),
  const TransactionItem(
    id: 'trx-002',
    vehicleName: 'DAIHATSU GRAND MAX BV - 1.3',
    licensePlate: 'BK8769ET',
    year: 2021,
    lot: 15,
    formedPrice: 150000000,
    status: TransactionStatus.unpaid,
  ),
  TransactionItem(
    id: 'trx-003',
    vehicleName: 'DAIHATSU GRAND MAX BV - 1.3',
    licensePlate: 'BK8769ET',
    year: 2021,
    lot: 15,
    formedPrice: 150000000,
    status: TransactionStatus.pendingPayment,
    payBeforeDate: DateTime(2026, 9, 1, 23, 59),
    totalBill: 146000000,
    paymentMethodName: 'Allo Bank',
  ),
];
