# API Auth — Kontrak & Mock

Kontrak ini dipakai bersama oleh aplikasi (`AuthRemoteDataSource`) dan mock
(`lib/features/auth/data/mock/auth_mock_api.dart`). Path ada di
`lib/features/auth/data/datasources/auth_endpoints.dart`; base URL di
`lib/core/config/app_config.dart`.

Semua body & respons memakai JSON `snake_case`. Error memakai bentuk standar
yang dibaca `ErrorMapper`:

```json
{
  "message": "Data pendaftaran tidak valid",
  "errors": { "email": ["Email sudah terdaftar"] }
}
```

`errors` opsional dan hanya untuk `422`. Key-nya = nama field request; pesan
pertama tampil langsung di bawah field terkait pada form.

---

## Alur register

```
RegisterPage ──POST /auth/register──▶ OTP terkirim (verification_id)
     │
     ▼
OtpPage ──POST /auth/otp/verify──▶ token disimpan ──▶ /dashboard
     └────POST /auth/otp/resend──▶ OTP baru + cooldown
```

### `POST /auth/register`

Request

```json
{
  "name": "Dinar Daniswara",
  "phone": "081234567889",
  "email": "dinar@gmail.com",
  "password": "rahasia123"
}
```

`phone` sudah dinormalisasi aplikasi ke format `08…` (tanpa spasi/strip,
`+62`/`62` → `0`). `email` di-lowercase.

Respons `201`

```json
{
  "verification_id": "reg_1717000000000",
  "destination": "08******7889",
  "expires_in": 300,
  "resend_in": 60
}
```

| Status | Kapan |
|---|---|
| 422 | Validasi gagal / email atau HP sudah terdaftar (`errors` per field) |
| 500 | Server error |

### `POST /auth/otp/verify`

Request

```json
{ "verification_id": "reg_1717000000000", "code": "123456" }
```

Respons `200` — sesi login (sama dengan respons login):

```json
{
  "user_id": "usr_1717000000000",
  "email": "dinar@gmail.com",
  "display_name": "Dinar Daniswara",
  "photo_url": null,
  "access_token": "…",
  "refresh_token": "…",
  "token_expiry": "2026-11-27T14:00:00.000"
}
```

| Status | Kapan |
|---|---|
| 422 | Kode salah (`errors.code`) |
| 410 | Kode kedaluwarsa |
| 404 | `verification_id` tidak dikenal |

### `POST /auth/otp/resend`

Request

```json
{ "verification_id": "reg_1717000000000" }
```

Respons `200` — bentuk sama dengan respons register.

| Status | Kapan |
|---|---|
| 429 | Batas kirim ulang (3x) tercapai |
| 404 | `verification_id` tidak dikenal |

---

## Skenario mock

| Input | Hasil |
|---|---|
| Email `terdaftar@emas.id` | 422 — email sudah terdaftar |
| HP `081200000000` | 422 — nomor sudah terdaftar |
| HP `081299999999` | 500 — server error |
| OTP `123456` | Berhasil, login, masuk dashboard |
| OTP `000000` | 410 — kedaluwarsa |
| OTP lain | 422 — kode salah |
| Kirim ulang ke-4 | 429 — batas tercapai |

Latensi mock default 800 ms (`MockRegistry.defaultDelay`).

## Pindah ke backend asli

1. Sesuaikan path di `AuthEndpoints` (dan base URL di `AppConfig`) bila berbeda.
2. Bila bentuk JSON berbeda, ubah `fromJson`/`toJson` di `data/models/`.
3. Hapus `...AuthMockApi().routes` dari `lib/app/di/mock_module.dart`
   **atau** jalankan dengan `--dart-define=USE_MOCK=false` untuk mematikan
   semua mock sekaligus.
4. `flutter pub run build_runner build --delete-conflicting-outputs`.

Endpoint lain tetap boleh memakai mock selama route-nya masih terdaftar:
`MockInterceptor` hanya menjawab request yang punya handler, sisanya diteruskan
ke jaringan.
