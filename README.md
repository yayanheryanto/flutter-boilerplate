# 🚀 Flutter Enterprise Boilerplate

Enterprise-grade Flutter boilerplate with Clean Architecture, atomic design, dan responsive system.

## 📋 Specs
- **Flutter**: 3.22.0
- **Package**: `com.yayan.boilerplate`
- **Architecture**: Clean Architecture (Domain / Data / Presentation)
- **State Management**: flutter_bloc
- **DI**: injectable + get_it
- **Navigation**: go_router
- **Networking**: Retrofit + Dio
- **Local Storage**: Hive
- **UI Pattern**: Atomic Design

---

## 🏗️ Project Structure

```
lib/
├── core/
│   ├── config/          # AppConfig, Environment
│   ├── constants/       # AppConstants, AppStrings, AppRoutes
│   ├── di/              # Injectable setup
│   ├── errors/          # AppFailure, AppException, ErrorMapper
│   ├── firebase/        # Firebase service abstractions
│   ├── network/         # DioClient + interceptors
│   ├── responsive/      # Breakpoints, Builder, Grid, ContextExtensions
│   ├── router/          # AppRouter (GoRouter)
│   ├── services/        # TokenService, Camera, FilePicker, Permission, Connectivity
│   ├── theme/           # AppTheme + Design Tokens
│   ├── ui/
│   │     ├── design_system/
│   │     ├── atoms/
│   │     │   ├── buttons/           # AppButton, AppIconButton, AppFAB
│   │     │   ├── display/           # AppImage, AppAvatar, AppCard, AppChip, etc.
│   │     │   ├── feedback/          # AppLoader, AppProgressIndicator, AppSnackBar
│   │     │   ├── input/             # AppTextField, AppPasswordField, AppDropdown, etc.
│   │     │   ├── navigation/        # AppAppBar, AppBackButton
│   │     │   └── typography/        # AppText, AppRichText, AppLinkText
│   │     ├── molecules/             # InfoCard, EmptyState, ErrorState, ConfirmationDialog, etc.
│   │     ├── organisms/             # AppScaffoldWrapper (adaptive nav)
│   │     ├── skeleton/
│   │     │   ├── atoms/             # SkeletonBox, SkeletonCircle, SkeletonText, etc.
│   │     │   ├── molecules/         # SkeletonListTile, SkeletonFormField, etc.
│   │     │   └── organisms/         # AuthFormSkeleton, DashboardSkeleton, etc.
│   │     └── templates/             # AuthTemplate (example)
│   └── usecases/        # BaseUseCase abstractions
│
├── features/
│   └── auth/
│       ├── domain/
│       │   ├── entities/          # AuthEntity
│       │   ├── repositories/      # AuthRepository (interface)
│       │   └── usecases/          # LoginUseCase, RegisterUseCase, etc.
│       ├── data/
│       │   ├── datasources/       # Remote (Retrofit) + Local (Hive)
│       │   ├── models/            # AuthModel (freezed)
│       │   └── repositories/      # AuthRepositoryImpl
│       └── presentation/
│           ├── bloc/              # AuthBloc + AuthEvent + AuthState
│           ├── organisms/         # AuthFormSection
│           ├── pages/             # AuthPage
│           └── templates/         # AuthTemplate
│

```

---

## 🚀 Quick Start

### 1. Setup Flutter
```bash
flutter pub get
```

### 2. Configure Firebase
Ganti placeholder values di:
- `lib/core/firebase/firebase_options_dev.dart`
- `lib/core/firebase/firebase_options_staging.dart`
- `lib/core/firebase/firebase_options_prod.dart`

Dengan nilai dari Firebase Console masing-masing project.

### 3. Generate Code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run by Environment
```bash
# Development
flutter run --flavor dev --target lib/main.dev.dart

# Staging
flutter run --flavor stag --target lib/main.stag.dart

# Production
flutter run --flavor prod --target lib/main.dart
```

### 5. Build APK (Release) by Environment
```bash
# Development
flutter build apk --release --flavor dev --target lib/main.dev.dart

# Staging
flutter build apk --release --flavor stag --target lib/main.stag.dart

# Production
flutter build apk --release --flavor prod --target lib/main.dart
```

### 6. Run / Build from Cursor (VSCode)
Project ini sudah punya konfigurasi supaya lebih gampang dijalankan dari Cursor:

#### Run (Debug / Profile / Release)
- Buka menu **Run and Debug**
- Pilih salah satu konfigurasi:
  - `Flutter (dev) - Debug / Profile / Release`
  - `Flutter (stag) - Debug / Profile / Release`
  - `Flutter (prod) - Debug / Profile / Release`

Konfigurasi ini ada di `.vscode/launch.json` dan otomatis pakai entrypoint:
- **dev** → `lib/main.dev.dart`
- **stag** → `lib/main.stag.dart`
- **prod** → `lib/main.dart`

#### Build APK (Release)
- Buka **Terminal → Run Task**
- Pilih task:
  - `flutter: build apk (dev, release)`
  - `flutter: build apk (stag, release)`
  - `flutter: build apk (prod, release)`

Task ini ada di `.vscode/tasks.json`.

### 7. Alternatif: Script PowerShell
Kalau kamu lebih suka satu command yang konsisten (dan otomatis pakai Flutter dari FVM jika ada), gunakan:

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
| Debug Banner | ❌ | ✅ | ❌ |

---

## 📱 Responsive Breakpoints

| Name | Width | Device |
|------|-------|--------|
| Compact | < 600dp | Small/Large phones |
| Medium | 600–1024dp | Tablet portrait |
| Expanded | > 1024dp | Tablet landscape / Desktop |

### Usage:
```dart
// Context extensions
context.isMobile    // bool
context.isTablet    // bool
context.isDesktop   // bool
context.screenWidth // double
context.screenHeight // double

// Responsive value
context.responsive(
mobile: 1,
tablet: 2,
desktop: 4,
)
```

---

## 💀 Skeleton Loading Usage

```dart
// Show skeleton while loading
if (state is AuthLoading) {
return const AuthFormSkeleton();
}

// Available skeletons:
AuthFormSkeleton()
DashboardSkeleton()
ProfileHeaderSkeleton()
ProductListSkeleton(itemCount: 5)
SkeletonListTile()
SkeletonCard(height: 120)
```

---

## 🧬 Atomic Design Usage

```dart
// Atoms
AppText('Hello', variant: AppTextVariant.headlineMedium)
AppButton(label: 'Submit', onPressed: () {})
AppTextField(label: 'Email', controller: emailCtrl)
AppCard(child: ...)

// Molecules
EmptyStateWidget(title: 'No items')
ErrorStateWidget(message: 'Failed', onRetry: retry)
InfoCard(title: 'Title', icon: Icons.info)
ConfirmationDialog.show(context, title: 'Delete?')

// Organisms
AppScaffoldWrapper(
body: ...,
navigationItems: items,
currentIndex: 0,
onNavigationTap: onTap,
)
```

---

## 🔥 Firebase Remote Config Keys

| Key | Type | Default |
|-----|------|---------|
| `enable_social_login` | bool | false |
| `maintenance_mode` | bool | false |
| `min_app_version` | string | 1.0.0 |
| `feature_dark_mode` | bool | true |

---

## 🧪 Running Tests
```bash
flutter test
```

---

## 📦 Code Generation Commands

```bash
# Generate all (freezed, json_serializable, retrofit, injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode during development
flutter pub run build_runner watch --delete-conflicting-outputs
```

---

## ✅ Checklist

- [x] Clean Architecture (Domain/Data/Presentation)
- [x] Null safety
- [x] flutter_bloc state management
- [x] Dependency Injection (injectable + get_it)
- [x] GoRouter typed navigation
- [x] Responsive system (mobile + tablet + desktop)
- [x] Atomic Design (Atoms/Molecules/Organisms/Templates)
- [x] Skeleton loading system with shimmer
- [x] Firebase abstractions (Analytics, Crashlytics, Remote Config)
- [x] Multi-environment (dev/staging/prod)
- [x] Retrofit + Dio with interceptors
- [x] Hive local storage
- [x] Error mapping (DioException → AppFailure)
- [x] fpdart Either<Failure, Success>
- [x] Complete auth feature example
- [x] Material 3 theme with design tokens
- [x] Adaptive scaffold (BottomNav mobile / NavigationRail tablet)
- [x] Camera, FilePicker, Permission services