String formatRupiah(int n) {
  if (n >= 1000000) {
    final jt = n / 1000000;
    return 'Rp ${jt == jt.truncateToDouble() ? jt.toInt() : jt.toStringAsFixed(1)} jt';
  }
  return 'Rp ${(n / 1000).toInt()} rb';
}

String formatTimer(int s) {
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sc = s % 60;
  final mm = m.toString().padLeft(2, '0');
  final ss = sc.toString().padLeft(2, '0');
  return h > 0 ? '${h.toString().padLeft(2, '0')}:$mm:$ss' : '$mm:$ss';
}
