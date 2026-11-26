import 'package:flutter/material.dart';

import 'package:emas/features/auction/domain/entities/auction_item.dart';

/// Atribut visual [AuctionCategory] — sengaja dipisah dari entity domain
/// agar domain tidak bergantung pada Flutter.
extension AuctionCategoryStyle on AuctionCategory {
  Color get color => switch (this) {
        AuctionCategory.motor => const Color(0xFFFF6F00),
        AuctionCategory.mobil => const Color(0xFF1565C0),
        AuctionCategory.elektronik => const Color(0xFF6A1B9A),
        AuctionCategory.properti => const Color(0xFF2E7D32),
        AuctionCategory.mewah => const Color(0xFFAD1457),
        AuctionCategory.lainnya => const Color(0xFF546E7A),
      };
}

extension AuctionItemStyle on AuctionItem {
  /// [AuctionItem.tint] (ARGB) sebagai [Color], atau `null` bila tidak diset.
  Color? get tintColor {
    final value = tint;
    return value == null ? null : Color(value);
  }
}
