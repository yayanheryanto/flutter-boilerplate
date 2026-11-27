# 🚀 Flutter Enterprise Boilerplate

Enterprise-grade Flutter boilerplate with Clean Architecture, BLoC state management, dan responsive system.

## 📋 Specs

- **Flutter**: 3.22.0
- **Package**: `com.mf.emas` (Dart package: `emas`)
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
├── app/                         # Composition root — boleh mengimpor semua lapisan
│   ├── app.dart                 # Root widget (MaterialApp.router + global BlocProvider)
│   └── router/app_router.dart   # Menggabungkan route dari tiap fitur + extra codec
│
├── core/                        # Infrastruktur murni — tidak boleh impor shared/ atau features/
│   ├── bloc/                    # Global BLoC (NotificationBloc)
│   ├── config/                  # AppConfig, Environment
│   ├── constants/               # AppRoutes (path string), Images, spacing/radius/elevation
│   ├── di/                      # Injectable setup (get_it)
│   ├── errors/                  # AppFailure, AppException, ErrorMapper
│   ├── firebase/                # Firebase services & options per environment
│   ├── network/                 # DioClient + interceptors (auth, logging, retry)
│   ├── responsive/              # Breakpoints, Builder, Grid, ContextExtensions
│   ├── services/                # Token, Camera, FilePicker, Permission, Connectivity, Socket
│   ├── usecases/                # BaseUseCase abstractions
│   └── utils/                   # Logger, formatters, navigator key, dll.
│
├── shared/                      # UI lintas fitur — tidak boleh impor features/
│   ├── layouts/                 # AppScaffoldWrapper
│   ├── theme/                   # AppTheme, AppColors, TypographyTokens
│   └── widgets/                 # Design system (design_system.dart = barrel export),
│                                #   notification/ (NotificationBadge, AppNotificationWrapper)
│
├── features/
│   ├── auth/                    # Login, register, OTP, lupa & ganti password
│   ├── kyc/                     # Verifikasi akun: KTP, NPWP, wajah, alamat, rekening bank
│   ├── dashboard/               # Shell tab + konten tab Beranda (composer)
│   ├── auction/                 # Kategori, daftar/detail lelang, ikut lelang
│   ├── live_auction/            # Lelang live real-time (socket)
│   ├── npl/                     # Beli NPL: daftar, detail, konfirmasi
│   ├── payment/                 # Pembayaran & panduan pembayaran
│   ├── transaction/             # Tab transaksi
│   └── profile/                 # Tab profil & pengaturan profil
│
├── main.dart                    # Entry Production  (init env, Firebase prod, DI, runApp)
├── main.dev.dart                # Entry Development (Firebase dev)
└── main.stag.dart               # Entry Staging     (Firebase staging)
```

Setiap fitur mengikuti pola yang sama (folder yang belum dibutuhkan boleh tidak ada):

```
features/<fitur>/
├── data/
│   ├── datasources/             # Remote (Retrofit) / Local (Hive) / Socket / Dummy
│   ├── models/                  # DTO + mapper JSON → entity
│   └── repositories/            # Implementasi repository
├── di/                          # @module injectable khusus fitur (opsional)
├── domain/                      # Dart murni — TANPA import Flutter
│   ├── entities/
│   ├── repositories/            # Kontrak (abstract class)
│   └── usecases/
└── presentation/
    ├── bloc/
    ├── dummy/                   # Data dummy sementara (TODO: ganti dengan BLoC/repository)
    ├── extensions/              # Atribut visual entity (warna, ikon)
    ├── layouts/  pages/  sections/  widgets/
    ├── models/                  # View model yang butuh tipe Flutter (IconData, Color)
    └── routes/<fitur>_routes.dart
```

---

## 📐 Architecture Layers

### Dependency Rule

```
app/      → boleh mengimpor semuanya (composition root)
features/ → boleh mengimpor shared/ dan core/
shared/   → boleh mengimpor core/        | TIDAK boleh mengimpor features/ atau app/
core/     → TIDAK boleh mengimpor shared/, features/, atau app/
```

Di dalam satu fitur:

```
presentation → domain        (BLoC hanya memanggil use case, tidak menyentuh data/)
data         → domain        (implementasi repository + mapper)
domain       → (core saja)   Dart murni, tanpa Flutter
```

Antar fitur:

- Sebuah fitur **hanya boleh mengimpor `domain/` fitur lain** (mis. `npl` memakai
  entity `AuctionItem` dari `auction`).
- Hanya `dashboard` (shell tab) yang boleh menyusun `presentation/` fitur lain.
- Navigasi antar fitur memakai path di `core/constants/app_routes.dart`, bukan
  mengimpor halaman fitur lain.

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
Replace placeholder values in (masing-masing dipakai oleh `main.dev.dart`, `main.stag.dart`, `main.dart`):
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
import 'package:emas/shared/widgets/design_system.dart';
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

1. Buat `lib/features/<fitur>/` dengan struktur di atas.
2. Daftarkan route di `presentation/routes/<fitur>_routes.dart`:
   ```dart
   final List<RouteBase> orderRoutes = [
     GoRoute(path: AppRoutes.orders, builder: (_, __) => const OrderPage()),
   ];
   ```
3. Tambahkan path ke `core/constants/app_routes.dart` dan `...orderRoutes`
   ke daftar `routes` di `lib/app/router/app_router.dart`.
4. Anotasi class dengan `@injectable` / `@LazySingleton(as: ...)`, lalu jalankan
   `build_runner`.

**Import rules:**
- Pages own the `BlocProvider` and route entry point
- Sections can read BLoC state via `BlocBuilder` / `BlocConsumer`
- Layouts are stateless wrappers — no business logic, no BLoC reads
- Jangan mengimpor `data/` dari `presentation/`; jangan mengimpor Flutter dari `domain/`
- Tombol back: pakai `context.popOrGo()` (`core/utils/navigation_extension.dart`), bukan `context.pop()` —
  `pop()` crash bila halaman dibuka lewat `go()`. `AppPageBar` sudah memakainya secara default dan
  menyembunyikan tombol back bila tidak ada halaman sebelumnya.
- Pindah ke area login/logout pakai `context.go()` (stack dibersihkan); selain itu `context.push()`.

Cek otomatis aturan di atas (tanpa Dart SDK):

```bash
python3 scripts/check_architecture.py .
```

---

## 🧪 Mock API (selama backend belum tersedia)

Request tetap lewat Retrofit ke endpoint sungguhan. Bila `AppConfig.useMock`
aktif, `MockInterceptor` (interceptor Dio terakhir) menjawab request yang punya
handler mock — tanpa jaringan. Request tanpa handler tetap diteruskan ke server.

| Environment | Default `useMock` |
|---|---|
| dev | ✅ |
| stag | ✅ (ubah ke `false` saat backend staging siap) |
| prod | ❌ |

Override: `flutter run --flavor dev -t lib/main.dev.dart --dart-define=USE_MOCK=false`

Struktur:

```
core/network/mock/mock_api.dart                 # MockRoute, MockResponse, MockRegistry
core/network/interceptors/mock_interceptor.dart # menjawab request saat useMock
features/<fitur>/data/datasources/<fitur>_endpoints.dart  # path — dipakai Retrofit & mock
features/<fitur>/data/mock/<fitur>_mock_api.dart          # backend palsu per fitur
app/di/mock_module.dart                         # mendaftarkan semua mock
```

Respons sukses backend berbentuk `{ "reff_no": "...", "response": { ... } }`;
`ApiEnvelopeInterceptor` membuka amplop ini sehingga model cukup memetakan isi
`response`. Mock otomatis memakai format yang sama.

Kontrak & skenario uji: [`docs/api/auth.md`](docs/api/auth.md)
(mis. OTP `123456` = benar, email `terdaftar@emas.id` = sudah terdaftar).

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


single responsibility
open close
liskov substitution
interface segregation
dependency 
