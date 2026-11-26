/// Satu-satunya tempat path endpoint auth.
///
/// Dipakai oleh Retrofit (`AuthRemoteDataSource`) **dan** mock
/// (`auth_mock_api.dart`), jadi saat backend tersedia cukup sesuaikan
/// path di sini (base URL ada di `AppConfig`), lalu matikan mock.
abstract final class AuthEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String requestOtp = '/auth/otp/request';
  static const String verifyOtp = '/auth/otp/verify';
  static const String resendOtp = '/auth/otp/resend';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
}
