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
