import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:boilerplate/core/constants/app_constants.dart';
import 'package:boilerplate/core/di/injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies(String environment) async {
  await Hive.initFlutter();
  // Use Box<dynamic> so HiveTokenService and AuthLocalDataSource can use Hive.box() without type mismatch.
  if (!Hive.isBoxOpen(AppConstants.authBox)) {
    await Hive.openBox<dynamic>(AppConstants.authBox);
  }
  if (!Hive.isBoxOpen(AppConstants.settingsBox)) {
    await Hive.openBox<dynamic>(AppConstants.settingsBox);
  }
  if (!Hive.isBoxOpen(AppConstants.cacheBox)) {
    await Hive.openBox<dynamic>(AppConstants.cacheBox);
  }

  getIt.init(environment: environment);
}
