import 'package:emas/core/network/mock/mock_api.dart';
import 'package:emas/features/promo/data/datasources/promo_endpoints.dart';

/// Backend palsu untuk promo. Dipakai selama `AppConfig.useMock`.
///
/// - `GET /promos` → daftar promo aktif (carousel dashboard)
/// - `GET /promos/{id}` → detail; id tidak dikenal → 404
class PromoMockApi {
  /// Gambar dari layanan publik (picsum.photos) — selalu bisa diakses tanpa
  /// VPN/jaringan internal. `seed` membuat gambar tiap promo tetap sama.
  /// Ganti dengan URL gambar promo asli saat backend tersedia.
  static String _image(String seed) => 'https://picsum.photos/seed/$seed/1200/600';

  final List<Map<String, dynamic>> _promos = [
    {
      'id': 'promo-1',
      'title': 'Cashback 10% Lelang Motor',
      'subtitle': 'Untuk kemenangan lelang pertama kamu',
      'image_url': _image('emas-promo-1'),
      'description': 'Menangkan lelang motor pertamamu di EMAS dan dapatkan cashback 10% '
          'dari harga akhir lelang, maksimal Rp1.000.000.\n\n'
          'Syarat & ketentuan:\n'
          '• Berlaku untuk akun yang sudah terverifikasi.\n'
          '• Hanya untuk kemenangan lelang kategori motor yang pertama.\n'
          '• Cashback dikirim ke rekening terdaftar maksimal 7 hari kerja setelah pelunasan.\n'
          '• Tidak dapat digabung dengan promo lain.',
      'valid_until': '2026-12-31T23:59:59.000',
    },
    {
      'id': 'promo-2',
      'title': 'Gratis Biaya Admin Beli NPL',
      'subtitle': 'Hemat biaya administrasi setiap pembelian',
      'image_url': _image('emas-promo-2'),
      'description': 'Nikmati pembebasan biaya administrasi untuk setiap pembelian aset NPL '
          'selama periode promo.\n\n'
          'Syarat & ketentuan:\n'
          '• Berlaku untuk semua kategori aset NPL.\n'
          '• Potongan otomatis di halaman konfirmasi pembelian.\n'
          '• Kuota terbatas setiap bulan.',
      'valid_until': '2027-01-31T23:59:59.000',
    },
    {
      'id': 'promo-3',
      'title': 'Bonus Bid Lelang Live',
      'subtitle': 'Ikut lelang live dan kumpulkan bonus',
      'image_url': _image('emas-promo-3'),
      'description': 'Ikuti minimal 3 sesi lelang live dalam satu minggu dan dapatkan '
          'voucher potongan Rp250.000 untuk pembayaran lelang berikutnya.\n\n'
          'Syarat & ketentuan:\n'
          '• Sesi dihitung bila kamu melakukan minimal satu bid.\n'
          '• Voucher berlaku 30 hari sejak diterbitkan.\n'
          '• Satu akun maksimal satu voucher per minggu.',
      'valid_until': '2026-12-15T23:59:59.000',
    },
  ];

  List<MockRoute> get routes => [
        MockRoute.get(PromoEndpoints.list, _list),
        MockRoute.get(PromoEndpoints.detail, _detail),
      ];

  MockResponse _list(MockRequest req) => MockResponse.ok({'items': _promos});

  MockResponse _detail(MockRequest req) {
    final id = req.pathParams['id'];
    for (final promo in _promos) {
      if (promo['id'] == id) return MockResponse.ok(promo);
    }
    return MockResponse.error(404, 'Promo tidak ditemukan atau sudah berakhir', code: 'PROMO_NOT_FOUND');
  }
}
