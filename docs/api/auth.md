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
RegisterPage ──POST /auth/register──────▶ akun dibuat (pending_verification)
     │                                     (respons: data user)
     ▼
OtpPage dibuka ──POST /auth/otp/request──▶ OTP terkirim (verification_id)
     ├────────────POST /auth/otp/verify──▶ token disimpan ──▶ /dashboard
     └────────────POST /auth/otp/resend──▶ OTP baru + cooldown
```

Request OTP dilakukan `OtpBloc` saat halaman OTP terbuka, terpisah dari
register. Bila gagal (mis. SMS gateway down), user cukup menekan "Kirim ulang"
— tidak perlu mendaftar ulang.

### `POST /auth/register`

Request — seluruh isi form:

```json
{
  "name": "Dinar Daniswara",
  "phone": "081234567889",
  "email": "dinar@gmail.com",
  "password": "rahasia123",
  "password_confirmation": "rahasia123",
  "terms_accepted": true
}
```

`phone` sudah dinormalisasi aplikasi ke format `08…` (tanpa spasi/strip,
`+62`/`62` → `0`). `email` di-lowercase.

Respons `201`

```json
{
  "user_id": "usr_1717000000000",
  "name": "Dinar Daniswara",
  "phone": "081234567889",
  "email": "dinar@gmail.com",
  "status": "pending_verification",
  "created_at": "2026-11-26T14:00:00.000"
}
```

| Status | Kapan |
|---|---|
| 422 | Validasi gagal / email atau HP sudah terdaftar / konfirmasi password beda / S&K belum disetujui (`errors` per field) |
| 500 | Server error |

### `POST /auth/otp/request`

Request

```json
{ "phone": "081234567889", "purpose": "register" }
```

`purpose`: `register` \| `forgot_password` \| `change_password`
(mock saat ini baru mendukung `register`).

Respons `200`

```json
{
  "verification_id": "otp_1717000000000",
  "destination": "08******7889",
  "expires_in": 300,
  "resend_in": 60
}
```

| Status | Kapan |
|---|---|
| 404 | Nomor belum terdaftar |
| 409 | Nomor sudah terverifikasi |
| 503 | Gagal mengirim SMS |

### `POST /auth/otp/verify`

Request

```json
{ "verification_id": "otp_1717000000000", "code": "123456" }
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
{ "verification_id": "otp_1717000000000" }
```

Respons `200` — bentuk sama dengan respons `/auth/otp/request`.

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
| HP `081299999999` | 500 — server error saat register |
| HP `081288888888` | Register berhasil, request OTP gagal 503 → tekan "Kirim ulang" |
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
