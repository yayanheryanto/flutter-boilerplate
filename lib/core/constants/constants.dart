class Constants {
  Constants._();

  // API
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // Hive boxes
  static const String authBox = 'auth_box';
  static const String settingsBox = 'settings_box';
  static const String cacheBox = 'cache_box';

  // Hive keys
  static const String tokenKey = 'token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user';

  // Shared Prefs keys
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String onboardingKey = 'onboarding_done';

  // Pagination
  static const int defaultPageSize = 20;
  static const int defaultPage = 1;

  // Cache duration
  static const Duration cacheDuration = Duration(hours: 1);

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Image quality
  static const int imageQuality = 80;
  static const int maxImageWidth = 1920;
}
