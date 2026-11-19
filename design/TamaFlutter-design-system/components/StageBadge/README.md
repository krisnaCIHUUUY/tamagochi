# StageBadge

Pil kecil di kiri atas PetScreen yang menunjukkan tahap hidup dan umur pet, atau jam bangun saat pet tidur.

**Yang disediakan pemakai:** `stage` (`LifeStage`), `ageYears` (1 hari nyata = 1 tahun), dan `wakeAt` (jam bangun, hanya saat tidur).

| Keadaan | Chip | Isi |
| --- | --- | --- |
| Telur | `egg`, `yolk` | "Telur · 3 menit" (sisa waktu menetas) |
| Bayi sampai Dewasa | `cake`, `char-gembul` | "Anak · 2 tahun" |
| Tidur | `bedtime`, `char-rapi` | "Tidur · sampai 07.00" |

- Nama tahap dalam `tm-label`, angka dalam Fredoka 600 16px, pemisah titik tengah `ink-muted`.
- Tinggi 40, sudut `radius-full`, isi `surface-raised`, garis `stroke`.
- Bukan tombol; tidak punya bibir.
