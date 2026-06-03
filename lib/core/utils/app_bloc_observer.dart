import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emas/core/utils/app_logger.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    AppLogger.d('onCreate -- ${bloc.runtimeType}', tag: 'BLOC');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    AppLogger.d(
      'onChange -- ${bloc.runtimeType}, $change',
      tag: 'BLOC',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    AppLogger.e(
      'onError -- ${bloc.runtimeType}, $error',
      tag: 'BLOC',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    AppLogger.d(
      'onTransition -- ${bloc.runtimeType}, $transition',
      tag: 'BLOC',
    );
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    AppLogger.d('onClose -- ${bloc.runtimeType}', tag: 'BLOC');
  }
}
