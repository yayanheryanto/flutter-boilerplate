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

import '../../app/di/mock_module.dart' as _i53;
import '../../app/router/app_router.dart' as _i180;
import '../../features/auction/data/datasources/auction_datasource.dart'
    as _i595;
import '../../features/auction/data/repositories/auction_repository_impl.dart'
    as _i350;
import '../../features/auction/domain/repositories/auction_repository.dart'
    as _i256;
import '../../features/auction/domain/usecases/get_auction_list_usecase.dart'
    as _i297;
import '../../features/auction/domain/usecases/get_auctions_by_category_usecase.dart'
    as _i687;
import '../../features/auction/presentation/bloc/auction_detail/auction_detail_bloc.dart'
    as _i875;
import '../../features/auction/presentation/bloc/auction_list/auction_list_bloc.dart'
    as _i189;
import '../../features/auction/presentation/bloc/category/category_bloc.dart'
    as _i423;
import '../../features/auction/presentation/bloc/join_auction/join_auction_bloc.dart'
    as _i847;
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
import '../../features/auth/domain/usecases/auth/otp_usecase.dart' as _i880;
import '../../features/auth/domain/usecases/auth/register_usecase.dart' as _i47;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/auth/presentation/bloc/otp/otp_bloc.dart' as _i75;
import '../../features/auth/presentation/bloc/register/register_bloc.dart'
    as _i210;
import '../../features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart'
    as _i72;
import '../../features/live_auction/data/datasources/live_auction_socket_datasource.dart'
    as _i302;
import '../../features/live_auction/data/repositories/live_auction_repository_impl.dart'
    as _i439;
import '../../features/live_auction/domain/repositories/live_auction_repository.dart'
    as _i57;
import '../../features/live_auction/domain/usecases/live_auction_usecases.dart'
    as _i891;
import '../../features/live_auction/presentation/bloc/live_auction_bloc.dart'
    as _i470;
import '../../features/npl/presentation/bloc/buy_npl_confirmation/buy_npl_confirmation_bloc.dart'
    as _i544;
import '../../features/npl/presentation/bloc/buy_npl_detail/buy_npl_detail_bloc.dart'
    as _i520;
import '../../features/profile/presentation/bloc/logout/logout_cubit.dart'
    as _i4001;
import '../bloc/notification_bloc.dart' as _i1015;
import '../firebase/firebase_services.dart' as _i454;
import '../firebase/notification_service.dart' as _i650;
import '../network/dio_client.dart' as _i667;
import '../network/interceptors/auth_interceptor.dart' as _i745;
import '../network/interceptors/logging_interceptor.dart' as _i344;
import '../network/interceptors/mock_interceptor.dart' as _i392;
import '../network/interceptors/retry_interceptor.dart' as _i914;
import '../network/mock/mock_api.dart' as _i1005;
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
    final mockModule = _$MockModule();
    final appModule = _$AppModule();
    final authModule = _$AuthModule();
    gh.factory<_i875.AuctionDetailBloc>(() => _i875.AuctionDetailBloc());
    gh.factory<_i847.JoinAuctionBloc>(() => _i847.JoinAuctionBloc());
    gh.factory<_i72.DashboardBloc>(() => _i72.DashboardBloc());
    gh.factory<_i544.BuyNplConfirmationBloc>(
        () => _i544.BuyNplConfirmationBloc());
    gh.factory<_i520.BuyNplDetailBloc>(() => _i520.BuyNplDetailBloc());
    gh.singleton<_i180.AppRouter>(() => _i180.AppRouter());
    gh.singleton<_i344.LoggingInterceptor>(() => _i344.LoggingInterceptor());
    gh.singleton<_i914.RetryInterceptor>(() => _i914.RetryInterceptor());
    gh.singleton<_i1005.MockRegistry>(() => mockModule.mockRegistry);
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
    gh.factory<_i595.AuctionDataSource>(() => _i595.AuctionDummyDataSource());
    gh.lazySingleton<_i454.AnalyticsService>(
        () => _i454.FirebaseAnalyticsService());
    gh.singleton<_i392.MockInterceptor>(
        () => _i392.MockInterceptor(gh<_i1005.MockRegistry>()));
    gh.lazySingleton<_i145.AppSocketService>(() => _i436.DummySocketService());
    gh.lazySingleton<_i454.RemoteConfigService>(
        () => _i454.FirebaseRemoteConfigService());
    gh.lazySingleton<_i227.TokenService>(() => _i227.HiveTokenService());
    gh.lazySingleton<_i650.NotificationService>(
        () => _i650.AppNotificationService());
    gh.factory<_i302.LiveAuctionSocketDataSource>(() =>
        _i302.LiveAuctionSocketDataSourceImpl(gh<_i145.AppSocketService>()));
    gh.lazySingleton<_i860.CameraService>(
        () => _i860.CameraServiceImpl(gh<_i183.ImagePicker>()));
    gh.factory<_i57.LiveAuctionRepository>(() =>
        _i439.LiveAuctionRepositoryImpl(
            gh<_i302.LiveAuctionSocketDataSource>()));
    gh.singleton<_i745.AuthInterceptor>(
        () => _i745.AuthInterceptor(gh<_i227.TokenService>()));
    gh.lazySingleton<_i47.ConnectivityService>(
        () => _i47.ConnectivityServiceImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i256.AuctionRepository>(
        () => _i350.AuctionRepositoryImpl(gh<_i595.AuctionDataSource>()));
    gh.factory<_i1015.NotificationBloc>(
        () => _i1015.NotificationBloc(gh<_i650.NotificationService>()));
    gh.factory<_i687.GetAuctionsByCategoryUseCase>(() =>
        _i687.GetAuctionsByCategoryUseCase(gh<_i256.AuctionRepository>()));
    gh.factory<_i297.GetAuctionListUseCase>(
        () => _i297.GetAuctionListUseCase(gh<_i256.AuctionRepository>()));
    gh.factory<_i891.WatchLiveAuctionEventsUseCase>(() =>
        _i891.WatchLiveAuctionEventsUseCase(gh<_i57.LiveAuctionRepository>()));
    gh.factory<_i891.WatchLiveAuctionConnectionUseCase>(() =>
        _i891.WatchLiveAuctionConnectionUseCase(
            gh<_i57.LiveAuctionRepository>()));
    gh.factory<_i891.JoinLiveAuctionUseCase>(
        () => _i891.JoinLiveAuctionUseCase(gh<_i57.LiveAuctionRepository>()));
    gh.factory<_i891.PlaceLiveBidUseCase>(
        () => _i891.PlaceLiveBidUseCase(gh<_i57.LiveAuctionRepository>()));
    gh.factory<_i891.LeaveLiveAuctionUseCase>(
        () => _i891.LeaveLiveAuctionUseCase(gh<_i57.LiveAuctionRepository>()));
    gh.factory<_i470.LiveAuctionBloc>(() => _i470.LiveAuctionBloc(
          gh<_i891.WatchLiveAuctionEventsUseCase>(),
          gh<_i891.WatchLiveAuctionConnectionUseCase>(),
          gh<_i891.JoinLiveAuctionUseCase>(),
          gh<_i891.PlaceLiveBidUseCase>(),
          gh<_i891.LeaveLiveAuctionUseCase>(),
        ));
    gh.factory<_i423.CategoryBloc>(
        () => _i423.CategoryBloc(gh<_i687.GetAuctionsByCategoryUseCase>()));
    gh.singleton<_i667.DioClient>(() => _i667.DioClient(
          gh<_i745.AuthInterceptor>(),
          gh<_i344.LoggingInterceptor>(),
          gh<_i914.RetryInterceptor>(),
          gh<_i392.MockInterceptor>(),
        ));
    gh.factory<_i189.AuctionListBloc>(
        () => _i189.AuctionListBloc(gh<_i297.GetAuctionListUseCase>()));
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
    gh.factory<_i880.RequestOtpUseCase>(
        () => _i880.RequestOtpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i880.VerifyOtpUseCase>(
        () => _i880.VerifyOtpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i880.ResendOtpUseCase>(
        () => _i880.ResendOtpUseCase(gh<_i787.AuthRepository>()));
    gh.factory<_i75.OtpBloc>(() => _i75.OtpBloc(
          gh<_i880.RequestOtpUseCase>(),
          gh<_i880.VerifyOtpUseCase>(),
          gh<_i880.ResendOtpUseCase>(),
          gh<_i454.AnalyticsService>(),
          gh<_i454.CrashlyticsService>(),
        ));
    gh.factory<_i797.AuthBloc>(() => _i797.AuthBloc(
          gh<_i370.LoginUseCase>(),
          gh<_i370.LogoutUseCase>(),
          gh<_i370.GetCachedAuthUseCase>(),
          gh<_i370.ForgotPasswordUseCase>(),
          gh<_i454.AnalyticsService>(),
          gh<_i454.CrashlyticsService>(),
        ));
    gh.factory<_i210.RegisterBloc>(
        () => _i210.RegisterBloc(gh<_i47.RegisterUseCase>()));
    gh.factory<_i4001.LogoutCubit>(() => _i4001.LogoutCubit(
          gh<_i726.LogoutUseCase>(),
          gh<_i454.AnalyticsService>(),
          gh<_i454.CrashlyticsService>(),
        ));
    return this;
  }
}

class _$MockModule extends _i53.MockModule {}

class _$AppModule extends _i460.AppModule {}

class _$AuthModule extends _i433.AuthModule {}
