import 'dart:math';

/// UUID versi 4 (acak), mis. `79465b44-3f8e-4b9c-b43b-1626cea61ee6`.
///
/// Memakai [Random.secure] sehingga aman dipakai sebagai identitas
/// (device id). Ditulis manual agar tidak perlu dependency tambahan.
String generateUuidV4({Random? random}) {
  final rng = random ?? Random.secure();
  final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40; // versi 4
  bytes[8] = (bytes[8] & 0x3f) | 0x80; // varian RFC 4122
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}
