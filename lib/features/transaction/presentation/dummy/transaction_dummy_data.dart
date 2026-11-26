import 'package:emas/features/transaction/domain/entities/transaction_item.dart';

// TODO(api): data dummy sementara — ganti dengan data dari repository/BLoC
// begitu endpoint tersedia. Jangan dipakai dari lapisan domain/data.

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
    payBeforeDate: DateTime(2026, 09, 15, 23, 59),
    totalBill: 146000000,
    paymentMethodName: 'Allo Bank',
  ),
];
