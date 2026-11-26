import 'package:go_router/go_router.dart';

import 'package:emas/core/constants/app_routes.dart';
import 'package:emas/features/profile/presentation/pages/profile_settings_page.dart';

/// Route fitur profil. Digabungkan oleh `AppRouter`.
final List<RouteBase> profileRoutes = [
  GoRoute(
    path: AppRoutes.profileSettings,
    name: 'profile-settings',
    builder: (context, state) => const ProfileSettingsPage(),
  ),
];
