/// Status pembayaran transaksi NPL/lelang.
enum TransaksiStatus { belumDibayar, menungguPembayaran }

class TransactionItem {
  final String id;
  final String namaKendaraan;
  final String noPolisi;
  final int tahun;
  final int lot;
  final int hargaTerbentuk;
  final TransaksiStatus status;

  const TransactionItem({
    required this.id,
    required this.namaKendaraan,
    required this.noPolisi,
    required this.tahun,
    required this.lot,
    required this.hargaTerbentuk,
    required this.status,
  });
}

/// Dummy data transaksi — ganti dengan hasil API begitu endpoint tersedia.
const dummyTransactionItems = [
  TransactionItem(
    id: 'trx-001',
    namaKendaraan: 'DAIHATSU GRAND MAX BV - 1.3',
    noPolisi: 'BK8769ET',
    tahun: 2021,
    lot: 15,
    hargaTerbentuk: 150000000,
    status: TransaksiStatus.belumDibayar,
  ),
  TransactionItem(
    id: 'trx-002',
    namaKendaraan: 'DAIHATSU GRAND MAX BV - 1.3',
    noPolisi: 'BK8769ET',
    tahun: 2021,
    lot: 15,
    hargaTerbentuk: 150000000,
    status: TransaksiStatus.belumDibayar,
  ),
  TransactionItem(
    id: 'trx-003',
    namaKendaraan: 'TOYOTA AVANZA VELOZ 1.5',
    noPolisi: 'BK1122AF',
    tahun: 2020,
    lot: 8,
    hargaTerbentuk: 175000000,
    status: TransaksiStatus.menungguPembayaran,
  ),
];
