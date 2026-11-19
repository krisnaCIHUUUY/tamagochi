TamaFlutter adalah peliharaan virtual offline untuk anak (8–12 tahun) dan remaja (13–17 tahun), dibangun dengan Flutter. Sistem ini mengatur satu layar utama, tempat pet tinggal, ditambah beberapa momen seperti liburan dan evolusi. Tampilannya seperti stiker dan tombol mainan plastik: garis tebal `stroke`, isi warna yang cerah, dan tombol dengan bibir keras yang turun saat ditekan.

## Prinsip

- **Pet adalah antarmukanya.** Pemain membaca keadaan dari wajah pet dulu (lihat Pet), baru dari meter. Mood selalu terlihat tanpa membuka menu.
- **Ikon dulu, kata kedua, angka tidak pernah.** Meter memakai lima pip, bukan persen. Angka yang boleh tampil hanya umur dan jam (`tm-numeral`).
- **Tidak ada hukuman visual.** Tidak ada tengkorak, merah gelap, layar abu-abu, atau kata "mati" dan "gagal". Kelalaian tampil sebagai pet yang murung atau catatan liburan.
- **Satu panggilan pada satu waktu.** Titik `attention` hanya muncul pada aksi yang benar-benar dibutuhkan sekarang, paling banyak dua sekaligus.

## Suara dan teks

Bahasa Indonesia sehari-hari. Pemain disapa **kamu**. Di catatan dan notifikasi, pet berbicara sebagai **aku**; di label sistem, pet disebut dengan namanya ("Tama").

- Label tombol berupa kata kerja, satu kata, huruf kapital di awal saja: "Makan", "Main", "Bersihkan", "Jemput Tama".
- Satu blok teks paling banyak dua kalimat pendek, sekitar 6 kata per kalimat.
- Paling banyak satu tanda seru per pesan. Tanpa emoji di UI; ikon yang menggantikannya.
- Jangan menyalahkan pemain. Ganti kalimat soal kesalahan pemain dengan apa yang dirasakan pet.

| Pakai | Hindari |
| --- | --- |
| Aku ke rumah nenek dulu. Jemput aku kalau kamu sudah siap, ya. | Kamu menelantarkan petmu selama 48 jam. |
| Tama kangen kamu | PERINGATAN: Tama lapar!!! |
| Waktu kamu pergi, Tama tumbuh | Evolusi selesai (karakter: ATLETIS) |
| Tama lagi tidur. Main lagi besok pagi. | Aksi tidak tersedia. |

## Warna

- Ada dua tema, **Siang** dan **Malam**. Tema mengikuti jam tidur pet (default 21.00–07.00), bukan setelan gelap ponsel: saat pet tidur, seluruh aplikasi ikut malam.
- Latar layar memakai `surface`, ruang pet memakai `room`, dan setiap kontrol serta kartu memakai `surface-raised` dengan garis `stroke` setebal `border-sticker`. Batas kontrol selalu datang dari `stroke`, bukan dari warna isi.
- Teks selalu `ink` atau `ink-muted`. Teks di atas `yolk` memakai `on-yolk`; teks di atas `accent` memakai `on-accent`.
- `yolk` adalah warna identitas. Pakai untuk satu Button primary per layar, chip Lampu, dan Si Seimbang.
- Warna chip mengikuti meter atau hal yang diubah aksinya: Makan `meter-hunger`, Main `meter-happy`, Camilan `char-gembul`, Bersihkan `char-rapi`, Obat `sick`, Lampu `yolk`. Ikon di dalam chip selalu `pet-ink`.
- `attention` hanya untuk titik panggilan. Error dan aksi yang ditolak tidak memakai warna merah; pet menggeleng (lihat ActionButton).
- `meter-hunger` dan `meter-happy` tidak dibedakan lewat warna saja. Setiap meter selalu punya ikon dan label.
- Warna tubuh pet (`char-*`, `pet-egg`) sama di kedua tema. Di Malam, pet terang di atas `room` yang gelap; di Siang, garis `pet-ink` yang memisahkannya dari latar.

## Tipografi

Dua keluarga dari Google Fonts (paket `google_fonts` di Flutter):

- **Fredoka** (`display`) untuk suara pet dan momen: `tm-display` hanya untuk nama karakter di EvolutionReveal, `tm-title` untuk judul kartu, `tm-numeral` untuk umur dan jam.
- **Lexend** (`body`) untuk semua yang dibaca: `tm-body`, `tm-label`, `tm-caption`. Lexend dirancang agar mudah dibaca pembaca muda.
- Tidak ada teks di bawah 14px (`tm-caption`). Teks dibiarkan membesar mengikuti `TextScaler` sampai 1.3x; layout harus tetap muat.

## Ruang, bentuk, dan bayangan

- Grid 4px: `space-1` sampai `space-8`. Gutter layar `space-4`, jarak antar-kelompok `space-6`.
- `radius-full` untuk Button, StageBadge, dan chip; `radius-md` untuk ActionButton dan kartu; `radius-lg` untuk ruang pet dan dock.
- `shadow-lip` hanya untuk yang bisa ditekan. Saat ditekan, tombol turun 3px dan berganti ke `shadow-lip-pressed`. `shadow-float` hanya untuk VacationNote dan sheet.
- Target sentuh minimal `size-touch-min` (48). ActionButton setinggi `size-action` (72), Button setinggi `size-button` (56).

## Gerak

Gerak adalah salah satu tujuan belajar, jadi setiap animasi punya token.

| Token | Flutter | Dipakai untuk |
| --- | --- | --- |
| `dur-breathe` + `ease-breathe` | `AnimationController(duration: 2400ms)..repeat(reverse: true)`, `Curves.easeInOutSine` | Napas pet saat diam, skala 1.00–1.03 |
| `dur-blink` | `TweenSequence` 120ms, jeda 3–5 dtk dari `Random(seed)` | Kedipan mata |
| `dur-react` + `ease-bounce` | `Curves.easeOutBack` | Lompat setelah makan atau main |
| `dur-shake` | 3 ayunan ±8° | Geleng saat aksi ditolak |
| `dur-press` | `AnimatedContainer` 90ms | Tombol turun saat ditekan |
| `dur-meter` + `ease-standard` | `TweenAnimationBuilder`, `Curves.easeOutCubic` | Pip terisi atau berkurang |
| `dur-reveal` | `Interval` 0–0.3 kilau, 0.3–0.6 siluet, 0.6–1.0 karakter | EvolutionReveal |

Kalau `MediaQuery.disableAnimationsOf(context)` bernilai true: napas dan kedipan berhenti, reaksi dan geleng diganti fade 150ms, dan EvolutionReveal langsung menampilkan karakter baru.

## Ikon

Ikon memakai **Material Symbols Rounded**, terisi, berat 500. Di Flutter pakai `Icons.<nama>_rounded` yang sudah ada di SDK, jadi tidak perlu aset. Pratinjau di sini memakai webfont Material Symbols, yang bentuknya sedikit berbeda dari set Material Icons di Flutter.

| Arti | Nama ikon | Flutter |
| --- | --- | --- |
| Makan | `restaurant` | `Icons.restaurant_rounded` |
| Camilan | `cookie` | `Icons.cookie_rounded` |
| Main | `sports_soccer` | `Icons.sports_soccer_rounded` |
| Bersihkan | `cleaning_services` | `Icons.cleaning_services_rounded` |
| Obat | `medication` | `Icons.medication_rounded` |
| Lampu | `lightbulb` | `Icons.lightbulb_rounded` |
| Kenyang | `rice_bowl` | `Icons.rice_bowl_rounded` |
| Senang | `favorite` | `Icons.favorite_rounded` |
| Tidur | `bedtime` | `Icons.bedtime_rounded` |
| Telur / umur | `egg` / `cake` | `Icons.egg_rounded` / `Icons.cake_rounded` |
| Liburan | `luggage` | `Icons.luggage_rounded` |
| Evolusi | `auto_awesome` | `Icons.auto_awesome_rounded` |
| Pulang | `home` | `Icons.home_rounded` |
| Pengaturan | `settings` | `Icons.settings_rounded` |

Belum ada logo. Nama aplikasi ditulis dengan Fredoka 600 dalam `ink`.

## Aksesibilitas

- Teks memenuhi minimal 4.5:1 dan ikon, garis, serta cincin fokus minimal 3:1 di kedua tema. Angka kontras ada di catatan tiap token.
- Setiap ActionButton dan StatusMeter dibungkus `Semantics` dengan kalimat lengkap, misalnya "Makan. Tama butuh ini." atau "Kenyang: 1 dari 5".
- Fokus memakai `focus-ring` 3px dengan jarak 3px.
- Warna tidak pernah menjadi satu-satunya pembawa makna; selalu ada ikon atau label juga.

## Untuk Flutter

Ikuti pola tema di Henshin: satu kelas konstanta per keluarga token di `lib/core/theme/`, ditambah satu `ThemeExtension` untuk warna khusus pet.

| Token | Dart |
| --- | --- |
| warna UI (`surface` … `on-accent`) | `AppColor.siang` / `AppColor.malam` → `ColorScheme` |
| warna pet dan meter (`meter-*`, `attention`, `sick`, `pet-*`, `char-*`) | `PetColors extends ThemeExtension<PetColors>` |
| `space-*`, `radius-*`, `size-*`, `border-*` | `AppSpacing`, `AppRadius`, `AppSize` |
| `tm-*` | `AppTextStyle` dengan `GoogleFonts.fredoka()` / `GoogleFonts.lexend()` |
| `dur-*`, `ease-*` | `AppMotion.breathe`, `AppMotion.bounce` (Duration dan Curve) |

```dart
@immutable
class PetColors extends ThemeExtension<PetColors> {
  const PetColors({required this.hunger, required this.happy, required this.attention, required this.ink});
  final Color hunger, happy, attention, ink;

  static const siang = PetColors(hunger: Color(0xFFC86400), happy: Color(0xFFD13F78), attention: Color(0xFFE0353C), ink: Color(0xFF1F2340));
  static const malam = PetColors(hunger: Color(0xFFFFA552), happy: Color(0xFFFF86B0), attention: Color(0xFFFF6B6E), ink: Color(0xFF1F2340));

  @override
  PetColors copyWith({Color? hunger, Color? happy, Color? attention, Color? ink}) =>
      PetColors(hunger: hunger ?? this.hunger, happy: happy ?? this.happy, attention: attention ?? this.attention, ink: ink ?? this.ink);

  @override
  PetColors lerp(PetColors? other, double t) => other == null ? this : PetColors(
        hunger: Color.lerp(hunger, other.hunger, t)!, happy: Color.lerp(happy, other.happy, t)!,
        attention: Color.lerp(attention, other.attention, t)!, ink: Color.lerp(ink, other.ink, t)!);
}
```

`lerp` membuat pergantian Siang ke Malam beranimasi dengan sendirinya saat `MaterialApp.theme` berganti.


---

## Consuming this system (generated — do not edit)

Every path named below is under `project/` in this design system: read `project/api/tokens.md`, not `api/tokens.md`.

9 components are documented without a runnable `components/bundle.js`: read each component’s card, and its README where it has one (`components/<Comp>/README.md`), and build to those guidelines. Tokens: the values are on `api/tokens.md`; a Slides deck or Design canvas also takes `tokens.json` by file path. On a Design canvas, also copy `tokens.css` to `project/ds/<folder>/tokens.css` in the call that installs this system, and link it in each artboard that uses this system, right after the `support.js` line and before the system’s other stylesheets: `<link rel="stylesheet" href="ds/<folder>/tokens.css">` (with one `../` in front for each folder the artboard is in).

**Read, per thing:** a component’s props, parts and examples: `api/components/<Comp>.md`; token values: `api/tokens.md`; stored assets and their paths: `api/assets/<Group>.md`. After this README, fetch the cards and fonts you need in ONE message as parallel calls — none depends on another.

**Two rules.** Before you use a thing — a component, a token group, an icon, an asset — read its card from the index below; a value you did not read from a card is a guess. `tokens.json`, `manifest.json` and `design-system.json` are sources for tools: hand them over. `components/<Comp>/README.md` is the long-form second read a card links to; `SKILL.md` and `artifact-type/` beside them are authoring guidance, not needed to consume the system.

## Index (generated — do not edit)

**Tokens**

- `api/tokens.md` — Every token: surface, text, fill, border, palette, type, spacing, radius, shadow, size, duration, easing. (14.3k)

**Icons and assets**

- `api/assets/Pet-Mood.md` — 6 files, by asset id. (1.1k)
- `api/assets/Egg-Pet-Character.md` — 6 files, by asset id. (1.2k)

**Components** (`api/components/<Comp>.md`, 9)

- **Aksi**: `ActionBar` — Dock 3 x 2 berisi enam ActionButton di bagian bawah PetScreen, selalu dalam urutan yang sama · `ActionButton` — Satu dari enam aksi rawat (Makan, Camilan, Main, Bersihkan, Obat, Lampu), digambar sebagai tombol mainan yang turun saat ditekan · `Button` — Tombol berlabel untuk keputusan di luar aksi rawat: Jemput Tama, Lihat Tama, Nanti saja
- **Momen**: `EvolutionReveal` — Momen kejutan satu layar saat app dibuka dan pet ternyata sudah berevolusi selama app tertutup (P0-5) · `VacationNote` — Catatan bertempel selotip yang menggantikan pet setelah 48 jam tanpa perawatan: pet pergi berlibur ke rumah nenek, bukan mati
- **Karakter**: `Pet` — Gambar pet yang dilukis PetPainter (CustomPainter) dari bentuk geometri saja: tubuh persegi bulat, dua kaki oval, mata, mulut, dan pipi
- **Layar**: `PetScreen` — Satu-satunya layar utama: StageBadge dan tombol pengaturan di atas, ruang pet di tengah, dua StatusMeter, lalu ActionBar di bawah
- **Status**: `StageBadge` — Pil kecil di kiri atas PetScreen yang menunjukkan tahap hidup dan umur pet, atau jam bangun saat pet tidur · `StatusMeter` — Meter Kenyang atau Senang dalam lima pip, seperti hati pada Tamagotchi asli, sehingga anak bisa membacanya tanpa angka
