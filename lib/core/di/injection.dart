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
  await Hive.openBox<void>(AppConstants.authBox);
  await Hive.openBox<void>(AppConstants.settingsBox);
  await Hive.openBox<void>(AppConstants.cacheBox);

  getIt.init(environment: environment);
}
