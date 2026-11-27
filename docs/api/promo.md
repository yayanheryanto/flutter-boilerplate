# API Promo — Kontrak & Mock

Path: `lib/features/promo/data/datasources/promo_endpoints.dart` · Mock:
`lib/features/promo/data/mock/promo_mock_api.dart`.

Respons sukses memakai amplop `{ "reff_no", "response" }` (lihat
[`auth.md`](auth.md) → format respons).

## Alur

```
Dashboard (tab Beranda) ──GET /promos──▶ carousel gambar promo (auto-slide 4 detik)
     │  tap gambar
     ▼
/promo/:id ──GET /promos/{id}──▶ gambar, judul, masa berlaku, deskripsi
```

Pull-to-refresh di tab Beranda memuat ulang daftar promo. Halaman detail selalu
mengambil data berdasarkan `id`, jadi bisa dibuka langsung lewat deep link
`/promo/promo-1`.

## `GET /promos`

Respons `200`

```json
{
  "reff_no": "79465b44-3f8e-4b9c-b43b-1626cea61ee6",
  "response": {
    "items": [
      {
        "id": "promo-1",
        "title": "Cashback 10% Lelang Motor",
        "subtitle": "Untuk kemenangan lelang pertama kamu",
        "image_url": "https://picsum.photos/seed/emas-promo-1/1200/600",
        "description": "Menangkan lelang motor pertamamu …",
        "valid_until": "2026-12-31T23:59:59.000"
      }
    ]
  }
}
```

`items` kosong → carousel disembunyikan.

## `GET /promos/{id}`

Respons `200` — satu objek promo (bentuk sama dengan item di atas) di dalam
`response`.

| Status | Kapan |
|---|---|
| 404 | Promo tidak ditemukan / sudah berakhir (`"code": "PROMO_NOT_FOUND"`) |

## Data mock

| id | Judul |
|---|---|
| `promo-1` | Cashback 10% Lelang Motor |
| `promo-2` | Gratis Biaya Admin Beli NPL |
| `promo-3` | Bonus Bid Lelang Live |

Gambar mock diambil dari `picsum.photos` (publik, butuh koneksi internet).
`description` berupa teks biasa; baris baru (`\n`) ditampilkan apa adanya.
