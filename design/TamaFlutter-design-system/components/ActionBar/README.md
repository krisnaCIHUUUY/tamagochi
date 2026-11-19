# ActionBar

Dock 3 x 2 berisi enam ActionButton di bagian bawah PetScreen, selalu dalam urutan yang sama.

**Yang disediakan pemakai:** daftar `needed` per aksi dan status tidur dari `PetViewState`, plus satu callback `onAction(CareAction)`.

- Urutan tetap: Makan, Camilan, Main di baris atas; Bersihkan, Obat, Lampu di baris bawah. Anak menghafal posisi, jadi urutan tidak boleh berubah karena keadaan.
- Isi `surface`, garis `stroke`, sudut `radius-lg`, padding `space-3`, celah `space-2`.
- Grid tiga kolom sama lebar; di layar 360dp tiap tombol sekitar 96dp.
- Paling banyak dua titik `attention` sekaligus. Kalau lebih, tampilkan yang paling mendesak (sakit, lalu lapar, lalu kotor).
- `Semantics(container: true, label: 'Rawat Tama')` di sekeliling grid.
