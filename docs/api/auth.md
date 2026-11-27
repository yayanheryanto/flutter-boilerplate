# API Auth — Kontrak & Mock

Kontrak ini dipakai bersama oleh aplikasi (`AuthRemoteDataSource`) dan mock
(`lib/features/auth/data/mock/auth_mock_api.dart`). Path ada di
`lib/features/auth/data/datasources/auth_endpoints.dart`; base URL di
`lib/core/config/app_config.dart`.

Semua body & respons memakai JSON `snake_case`.

**Respons sukses (200)** dibungkus amplop berisi `reff_no` (ID pelacakan,
UUID) dan `response` (data):

```json
{
  "reff_no": "79465b44-3f8e-4b9c-b43b-1626cea61ee6",
  "response": { "user_id": "usr_1717000000000", "name": "Testing", "email": "test@gmail.com" }
}
```

`ApiEnvelopeInterceptor` membuka amplop ini di satu tempat, jadi model &
datasource hanya memetakan isi `response`. `reff_no` disimpan di
`Response.extra['reff_no']` dan dicatat di log.

**Respons error** memakai bentuk standar yang dibaca `ErrorMapper`, plus `reff_no`:

```json
{
  "reff_no": "79465b44-3f8e-4b9c-b43b-1626cea61ee6",
  "message": "Data pendaftaran tidak valid",
  "errors": { "email": ["Email sudah terdaftar"] }
}
```

`code` opsional: kode error yang bisa dibaca mesin (mis. `OTP_EXPIRED`,
`OTP_INVALID`, `ACCOUNT_NOT_VERIFIED`) untuk membedakan sebab dengan status
HTTP yang sama — aplikasi sebaiknya bercabang berdasarkan `code`, bukan teks
`message`.

`errors` opsional dan hanya untuk `422`. Key-nya = nama field request; pesan
pertama tampil langsung di bawah field terkait pada form.

---

## Alur login

```
LoginPage dibuka ── sesi tersimpan & belum kedaluwarsa? ──▶ /dashboard (auto-login)
     │
     ▼
POST /auth/login ──200──▶ token disimpan ──▶ /dashboard
     ├──────────403──▶ nomor belum diverifikasi ──▶ OtpPage (request OTP register)
     └──401/422/429──▶ pesan error (field / snackbar)
```

### `POST /auth/login`

Request

```json
{
  "phone": "081234567890",
  "password": "Rahasia123",
  "device_id": "3f2b8c1e-9a4d-4f6b-8e21-7c5d0a9b1e44"
}
```

`phone` dinormalisasi aplikasi ke format `08…`.

`device_id` = **ID instalasi** aplikasi: UUID v4 yang dibuat sekali saat
pertama dibutuhkan lalu disimpan di Hive (`settings_box`). Sama untuk login &
register di perangkat yang sama, tetap setelah logout, dan berubah bila
aplikasi di-uninstall. Lihat `lib/core/services/device_id_service.dart`.

Respons `200` — sesi login (sama dengan respons `/auth/otp/verify`):

```json
{
  "reff_no": "79465b44-3f8e-4b9c-b43b-1626cea61ee6",
  "response": {
    "user_id": "usr_demo",
    "email": "demo@emas.id",
    "display_name": "Pengguna Demo",
    "photo_url": null,
    "access_token": "…",
    "refresh_token": "…",
    "token_expiry": "2026-11-27T14:00:00.000"
  }
}
```

| Status | Kapan |
|---|---|
| 401 | Nomor HP atau password salah |
| 403 | Nomor belum diverifikasi — body berisi `"code": "ACCOUNT_NOT_VERIFIED"`; aplikasi membuka halaman OTP |
| 422 | Format input tidak valid (`errors.phone` / `errors.password` / `errors.device_id`) |
| 429 | Terlalu banyak percobaan gagal (terkunci sementara) |
| 500 | Server error |

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
  "terms_accepted": true,
  "device_id": "3f2b8c1e-9a4d-4f6b-8e21-7c5d0a9b1e44"
}
```

`phone` sudah dinormalisasi aplikasi ke format `08…` (tanpa spasi/strip,
`+62`/`62` → `0`). `email` di-lowercase.

Respons `200`

```json
{
  "reff_no": "79465b44-3f8e-4b9c-b43b-1626cea61ee6",
  "response": {
    "user_id": "usr_1717000000000",
    "name": "Dinar Daniswara",
    "phone": "081234567889",
    "email": "dinar@gmail.com",
    "status": "pending_verification",
    "created_at": "2026-11-26T14:00:00.000"
  }
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
  "reff_no": "79465b44-3f8e-4b9c-b43b-1626cea61ee6",
  "response": {
    "verification_id": "otp_1717000000000",
    "destination": "08******7889",
    "expires_in": 300,
    "resend_in": 60
  }
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
  "reff_no": "79465b44-3f8e-4b9c-b43b-1626cea61ee6",
  "response": {
    "user_id": "usr_1717000000000",
    "email": "dinar@gmail.com",
    "display_name": "Dinar Daniswara",
    "photo_url": null,
    "access_token": "…",
    "refresh_token": "…",
    "token_expiry": "2026-11-27T14:00:00.000"
  }
}
```

| Status | Kapan |
|---|---|
| 422 | Kode salah (`"code": "OTP_INVALID"`, `errors.code`) |
| 422 | Kode kedaluwarsa (`"code": "OTP_EXPIRED"`, `errors.code`) |
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

### `POST /auth/logout`

Tanpa body; token dikirim lewat header `Authorization: Bearer …`.

Respons `200`

```json
{
  "reff_no": "79465b44-3f8e-4b9c-b43b-1626cea61ee6",
  "response": {
    "message": "Berhasil keluar"
  }
}
```

Sesi lokal (token & data user di Hive) **selalu** dihapus aplikasi, apa pun
respons server — gagal logout di server (mis. offline) tidak menahan user tetap
login.

---

## Skenario mock

| Input | Hasil |
|---|---|
| Login `081234567890` / `Rahasia123` | Berhasil → dashboard (akun demo aktif) |
| Login `081211111111` / `Rahasia123` | 403 → halaman OTP (akun demo belum verifikasi) |
| Login password salah | 401 + sisa percobaan |
| Login password salah 3x | 429 — terkunci 1 menit |
| Login HP `081299999999` | 500 — server error |
| Login dengan akun hasil register | Berhasil setelah OTP diverifikasi; sebelum itu 403 |
| Email `terdaftar@emas.id` | 422 — email sudah terdaftar |
| HP `081200000000` | 422 — nomor sudah terdaftar |
| HP `081299999999` | 500 — server error saat register |
| HP `081288888888` | Register berhasil, request OTP gagal 503 → tekan "Kirim ulang" |
| OTP `123456` | Berhasil, login, masuk dashboard |
| OTP `000000` | 422 `OTP_EXPIRED` — kedaluwarsa |
| OTP lain | 422 `OTP_INVALID` — kode salah |
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
