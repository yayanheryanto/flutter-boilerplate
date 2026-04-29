# 🚀 Flutter Enterprise Boilerplate

Enterprise-grade Flutter boilerplate with Clean Architecture, BLoC state management, dan responsive system.

## 📋 Specs

- **Flutter**: 3.22.0
- **Package**: `com.yayan.boilerplate`
- **Architecture**: Clean Architecture (Domain / Data / Presentation)
- **State Management**: flutter_bloc
- **DI**: injectable + get_it
- **Navigation**: go_router
- **Networking**: Retrofit + Dio
- **Local Storage**: Hive

---

## 🏗️ Project Structure

```
lib/
├── core/                        # Pure infrastructure — no UI, no features
│   ├── bloc/                    # Global BLoC (NotificationBloc)
│   ├── config/                  # AppConfig, Environment
│   ├── constants/               # AppConstants, AppRoutes, AppStrings
│   │   └── tokens/              # Pure Dart design tokens (spacing, radius, elevation)
│   ├── di/                      # Injectable setup (get_it)
│   ├── errors/                  # AppFailure, AppException, ErrorMapper
│   ├── firebase/                # Firebase service abstractions & options
│   ├── network/                 # DioClient + interceptors (auth, logging, retry)
│   ├── responsive/              # Breakpoints, Builder, Grid, ContextExtensions
│   ├── router/                  # AppRouter (GoRouter)
│   ├── services/                # TokenService, Camera, FilePicker, Permission, Connectivity
│   ├── usecases/                # BaseUseCase abstractions
│   └── utils/                   # AppLogger, AppBlocObserver, DateConverter, etc.
│
├── shared/                      # Cross-feature UI — reusable, no business logic
│   ├── layouts/                 # AppScaffoldWrapper (adaptive nav: BottomNav / NavigationRail)
│   ├── theme/                   # AppTheme, ColorTokens, TypographyTokens (Flutter-dependent)
│   └── widgets/                 # All shared UI components
│       ├── buttons/             # AppButton
│       ├── display/             # AppAvatar, AppBadge, AppCard, AppChip, AppImage, AppSpacer, etc.
│       ├── feedback/            # AppLoader, AppProgressIndicator
│       ├── input/               # AppTextField, AppPasswordField, AppFormInputs
│       ├── navigation/          # AppNavigation
│       ├── typography/          # AppText, AppLinkText
│       ├── bottomsheets/        # AppBottomSheet
│       ├── dialogs/             # AppDialog
│       ├── overlays/            # AppOverlays
│       ├── pickers/             # AppDatePicker, AppPickers
│       ├── snackbar/            # AppSnackbar
│       ├── toast/               # AppToast
│       ├── skeleton/            # SkeletonAtoms, SkeletonMolecules, SkeletonOrganisms
│       ├── app_molecules.dart   # EmptyState, ErrorState, LoadingSection, InfoCard, etc.
│       └── design_system.dart   # Single barrel export for all shared widgets
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/     # Remote (Retrofit) + Local (Hive)
│   │   │   ├── models/          # AuthModel (freezed + json_serializable)
│   │   │   └── repositories/    # AuthRepositoryImpl
│   │   ├── di/                  # AuthModule (injectable)
│   │   ├── domain/
│   │   │   ├── entities/        # AuthEntity
│   │   │   ├── repositories/    # AuthRepository (interface)
│   │   │   └── usecases/        # Login, Register, Logout, GetCached, ForgotPassword
│   │   └── presentation/
│   │       ├── bloc/            # AuthBloc, AuthEvent, AuthState
│   │       ├── layouts/         # AuthLayout (mobile/tablet responsive wrapper)
│   │       ├── pages/           # LoginPage, RegisterPage, ForgotPasswordPage
│   │       └── sections/        # LoginFormSection, RegisterFormSection, ForgotPasswordFormSection
│   │
│   └── dashboard/
│       ├── data/
│       │   └── models/          # AuctionItem, DummyData, Formatters
│       └── presentation/
│           ├── layouts/         # DashboardLayout, ProfileLayout, HomeTabLayout, ProfileTabLayout
│           ├── pages/           # DashboardPage, CategoryPage
│           ├── sections/
│           │   ├── home/        # DashboardHeader, BannerCarousel, CategorySection,
│           │   │                #   ActivitySection, AuctionListSection
│           │   └── profile/     # ProfileHeader, ProfileInfoSection, ProfileMenuSection
│           └── widgets/
│               ├── home/        # AuctionCard, BidCard, CategoryAuctionListItem,
│               │                #   LiveBadge, MetricCard, SectionHeader
│               └── profile/     # ProfileLogoutButton
│
└── main.dart                    # Production entry point
```

---

## 📐 Architecture Layers

### Dependency Rule

```
features/ → may import from shared/ and core/
shared/   → may import from core/  |  must NOT import from features/
core/     → must NOT import from shared/ or features/
```

### Presentation Layer Responsibilities

| Folder | Responsibility | Example |
|---|---|---|
| `pages/` | Full screens with routes & BlocProvider | `LoginPage`, `DashboardPage` |
| `layouts/` | Responsive wrappers & scaffold structure | `AuthLayout`, `DashboardLayout` |
| `sections/` | Large UI blocks inside a page | `LoginFormSection`, `BannerCarousel` |
| `widgets/` | Small, reusable UI components | `AuctionCard`, `MetricCard`, `LiveBadge` |

### Token Split

| Location | Content | Flutter dep? |
|---|---|---|
| `core/constants/tokens/` | Spacing, Radius, Elevation (pure `double`) | ❌ Pure Dart |
| `shared/theme/` | Color, Typography, AppTheme | ✅ Flutter |

---

## 🚀 Quick Start

### 1. Install dependencies
```bash
flutter pub get
```

### 2. Configure Firebase
Replace placeholder values in:
- `lib/core/firebase/firebase_options_dev.dart`
- `lib/core/firebase/firebase_options_staging.dart`
- `lib/core/firebase/firebase_options_prod.dart`

### 3. Generate code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run by environment
```bash
# Development
flutter run --flavor dev --target lib/main.dev.dart

# Staging
flutter run --flavor stag --target lib/main.stag.dart

# Production
flutter run --flavor prod --target lib/main.dart
```

### 5. Build APK (Release) by environment
```bash
# Development
flutter build apk --release --flavor dev --target lib/main.dev.dart

# Staging
flutter build apk --release --flavor stag --target lib/main.stag.dart

# Production
flutter build apk --release --flavor prod --target lib/main.dart
```

### 6. Run from VS Code / Cursor
Launch configs tersedia di `.vscode/launch.json`:

- `Flutter (dev) - Debug / Profile / Release`
- `Flutter (stag) - Debug / Profile / Release`
- `Flutter (prod) - Debug / Profile / Release`

Build tasks tersedia di `.vscode/tasks.json`:

- `flutter: build apk (dev, release)`
- `flutter: build apk (stag, release)`
- `flutter: build apk (prod, release)`

### 7. PowerShell Script
```powershell
# Run debug
.\scripts\flutter.ps1 run dev
.\scripts\flutter.ps1 run stag
.\scripts\flutter.ps1 run prod

# Build APK release
.\scripts\flutter.ps1 build-apk dev
.\scripts\flutter.ps1 build-apk stag
.\scripts\flutter.ps1 build-apk prod
```

---

## 🌍 Environment Config

| Key | Dev | Staging | Prod |
|-----|-----|---------|------|
| Base URL | `api-dev.example.com` | `api-staging.example.com` | `api.example.com` |
| Firebase | ❌ Disabled | ✅ Enabled | ✅ Enabled |
| Logging | Verbose | Debug | Error only |
| Debug Banner | ✅ | ✅ | ❌ |

---

## 📱 Responsive Breakpoints

| Name | Width | Device |
|------|-------|--------|
| Mobile | < 600dp | Phones |
| Tablet | 600–1024dp | Tablet portrait |
| Desktop | > 1024dp | Tablet landscape / Desktop |

### Usage
```dart
// Context extensions
context.isMobile     // bool
context.isTablet     // bool
context.isDesktop    // bool
context.screenWidth  // double
context.screenHeight // double

// Responsive value
context.responsive(
  mobile: 1,
  tablet: 2,
  desktop: 4,
)

// Responsive padding
context.responsivePadding  // EdgeInsets

// Responsive layout builder
ResponsiveLayoutBuilder(
  mobile:  MobileDashboardLayout(...),
  tablet:  TabletDashboardLayout(...),
  desktop: TabletDashboardLayout(...),
)
```

---

## 🎨 Design System Usage

Import the single barrel file to access all shared widgets:

```dart
import 'package:boilerplate/shared/widgets/design_system.dart';
```

### Widgets
```dart
// Typography
AppText('Hello', variant: AppTextVariant.headlineMedium)
AppText('Link', variant: AppTextVariant.bodyMedium, color: Colors.blue)

// Buttons
AppButton(label: 'Submit', onPressed: () {})
AppButton(label: 'Outline', variant: AppButtonVariant.outlined, onPressed: () {})
AppButton(label: 'Loading', isLoading: true, onPressed: () {})

// Inputs
AppTextField(label: 'Email', controller: emailCtrl)
AppPasswordField(controller: passwordCtrl)

// Display
AppCard(child: ...)
AppAvatar(initials: 'AR')
AppBadge(label: 'New', backgroundColor: Colors.red)
AppSpacer.md()
AppSpacer.lg()

// Feedback
AppLoader()
AppSnackbar.error(context, 'Something went wrong')
AppSnackbar.success(context, 'Saved!')
```

### Molecules
```dart
// State widgets
EmptyStateWidget(title: 'No items', icon: Icons.inbox)
ErrorStateWidget(message: 'Failed to load', onRetry: retry)
LoadingSection()

// Interactive
InfoCard(title: 'Title', subtitle: 'Subtitle', icon: Icons.info)
ConfirmationDialog.show(context, title: 'Delete?', onConfirm: delete)
PaginationFooter(isLoading: false, hasMore: true, onLoadMore: loadMore)
OTPInputGroup(length: 6, onCompleted: (otp) {})
```

### Layout
```dart
// Adaptive scaffold (BottomNav on mobile, NavigationRail on tablet)
AppScaffoldWrapper(
  body: content,
  navigationItems: const [
    NavigationItem(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home'),
    NavigationItem(icon: Icons.person_outline, selectedIcon: Icons.person_rounded, label: 'Profile'),
  ],
  currentIndex: _navIndex,
  onNavigationTap: (i) => setState(() => _navIndex = i),
)
```

---

## 💀 Skeleton Loading Usage

```dart
// Show skeleton while loading
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) return const AuthFormSkeleton();
    return const LoginFormSection();
  },
)

// Available skeletons
AuthFormSkeleton()
DashboardSkeleton()
ProfileHeaderSkeleton()
ProductListSkeleton(itemCount: 5)
SkeletonListTile()
SkeletonCard(height: 120)
SkeletonBox(width: 100, height: 16)
SkeletonCircle(size: 48)
```

---

## 🔑 Adding a New Feature

Follow this structure for every new feature:

```
features/{feature_name}/
├── data/
│   ├── datasources/         # Remote + Local data sources
│   ├── models/              # Freezed models (json_serializable / retrofit)
│   └── repositories/        # Repository implementation
├── di/                      # Feature injectable module
├── domain/
│   ├── entities/            # Pure Dart domain objects
│   ├── repositories/        # Abstract repository interface
│   └── usecases/            # One class per use case
└── presentation/
    ├── bloc/                # FeatureBloc, FeatureEvent, FeatureState
    ├── layouts/             # Responsive wrappers for this feature
    ├── pages/               # Full screens (routed)
    ├── sections/            # Large UI blocks inside a page
    └── widgets/             # Small reusable components
```

**Import rules:**
- Feature widgets import from `shared/widgets/` and `core/` — never from another feature
- Sections can read BLoC state via `BlocBuilder` / `BlocConsumer`
- Pages own the `BlocProvider` and route entry point
- Layouts are stateless wrappers — no business logic, no BLoC reads

---

## 🔥 Firebase Remote Config Keys

| Key | Type | Default |
|-----|------|---------|
| `enable_social_login` | bool | false |
| `maintenance_mode` | bool | false |
| `min_app_version` | string | 1.0.0 |
| `feature_dark_mode` | bool | true |

---

## 📦 Code Generation

```bash
# Generate all (freezed, json_serializable, retrofit, injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## 🧪 Running Tests

```bash
flutter test
```

---

## ✅ Checklist

- [x] Clean Architecture (Domain / Data / Presentation)
- [x] Null safety
- [x] flutter_bloc state management
- [x] Dependency Injection (injectable + get_it)
- [x] GoRouter typed navigation
- [x] Responsive system (mobile + tablet + desktop)
- [x] Shared widget library with single barrel export
- [x] Skeleton loading system with shimmer
- [x] Firebase abstractions (Analytics, Crashlytics, Remote Config, Push Notifications)
- [x] Global NotificationBloc
- [x] Multi-environment (dev / staging / prod)
- [x] Retrofit + Dio with interceptors (auth, logging, retry)
- [x] Hive local storage
- [x] Error mapping (DioException → AppFailure)
- [x] fpdart Either<Failure, Success>
- [x] Complete auth feature (login, register, forgot password)
- [x] Dashboard feature (home, category, profile)
- [x] Material 3 theme with design tokens
- [x] Token split: pure Dart tokens (core) vs Flutter tokens (shared/theme)
- [x] Adaptive scaffold (BottomNav mobile / NavigationRail tablet)
- [x] Camera, FilePicker, Permission services
- [x] Presentation layer with clear folder responsibilities (pages / layouts / sections / widgets)