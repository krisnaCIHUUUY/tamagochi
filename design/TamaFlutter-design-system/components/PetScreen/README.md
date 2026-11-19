# PetScreen

Satu-satunya layar utama: StageBadge dan tombol pengaturan di atas, ruang pet di tengah, dua StatusMeter, lalu ActionBar di bawah.

**Yang disediakan pemakai:** `PetViewState` dari `PetBloc`; layar ini tidak menyimpan state sendiri.

- Basis 360 x 800 dp. Gutter `space-4`, jarak antar-kelompok `space-4` sampai `space-6`.
- Ruang pet (`room`, `radius-lg`, garis `stroke`) mengambil sisa tinggi, minimal 240. Pet berdiri di atas garis lantai `outline` pada 22% dari bawah.
- Meter berdampingan dalam dua kolom sama lebar.
- Contoh di pratinjau: Tama lapar, Kenyang 18 (rendah), Senang 64, titik panggilan di Makan. Wajah, meter, dan tombol menceritakan hal yang sama.
- Saat jam tidur, tema berganti ke Malam, semua ActionButton kecuali Lampu masuk keadaan pet tidur, dan StageBadge menampilkan jam bangun.
- Saat liburan, pet dan ActionBar diganti VacationNote di tengah ruang.
