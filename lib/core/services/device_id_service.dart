import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/constants/constants.dart';
import 'package:emas/core/utils/uuid_generator.dart';

/// Identitas perangkat yang dikirim ke backend (mis. saat login & register).
abstract class DeviceIdService {
  /// ID stabil untuk instalasi aplikasi ini.
  Future<String> getDeviceId();
}

/// Device id berbasis **ID instalasi**: UUID v4 dibuat sekali lalu disimpan
/// di Hive (`settings_box`).
///
/// - Tetap sama setelah logout/login atau aplikasi ditutup.
/// - Berubah bila aplikasi di-uninstall atau datanya dihapus.
///
/// Sengaja tidak memakai ID hardware: Android ID tidak lagi tersedia di
/// `device_info_plus`, dan Google menyarankan ID per-instalasi untuk privasi.
@LazySingleton(as: DeviceIdService)
class HiveDeviceIdService implements DeviceIdService {
  Box<dynamic> get _box => Hive.box(Constants.settingsBox);

  String? _cached;

  @override
  Future<String> getDeviceId() async {
    final cached = _cached;
    if (cached != null) return cached;

    final stored = _box.get(Constants.deviceIdKey) as String?;
    if (stored != null && stored.isNotEmpty) return _cached = stored;

    final created = generateUuidV4();
    await _box.put(Constants.deviceIdKey, created);
    return _cached = created;
  }
}
