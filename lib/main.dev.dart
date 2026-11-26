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
import 'package:emas/core/firebase/notification_service.dart';
import 'package:emas/core/utils/app_bloc_observer.dart';

/// Entry point Development.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize environment
  const env = Environment.dev;
  AppConfig.initialize(env);

  // Initialize Firebase
  if (AppConfig.isFirebaseEnabled) {
    await Firebase.initializeApp(
      options: DevFirebaseOptions.currentPlatform,
    );
  }

  // Configure dependency injection
  await configureDependencies(env.name);

  // Initialize notification service
  await getIt<NotificationService>().initialize();
  await initializeDateFormatting('id_ID');

  Bloc.observer = AppBlocObserver();

  runApp(const App());
}
