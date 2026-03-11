import 'package:flutter/material.dart';

/// Kategori lelang — satu sumber kebenaran untuk label, emoji, warna, dan slug routing.
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

  String get emoji => const {
    AuctionCategory.motor: '🏍️',
    AuctionCategory.mobil: '🚗',
    AuctionCategory.elektronik: '📱',
    AuctionCategory.properti: '🏠',
    AuctionCategory.mewah: '💎',
    AuctionCategory.lainnya: '🛠️',
  }[this]!;

  Color get color => const {
    AuctionCategory.motor: Color(0xFFFF6F00),
    AuctionCategory.mobil: Color(0xFF1565C0),
    AuctionCategory.elektronik: Color(0xFF6A1B9A),
    AuctionCategory.properti: Color(0xFF2E7D32),
    AuctionCategory.mewah: Color(0xFFAD1457),
    AuctionCategory.lainnya: Color(0xFF546E7A),
  }[this]!;
}

class AuctionItem {
  final String title;
  final String emoji;
  final int bid;
  final int secs;
  final bool winning;
  final bool wishlisted;
  final Color? tint;
  final AuctionCategory category;

  const AuctionItem({
    required this.title,
    required this.emoji,
    required this.bid,
    required this.secs,
    required this.category,
    this.winning = false,
    this.wishlisted = false,
    this.tint,
  });
}
