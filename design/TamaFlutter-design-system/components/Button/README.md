# Button

Tombol berlabel untuk keputusan di luar aksi rawat: Jemput Tama, Lihat Tama, Nanti saja.

**Yang disediakan pemakai:** `label` (satu sampai tiga kata, kata kerja), `onPressed`, `variant`, dan `icon` (opsional, ikon Material Rounded di kiri label).

| Varian | Kapan | Tampilan |
| --- | --- | --- |
| primary | Satu langkah utama di layar atau kartu | isi `yolk`, teks `on-yolk`, garis `stroke`, `shadow-lip` |
| secondary | Pilihan kedua di samping primary | isi `surface-raised`, teks `ink` |
| quiet | Tautan pengaturan, aksi kecil | teks `accent`, tanpa garis dan bibir |

| Keadaan | Perilaku |
| --- | --- |
| ditekan | turun 3px dalam `dur-press`, bibir menjadi `shadow-lip-pressed`; lepas dengan `ease-bounce` |
| fokus | `focus-ring` 3px, jarak 3px |
| nonaktif | tidak dipakai; sembunyikan tombol atau jelaskan lewat pet |

- Satu primary per layar.
- Tinggi `size-button` (56), sudut `radius-full`, label 17/20 Lexend 600.

```dart
TamaButton.primary(label: 'Jemput Tama', icon: Icons.home_rounded, onPressed: bloc.pickUp)
```
