import 'package:flutter/material.dart';

import 'package:boilerplate/features/dashboard/data/models/auction_item.dart';

const List<AuctionItem> dummyMyBids = [
  AuctionItem(title: 'Honda PCX 160 2022',      emoji: '🏍️', bid: 22500000,  secs: 925,  winning: true),
  AuctionItem(title: 'iPhone 15 Pro Max 256GB', emoji: '📱', bid: 18750000,  secs: 3210),
  AuctionItem(title: 'Toyota Avanza 2021',       emoji: '🚗', bid: 195000000, secs: 7890, winning: true),
];

const List<AuctionItem> dummyEndingSoon = [
  AuctionItem(title: 'Yamaha NMAX 155 ABS',      emoji: '🏍️', bid: 19800000,  secs: 312),
  AuctionItem(title: 'MacBook Air M2 256GB',     emoji: '💻', bid: 14200000,  secs: 874),
  AuctionItem(title: 'Honda Brio RS 2023',        emoji: '🚗', bid: 168000000, secs: 1543),
  AuctionItem(title: 'Samsung S24 Ultra 512GB',  emoji: '📱', bid: 16400000,  secs: 2211),
];

const List<AuctionItem> dummyRecommended = [
  AuctionItem(title: 'Suzuki GSX-R150 2022',    emoji: '🏍️', bid: 24500000,  secs: 18340, tint: Color(0xFF1565C0)),
  AuctionItem(title: 'Mitsubishi Xpander 2023', emoji: '🚗', bid: 218000000, secs: 43200, tint: Color(0xFF2E7D32)),
  AuctionItem(title: 'iPad Pro 12.9" M2 WiFi',  emoji: '📱', bid: 13900000,  secs: 86400, wishlisted: true, tint: Color(0xFF6A1B9A)),
];
