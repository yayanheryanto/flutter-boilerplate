/// One collapsible payment-guide section, e.g. "Allo Wallet",
/// "Internet Banking Allo Bank", "Kantor Allo Bank".
///
/// Each step supports a light markup:
/// - `**text**` renders bold
/// - `[[text]]` renders as a tappable link (see `onLinkTap` in the page)
class PaymentGuideChannel {
  final String title;
  final List<String> steps;

  const PaymentGuideChannel({required this.title, required this.steps});
}

/// Dummy payment guide content — replace with API results once available.
const paymentGuideChannels = [
  PaymentGuideChannel(
    title: 'Allo Wallet',
    steps: [
      'Log in pada aplikasi Allo Bank. [[Klik disini]]',
      'Pilih menu **bayar tagihan**',
      'Pilih menu **cicilan kredit**',
      'Di menu **Pilih Biller**, pilih Mega Finance. Kemudian masukkan nomor kontrak di atas',
      'Cek kembali nominal tagihan Anda',
      'Masukkan pin Allo Bank',
      'Pembayaran selesai. Simpan bukti pembayaran',
    ],
  ),
  PaymentGuideChannel(
    title: 'Internet Banking Allo Bank',
    steps: [
      'Login ke **Internet Banking Allo Bank** menggunakan User ID dan PIN Anda',
      'Pilih menu **Pembayaran** lalu **Pembayaran Tagihan**',
      'Pilih **Mega Finance** sebagai penyedia jasa',
      'Masukkan nomor rekening virtual account di atas',
      'Periksa kembali nominal tagihan, lalu konfirmasi pembayaran',
      'Simpan bukti pembayaran sebagai referensi',
    ],
  ),
  PaymentGuideChannel(
    title: 'Kantor Allo Bank',
    steps: [
      'Datang ke kantor cabang **Allo Bank** terdekat',
      'Sampaikan ke petugas bahwa Anda ingin membayar tagihan **Mega Finance**',
      'Berikan nomor rekening virtual account di atas kepada petugas',
      'Lakukan pembayaran sesuai nominal tagihan',
      'Simpan struk/bukti pembayaran dari petugas',
    ],
  ),
];
