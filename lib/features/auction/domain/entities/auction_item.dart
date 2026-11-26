/// Kategori lelang — satu sumber kebenaran untuk label, image, dan slug routing.
///
/// Warna kategori ada di lapisan presentation
/// (`AuctionCategoryStyle.color` di `auction_category_style.dart`) supaya
/// domain tetap Dart murni tanpa dependensi Flutter.
enum AuctionCategory {
  motor,
  mobil,
  elektronik,
  properti,
  mewah,
  lainnya;

  /// Label tampil ke pengguna.
  String get label => const {
    AuctionCategory.motor: 'Motor',
    AuctionCategory.mobil: 'Mobil',
    AuctionCategory.elektronik: 'Elektronik',
    AuctionCategory.properti: 'Properti',
    AuctionCategory.mewah: 'Mewah',
    AuctionCategory.lainnya: 'Lainnya',
  }[this]!;

  /// Slug untuk GoRouter path param (:slug).
  String get slug => name; // 'motor', 'mobil', dst.

  /// Parse dari slug path param.
  static AuctionCategory fromSlug(String slug) =>
      AuctionCategory.values.firstWhere(
            (e) => e.slug == slug,
        orElse: () => AuctionCategory.lainnya,
      );

  String get image => const {
    AuctionCategory.motor: '🏍️',
    AuctionCategory.mobil: '🚗',
    AuctionCategory.elektronik: '📱',
    AuctionCategory.properti: '🏠',
    AuctionCategory.mewah: '💎',
    AuctionCategory.lainnya: '🛠️',
  }[this]!;
}

class AuctionItem {
  final String title;
  final String image;
  final int bid;
  final int secs;
  final bool winning;
  final bool wishlisted;
  /// Warna aksen opsional dalam format ARGB (mis. `0xFF1565C0`).
  /// Ubah ke `Color` lewat `AuctionItemStyle.tintColor` di presentation.
  final int? tint;
  final AuctionCategory category;

  const AuctionItem({
    required this.title,
    required this.image,
    required this.bid,
    required this.secs,
    required this.category,
    this.winning = false,
    this.wishlisted = false,
    this.tint,
  });
}
