import 'package:emas/features/dashboard/presentation/sections/home/auction_schedule_card.dart';
import 'package:flutter/material.dart';

import 'package:emas/features/auction/domain/entities/auction_item.dart';

// TODO(api): data dummy tab beranda — ganti dengan data dari BLoC/repository.

// ── Tawaran aktif saya ────────────────────────────────────────────────────────

const List<AuctionItem> dummyMyBids = [
  AuctionItem(title: 'Honda PCX 160 2022',      image: '🏍️', bid: 22500000,  secs: 925,  winning: true,  category: AuctionCategory.motor),
  AuctionItem(title: 'iPhone 15 Pro Max 256GB', image: '📱', bid: 18750000,  secs: 3210,                  category: AuctionCategory.elektronik),
  AuctionItem(title: 'Toyota Avanza 2021',      image: '🚗', bid: 195000000, secs: 7890, winning: true,  category: AuctionCategory.mobil),
];

// ── Segera berakhir ───────────────────────────────────────────────────────────

const List<AuctionItem> dummyEndingSoon = [
  AuctionItem(title: 'Yamaha NMAX 155 ABS',     image: '🏍️', bid: 19800000,  secs: 312,  category: AuctionCategory.motor),
  AuctionItem(title: 'MacBook Air M2 256GB',    image: '💻', bid: 14200000,  secs: 874,  category: AuctionCategory.elektronik),
  AuctionItem(title: 'Honda Brio RS 2023',      image: '🚗', bid: 168000000, secs: 1543, category: AuctionCategory.mobil),
  AuctionItem(title: 'Samsung S24 Ultra 512GB', image: '📱', bid: 16400000,  secs: 2211, category: AuctionCategory.elektronik),
];

// ── Rekomendasi ───────────────────────────────────────────────────────────────

const List<AuctionItem> dummyRecommended = [
  AuctionItem(title: 'Suzuki GSX-R150 2022',    image: '🏍️', bid: 24500000,  secs: 18340, tint: 0xFF1565C0, category: AuctionCategory.motor),
  AuctionItem(title: 'Mitsubishi Xpander 2023', image: '🚗', bid: 218000000, secs: 43200, tint: 0xFF2E7D32, category: AuctionCategory.mobil),
  AuctionItem(title: 'iPad Pro 12.9" M2 WiFi',  image: '📱', bid: 13900000,  secs: 86400, wishlisted: true, tint: 0xFF6A1B9A, category: AuctionCategory.elektronik),
];

// ── Jadwal Lelang ─────────────────────────────────────────────────────────────

const List<AuctionScheduleData> dummyAuctionSchedule = [
  AuctionScheduleData(
    itemName: 'Motor',
    locationName: 'Mega Finance Fatmawati',
    dateLabel: '12 Jun 2026',
    timeLabel: '10.00',
    image: '🏍️',
  ),
  AuctionScheduleData(
    itemName: 'Motor',
    locationName: 'Mega Finance Depok',
    dateLabel: '13 Jun 2026',
    timeLabel: '09.00',
    image: '🏍️',
  ),
  AuctionScheduleData(
    itemName: 'Mobil',
    locationName: 'Mega Finance Bekasi',
    dateLabel: '14 Jun 2026',
    timeLabel: '13.00',
    image: '🚗',
    tint: Color(0xFFBBDEFB),
  ),
];
