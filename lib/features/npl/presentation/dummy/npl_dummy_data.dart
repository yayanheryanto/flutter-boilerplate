import 'package:emas/features/npl/domain/entities/npl_item.dart';

// TODO(api): data dummy sementara — ganti dengan data dari repository/BLoC
// begitu endpoint tersedia. Jangan dipakai dari lapisan domain/data.

final List<NPLItem> dummyNPLItems = [
  NPLItem(
    id: 'trx-001',
    categoryTitle: 'Live Auction Mobil',
    nplNumber: '100104',
    schedule: '09.30 WIB',
    location: 'Fatmawati',
    licensePlate: 'BK 8769 ET',
    year: 2021,
    lot: 15,
    status: NPLStatus.unpaid,
    payBeforeDate: DateTime(2026, 9, 10, 23, 59),
    totalBill: 3000000,
    paymentMethodName: 'Allo Bank',
    price: 3000000,
  ),
  const NPLItem(
    id: 'trx-003',
    categoryTitle: 'Live Auction Motor',
    nplNumber: '200101',
    schedule: '10.00 WIB',
    location: 'Jakarta Selatan',
    licensePlate: 'B 5678 EF',
    year: 2020,
    lot: 8,
    status: NPLStatus.active,
    totalBill: 1500000,
    paymentMethodName: 'Mandiri Virtual Account',
  ),
];
