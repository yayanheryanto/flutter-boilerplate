import 'package:emas/hive_registrar.g.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:emas/core/constants/constants.dart';
import 'package:emas/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies(String environment) async {
  await Hive.initFlutter();
  Hive.registerAdapters(); // ← tambahkan ini, siap untuk nanti
  // Use Box<dynamic> so HiveTokenService and AuthLocalDataSource can use Hive.box() without type mismatch.
  if (!Hive.isBoxOpen(Constants.authBox)) {
    await Hive.openBox<dynamic>(Constants.authBox);
  }
  if (!Hive.isBoxOpen(Constants.settingsBox)) {
    await Hive.openBox<dynamic>(Constants.settingsBox);
  }
  if (!Hive.isBoxOpen(Constants.cacheBox)) {
    await Hive.openBox<dynamic>(Constants.cacheBox);
  }

  getIt.init(environment: environment);
}
