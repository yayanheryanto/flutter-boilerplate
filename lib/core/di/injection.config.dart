// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/datasources/auth_local_datasource.dart'
    as _i992;
import '../../features/auth/data/datasources/auth_remote_datasource.dart'
    as _i161;
import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/di/auth_module.dart' as _i433;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/domain/usecases/auth/auth_usecase.dart' as _i370;
import '../../features/auth/domain/usecases/auth/forgot_password_usecase.dart'
    as _i911;
import '../../features/auth/domain/usecases/auth/get_cached_usecase.dart'
    as _i25;
import '../../features/auth/domain/usecases/auth/login_usecase.dart' as _i985;
import '../../features/auth/domain/usecases/auth/logout_usecase.dart' as _i726;
import '../../features/auth/domain/usecases/auth/register_usecase.dart' as _i47;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/dashboard/data/datasources/live_auction_socket_datasource.dart'
    as _i702;
import '../../features/dashboard/presentation/bloc/live_auction/live_auction_bloc.dart'
    as _i899;
import '../bloc/notification_bloc.dart' as _i1015;
import '../firebase/firebase_services.dart' as _i454;
import '../firebase/notification_service.dart' as _i650;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/interceptors/logging_interceptor.dart' as _i344;
import '../network/interceptors/retry_interceptor.dart' as _i914;
import '../router/app_router.dart' as _i81;
import '../services/camera_service.dart' as _i860;
import '../services/connectivity_service.dart' as _i47;
import '../services/file_picker_service.dart' as _i108;
import '../services/permission_service.dart' as _i165;
import '../services/socket/app_socket_service.dart' as _i145;
import '../services/socket/dummy_socket_service.dart' as _i436;
import '../services/token_service.dart' as _i227;
import 'app_module.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    final authModule = _$AuthModule();
    gh.singleton<_i344.LoggingInterceptor>(() => _i344.LoggingInterceptor());
    gh.singleton<_i914.RetryInterceptor>(() => _i914.RetryInterceptor());
    gh.singleton<_i81.AppRouter>(() => _i81.AppRouter());
    gh.lazySingleton<_i183.ImagePicker>(() => appModule.imagePicker);
    gh.lazySingleton<_i895.Connectivity>(() => appModule.connectivity);
    gh.lazySingleton<_i454.CrashlyticsService>(
        () => _i454.FirebaseCrashlyticsService());
    gh.lazySingleton<_i108.FilePickerService>(
        () => _i108.FilePickerServiceImpl());
    gh.lazySingleton<_i165.PermissionService>(
        () => _i165.PermissionServiceImpl());
    gh.lazySingleton<_i992.AuthLocalDataSource>(
        () => _i992.HiveAuthLocalDataSource());
    gh.lazySingleton<_i454.AnalyticsService>(
        () => _i454.FirebaseAnalyticsService());
    gh.lazySingleton<_i145.AppSocketService>(() => _i436.DummySocketService());
    gh.lazySingleton<_i454.RemoteConfigService>(
        () => _i454.FirebaseRemoteConfigService());
    gh.lazySingleton<_i227.TokenService>(() => _i227.HiveTokenService());
    gh.lazySingleton<_i650.NotificationService>(
        () => _i650.AppNotificationService());
    gh.lazySingleton<_i860.CameraService>(
        () => _i860.CameraServiceImpl(gh<_i183.ImagePicker>()));
    gh.singleton<_i745.AuthInterceptor>(
        () => _i745.AuthInterceptor(gh<_i227.TokenService>()));
    gh.lazySingleton<_i47.ConnectivityService>(
        () => _i47.ConnectivityServiceImpl(gh<_i895.Connectivity>()));
    gh.factory<_i702.LiveAuctionSocketDataSource>(() =>
        _i702.LiveAuctionSocketDataSourceImpl(gh<_i145.AppSocketService>()));
    gh.factory<_i1015.NotificationBloc>(
        () => _i1015.NotificationBloc(gh<_i650.NotificationService>()));
    gh.factory<_i899.LiveAuctionBloc>(
        () => _i899.LiveAuctionBloc(gh<_i702.LiveAuctionSocketDataSource>()));
    gh.singleton<_i667.DioClient>(() => _i667.DioClient(
          gh<_i745.AuthInterceptor>(),
          gh<_i344.LoggingInterceptor>(),
          gh<_i914.RetryInterceptor>(),
        ));
    gh.lazySingleton<_i161.AuthRemoteDataSource>(
        () => authModule.authRemoteDataSource(gh<_i667.DioClient>()));
    gh.lazySingleton<_i787.AuthRepository>(() => _i153.AuthRepositoryImpl(
          gh<_i161.AuthRemoteDataSource>(),
          gh<_i992.AuthLocalDataSource>(),
          gh<_i227.TokenService>(),
        ));
    gh.factory<_i911.ForgotPasswordUseCase>(
        () => _i911.ForgotPasswordUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i25.GetCachedAuthUseCase>(
        () => _i25.GetCachedAuthUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i985.LoginUseCase>(
        () => _i985.LoginUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i726.LogoutUseCase>(
        () => _i726.LogoutUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i47.RegisterUseCase>(
        () => _i47.RegisterUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          gh<_i370.LoginUseCase>(),
          gh<_i370.RegisterUseCase>(),
          gh<_i370.LogoutUseCase>(),
          gh<_i370.GetCachedAuthUseCase>(),
          gh<_i370.ForgotPasswordUseCase>(),
          gh<_i454.AnalyticsService>(),
          gh<_i454.CrashlyticsService>(),
        ));
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}

class _$AuthModule extends _i433.AuthModule {}
