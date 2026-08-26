import 'package:emas/features/dashboard/presentation/sections/home/auction_schedule_card.dart';
import 'package:flutter/material.dart';

import 'package:emas/features/dashboard/domain/entities/auction_item.dart';

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
  AuctionItem(title: 'Suzuki GSX-R150 2022',    image: '🏍️', bid: 24500000,  secs: 18340, tint: Color(0xFF1565C0), category: AuctionCategory.motor),
  AuctionItem(title: 'Mitsubishi Xpander 2023', image: '🚗', bid: 218000000, secs: 43200, tint: Color(0xFF2E7D32), category: AuctionCategory.mobil),
  AuctionItem(title: 'iPad Pro 12.9" M2 WiFi',  image: '📱', bid: 13900000,  secs: 86400, wishlisted: true, tint: Color(0xFF6A1B9A), category: AuctionCategory.elektronik),
];

// ── Data per kategori ─────────────────────────────────────────────────────────

const List<AuctionItem> dummyAllItems = [
  // Motor
  AuctionItem(title: 'Honda PCX 160 2022',       image: '🏍️', bid: 22500000,  secs: 925,   category: AuctionCategory.motor),
  AuctionItem(title: 'Yamaha NMAX 155 ABS',      image: '🏍️', bid: 19800000,  secs: 312,   category: AuctionCategory.motor),
  AuctionItem(title: 'Suzuki GSX-R150 2022',     image: '🏍️', bid: 24500000,  secs: 18340, category: AuctionCategory.motor),
  AuctionItem(title: 'Honda CBR 150R 2023',      image: '🏍️', bid: 28000000,  secs: 7200,  category: AuctionCategory.motor),
  AuctionItem(title: 'Kawasaki KLX 150 BF',      image: '🏍️', bid: 21000000,  secs: 3600,  category: AuctionCategory.motor),
  AuctionItem(title: 'Yamaha R15 V4 2023',       image: '🏍️', bid: 32500000,  secs: 54000, category: AuctionCategory.motor),

  // Mobil
  AuctionItem(title: 'Toyota Avanza 2021',       image: '🚗', bid: 195000000, secs: 7890,  category: AuctionCategory.mobil),
  AuctionItem(title: 'Honda Brio RS 2023',       image: '🚗', bid: 168000000, secs: 1543,  category: AuctionCategory.mobil),
  AuctionItem(title: 'Mitsubishi Xpander 2023',  image: '🚗', bid: 218000000, secs: 43200, category: AuctionCategory.mobil),
  AuctionItem(title: 'Daihatsu Rocky 2022',      image: '🚗', bid: 185000000, secs: 9000,  category: AuctionCategory.mobil),
  AuctionItem(title: 'Honda HR-V 1.5 SE CVT',    image: '🚗', bid: 245000000, secs: 21600, category: AuctionCategory.mobil),
  AuctionItem(title: 'Toyota Innova Zenix 2023', image: '🚗', bid: 390000000, secs: 86400, category: AuctionCategory.mobil),

  // Elektronik
  AuctionItem(title: 'iPhone 15 Pro Max 256GB',  image: '📱', bid: 18750000,  secs: 3210,  category: AuctionCategory.elektronik),
  AuctionItem(title: 'MacBook Air M2 256GB',     image: '💻', bid: 14200000,  secs: 874,   category: AuctionCategory.elektronik),
  AuctionItem(title: 'Samsung S24 Ultra 512GB',  image: '📱', bid: 16400000,  secs: 2211,  category: AuctionCategory.elektronik),
  AuctionItem(title: 'iPad Pro 12.9" M2 WiFi',  image: '📱', bid: 13900000,  secs: 86400, wishlisted: true, category: AuctionCategory.elektronik),
  AuctionItem(title: 'Sony WH-1000XM5',          image: '🎧', bid: 3800000,   secs: 14400, category: AuctionCategory.elektronik),
  AuctionItem(title: 'Samsung QLED 65" 4K',      image: '📺', bid: 11500000,  secs: 28800, category: AuctionCategory.elektronik),

  // Properti
  AuctionItem(title: 'Kavling Ciputat 120m²',    image: '🏠', bid: 450000000, secs: 86400, category: AuctionCategory.properti),
  AuctionItem(title: 'Rumah Depok 2KT 90m²',    image: '🏠', bid: 620000000, secs: 72000, category: AuctionCategory.properti),
  AuctionItem(title: 'Ruko Fatmawati 4 Lantai',  image: '🏢', bid: 1800000000, secs: 43200, category: AuctionCategory.properti),
  AuctionItem(title: 'Apartemen Kuningan 28m²',  image: '🏙️', bid: 380000000, secs: 54000, category: AuctionCategory.properti),

  // Mewah
  AuctionItem(title: 'Rolex Submariner Date',    image: '⌚', bid: 125000000, secs: 7200,  category: AuctionCategory.mewah),
  AuctionItem(title: 'Tas Hermes Birkin 30',     image: '👜', bid: 220000000, secs: 18000, category: AuctionCategory.mewah),
  AuctionItem(title: 'Berlian 1.5 Ct VVS1',      image: '💎', bid: 95000000,  secs: 28800, wishlisted: true, category: AuctionCategory.mewah),
  AuctionItem(title: 'Louis Vuitton Neverfull',  image: '👜', bid: 18500000,  secs: 3600,  category: AuctionCategory.mewah),

  // Lainnya
  AuctionItem(title: 'Sepeda Brompton C Line',   image: '🚲', bid: 28000000,  secs: 9000,  category: AuctionCategory.lainnya),
  AuctionItem(title: 'Kamera Sony A7 IV',        image: '📷', bid: 32000000,  secs: 21600, category: AuctionCategory.lainnya),
  AuctionItem(title: 'Set Golf Titleist 2023',   image: '⛳', bid: 15000000,  secs: 43200, category: AuctionCategory.lainnya),
  AuctionItem(title: 'Mesin Espresso La Marzocco', image: '☕', bid: 42000000, secs: 14400, category: AuctionCategory.lainnya),
];

List<AuctionItem> itemsByCategory(AuctionCategory category) =>
    dummyAllItems.where((e) => e.category == category).toList();

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
