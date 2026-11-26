import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:emas/app/app.dart';
import 'package:emas/core/config/app_config.dart';
import 'package:emas/core/config/env.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/firebase/firebase_options_dev.dart';
import 'package:emas/core/firebase/firebase_options_prod.dart';
import 'package:emas/core/firebase/firebase_options_staging.dart';
import 'package:emas/core/firebase/notification_service.dart';
import 'package:emas/core/utils/app_bloc_observer.dart';

/// Satu-satunya jalur inisialisasi aplikasi. Entry point per environment
/// (`main.dart`, `main.dev.dart`, `main.stag.dart`) cukup memanggil ini.
Future<void> bootstrap(Environment env) async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  AppConfig.initialize(env);

  if (AppConfig.isFirebaseEnabled) {
    await Firebase.initializeApp(options: _firebaseOptionsFor(env));
  }

  await configureDependencies(env.name);

  await getIt<NotificationService>().initialize();
  await initializeDateFormatting('id_ID');

  Bloc.observer = AppBlocObserver();

  runApp(const App());
}

FirebaseOptions _firebaseOptionsFor(Environment env) {
  switch (env) {
    case Environment.dev:
      return DevFirebaseOptions.currentPlatform;
    case Environment.stag:
      return StagingFirebaseOptions.currentPlatform;
    case Environment.prod:
      return ProdFirebaseOptions.currentPlatform;
  }
}
