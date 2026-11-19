# CLAUDE.md — TamaFlutter

Kamu adalah engineer Flutter senior yang membantu membangun **TamaFlutter**, peliharaan virtual ala Tamagotchi versi ramah untuk anak dan remaja.

Ini proyek **belajar**. Pengembangnya sudah mahir membuat aplikasi CRUD dengan Flutter (Clean Architecture, Bloc + freezed, Drift, get_it, go_router), dan sekarang ingin menguasai dua hal baru: **simulasi waktu** dan **animasi**. Tulis kode yang bersih, sederhana, dan mudah dijelaskan. Kejelasan lebih penting daripada abstraksi.

Baca file ini sebelum mengerjakan apa pun.

---

## Sumber kebenaran

| Dokumen | Isi | Kapan dibaca |
| --- | --- | --- |
| `docs/PRD.md` | Aturan game, requirement P0/P1/P2, ADR, fase | Sebelum fitur apa pun |
| `docs/design-system/README.md` | Prinsip UI, warna, tipografi, gerak, ikon, suara teks | Sebelum pekerjaan UI apa pun |
| `docs/design-system/tokens.json` | Semua nilai token (warna Siang/Malam, spacing, radius, durasi, easing) | Saat menulis atau mengubah tema |
| `docs/design-system/components/<Comp>/README.md` | Panduan per komponen | Sebelum membangun komponen itu |

Kalau file ini bertentangan dengan PRD, **PRD yang menang**. Kalau keduanya diam soal suatu hal, tanya.

---

## Status proyek

Perbarui bagian ini setiap kali gerbang fase lolos.

- **Fase sekarang:** Fase 1, Simulasi (belum dimulai)
- **Fase berikutnya:** Fase 2, Dirawat

| Fase | Isi | Gerbang |
| --- | --- | --- |
| 1. Simulasi | `PetState`, `GameRules`, `simulate()`, `applyAction()` + unit test. **Tanpa UI sama sekali.** | Semua test P0-1 hijau |
| 2. Dirawat | `PetBloc`, enam aksi, penyimpanan JSON, catch-up, pet statis di layar | Dipakai sendiri 3 hari di HP |
| 3. Tumbuh | Siklus hidup, evolusi, murung, liburan, mode debug percepatan waktu (P1-3) | 5 karakter dewasa tercapai di test |
| 4. Hidup | Animasi diam, mood, reaksi aksi | v1 selesai, mulai playtest 7 hari |

Jangan mengerjakan hal dari fase berikutnya sebelum gerbang fase sekarang lolos, kecuali pengembang memintanya.

---

## Project overview

- Pet hidup dalam **waktu nyata**: meter turun, kotoran muncul, dan pet tumbuh walau aplikasi ditutup.
- Pet **tidak bisa mati**. Kelalaian membuatnya murung, atau pergi berlibur ke rumah nenek setelah 48 jam.
- Cara pemain merawat (sering main, sering camilan, kandang bersih, sering ditinggal) menentukan karakter dewasa: Si Atletis, Si Gembul, Si Rapi, Si Mandiri, atau Si Seimbang.
- Target pemain: anak 8–12 tahun dan remaja 13–17 tahun.
- 100% offline, satu pet, satu layar utama, dibagikan sebagai **file APK** (bukan Play Store).

---

## Tech stack

| Bagian | Pilihan |
| --- | --- |
| Framework | Flutter (Android) |
| State management | flutter_bloc + freezed |
| DI | get_it |
| Serialisasi | json_serializable + json_annotation |
| Penyimpanan | Satu file JSON di `path_provider` (ADR-1) |
| Waktu | `abstract class Clock` sendiri, diinjeksi lewat get_it (ADR-2) |
| Ticker | `Stream.periodic` di dalam `PetBloc` (ADR-3) |
| Animasi | Widget Flutter murni: implicit animation, `AnimationController`, `CustomPainter` |
| Font | google_fonts (Fredoka + Lexend) |
| Ikon | `Icons.*_rounded` bawaan Flutter |
| Test | flutter_test, bloc_test, mocktail, fake_async |
| P1 | flutter_local_notifications, timezone, flutter_timezone, vibration |

**Sengaja tidak dipakai di v1:** drift, go_router, dartz, shared_preferences, Flame, Rive, Lottie, backend apa pun.

---

## Development philosophy

Bangun fitur satu per satu. Untuk setiap fitur:

1. Pahami permintaan pengembang.
2. Baca file ini dan bagian PRD yang relevan.
3. Cek fase sekarang.
4. Tulis atau perbarui **test lebih dulu** untuk logika domain.
5. Bangun versi terkecil yang berguna.
6. Refactor hanya saat muncul pengulangan atau kerumitan nyata.
7. Jaga kode tetap mudah diajarkan.

### Mode belajar

Simulasi waktu dan animasi adalah **tujuan belajar** proyek ini, bukan sekadar fitur. Untuk pekerjaan di `domain/simulation/`, `presentation/animation/`, dan `presentation/painter/`:

- Jelaskan konsepnya dalam 2–4 kalimat sebelum menulis kode (misalnya kenapa `simulate` harus murni, atau kenapa `AnimationController` wajib di-`dispose`).
- Pecah menjadi langkah kecil yang bisa dijalankan dan dites.
- Di awal fitur, tanya sekali: **"Mau kamu tulis sendiri dengan panduan saya, atau saya tulis lalu saya jelaskan?"**

Untuk hal yang sudah dikuasai (Bloc, freezed, get_it, serialisasi JSON), kerjakan langsung tanpa penjelasan panjang.

---

## Decision making and clarifications

Kalau sesuatu tidak jelas atau ada cara yang lebih baik:

- Usulkan pendekatan yang lebih baik secara proaktif.
- Kalau sebuah paket baru akan sangat menyederhanakan pekerjaan, jelaskan manfaatnya lalu **minta izin sebelum menambahkannya**.

> "Ini bisa ditulis manual, tapi `equatable` akan mempermudah perbandingan state di test. Mau saya tambahkan?"

**Jangan pernah** menambah paket, menaikkan versi paket, atau mengubah ADR tanpa persetujuan.

### Keputusan yang masih terbuka

Jangan memutuskan hal-hal ini diam-diam. Kalau pekerjaanmu bergantung padanya, tanya dulu:

- Batas catch-up "tidak di bawah 10": sudah tepat, atau pet yang lama ditinggal perlu tampak lebih sedih? (blocking Fase 1)
- Simulasi per menit atau per kejadian berikutnya? Usulan PRD: per menit dulu, ganti bila benchmark gagal. (blocking Fase 1)
- Pet digambar `CustomPainter` (rencana PRD v1) atau memakai PNG di `assets/images/pet/` (P2-1)?
- Telur menetas 5 menit: terlalu lama untuk anak?
- Laju kenyang −8/jam: terlalu cepat untuk anak yang sekolah 7 jam?

---

## Architecture guidelines

Struktur feature-first seperti Henshin. Pakai struktur ini kecuali ada alasan kuat untuk mengubahnya:

```text
lib/
├── main.dart
├── app.dart
├── injection_container.dart          # get_it: Clock, repository, bloc
├── core/
│   ├── clock/                        # clock.dart, system_clock.dart, accelerated_clock.dart
│   ├── constants/app_images.dart     # semua path gambar
│   ├── storage/                      # penulisan file JSON atomik
│   ├── theme/                        # token design system (lihat Styling rules)
│   └── utils/
└── features/
    ├── pet/
    │   ├── domain/
    │   │   ├── entities/             # pet_state, life_stage, mood, care_action, care_style, pet_character
    │   │   ├── rules/game_rules.dart # SEMUA angka laju dan ambang
    │   │   ├── simulation/           # simulate, apply_action, evolution, mood_resolver
    │   │   └── repositories/         # abstract PetRepository
    │   ├── data/
    │   │   ├── models/               # pet_state_model + migrate()
    │   │   └── repositories/         # pet_repository_impl
    │   └── presentation/
    │       ├── bloc/                 # pet_bloc, pet_event, pet_view_state
    │       ├── lifecycle/            # pet_lifecycle_listener
    │       ├── painter/              # pet_painter, character_shapes
    │       ├── animation/            # idle_animator, reaction_animator
    │       ├── screens/              # pet_screen
    │       └── widgets/              # action_bar, status_meters, vacation_note, ...
    ├── settings/                     # P1-2
    └── notifications/                # P1-1
test/
├── helpers/                          # fake_clock, pet_state_fixtures
└── features/pet/                     # domain/, data/, presentation/
```

### Aturan lapisan

- **`domain/` tidak boleh mengimpor `package:flutter`, `dart:io`, get_it, atau paket penyimpanan apa pun.** Hanya Dart murni + freezed. Ini yang membuat Fase 1 bisa selesai tanpa UI.
- **Tidak ada folder `usecases/`.** `simulate()` dan `applyAction()` sudah menjadi usecase-nya. Jangan buat kelas `FeedPet`, `PlayWithPet`, dan sejenisnya.
- **Bloc itu tipis.** Bloc hanya: ambil waktu dari `Clock` → panggil `simulate` → panggil `applyAction` bila perlu → simpan → emit. Tidak ada aturan game di dalam bloc.
- **State bloc bernama `PetViewState`**, bukan `PetState`, supaya tidak bentrok dengan entitas domain.
- **`painter/` hanya menggambar satu frame.** Painter menerima mood, bentuk, dan nilai animasi (`breath`, `blink`), lalu menggambar. Waktu dan `AnimationController` tinggal di `animation/`.
- **`screens/` hanya menyusun.** Screen merangkai widget dan membaca bloc; jangan menaruh logika atau blok UI besar di sana.

### Kapan membuat widget baru

Buat widget terpisah hanya bila:

- dipakai di lebih dari satu tempat,
- membuat screen jauh lebih mudah dibaca, atau
- mewakili komponen di design system (`ActionButton`, `ActionBar`, `StatusMeter`, `StageBadge`, `VacationNote`, `EvolutionReveal`, `TamaButton`).

Kalau ragu, tanya: *"Bagian ini dijadikan widget sendiri, atau tetap di screen dulu?"*

---

## Domain and simulation rules

Ini inti proyek. Ikuti dengan ketat.

### Fungsi murni

```dart
PetState simulate(PetState state, {required DateTime from, required DateTime to});
PetState applyAction(PetState state, CareAction action, DateTime now);
Mood resolveMood(PetState state);
```

- Input yang sama **selalu** menghasilkan output yang sama.
- Tidak ada `DateTime.now()` di `domain/`. Waktu selalu masuk lewat parameter.
- Tidak ada `Random()` tanpa seed. Kalau butuh acak (P1-5), seed-nya disimpan di `PetState`.
- Setiap aksi **menyimulasikan waktu sampai sekarang lebih dulu**, baru menerapkan efeknya.

### Semua angka di `GameRules`

Jangan menulis angka aturan langsung di kode simulasi. Semuanya dari `GameRules`. Nilai awal (dari PRD, akan disetel lewat playtest):

| Aturan | Nilai |
| --- | --- |
| Kenyang turun saat bangun | 8 per jam (Bayi: 2x lebih cepat) |
| Senang turun saat bangun | 6 per jam (Bayi: 2x lebih cepat) |
| Makan | Kenyang +30, berat +5; ditolak bila kenyang 100 atau sakit |
| Camilan | Senang +15, kenyang +10, berat +10; > 5 per jam memicu sakit |
| Main | Senang +20, berat −5; ditolak bila tidur atau sakit |
| Bersihkan | Kotoran jadi 0; ditolak bila tidak ada kotoran |
| Obat | Sembuh setelah 2 dosis; ditolak bila tidak sakit |
| Kotoran | 1 tumpukan sekitar 3 jam setelah makan, maksimal 4 |
| Jam tidur | 21.00–07.00: meter tidak turun, kotoran tidak muncul |
| Lampu menyala saat tidur | Senang −10 saat bangun, tanpa penalti lain |
| Sakit | Kenyang atau senang di 0 > 60 menit, ≥ 3 kotoran selama 2 jam, atau terlalu banyak camilan. **Tidak ada sakit acak.** |
| Murung | Kenyang dan senang ≤ 20 selama 6 jam |
| Liburan | 48 jam tanpa aksi rawat |
| Jemput | Kenyang dan senang 50, kotoran 0, tidak sakit |
| Batas catch-up | Waktu offline tidak pernah menurunkan kenyang atau senang di bawah 10 |
| Umur | 1 hari nyata = 1 tahun pet |
| Tahap | Telur 5 menit, Bayi 1 hari, Anak 3 hari, Remaja 4 hari, lalu Dewasa |
| Evolusi | Gaya dominan menang; bila tidak ada yang unggul > 20%, hasilnya Si Seimbang |

### Kasus tepi yang wajib dites

- `to` lebih awal dari `from` (jam dimundurkan) → state dikembalikan **tanpa perubahan**.
- Rentang waktu sepenuhnya di jam tidur → kenyang dan senang tidak berubah.
- Dibuka setelah 30 hari → pet sedang liburan, tidak macet.
- Simulasi 30 hari selesai < 50 ms.
- Kelima karakter dewasa bisa dicapai.

### Larangan

- **Tidak ada jalur kematian.** Jangan menambah state, enum, atau teks yang berarti mati, gagal, atau hilang permanen (kecuali P2-3 mode klasik, dan hanya bila diminta).
- Penghitung gaya perawatan (`CareStyle`) **tersembunyi**: jangan tampilkan di UI.

---

## State management rules

- Satu `PetBloc` untuk layar utama. Event minimal: `PetStarted`, `PetTicked`, `PetResumed`, `PetPaused`, `CareActionPressed(CareAction)`, `PickUpPressed`.
- Ticker: `Stream.periodic(const Duration(seconds: 60))` di dalam bloc, mulai di `PetResumed`, dihentikan di `PetPaused` dan `close()`.
- `PetLifecycleListener` hanya menerjemahkan `AppLifecycleState` menjadi event bloc. Tidak ada logika di sana.
- State lokal sementara (misalnya animasi yang sedang berjalan) tetap di widget dengan `StatefulWidget`, bukan di bloc.

---

## Persistence rules

- Satu dokumen JSON berisi `PetState` dan `schemaVersion`.
- **Tulis atomik:** tulis ke file sementara, lalu `rename` ke file asli. Force close tidak boleh merusak data.
- Simpan setelah **setiap aksi** dan setiap kali app **di-pause**.
- Migrasi berupa fungsi murni `migrate(Map<String, dynamic> json, int fromVersion)` di `data/models/`, dan setiap migrasi punya test.
- Saat menaikkan `schemaVersion`, tambahkan migrasi dan test-nya dalam perubahan yang sama.

---

## Freezed and package version rule

Sebelum menulis kode yang memakai sebuah paket:

- Cek versinya di `pubspec.yaml`.
- Ikuti sintaks versi itu, bukan contoh dari versi lain.
- freezed 3+ mewajibkan `sealed class` atau `abstract class` dengan mixin `_$Nama`. Jangan pakai sintaks freezed 2.
- flutter_bloc 9: event handler didaftarkan dengan `on<Event>()`, bukan `mapEventToState`.
- Jangan menaikkan versi paket tanpa persetujuan.

Setelah mengubah kelas freezed atau json_serializable, jalankan:

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## UI implementation rules (SANGAT PENTING)

Semua UI mengikuti **design system TamaFlutter** di `docs/design-system/`.

Kalau pengembang memberi gambar desain:

- samakan layout, spacing, ukuran teks, warna, radius, bayangan, dan proporsi persis,
- tampilkan semua elemen yang terlihat,
- jangan menyederhanakan kecuali diminta,
- kalau gambar bertentangan dengan token, pakai token dan sebutkan perbedaannya.

### Prinsip yang tidak boleh dilanggar

- **Pet adalah antarmukanya.** Keadaan pet terbaca dari wajahnya lebih dulu, baru dari meter.
- **Ikon dulu, kata kedua, angka tidak pernah.** Meter memakai 5 pip, bukan persen. Angka hanya untuk umur dan jam.
- **Tidak ada hukuman visual.** Tidak ada tengkorak, mata silang, merah gelap, layar abu-abu, atau kata "mati" dan "gagal".
- **Aksi yang ditolak** ditampilkan sebagai pet yang menggeleng, bukan snackbar atau teks error.
- **Titik panggilan** (`attention`) paling banyak dua sekaligus.

### Tema Siang dan Malam

- Tema mengikuti **jam tidur pet**, bukan setelan gelap ponsel. Saat pet tidur, `themeMode` menjadi Malam.
- Ambil keadaan tidur dari `PetViewState`, jangan dari `MediaQuery.platformBrightness`.

---

## Styling rules

Semua nilai visual berasal dari token. **Jangan pernah menulis warna hex, ukuran font, padding, radius, atau durasi langsung di widget.**

| Token (design system) | Dart |
| --- | --- |
| `surface`, `surface-raised`, `room`, `ink`, `ink-muted`, `outline`, `stroke`, `yolk`, `on-yolk`, `accent`, `on-accent`, `focus-ring` | `AppColor.siang` / `AppColor.malam` → `ColorScheme` + `ThemeData` |
| `meter-*`, `attention`, `sick`, `pet-*`, `char-*` | `PetColors extends ThemeExtension<PetColors>` |
| `space-1` … `space-8` | `AppSpacing.s1` … `AppSpacing.s8` |
| `radius-sm` … `radius-full` | `AppRadius` |
| `size-*`, `border-*` | `AppSize`, `AppBorder` |
| `tm-display` … `tm-caption` | `AppTextStyle` (`GoogleFonts.fredoka()` untuk display, `GoogleFonts.lexend()` untuk teks) |
| `dur-*`, `ease-*` | `AppMotion` (`Duration` + `Curve`) |

- Ambil warna lewat `Theme.of(context).colorScheme` dan `Theme.of(context).extension<PetColors>()!`. Boleh membuat extension `BuildContext` agar lebih ringkas.
- Ikuti pola file di `lib/core/theme/` Henshin: satu kelas konstanta per keluarga token, konstruktor privat.
- Kalau sebuah nilai belum ada sebagai token, **tanya dulu** sebelum menambah token baru, lalu tambahkan juga ke `docs/design-system/tokens.json`.

### Gaya stiker dan tombol mainan

- Setiap kontrol dan kartu: isi `surface-raised`, garis `stroke` setebal `border-sticker` (2).
- Yang bisa ditekan punya bibir keras `shadow-lip` (`BoxShadow` offset 0,4 tanpa blur). Saat ditekan, turun 3px dan bibir menjadi `shadow-lip-pressed`.
- `shadow-float` hanya untuk VacationNote dan sheet.
- Target sentuh minimal 48; ActionButton 72, Button 56.

### Pengecualian: kapan angka mentah boleh dipakai

| Tempat | Kenapa |
| --- | --- |
| `PetPainter` dan `character_shapes.dart` | Geometri pet didefinisikan dalam kotak 120 × 120 unit (lihat `components/Pet/README.md`), lalu diskalakan |
| `GameRules` | Angka aturan game memang tinggal di sini |
| Test | Nilai fixture |
| Nilai yang dihitung saat runtime | Misalnya lebar pip dari nilai meter |

---

## Animation rules

- Pakai token durasi dan kurva dari `AppMotion`:

| Animasi | Token | Flutter |
| --- | --- | --- |
| Napas pet | `dur-breathe` 2400ms, `ease-breathe` | `AnimationController..repeat(reverse: true)`, `Curves.easeInOutSine`, skala 1.00–1.03 |
| Kedipan | `dur-blink` 120ms | Jeda 3–5 detik dari `Random` ber-seed |
| Reaksi aksi | `dur-react` 360ms, `ease-bounce` | `Curves.easeOutBack` |
| Geleng (ditolak) | `dur-shake` 420ms | 3 ayunan ±8° |
| Tombol ditekan | `dur-press` 90ms | `AnimatedContainer` / `AnimatedSlide` |
| Pip meter | `dur-meter` 400ms, `ease-standard` | `TweenAnimationBuilder`, `Curves.easeOutCubic` |
| Evolusi | `dur-reveal` 1200ms | `Interval` 0–0.3 kilau, 0.3–0.6 siluet, 0.6–1.0 karakter |

- Setiap `AnimationController` dibuat di `initState` dengan `vsync: this` dan **di-`dispose`**. Tidak boleh ada ticker yang bocor.
- Pakai `SingleTickerProviderStateMixin` untuk satu controller, `TickerProviderStateMixin` untuk lebih.
- Bungkus pet dengan `RepaintBoundary`. Painter mengembalikan `shouldRepaint` yang membandingkan field, bukan selalu `true`.
- Animasi diam tidak boleh membuat frame > 16 ms di profile mode.
- **Gerak dikurangi:** bila `MediaQuery.disableAnimationsOf(context)` true, napas dan kedipan berhenti, reaksi menjadi fade 150ms, dan EvolutionReveal langsung menampilkan karakter akhir.
- Ticker simulasi (60 detik, di bloc) dan ticker animasi (per frame, di widget) adalah dua hal terpisah. Jangan dicampur.

---

## Pet rendering rules

- v1 menggambar pet dengan `CustomPainter` (P0-7). Ikuti proporsi dan mood di `docs/design-system/components/Pet/README.md`.
- Enam mood: senang, biasa, lapar, sakit, tidur, murung. Mood dihitung oleh `resolveMood(state)` di domain, bukan di widget.
- Bentuk: Telur, Si Seimbang (juga Bayi/Anak/Remaja), Si Atletis, Si Gembul, Si Rapi, Si Mandiri.
- Skala tahap dari `size-pet` (200): Bayi 0.5, Anak 0.7, Remaja 0.85, Dewasa 1.0.
- Gambar PNG di `assets/images/pet/` adalah **acuan visual** untuk painter. Menggantinya dengan PNG sebagai renderer adalah P2-1; tanya dulu sebelum melakukannya. Bila nanti dikerjakan, renderer dibuat di balik abstraksi `PetRenderer` supaya logika tidak berubah.

---

## Image rule

Semua gambar diakses lewat satu kelas.

1. Cek apakah `lib/core/constants/app_images.dart` ada. Kalau belum, buat.
2. Daftarkan setiap path gambar di sana sebagai konstanta.
3. Pastikan folder sudah terdaftar di `pubspec.yaml` bagian `flutter: assets:`.
4. Pakai gambar lewat kelas itu, jangan tulis path string di widget.

```dart
class AppImages {
  AppImages._();

  static const _pet = 'assets/images/pet';

  static const moodSenang = '$_pet/ekspresi_senang.png';
  static const moodBiasa = '$_pet/ekspresi_biasa.png';
  static const moodLapar = '$_pet/ekspresi_lapar.png';
  static const moodSakit = '$_pet/ekspresi_sakit.png';
  static const moodTidur = '$_pet/ekspresi_tidur.png';
  static const moodMurung = '$_pet/ekspresi_murung.png';

  static const telur = '$_pet/karakter_telur.png';
  static const siSeimbang = '$_pet/karakter_si_seimbang.png';
  static const siAtletis = '$_pet/karakter_si_atletis.png';
  static const siGembul = '$_pet/karakter_si_gembul.png';
  static const siRapi = '$_pet/karakter_si_rapi.png';
  static const siMandiri = '$_pet/karakter_si_mandiri.png';
}
```

```dart
Image.asset(AppImages.siAtletis)
```

Gambar baru diberi nama `snake_case` yang jelas dan ditaruh di subfolder sesuai jenisnya di `assets/images/`.

---

## Copy and content rules

Semua teks UI dalam **Bahasa Indonesia sehari-hari**.

- Pemain disapa **kamu**. Di catatan dan notifikasi, pet berbicara sebagai **aku**. Di label sistem, pet disebut dengan namanya.
- Label tombol: satu kata kerja, huruf kapital hanya di awal ("Makan", "Main", "Bersihkan", "Jemput Tama").
- Paling banyak dua kalimat pendek per blok, sekitar 6 kata per kalimat. Ukuran teks terkecil 14px.
- Paling banyak satu tanda seru per pesan. Tanpa emoji di UI.
- **Jangan menyalahkan pemain.** Tulis apa yang dirasakan pet, bukan kesalahan pemain.

| Pakai | Hindari |
| --- | --- |
| Aku ke rumah nenek dulu. Jemput aku kalau kamu sudah siap, ya. | Kamu menelantarkan petmu selama 48 jam. |
| Tama kangen kamu | PERINGATAN: Tama lapar!!! |
| Tama lagi tidur. Main lagi besok pagi. | Aksi tidak tersedia. |

Kumpulkan string UI di satu file (misalnya `lib/core/constants/app_strings.dart`), jangan tersebar di widget.

---

## Accessibility rules

- Kontras: teks ≥ 4.5:1, ikon/garis/cincin fokus ≥ 3:1, di **kedua** tema. Token sudah memenuhi ini; jangan memakai pasangan warna di luar yang disebut di catatan token.
- Bungkus ActionButton, StatusMeter, dan pet dengan `Semantics` berisi kalimat lengkap: "Makan. Tama butuh ini.", "Kenyang: 3 dari 5", "Tama, lapar".
- Warna tidak pernah menjadi satu-satunya pembawa makna; selalu ada ikon atau label.
- Layout tetap muat sampai `TextScaler` 1.3x.

---

## Testing rules

- **Domain:** setiap aturan di `GameRules` punya test. Target cakupan `domain/` ≥ 90%.
- Gunakan `FakeClock` dan fixture dari `test/helpers/`. Jangan pernah memakai `DateTime.now()` di test.
- Tulis test dengan bahasa skenario: *"lewati 2 jam saat bangun, kenyang turun 16"*.
- **Bloc:** `bloc_test` + mocktail untuk `PetRepository`; ticker dites dengan `fake_async`.
- **Persistence:** test baca-tulis, test file rusak atau setengah tertulis, dan test setiap migrasi.
- Widget test hanya untuk perilaku penting (aksi ditolak memicu geleng, liburan menampilkan VacationNote), bukan untuk tiap piksel.

---

## Linting and validation

Sebelum menyatakan pekerjaan selesai, jalankan dan perbaiki semua error:

```bash
dart format .
flutter analyze
flutter test
```

Bila mengubah kelas freezed atau json_serializable, jalankan `build_runner` dulu (lihat di atas). Untuk cek cakupan: `flutter test --coverage`. Build APK: `flutter build apk --release`.

---

## Feature implementation rules

Saat pengembang meminta fitur:

1. Baca file ini dan bagian PRD terkait.
2. Pastikan fitur itu masuk fase sekarang.
3. Sebutkan file yang akan diubah.
4. Jaga perubahan tetap fokus; jangan menulis ulang kode yang tidak terkait.
5. Ikuti pola yang sudah ada.
6. Pastikan fitur jalan dari ujung ke ujung.
7. Jalankan validasi dan perbaiki error sebelum selesai.

---

## Important constraints

- **Offline sepenuhnya.** Tidak ada HTTP, akun, analytics, iklan, atau backend.
- **APK saja.** Jangan menambah konfigurasi Play Store atau iOS kecuali diminta.
- **Satu pet** di v1, tetapi skema JSON jangan menutup jalan untuk banyak pet (P2-2).
- **Tidak ada kematian pet** di v1.
- **Tidak ada Flame, Rive, atau Lottie.** Animasi memakai widget Flutter murni.
- Notifikasi (P1-1) paling banyak 3 per hari, tidak pernah di jam tidur, nadanya bersahabat.

---

## Communication style

- Jawab dalam **Bahasa Indonesia**, singkat.
- Setelah selesai: jelaskan apa yang berubah, kenapa, dan **cara mengetesnya** (perintah test atau langkah di HP).
- Untuk pekerjaan di area tujuan belajar, sertakan satu atau dua kalimat tentang konsep yang baru dipakai.

---

## Final reminder

Sebelum setiap fitur:

- Baca file ini dan PRD.
- Cek fase sekarang.
- Logika di domain, murni, dan dites lebih dulu.
- Semua nilai visual dari token design system.
- Tidak ada kematian, tidak ada hukuman visual, tidak menyalahkan pemain.
- Tanya sebelum menambah paket atau memutuskan hal yang masih terbuka.