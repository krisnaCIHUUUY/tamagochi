# TamaFlutter v1 (P0) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.
>
> Setelah disetujui, file ini disalin ke `docs/superpowers/plans/2026-11-19-tamaflutter-v1.md`. **Langkah 1 baru dikerjakan setelah ada persetujuan eksplisit dari user.**

**Goal:** Membangun TamaFlutter v1 (P0-1 s.d. P0-7): pet virtual offline dengan mesin simulasi waktu murni, penyimpanan JSON atomik, Bloc + ticker, UI sesuai design system, dan pet `CustomPainter` beranimasi.

**Architecture:** Inti berupa fungsi murni `simulate` / `applyAction` / `pickUp` di `features/pet/domain/` (Dart murni, tanpa Flutter). `PetBloc` membungkusnya: setiap event → simulate sampai `clock.now()` → terapkan efek → emit → simpan. UI hanya membaca `PetViewState`; painter menggambar satu frame, animator mengatur waktunya.

**Tech Stack:** Flutter 3.47 / Dart ^3.13, flutter_bloc, freezed + json_serializable, get_it, path_provider, google_fonts (font dibundel sebagai aset), bloc_test, mocktail, fake_async.

**Spec:** `docs/PRD Tamagotchi Flutter.md` + `design/TamaFlutter-design-system/` (README, `tokens.json`, `api/components/*.md`, `prd.md` = peta requirement→komponen) + mockup `design/UI/*/`. Konvensi di `CLAUDE.md`.

## Global Constraints

- Offline 100%: tidak ada request jaringan saat runtime (termasuk google_fonts → `GoogleFonts.config.allowRuntimeFetching = false`, font dibundel).
- `domain/` tidak mengimpor `package:flutter`, `dart:io`, atau kode data.
- Semua angka game hanya di `GameRules`; nilai awal persis dari tabel PRD "Aturan game".
- Identifier berbahasa Inggris; teks UI bahasa Indonesia, pemain "kamu", pet "aku"/"Tama", tanpa emoji, ≤ 1 tanda seru.
- Tidak ada kematian, kata "mati"/"gagal", tengkorak, atau merah untuk error. Aksi ditolak = pet geleng.
- Target sentuh ≥ 48 dp; meter 5 pip tanpa angka; teks ≥ 14 px; layout muat di `TextScaler` 1.3x.
- Warna/spasi/radius/durasi hanya dari token desain.
- Paket hanya yang ada di PRD "Tech stack"; tambahan apa pun harus ditanyakan dulu.
- Hanya P0 (+ P1-3 debug clock, yang ditarik ke Fase 3 oleh PRD). P1/P2 lain tidak dikerjakan.

## Keputusan aturan yang TIDAK ada di PRD (perlu Anda konfirmasi)

Aturan di PRD belum lengkap untuk ditulis jadi kode. Usulan saya di bawah; semuanya jadi konstanta `GameRules` sehingga mudah diubah.

| # | Celah di PRD | Usulan |
| --- | --- | --- |
| K1 | **Batas catch-up 10** vs sakit "kenyang 0 > 60 menit" (open question blocking #1) | `simulate(..., offline: true)` saat app dibuka/resumed → meter tidak turun di bawah 10. Ticker saat app terbuka `offline: false` → meter bisa 0 dan memicu sakit. |
| K2 | Per menit vs per kejadian (open question blocking #2) | Per menit (sesuai usulan PRD). Langkah terakhir boleh < 1 menit supaya `lastUpdated == to` persis. Ganti hanya bila benchmark Task 14 gagal. |
| K3 | "Aksi seimbang" tidak didefinisikan | `balancedActions` = jumlah aksi **Makan** biasa yang diterima. Main→Atletis, Camilan→Gembul, bersih tepat waktu→Rapi, jam terlantar→Mandiri, makan biasa→Seimbang. |
| K4 | "Unggul lebih dari 20%" pada satuan berbeda | Skor: plays, snacks, timelyCleans, `neglectMinutes ~/ 60`, balancedActions. Pemenang = skor tertinggi bila ≥ 1.2 × skor kedua; selain itu (termasuk semua 0) → Seimbang. |
| K5 | Karakter Remaja tidak didefinisikan, hanya 5 karakter dewasa | Evolusi pertama (akhir Anak) memberi salah satu dari 5 karakter yang sama, digambar lebih kecil; evolusi kedua (akhir Remaja) boleh mengganti karakter. |
| K6 | "Bersih tepat waktu", "menit terlantar" | Tepat waktu = dibersihkan ≤ 1 jam sejak tumpukan pertama muncul. Menit terlantar = menit bangun dengan kenyang ≤ 20 atau senang ≤ 20, atau menit saat liburan. Dihitung sejak tahap Anak. |
| K7 | "Kedekatan tidak pernah turun lebih dari 10/hari", tapi tidak ada aturan turun | v1: kedekatan hanya naik (+1 per aksi yang dibutuhkan: makan saat kenyang < 50, main saat senang < 50, bersihkan, obat, lampu mati saat tidur). Batas turun otomatis terpenuhi. |
| K8 | Nilai awal saat menetas | Kenyang 80, senang 80, berat 100 g, berat minimum 10 g. Telur: meter tidak turun. |
| K9 | Kotoran "sekitar 3 jam" | Tepat 3 jam setelah setiap **Makan** (bukan camilan); bila jatuh di jam tidur, muncul saat bangun; maksimal 4 tumpukan. |
| K10 | Saat liburan | Meter, kotoran, dan sakit dibekukan; umur, tahap, evolusi, dan menit terlantar tetap berjalan. |
| K11 | Ambang mood | Lapar bila kenyang ≤ 30; senang bila senang ≥ 70; prioritas: tidur > sakit > murung > lapar > senang > biasa. |
| K12 | Lampu | Aksi Lampu menyalakan/mematikan lampu, tidak pernah ditolak. Saat bangun: kalau lampu menyala sepanjang tidur → senang −10, lalu lampu otomatis menyala. |
| K13 | Repo belum git | Task 1 menjalankan `git init` + commit awal; setiap task diakhiri commit. Kalau tidak mau pakai git, langkah commit dilewati. |

## Review Focus

Input atau kondisi yang tidak diuji eksplisit oleh PRD, tetapi paling mungkin merusak pengalaman pemain. Masing-masing sudah punya test di task pemiliknya:

1. **Dua aksi diketuk cepat atau save tumpang-tindih** → state tidak hilang dan file tidak rusak. Test: Task 16 (`concurrent saves keep last state`) dan Task 18 (`two rapid actions both applied`).
2. **Sisa `pet.json.tmp` atau file JSON rusak/versi tak dikenal** → pet lama tidak terhapus diam-diam. Test: Task 16.
3. **`DateTime` UTC vs lokal / zona waktu ponsel berganti** → jam tidur dihitung dari jam lokal. Test: Task 4 (`isAsleepAt uses local time`).
4. **Teks 1.3x di layar kecil (360×640)** → tidak ada overflow. Test: Task 24.
5. **Kembali dari jam yang dipercepat ke jam normal** (`lastUpdated` di masa depan) → pet tidak beku lama tanpa penjelasan. Test: Task 25.

---

## Struktur file

```text
lib/
  main.dart, app.dart, injection_container.dart
  core/clock/{clock.dart, system_clock.dart, accelerated_clock.dart}
  core/theme/{tama_tokens.dart, tama_theme.dart}
  features/pet/domain/entities/{pet_state.dart, care_style.dart, sleep_schedule.dart, enums.dart}
  features/pet/domain/rules/game_rules.dart
  features/pet/domain/simulation/{simulate.dart, apply_action.dart, evolution.dart, mood_resolver.dart}
  features/pet/domain/repositories/pet_repository.dart
  features/pet/data/models/pet_save_file.dart          # envelope {schemaVersion, pet} + migrate
  features/pet/data/repositories/pet_repository_impl.dart
  features/pet/presentation/bloc/{pet_bloc.dart, pet_event.dart, pet_view_state.dart}
  features/pet/presentation/lifecycle/pet_lifecycle_listener.dart
  features/pet/presentation/painter/{pet_painter.dart, character_shapes.dart}
  features/pet/presentation/animation/{idle_animator.dart, reaction_animator.dart}
  features/pet/presentation/screens/pet_screen.dart
  features/pet/presentation/widgets/{status_meter.dart, stage_badge.dart, action_button.dart, action_bar.dart, vacation_note.dart, evolution_reveal.dart}
assets/fonts/  (Fredoka, Lexend .ttf)
test/ cermin lib/ + test/helpers/{fake_clock.dart, pet_state_fixtures.dart}
```

Penyimpangan kecil dari tree PRD: empat enum digabung ke `enums.dart`; `pet_state_model.dart` diganti `pet_save_file.dart`. `PetState` punya `fromJson` freezed sendiri (json_annotation adalah Dart murni), jadi data layer cukup mengurus envelope versi dan migrasi, tanpa mapping ganda.

## Interfaces inti (dipakai lintas task)

```dart
// core/clock/clock.dart
abstract class Clock { DateTime now(); }

// enums.dart
enum LifeStage { egg, baby, child, teen, adult }
enum Mood { happy, neutral, hungry, sick, asleep, moody }
enum CareAction { feed, snack, play, clean, medicine, lights }
enum PetCharacter { atletis, gembul, rapi, mandiri, seimbang }

// sleep_schedule.dart (freezed + json)
SleepSchedule({int startHour = 21, int endHour = 7}); bool isAsleepAt(DateTime t);

// care_style.dart (freezed + json)
CareStyle({int plays = 0, int snacks = 0, int timelyCleans = 0, int neglectMinutes = 0, int balancedActions = 0});

// pet_state.dart (freezed + json)
PetState({
  required DateTime bornAt, required DateTime lastUpdated, required DateTime lastCareAt,
  required DateTime stageStartedAt, LifeStage stage = LifeStage.egg, PetCharacter? character,
  double fullness, double happiness, int poop = 0, List<DateTime> poopDueAt = const [],
  DateTime? firstPoopAt, bool isSick = false, int medicineDoses = 0, int weight, double bond = 0,
  bool lightsOn = true, bool lightsOnAllSleep = false, bool isMoody = false, bool onVacation = false,
  Duration zeroNeedFor = Duration.zero, Duration heavyPoopFor = Duration.zero, Duration lowBothFor = Duration.zero,
  List<DateTime> recentSnacks = const [], CareStyle careStyle = const CareStyle(),
  SleepSchedule sleepSchedule = const SleepSchedule(), bool pendingReveal = false,
});
factory PetState.newEgg(DateTime now);
extension on PetState { int ageYears(DateTime now); bool isAsleepAt(DateTime now); }

// simulation/*
PetState simulate(PetState state, {required DateTime from, required DateTime to, bool offline = false});
typedef ActionResult = ({PetState state, bool accepted});
ActionResult applyAction(PetState state, CareAction action, DateTime now);
PetState pickUp(PetState state, DateTime now);              // "Jemput"
PetCharacter chooseCharacter(CareStyle style);
Mood resolveMood(PetState state, DateTime now);
List<CareAction> neededActions(PetState state, DateTime now); // maks. 2, untuk titik attention

// repositories
abstract class PetRepository { Future<PetState?> load(); Future<void> save(PetState state); }
```

Catatan: `simulate` menambah parameter opsional `offline` dibanding signature PRD (lihat K1).

---

# Fase 0 — Fondasi proyek

### Task 1: Dependensi, scaffold, buang template counter

**Files:** Modify `pubspec.yaml`, `lib/main.dart`, `lib/app.dart`, `test/widget_test.dart`; Create `assets/fonts/*`.
**Produces:** `TamaApp` (StatelessWidget) di `app.dart`; `main()` memanggil `runApp(const TamaApp())`.

- [ ] `git init` + commit awal kondisi sekarang (K13).
- [ ] `flutter pub add flutter_bloc freezed_annotation json_annotation get_it path_provider google_fonts` dan `flutter pub add dev:build_runner dev:freezed dev:json_serializable dev:bloc_test dev:mocktail dev:fake_async`.
- [ ] Unduh TTF Fredoka + Lexend (OFL) ke `assets/fonts/`, daftarkan di `pubspec.yaml` `flutter: assets:`.
- [ ] Ganti test `widget_test.dart`: `testWidgets('app boots', ...)` → `pumpWidget(const TamaApp())`, `expect(find.byType(MaterialApp), findsOneWidget)`.
- [ ] Ganti `main.dart`/`app.dart` dengan `TamaApp` minimal (MaterialApp + Scaffold kosong).
- [ ] Jalankan `flutter analyze` → No issues; `flutter test` → All passed; `dart run build_runner build --delete-conflicting-outputs` → selesai tanpa error.
- [ ] Commit `chore: scaffold dependencies and remove counter template`.

---

# Fase 1 — Domain murni (tanpa UI). Gerbang: semua test domain hijau, coverage domain ≥ 90%, benchmark < 50 ms.

### Task 2: Clock + FakeClock

**Files:** Create `lib/core/clock/clock.dart`, `system_clock.dart`, `test/helpers/fake_clock.dart`, `test/core/clock/fake_clock_test.dart`.
**Produces:** `Clock`, `SystemClock`, `FakeClock(DateTime start)` dengan `now()`, `advance(Duration)`, `set(DateTime)`.

- [ ] Test `advance moves now forward`: `FakeClock(DateTime(2026,1,1,8))..advance(Duration(hours: 2))` → `now() == DateTime(2026,1,1,10)`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 3: Enums, GameRules, SleepSchedule, CareStyle, PetState

**Files:** Create `entities/{enums,sleep_schedule,care_style,pet_state}.dart`, `rules/game_rules.dart`, `test/helpers/pet_state_fixtures.dart`, `test/features/pet/domain/entities/pet_state_test.dart`.
**Produces:** semua tipe di "Interfaces inti"; `abstract final class GameRules` berisi semua nilai PRD + K1–K12 sebagai `static const`. Fixtures: `awakePet({double fullness = 80, ...})` dengan `lastUpdated = DateTime(2026,1,5,10)` (jam bangun), `childPet(...)`.

- [ ] Test:
  - `newEgg has defaults`: stage `egg`, `fullness == 80`, `happiness == 80`, `weight == 100`, `lastUpdated == bornAt == now`.
  - `json round-trip`: `PetState.fromJson(s.toJson()) == s` untuk fixture yang semua fieldnya terisi (termasuk `Duration`, list `DateTime`, `character`).
  - `ageYears`: `newEgg(t).ageYears(t + 3 hari + 1 jam) == 3`.
- [ ] Run → FAIL; implementasi + `build_runner`; run → PASS. Commit.

### Task 4: SleepSchedule.isAsleepAt

**Files:** Modify `sleep_schedule.dart`; Test `test/features/pet/domain/entities/sleep_schedule_test.dart`.

- [ ] Test (default 21→7): 21:00 true, 23:59 true, 06:59 true, 07:00 false, 20:59 false. Jadwal tanpa lewat tengah malam `SleepSchedule(startHour: 13, endHour: 15)`: 14:00 true, 15:00 false.
- [ ] **Review Focus 3**, test `isAsleepAt uses local time`: `isAsleepAt(DateTime(2026,1,1,22).toUtc()) == true`.
- [ ] Run → FAIL; implementasi pakai `t.toLocal()`; run → PASS. Commit.

> ❓ **BELUM JELAS (sedang):** jadwal tidur dihitung dari jam lokal ponsel. Kalau zona waktu berganti (bepergian), jendela tidur ikut bergeser. Ini dianggap wajar dan tidak diuji lebih jauh.

### Task 5: `simulate` inti — peluruhan meter, tidur, jam mundur, telur, bayi

**Files:** Create `simulation/simulate.dart`; Test `test/features/pet/domain/simulation/simulate_test.dart`.
**Produces:** `simulate` dengan loop per menit (K2). Tiap langkah: tentukan tidur/bangun → kurangi meter kalau bangun (bayi 2×, telur tidak) → clamp 0–100 → majukan waktu. Task 6–10 menambah aturan ke dalam loop yang sama.

- [ ] Test (pakai `closeTo(x, 0.001)` untuk meter):
  - `awake 2h: fullness 80 -> 64` (PRD P0-1), `happiness 80 -> 68`.
  - `fully asleep range leaves meters unchanged` (22:00→06:00).
  - `to before from returns identical state` (`expect(result, same(state))`).
  - `range crossing bedtime only decays awake part` (20:00→22:00 → kenyang turun 8).
  - `baby decays twice as fast` (bayi, 1 jam bangun → kenyang 80 → 64).
  - `egg does not decay and hatches after 5 minutes` → stage `baby`, `stageStartedAt == bornAt + 5 menit`.
  - `lastUpdated equals to after partial minute` (rentang 90 detik).
  - `meters clamp at 0`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

> ⚠️ **RISIKO TINGGI:** ini jantung seluruh game, dan pilihan "per menit" (K2) adalah open question *blocking* di PRD. Desain loop yang salah memaksa Task 6–10 ditulis ulang. Mitigasi: semua aturan berbasis durasi disimpan sebagai `Duration` kumulatif di `PetState`, jadi pindah ke "per kejadian" nanti tidak mengubah state.

### Task 6: Kotoran + lampu + transisi bangun

**Files:** Modify `simulate.dart`; Test `simulate_poop_lights_test.dart`.

- [ ] Test:
  - `poop appears 3h after feed`: state dengan `poopDueAt: [t+3h]`, simulate 3h1m → `poop == 1`, `firstPoopAt == t+3h`.
  - `poop due during sleep appears at wake` (jatuh 23:00 → muncul 07:00).
  - `poop caps at 4`.
  - `lights left on all night: happiness -10 at wake` (21:00→07:01, `lightsOn: true`): senang turun tepat 10 dari nilai saat tidur.
  - `lights off at night: no penalty, lights back on at wake`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 7: Aturan sakit

**Files:** Modify `simulate.dart`; Test `simulate_sickness_test.dart`.

- [ ] Test:
  - `zero fullness for 61 min makes sick` (online) dan `for 59 min does not`.
  - `zero happiness for 61 min makes sick`.
  - `3 poop for 2h makes sick`, `2 poop for 10h does not`.
  - `zeroNeedFor resets when meter rises above 0`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 8: Murung, liburan, batas catch-up offline

**Files:** Modify `simulate.dart`; Test `simulate_moody_vacation_test.dart`.

- [ ] Test:
  - `both <= 20 for 6h makes moody` dan `5h59m does not`.
  - `48h without care -> onVacation` (dari `lastCareAt`, jam dinding termasuk tidur).
  - `vacation freezes meters, poop, sickness but age advances` (K10).
  - `offline never drops fullness/happiness below 10` (simulate 3 hari, `offline: true`).
  - `online can reach 0` (`offline: false`).
  - **PRD P0-6**, `30 days offline -> on vacation, meters >= 10`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

> ⚠️ **RISIKO TINGGI / ❓ BELUM JELAS:** batas 10 adalah open question *blocking* #1. Usulan K1 membuat sakit karena meter 0 hanya bisa terjadi saat app terbuka. Kalau Anda ingin pet yang ditinggal "lebih menyedihkan", aturan ini dan test-nya berubah.

### Task 9: `applyAction` — Makan, Camilan, Main

**Files:** Create `simulation/apply_action.dart`; Test `apply_action_test.dart`.
**Produces:** `applyAction` hanya menerapkan efek pada state yang **sudah** disimulasikan ke `now` (bloc yang memanggil `simulate` dulu). Aksi diterima → `lastCareAt = now`; aksi ditolak → `(state: state, accepted: false)` dengan state identik.

- [ ] Test:
  - `feed: +30 fullness, +5 weight, schedules poop at now+3h, clears moody`.
  - `feed rejected when fullness == 100` dan `when sick`.
  - `feed clamps at 100` (kenyang 90 → 100).
  - `snack: +15 happiness, +10 fullness, +10 weight`.
  - `6th snack within an hour makes sick, 5th does not`.
  - `play: +20 happiness, -5 weight`; `rejected when asleep / sick / moody`.
  - `weight never below 10`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 10: `applyAction` — Bersihkan, Obat, Lampu + kedekatan + `pickUp`

**Files:** Modify `apply_action.dart`; Test `apply_action_care_test.dart`.

- [ ] Test:
  - `clean sets poop 0, clears firstPoopAt`; `rejected when poop == 0`.
  - `medicine: first dose keeps sick, second cures and resets doses`; `rejected when not sick`.
  - `lights toggles and is never rejected`.
  - `bond +1 for needed action (feed at fullness 40), +0 for unneeded (feed at 60)` (K7).
  - `any action rejected while onVacation`.
  - `pickUp: fullness 50, happiness 50, poop 0, not sick, not moody, onVacation false, lastCareAt now`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 11: Tahap hidup + penghitung gaya perawatan

**Files:** Modify `simulate.dart`, `apply_action.dart`; Test `life_stage_test.dart`.

- [ ] Test:
  - `stages advance: egg 5m -> baby 1d -> child 3d -> teen 4d -> adult` (cek `stage` di setiap batas ±1 menit).
  - `care style not counted before child` (main saat bayi → `plays == 0`).
  - `child: play/snack/feed increment plays/snacks/balancedActions`.
  - `clean within 1h of first poop counts timelyCleans, after 1h does not` (K6).
  - `neglectMinutes counts awake minutes with a meter <= 20 and vacation minutes`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 12: Evolusi

**Files:** Create `simulation/evolution.dart`; Modify `simulate.dart`; Test `evolution_test.dart`.
**Produces:** `chooseCharacter` (K4). Di batas Anak→Remaja dan Remaja→Dewasa, `simulate` mengisi `character`, mereset `careStyle`, dan menyetel `pendingReveal = true`.

- [ ] Test `chooseCharacter`:
  - `plays 12, others 5 -> atletis`; `snacks dominant -> gembul`; `timelyCleans -> rapi`; `neglectMinutes 600 (=10) vs 5 -> mandiri`; `balancedActions dominant -> seimbang`.
  - `top 11 vs second 10 (< 20% lead) -> seimbang`; `all zero -> seimbang`.
- [ ] Test integrasi (**PRD P0-5**) `all five adults reachable`: lima skenario, masing-masing menjalankan simulasi + aksi berulang dengan `FakeClock` dari telur sampai dewasa memakai satu gaya, lalu `expect(state.character, <target>)`.
- [ ] Test `evolution resets careStyle and sets pendingReveal`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

> ⚠️ **RISIKO TINGGI / ❓ BELUM JELAS:** PRD tidak mendefinisikan "aksi seimbang", cara membandingkan satuan berbeda (menit vs jumlah), maupun wujud karakter Remaja (K3–K5). Kalau definisinya salah, evolusi terasa acak bagi pemain, padahal itu Goal produk #5. Konfirmasi K3–K5 sebelum task ini dimulai.

### Task 13: Mood + aksi yang dibutuhkan

**Files:** Create `simulation/mood_resolver.dart`; Test `mood_resolver_test.dart`.

- [ ] Test `resolveMood` (K11): `asleep beats sick`, `sick beats moody`, `moody beats hungry`, `fullness 30 -> hungry`, `happiness 70 -> happy`, `otherwise neutral`, `egg -> neutral`.
- [ ] Test `neededActions`: `sick -> [medicine]` paling depan; `poop>0 and fullness<50 -> [clean, feed]`; maks. 2 item; `asleep with lights on -> [lights]`; `onVacation -> []`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 14: Determinisme + benchmark (gerbang Fase 1)

**Files:** Test `simulate_benchmark_test.dart`.

- [ ] Test `same input same output` (7 hari, dua kali → `==`).
- [ ] Test `30 days < 50 ms`: `Stopwatch` di sekitar `simulate(childPet, from, from + 30 hari, offline: true)` → `elapsedMilliseconds < 50`.
- [ ] Jalankan `flutter test --coverage`; cek coverage `lib/features/pet/domain/` ≥ 90% (lihat `coverage/lcov.info`).
- [ ] Commit `test: phase 1 gate`.

> ⚠️ **RISIKO (sedang):** 43.200 iterasi dengan alokasi `copyWith` per menit bisa melewati 50 ms. Mitigasi: di dalam loop pakai variabel lokal yang bisa diubah, dan `copyWith` sekali di akhir. Benchmark di PC lebih cepat dari HP; ukur ulang di perangkat pada Task 29.

---

# Fase 2 — Data, Bloc, lifecycle. Gerbang: test repo + bloc hijau.

### Task 15: Envelope simpanan + migrasi

**Files:** Create `data/models/pet_save_file.dart`; Test `test/features/pet/data/pet_save_file_test.dart`.
**Produces:** `const currentSchemaVersion = 1; Map<String,dynamic> encodeSave(PetState); PetState decodeSave(Map<String,dynamic>)`; `Map<String,dynamic> migrate(Map<String,dynamic> json, int fromVersion)` (v1 = identitas). Versi lebih baru dari `currentSchemaVersion` → `FormatException`.

- [ ] Test: `round-trip`, `schemaVersion written as 1`, `future version throws FormatException`, `migrate v1 is identity`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 16: PetRepositoryImpl (tulis atomik)

**Files:** Create `domain/repositories/pet_repository.dart`, `data/repositories/pet_repository_impl.dart`; Test `test/features/pet/data/pet_repository_impl_test.dart` (pakai `Directory.systemTemp.createTemp()`).
**Produces:** `PetRepositoryImpl(Directory dir)`; file `pet.json`; tulis ke `pet.json.tmp` lalu `rename`; semua `save` diserialkan lewat rantai `Future` internal.

- [ ] Test:
  - `load returns null when no file`.
  - `save then load returns equal state`.
  - **Review Focus 2**, `leftover pet.json.tmp is ignored`: tmp berisi sampah + pet.json valid → load = pet valid.
  - **Review Focus 2**, `corrupt pet.json is renamed to pet.json.corrupt and load returns null` (file asli tidak dihapus).
  - **Review Focus 1**, `concurrent saves keep last state`: `Future.wait([save(a), save(b)])` → load == b.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

> ⚠️ **RISIKO (sedang):** perilaku `File.rename` menimpa file berbeda di Windows (tempat test jalan) dan Android. Test di Windows membuktikan logikanya; uji force-close nyata di HP ada di Task 29.

### Task 17: PetViewState + PetEvent

**Files:** Create `presentation/bloc/pet_event.dart`, `pet_view_state.dart`.
**Produces:**
```dart
sealed class PetEvent; // PetStarted, PetTicked, PetResumed, PetPaused, CareActionPressed(CareAction action), PickUpPressed, RevealSeen
@freezed PetViewState({PetState? pet, Mood mood = Mood.neutral, List<CareAction> needed = const [], PetReaction? reaction});
@freezed PetReaction({required CareAction action, required bool accepted, required int seq}); // seq naik tiap aksi agar animasi terpicu ulang
```
- [ ] Tanpa test sendiri (tipe data murni); diverifikasi oleh Task 18. `build_runner` + `flutter analyze` bersih. Commit.

### Task 18: PetBloc

**Files:** Create `presentation/bloc/pet_bloc.dart`; Test `test/features/pet/presentation/pet_bloc_test.dart` (bloc_test + mocktail `MockPetRepository` + `FakeClock`).
**Produces:** `PetBloc({required PetRepository repository, required Clock clock, Duration tickInterval = const Duration(seconds: 60)})`. Setiap handler: hitung state baru secara sinkron dari `state` → `emit` → baru `await repository.save` (supaya dua event tidak membaca state basi).

- [ ] Test:
  - `started with no save creates egg and saves it`.
  - `started with save simulates offline to now` (save 3 hari lalu → `pet.fullness >= 10`, `lastUpdated == clock.now()`).
  - `feed pressed simulates first then applies` (kenyang 80, maju 2 jam, makan → 94).
  - `rejected action emits reaction accepted=false and does not save`.
  - **Review Focus 1**, `two rapid actions both applied` (dua `CareActionPressed(snack)` tanpa jeda → senang +30).
  - `ticker fires every 60s while resumed, stops after paused` (fake_async: elapse 180 dtk → 3 tick; pause; elapse 180 dtk → tidak ada emit baru).
  - `close cancels ticker` (tidak ada timer tersisa setelah `bloc.close()` di fake_async).
  - `paused saves state`; `pickUp clears vacation and saves`; `revealSeen clears pendingReveal`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

> ⚠️ **RISIKO (sedang):** gabungan `Stream.periodic` + fake_async + bloc_test rawan test yang menggantung atau timer bocor (P0-2). Pakai `StreamSubscription` yang di-cancel di `PetPaused` dan `close()`.

### Task 19: DI + lifecycle listener + wiring app

**Files:** Modify `lib/injection_container.dart`, `lib/main.dart`, `lib/app.dart`; Create `presentation/lifecycle/pet_lifecycle_listener.dart`; Test `test/features/pet/presentation/pet_lifecycle_listener_test.dart`.
**Produces:** `Future<void> initDependencies()` mendaftarkan `Clock` (`SystemClock`), `PetRepository` (`PetRepositoryImpl(await getApplicationDocumentsDirectory())`), dan factory `PetBloc`. `PetLifecycleListener({required Widget child})` memakai `AppLifecycleListener` dan mengirim `PetResumed` saat resumed, `PetPaused` saat paused/hidden.

- [ ] Test widget (mock bloc): `tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused)` → `verify(() => bloc.add(PetPaused()))`; resumed → `PetResumed`.
- [ ] Run → FAIL; implementasi; run → PASS. `flutter run` di emulator: app terbuka tanpa crash, `pet.json` terbentuk. Commit.

---

# Fase 3 — UI statis, painter, debug clock. Gerbang: semua layar tampil benar di HP, siang dan malam.

### Task 20: Token + tema Siang/Malam

**Files:** Create `lib/core/theme/tama_tokens.dart` (salin manual dari `design/TamaFlutter-design-system/tokens.json`: warna per tema, space, radius, shadow, size, durasi, kurva), `tama_theme.dart`; Test `test/core/theme/tama_theme_test.dart`.
**Produces:** `class TamaColors extends ThemeExtension<TamaColors>` dengan field per token warna (`surface`, `surfaceRaised`, `room`, `ink`, `inkMuted`, `stroke`, `yolk`, `meterHunger`, `meterHappy`, `attention`, `sick`, `petInk`, `char*`...), `TamaColors.siang` / `.malam`; `ThemeData tamaTheme(TamaColors c)` dengan Fredoka/Lexend dari aset; `abstract final class TamaSpace/TamaRadius/TamaSize/TamaMotion`.

- [ ] Test: `siang surface == Color(0xFFF5F7FC)`, `malam surface == Color(0xFF12152B)`, `theme exposes TamaColors extension`, `GoogleFonts.config.allowRuntimeFetching == false` setelah `tamaTheme` dipanggil.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

> ⚠️ **RISIKO TINGGI:** secara default `google_fonts` **mengunduh font dari internet saat runtime**, dan itu melanggar "100% offline". Wajib bundel TTF di `assets/fonts/` dan `allowRuntimeFetching = false`. Kalau terlewat, font gagal dimuat tanpa koneksi dan test widget bisa mencoba akses jaringan.

### Task 21: PetPainter statis (bentuk + ekspresi)

**Files:** Create `painter/pet_painter.dart`, `painter/character_shapes.dart`; Test `test/features/pet/presentation/pet_painter_test.dart`.
**Produces:** `PetPainter({required LifeStage stage, PetCharacter? character, required Mood mood, required TamaColors colors, double breath = 0, double blink = 0, Offset reactionOffset = Offset.zero, double reactionAngle = 0})`; `shouldRepaint` membandingkan semua field. Telur = `karakter_telur`; bayi/anak = bentuk dasar; remaja = karakter skala 0.85; dewasa = karakter penuh.

- [ ] Test: `paints every stage x mood without throwing` (pump `CustomPaint` untuk semua kombinasi); `shouldRepaint false for identical args, true when mood changes`.
- [ ] Bandingkan manual dengan `design/karakter_virtual_pet_terpisah/*.png` dan `components/Pet/README.md` (jalankan di emulator).
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

> ❓ **BELUM JELAS (sedang):** open question PRD "tampilan 5 karakter dengan geometri saja". PNG di `design/` dipakai **hanya sebagai referensi bentuk** dan tidak dibundel (non-goal aset ilustrasi). Bagian ini paling banyak butuh iterasi visual, dan test tidak bisa membuktikan "terlihat bagus".

### Task 22: StatusMeter + StageBadge

**Files:** Create `widgets/status_meter.dart`, `widgets/stage_badge.dart`; Test `status_meter_test.dart`, `stage_badge_test.dart`.
**Produces:** `StatusMeter({required IconData icon, required String label, required double value, bool paused = false})` berisi 5 pip, jumlah pip terisi = `(value / 20).ceil()`, dianimasikan `TweenAnimationBuilder` (`dur-meter`, `easeOutCubic`). `StageBadge({required LifeStage stage, required int ageYears})`. Spesifikasi: `api/components/StatusMeter.md`, `StageBadge.md`.

- [ ] Test: `value 0 -> 0 filled pips`, `value 41 -> 3`, `value 100 -> 5`; `no numeric text rendered`; `semantics label contains label`; `StageBadge shows "Anak" and "3 tahun"`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 23: ActionButton + ActionBar

**Files:** Create `widgets/action_button.dart`, `widgets/action_bar.dart`; Test `action_button_test.dart`.
**Produces:** `ActionButton({required CareAction action, required VoidCallback onPressed, bool attention = false})` dengan tinggi `size-action` 72, efek tekan turun 3px `AnimatedContainer` `dur-press` 90 ms, warna chip sesuai README. `ActionBar({required List<CareAction> needed, required ValueChanged<CareAction> onAction})` berisi 6 tombol. Label: "Makan", "Camilan", "Main", "Bersihkan", "Obat", "Lampu".

- [ ] Test: `every button >= 48x48`, `tap calls onAction with action`, `attention dot shown only for needed (max 2)`, `icons are *_rounded per design table`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 24: PetScreen + VacationNote

**Files:** Create `screens/pet_screen.dart`, `widgets/vacation_note.dart`; Modify `app.dart`; Test `pet_screen_test.dart` (mock `PetBloc` via `MockBloc`).
**Produces:** `PetScreen` = `BlocBuilder<PetBloc, PetViewState>`; tema Siang/Malam dari `pet.isAsleepAt(clock.now())` (bukan dark mode ponsel); `pet == null` → indikator muat. Saat `onVacation` → `VacationNote` berteks "Aku ke rumah nenek dulu. Jemput aku kalau kamu sudah siap, ya." + `Button` "Jemput Tama" → `PickUpPressed`. Referensi layar: `design/UI/Beranda · Siang-html`, `Beranda · Malam (Tama tidur)-html`, `Liburan-html`.

- [ ] Test: `shows meters, badge, action bar when awake`; `uses malam colors when asleep`; `vacation shows note and Jemput dispatches PickUpPressed`; **Review Focus 4**, `no overflow at 360x640 with textScaler 1.3` (`tester.view.physicalSize`, `MediaQuery(textScaler: TextScaler.linear(1.3))`, `expect(tester.takeException(), isNull)`).
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 25: AcceleratedClock (P1-3, ditarik ke Fase 3)

**Files:** Create `lib/core/clock/accelerated_clock.dart`; Modify `injection_container.dart`; Test `test/core/clock/accelerated_clock_test.dart`.
**Produces:** `AcceleratedClock({required Clock base, required int factor})`: `now() = anchor + (base.now() - anchor) * factor`. Didaftarkan hanya bila `kDebugMode` dan `--dart-define=TAMA_SPEED=60`.

- [ ] Test: `factor 60: 1 real minute = 1 pet hour` (FakeClock base).
- [ ] **Review Focus 5**, test di `pet_bloc_test`: `save from future (lastUpdated > now) does not crash and emits pet unchanged`. Dokumentasikan di README: hapus `pet.json` saat pindah dari mode cepat ke normal.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

> ⚠️ **RISIKO (sedang):** simpanan dari mode cepat punya `lastUpdated` jauh di masa depan. Saat kembali ke jam normal, aturan "jam mundur" membekukan pet sampai waktu nyata menyusul. Ini aman (tidak ada data rusak), tapi membingungkan saat debug.

---

# Fase 4 — Animasi dan kejutan evolusi. Gerbang: profile mode di HP, 0 frame > 16 ms selama 60 detik.

### Task 26: Idle animator (napas + kedip)

**Files:** Create `animation/idle_animator.dart`; Test `idle_animator_test.dart`.
**Produces:** `IdleAnimator({required Widget Function(double breath, double blink) builder, int seed = 0})`, StatefulWidget dengan `TickerProviderStateMixin`. Napas: `AnimationController(2400 ms)..repeat(reverse: true)`, `Curves.easeInOutSine`, skala 1.00–1.03. Kedip: `TweenSequence` 120 ms, jeda 3–5 detik dari `Random(seed)`.

- [ ] Test: `breath value changes over time`; `disableAnimations -> no running animations` (`MediaQuery(disableAnimations: true)` → `tester.hasRunningAnimations == false`); `unmount leaves no pending timers` (pump widget lain → tidak ada exception "Timer is still pending").
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 27: Reaction animator (lompat, kunyah, putar, geleng)

**Files:** Create `animation/reaction_animator.dart`; Modify `pet_screen.dart`; Test `reaction_animator_test.dart`.
**Produces:** `ReactionAnimator({required PetReaction? reaction, required Widget Function(Offset offset, double angle) builder})` yang memulai animasi saat `reaction.seq` berubah. Pemetaan: makan/camilan = kunyah, main = lompat (`easeOutBack`, `dur-react`), bersihkan/obat/lampu = putar, ditolak = geleng 3 ayunan ±8° (`dur-shake`). Bila disableAnimations → fade 150 ms.

- [ ] Test: `new seq starts animation and it settles`; `rejected reaction rotates within ±8°`; `same seq does not restart`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 28: EvolutionReveal

**Files:** Create `widgets/evolution_reveal.dart`; Modify `pet_screen.dart`; Test `evolution_reveal_test.dart`.
**Produces:** Muncul saat `pet.pendingReveal`. Controller `dur-reveal` dengan `Interval` 0–0.3 kilau, 0.3–0.6 siluet, 0.6–1.0 karakter + nama (`tm-display`, mis. "Si Atletis") + teks "Waktu kamu pergi, Tama tumbuh". Selesai → tombol menutup → `RevealSeen`. Bila disableAnimations → langsung tampil karakter. Referensi: `design/UI/Evolusi-html`, `api/components/EvolutionReveal.md`.

- [ ] Test: `shows character name after animation completes`; `dismiss dispatches RevealSeen`; `disableAnimations shows final frame immediately`.
- [ ] Run → FAIL; implementasi; run → PASS. Commit.

### Task 29: Verifikasi di perangkat (gerbang v1)

- [ ] `flutter run --profile` di HP Android fisik; DevTools Performance 60 detik layar diam → 0 frame > 16 ms (P0-7).
- [ ] Benchmark `simulate` 30 hari di HP (tombol debug sementara atau `flutter test` integration) < 50 ms.
- [ ] Playtest dengan `--dart-define=TAMA_SPEED=60`: telur menetas, evolusi tampil sebagai kejutan setelah app ditutup, liburan + Jemput, force-close tepat setelah ketuk Makan → state terakhir utuh.
- [ ] `flutter build apk --release` → APK terpasang dan jalan dalam mode pesawat (bukti offline + font terbundel).
- [ ] Commit `chore: v1 device verification`.

> ⚠️ **RISIKO (sedang):** butuh HP Android fisik dan langkah manual; tidak bisa diotomasi di sesi ini.

---

## Self-review

- **Cakupan PRD:** P0-1 → Task 5–8, 14 · P0-2 → Task 18, 19 · P0-3 → Task 9, 10, 23, 27 · P0-4 → Task 15, 16, 18 · P0-5 → Task 11, 12, 28 · P0-6 → Task 8, 10, 24 · P0-7 → Task 21, 26, 27, 29 · P1-3 → Task 25. Kasus tepi PRD (jam mundur, 30 hari, force close) → Task 5, 8, 16, 29.
- **Konsistensi tipe:** semua nama mengikuti blok "Interfaces inti" dan Task 17.
- **Tidak dikerjakan:** P1 lainnya (notifikasi, pengaturan jam tidur, mini game, album, suara), P2, layar Pengaturan (`design/UI/Pengaturan-html` adalah P1-2).

## Verification (end-to-end)

`flutter analyze` bersih → `flutter test --coverage` hijau dengan coverage domain ≥ 90% → Task 29 di HP fisik (profile mode, mode pesawat, force-close, playtest dengan jam dipercepat).
