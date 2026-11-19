# EvolutionReveal

Momen kejutan satu layar saat app dibuka dan pet ternyata sudah berevolusi selama app tertutup (P0-5).

**Yang disediakan pemakai:** `petName`, `character` (`PetCharacter` hasil `evolution.dart`), dan `onContinue`.

- Panggung `room`, garis `stroke`, sudut `radius-lg`, padding `space-8`.
- Urutan dalam `dur-reveal`: kilau `auto_awesome` `yolk` muncul (0–30%), siluet `pet-ink` membesar (30–60%), lalu warna `char-*` mengisi dan pet melompat (60–100%).
- Teks: keterangan "Waktu kamu pergi, <nama> tumbuh", nama karakter dalam `tm-display`, satu kalimat ciri dan alasannya dalam `tm-body` ("Kamu sering mengajaknya main.").
- Alasan selalu ditulis positif, sesuai gaya perawatan, tanpa menyebut penghitung tersembunyi.
- Satu Button primary "Lihat <nama>".
- Gerak dikurangi: tampilkan langsung frame terakhir.
