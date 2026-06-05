import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emas/core/config/app_config.dart';
import 'package:emas/core/config/env.dart';
import 'package:emas/core/di/injection.dart';
import 'package:emas/core/firebase/firebase_options_dev.dart';
import 'package:emas/core/bloc/notification_bloc.dart';
import 'package:emas/core/firebase/notification_service.dart';
import 'package:emas/core/router/app_router.dart';
import 'package:emas/shared/theme/app_theme.dart';
import 'package:emas/core/utils/app_bloc_observer.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>().router;

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<NotificationBloc>(
              create: (_) => getIt<NotificationBloc>()..add(NotificationStartListening()),
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
      },
    );
  }
}
