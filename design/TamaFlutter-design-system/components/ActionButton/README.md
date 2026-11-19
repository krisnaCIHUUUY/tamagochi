# ActionButton

Satu dari enam aksi rawat (Makan, Camilan, Main, Bersihkan, Obat, Lampu), digambar sebagai tombol mainan yang turun saat ditekan.

**Yang disediakan pemakai:** `action` (`CareAction`), `needed` (bool, dari `PetState`), `resting` (bool, pet sedang tidur), dan `onPressed`. Ikon, warna chip, dan label diturunkan dari `action`; jangan dikirim terpisah.

| Aksi | Ikon | Chip |
| --- | --- | --- |
| Makan | `restaurant` | `meter-hunger` |
| Camilan | `cookie` | `char-gembul` |
| Main | `sports_soccer` | `meter-happy` |
| Bersihkan | `cleaning_services` | `char-rapi` |
| Obat | `medication` | `sick` |
| Lampu | `lightbulb` | `yolk` |

| Keadaan | Tampilan | Perilaku |
| --- | --- | --- |
| biasa | isi `surface-raised`, garis `stroke`, `shadow-lip` | — |
| dibutuhkan | titik `attention` di pojok kanan atas | semantik: "Makan. Tama butuh ini." |
| ditekan | turun 3px, `shadow-lip-pressed` | `dur-press` |
| ditolak | miring dan bergoyang 3 kali dalam `dur-shake`, pet ikut menggeleng | tanpa teks error, tanpa merah |
| pet tidur | garis putus-putus, tanpa bibir, teks `ink-muted` | hanya Lampu yang tetap aktif |

- Tinggi `size-action` (72), sudut `radius-md`, chip 32px dengan ikon `pet-ink`.
- Tanpa angka atau hitungan di tombol.
- Saat aksi ditolak, getar pendek (paket `vibration`) hanya kalau suara dan getar menyala.
