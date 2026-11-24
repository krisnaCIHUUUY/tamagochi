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

## D8 — Signature `applyAction` dan `resolveMood` (Task 9) · Diputuskan: ikut rencana

`CLAUDE.md` menulis `PetState applyAction(...)` dan `Mood resolveMood(PetState state)`, sedangkan rencana menulis versi lain. **Hasil:** ikut rencana, dan blok "Fungsi murni" di `CLAUDE.md` sudah disesuaikan.

- `typedef ActionResult = ({PetState state, bool accepted}); ActionResult applyAction(state, action, now)`. **Alasan:** status "ditolak" eksplisit, sehingga bloc tinggal membaca `accepted` untuk memicu animasi geleng.
- `Mood resolveMood(PetState state, DateTime now)`. **Alasan:** mood "tidur" bergantung pada jam, dan domain tidak boleh memanggil `DateTime.now()`.

## D9 — "Aksi seimbang" (Task 12) · Diputuskan: Si Seimbang = tidak ada yang unggul

K3 menghitung setiap Makan sebagai aksi seimbang. Karena kotoran hanya muncul dari Makan, `timelyCleans ≤ balancedActions`, sehingga Si Rapi mustahil tercapai (melanggar PRD P0-5). **Hasil:** `balancedActions` dihapus dari `CareStyle`, dari penghitung di `applyAction`, dan dari skor evolusi. Skor tinggal 4: main, camilan, bersih tepat waktu, dan menit terlantar ÷ 60. Si Seimbang muncul bila tidak ada skor yang unggul > 20%, sesuai tabel PRD "Tidak ada yang dominan". Ini menggantikan K3.

## D10 — Batas unggul evolusi (Task 12) · Diputuskan: ketat > 20% (PRD)

PRD menulis "bila tidak ada yang unggul lebih dari 20%", sedangkan K4 menulis "≥ 1,2 × skor kedua". **Hasil:** ikut PRD. Skor tertinggi menang hanya bila `> 1,2 × skor kedua`, jadi 12 lawan 10 menghasilkan Si Seimbang.

## D11 — Definisi `neededActions` (Task 13) · Diputuskan: diterima + menambah kedekatan

Sebuah aksi "dibutuhkan" (titik panggilan) persis bila `applyAction` menerimanya **dan** kedekatan naik (definisi K7). Urutan prioritas: Obat > Lampu > Bersihkan > Makan > Main, diambil paling banyak `GameRules.maxAttention` (2). **Alasan:** aturan "dibutuhkan" tidak ditulis dua kali, dan aksi yang pasti ditolak (misalnya Makan saat sakit) tidak pernah disarankan.

## D12 — Simulasi per kejadian (Task 14) · Diputuskan: ganti dari per menit ke per kejadian

Benchmark 30 hari per menit memakan ~460 ms (target < 50 ms). Penyebabnya, pembuatan `DateTime` lokal (`.add`, `toLocal`) sekitar 10 µs per kali di Windows, dikali 43.200 langkah. Opsi optimasi per menit (waktu sebagai `int` + cache jam tidur) ditolak. **Hasil:** sesuai rencana (K2), `simulate` diganti ke per kejadian. Ini menggantikan K2.

- Waktu melompat ke kejadian terdekat: tidur/bangun, kotoran jatuh tempo, batas tahap, mulai liburan, meter mencapai 0 atau 20, dan timer mencapai ambang. Di antara dua kejadian meter turun lurus dan timer bertambah sepanjang segmen.
- **Kejadian di awal segmen** (tidur/bangun, kotoran muncul) diproses saat segmen dimulai, jadi kejadian tepat di `to` diproses di panggilan berikutnya (sama seperti versi per menit). **Kejadian saat dicapai** (ambang timer, tahap, liburan) diproses begitu `t` mencapainya, termasuk tepat di `to`.
- Dalam waktu kontinu, sakit karena meter 0 terjadi tepat saat timer mencapai 60 menit (`>=`). Versi per menit baru sakit di menit ke-61; test 59 vs 61 menit tetap sama.
- Menit terlantar dihitung dari `Duration` lalu dibulatkan ke bawah per panggilan (shortcut, lihat komentar di kode).
- Hasil: 30 hari offline ≈ 36 ms saat JIT dingin dan ≈ 14 ms saat panas (Windows, `flutter test`). Seluruh 119 test lama tetap lulus tanpa diubah.

## D13 — Format waktu di simpanan (Task 15) · Diputuskan: UTC

Bawaan `json_serializable` menulis `DateTime` lokal tanpa zona, jadi pindah zona waktu (misalnya WIB ke WITA) menggeser waktu pet. **Hasil:** `UtcDateTimeConverter` menulis UTC (akhiran `Z`) dan membaca kembali sebagai waktu lokal. Jam tidur tetap dihitung dari jam lokal ponsel.

## D14 — Simpanan berisi salah (Task 15) · Diputuskan: semua `FormatException`

Rencana hanya mengatur versi lebih baru. **Hasil:** `decodeSave` melempar `FormatException` untuk semua isi yang tidak bisa dibaca: versi hilang/bukan angka/di luar 1–`currentSchemaVersion`, `pet` hilang, field hilang atau salah tipe, enum asing, tanggal rusak. Repository (Task 16) cukup menangkap satu jenis exception.

## D15 — Waktu terlantar sebagai `Duration` (Task 15) · Diputuskan: ganti sekarang

`neglectMinutes` (int) membuang sisa < 1 menit di setiap panggilan `simulate`, sehingga banyak panggilan pendek (ticker, aksi) membuatnya meleset. **Hasil:** diganti `CareStyle.neglectedFor` (`Duration`). Skor Si Mandiri tetap jam penuh: `neglectedFor.inMinutes ~/ neglectMinutesPerPoint`. Tanpa migrasi karena belum ada simpanan. Menggantikan poin shortcut di D12.
