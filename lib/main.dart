import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:boilerplate/core/config/app_config.dart';
import 'package:boilerplate/core/config/env.dart';
import 'package:boilerplate/core/di/injection.dart';
import 'package:boilerplate/core/firebase/firebase_options_dev.dart';
import 'package:boilerplate/core/firebase/notification_bloc.dart';
import 'package:boilerplate/core/firebase/notification_service.dart';
import 'package:boilerplate/core/router/app_router.dart';
import 'package:boilerplate/core/theme/app_theme.dart';
import 'package:boilerplate/core/utils/app_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize environment
  const env = Environment.prod;
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

  Bloc.observer = AppBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().router;

    return MultiBlocProvider(
      providers: [
        BlocProvider<NotificationBloc>(
          create: (_) => getIt<NotificationBloc>()
            ..add(NotificationStartListening()),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: router,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
