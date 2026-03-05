// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:image_picker/image_picker.dart' as _i6;
import 'package:injectable/injectable.dart' as _i2;

import '../../features/auth/data/datasources/auth_local_datasource.dart' as _i8;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i19;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i21;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i20;
import '../../features/auth/domain/usecases/auth/auth_usecase.dart' as _i28;
import '../../features/auth/domain/usecases/auth/forgot_password_usecase.dart'
    as _i22;
import '../../features/auth/domain/usecases/auth/get_cached_usecase.dart'
    as _i23;
import '../../features/auth/domain/usecases/auth/login_usecase.dart' as _i24;
import '../../features/auth/domain/usecases/auth/logout_usecase.dart' as _i25;
import '../../features/auth/domain/usecases/auth/register_usecase.dart' as _i26;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i27;
import '../firebase/firebase_services.dart' as _i11;
import '../firebase/notification_bloc.dart' as _i14;
import '../firebase/notification_service.dart' as _i10;
import '../network/dio_client.dart' as _i18;
import '../network/interceptors/auth_interceptor.dart' as _i17;
import '../network/interceptors/logging_interceptor.dart' as _i3;
import '../network/interceptors/retry_interceptor.dart' as _i4;
import '../router/app_router.dart' as _i5;
import '../services/camera_service.dart' as _i15;
import '../services/connectivity_service.dart' as _i16;
import '../services/file_picker_service.dart' as _i9;
import '../services/permission_service.dart' as _i12;
import '../services/token_service.dart' as _i13;
import 'app_module.dart' as _i29;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.singleton<_i3.LoggingInterceptor>(() => _i3.LoggingInterceptor());
    gh.singleton<_i4.RetryInterceptor>(() => _i4.RetryInterceptor());
    gh.singleton<_i5.AppRouter>(() => _i5.AppRouter());
    gh.lazySingleton<_i6.ImagePicker>(() => appModule.imagePicker);
    gh.lazySingleton<_i7.Connectivity>(() => appModule.connectivity);
    gh.lazySingleton<_i8.AuthLocalDataSource>(
        () => _i8.HiveAuthLocalDataSource());
    gh.lazySingleton<_i9.FilePickerService>(() => _i9.FilePickerServiceImpl());
    gh.lazySingleton<_i10.NotificationService>(
        () => _i10.AppNotificationService());
    gh.lazySingleton<_i11.CrashlyticsService>(
        () => _i11.FirebaseCrashlyticsService());
    gh.lazySingleton<_i11.RemoteConfigService>(
        () => _i11.FirebaseRemoteConfigService());
    gh.lazySingleton<_i11.AnalyticsService>(
        () => _i11.FirebaseAnalyticsService());
    gh.lazySingleton<_i12.PermissionService>(
        () => _i12.PermissionServiceImpl());
    gh.lazySingleton<_i13.TokenService>(() => _i13.HiveTokenService());
    gh.factory<_i14.NotificationBloc>(
        () => _i14.NotificationBloc(gh<_i10.NotificationService>()));
    gh.lazySingleton<_i15.CameraService>(
        () => _i15.CameraServiceImpl(gh<_i6.ImagePicker>()));
    gh.lazySingleton<_i16.ConnectivityService>(
        () => _i16.ConnectivityServiceImpl(gh<_i7.Connectivity>()));
    gh.singleton<_i17.AuthInterceptor>(
        () => _i17.AuthInterceptor(gh<_i13.TokenService>()));
    gh.singleton<_i18.DioClient>(() => _i18.DioClient(
          gh<_i17.AuthInterceptor>(),
          gh<_i3.LoggingInterceptor>(),
          gh<_i4.RetryInterceptor>(),
        ));
    gh.factory<_i19.AuthRemoteDataSource>(
        () => appModule.authRemoteDataSource(gh<_i18.DioClient>()));
    gh.lazySingleton<_i20.AuthRepository>(() => _i21.AuthRepositoryImpl(
          gh<_i19.AuthRemoteDataSource>(),
          gh<_i8.AuthLocalDataSource>(),
          gh<_i13.TokenService>(),
        ));
    gh.factory<_i22.ForgotPasswordUseCase>(
        () => _i22.ForgotPasswordUseCase(gh<_i20.AuthRepository>()));
    gh.factory<_i23.GetCachedAuthUseCase>(
        () => _i23.GetCachedAuthUseCase(gh<_i20.AuthRepository>()));
    gh.factory<_i24.LoginUseCase>(
        () => _i24.LoginUseCase(gh<_i20.AuthRepository>()));
    gh.factory<_i25.LogoutUseCase>(
        () => _i25.LogoutUseCase(gh<_i20.AuthRepository>()));
    gh.factory<_i26.RegisterUseCase>(
        () => _i26.RegisterUseCase(gh<_i20.AuthRepository>()));
    gh.factory<_i27.AuthBloc>(() => _i27.AuthBloc(
          gh<_i28.LoginUseCase>(),
          gh<_i28.RegisterUseCase>(),
          gh<_i28.LogoutUseCase>(),
          gh<_i28.GetCachedAuthUseCase>(),
          gh<_i28.ForgotPasswordUseCase>(),
          gh<_i11.AnalyticsService>(),
          gh<_i11.CrashlyticsService>(),
        ));
    return this;
  }
}

class _$AppModule extends _i29.AppModule {}
