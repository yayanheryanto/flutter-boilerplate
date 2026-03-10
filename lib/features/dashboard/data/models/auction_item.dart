import 'package:flutter/material.dart';

class AuctionItem {
  final String title;
  final String emoji;
  final int bid;
  final int secs;
  final bool winning;
  final bool wishlisted;
  final Color? tint;

  const AuctionItem({
    required this.title,
    required this.emoji,
    required this.bid,
    required this.secs,
    this.winning = false,
    this.wishlisted = false,
    this.tint,
  });
}
