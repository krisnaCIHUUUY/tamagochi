# Keputusan teknis

Keputusan yang tidak diatur di `docs/superpowers/plans/2026-11-19-tamaflutter-v1.md`. Status: **Menunggu** = belum dijawab, **Diputuskan** = sudah disetujui.

## D1 — Sumber dan bentuk file font (Task 1) · Diputuskan: A

**Hasil:** `assets/fonts/{Fredoka-SemiBold,Lexend-Regular,Lexend-SemiBold}.ttf` diambil dari Google Fonts CSS API resmi (`fonts.googleapis.com/css2`, instance statis di `fonts.gstatic.com`) lalu diberi nama asli. Lisensi `Fredoka-OFL.txt` dan `Lexend-OFL.txt` diambil dari `github.com/google/fonts` dan didaftarkan di `main()` lewat `LicenseRegistry`. `allowRuntimeFetching = false` tetap dikerjakan di Task 20 sesuai rencana.

Konteks awal:

Rencana bilang "unduh TTF Fredoka + Lexend ke `assets/fonts/`", tapi tidak menyebut file mana. Fakta dari dokumentasi `google_fonts` (via Context7):

- Untuk font yang dibundel, nama file harus tetap nama asli Google Fonts, misalnya `Lexend-SemiBold.ttf` (akhiran berat: 400 = `Regular`, 600 = `SemiBold`).
- Token desain hanya memakai 3 berat: Fredoka 600 (`tm-display`, `tm-title`, `tm-numeral`), Lexend 400 (`tm-body`, `tm-caption`), dan Lexend 600 (`tm-label`).
- Font OFL wajib menyertakan `OFL.txt`, dan dokumentasi menyarankan mendaftarkannya lewat `LicenseRegistry` di `main()`.

Pilihan:

- **A.** 3 file statis (`Fredoka-SemiBold.ttf`, `Lexend-Regular.ttf`, `Lexend-SemiBold.ttf`) dari folder `static/` hasil unduhan resmi fonts.google.com, + `OFL.txt` + registrasi `LicenseRegistry`.
- **B.** File variable font (satu file per keluarga) dari repo `github.com/google/fonts`. Belum terverifikasi apakah `google_fonts` mengenali nama file variable.

## D2 — Versi `google_fonts` (Task 1) · Diputuskan: tetap `^9.0.0`

`flutter pub add google_fonts` (perintah di rencana) memasang `^9.0.0`, sedangkan tabel PRD menulis `^8.2.1`. Paket lain sesuai PRD.

## Catatan Task 1

- Repo git ternyata sudah ada (branch `develop`, commit `fe031d4`, remote `origin`). `git init` di rencana tidak diperlukan dan tidak mengubah apa pun.

## D3 — Letak file enum (Task 3) · Diputuskan: file terpisah

Rencana menggabungkan enum ke `entities/enums.dart`, sedangkan `CLAUDE.md` menulis satu file per enum. **Hasil:** ikut `CLAUDE.md`, yaitu `life_stage.dart`, `mood.dart`, `care_action.dart`, dan `pet_character.dart` di `features/pet/domain/entities/`. Task berikutnya mengimpor dari file-file ini, bukan dari `enums.dart`.

## D4 — Nilai awal `GameRules` (Task 3) · Diputuskan: pakai usulan K1–K12

Semua usulan K1–K12 di tabel "Keputusan aturan" pada rencana dipakai apa adanya sebagai konstanta `GameRules`. Semua angka akan disetel ulang lewat playtest.

## D5 — Timer sakit saat tidur (Task 7) · Diputuskan: hanya berjalan saat bangun

`zeroNeedFor` ("kenyang/senang 0 > 60 menit") dan `heavyPoopFor` ("≥ 3 kotoran selama 2 jam") hanya bertambah di menit bangun. Saat tidur timer **berhenti**: tidak bertambah dan tidak direset. **Alasan:** konsisten dengan "saat tidur meter tidak turun", dan anak tidak bisa merawat di malam hari.

## D6 — Timer setelah jadi sakit (Task 7) · Diputuskan: reset saat jadi sakit

Saat pet menjadi sakit, `zeroNeedFor` dan `heavyPoopFor` kembali ke 0 dan tidak bertambah selama sakit. **Alasan:** Makan ditolak saat sakit. Tanpa reset, pet dengan kenyang 0 langsung sakit lagi semenit setelah sembuh diberi Obat, sehingga terjebak sakit terus. Setelah sembuh, pemain punya 60 menit untuk memberi makan.

## D7 — Timer murung saat tidur (Task 8) · Diputuskan: hanya berjalan saat bangun

`lowBothFor` ("kenyang dan senang ≤ 20 selama 6 jam") hanya bertambah di menit bangun dan berhenti tanpa reset saat tidur, sama seperti D5. **Alasan:** pet yang tidur dengan meter 20 tidak otomatis bangun dalam keadaan murung.
