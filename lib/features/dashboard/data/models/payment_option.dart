import 'package:flutter/material.dart';

class PaymentOption {
  final String id;
  final String name;
  final String activationHint;
  final IconData icon;
  final Color iconBackgroundColor;

  const PaymentOption({
    required this.id,
    required this.name,
    required this.activationHint,
    required this.icon,
    required this.iconBackgroundColor,
  });
}

/// Dummy daftar opsi pembayaran — ganti dengan hasil API begitu tersedia.
const dummyPaymentOptions = [
  PaymentOption(
    id: 'allo-wallet',
    name: 'Allo Wallet',
    activationHint: 'Aktivasi Allo Wallet Sekarang!',
    icon: Icons.account_balance_wallet_rounded,
    iconBackgroundColor: Color(0xFF1E1B2E),
  ),
  PaymentOption(
    id: 'mpc-points',
    name: 'MPC Points',
    activationHint: 'Aktivasi MPC Points Sekarang!',
    icon: Icons.workspace_premium_rounded,
    iconBackgroundColor: Color(0xFFF99D1C),
  ),
];
