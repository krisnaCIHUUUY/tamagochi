# Progress — TamaFlutter v1

Rencana: `docs/superpowers/plans/2026-11-19-tamaflutter-v1.md` · Keputusan: `docs/keputusan-teknis.md` · Branch: `develop`

| Fase | Task | Status | Commit |
| --- | --- | --- | --- |
| 0 | 1. Dependensi, scaffold, buang template counter | ✅ Selesai, diverifikasi user | `0ec5f48` |
| 1 | 2. Clock + FakeClock | ✅ Selesai, menunggu verifikasi user | — |
| 1 | 3. Enum, GameRules, SleepSchedule, CareStyle, PetState | ✅ Selesai, menunggu verifikasi user | — |
| 1 | 4–14. Domain murni | Belum | — |
| 2 | 15–19. Data, Bloc, lifecycle | Belum | — |
| 3 | 20–25. UI statis, painter, debug clock | Belum | — |
| 4 | 26–29. Animasi, evolusi, verifikasi HP | Belum | — |

## Task 1 — Fondasi proyek (2026-11-19)

- Paket PRD terpasang: `flutter_bloc`, `freezed_annotation`, `json_annotation`, `get_it`, `path_provider`, `google_fonts ^9.0.0` (D2); dev: `build_runner`, `freezed`, `json_serializable`, `bloc_test`, `mocktail`, `fake_async`.
- Template counter dihapus; `lib/app.dart` berisi `TamaApp` minimal; `lib/main.dart` menjalankannya.
- `test/widget_test.dart` → test `app boots` (RED dulu, lalu GREEN).
- Font dibundel di `assets/fonts/`: `Fredoka-SemiBold`, `Lexend-Regular`, `Lexend-SemiBold` + `*-OFL.txt`; lisensi didaftarkan di `main()` (D1).
- Verifikasi: `flutter analyze` bersih, `flutter test` 1/1 lulus, `build_runner` OK, font ada di `build/flutter_assets`.
- Catatan terbuka: pendaftaran lisensi di `main()` belum dites; `allowRuntimeFetching = false` dikerjakan di Task 20.

## Task 2 — Clock + FakeClock (2026-11-19)

- `lib/core/clock/clock.dart`: `abstract class Clock { DateTime now(); }` (ADR-2).
- `lib/core/clock/system_clock.dart`: `SystemClock` (const) → `DateTime.now()`.
- `test/helpers/fake_clock.dart`: `FakeClock(DateTime start)` dengan `now()`, `advance(Duration)`, `set(DateTime)`.
- `test/core/clock/fake_clock_test.dart`: `advance moves now forward` (RED dulu, lalu GREEN).
- Verifikasi: `flutter test` 2/2 lulus, `flutter analyze` bersih, `dart format` dijalankan.

## Task 3 — Entitas domain + GameRules (2026-11-19)

- Enum di file terpisah (D3): `life_stage.dart`, `mood.dart`, `care_action.dart`, `pet_character.dart` di `features/pet/domain/entities/`.
- `rules/game_rules.dart`: semua angka PRD + K1–K12 (D4) sebagai `static const`.
- Entitas freezed + JSON: `SleepSchedule` (default 21→7), `CareStyle` (5 penghitung), `PetState` (field sesuai rencana, `PetState.newEgg(now)`, extension `ageYears(now)`). `PetState` memakai `explicitToJson` agar objek bersarang ikut ter-serialisasi.
- Fixture `test/helpers/pet_state_fixtures.dart`: `fixtureNow` (2026-01-05 10.00) dan `awakePet({fullness, happiness, stage = child})`.
- Test `pet_state_test.dart`: `newEgg has defaults`, `json round-trip keeps every field`, `ageYears counts whole real days since birth` (RED dulu, lalu GREEN).
- Verifikasi: `flutter test` 5/5 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.
- Ditunda: extension `isAsleepAt(now)` dikerjakan di Task 4 (butuh `SleepSchedule.isAsleepAt`); fixture `childPet` tidak dibuat karena `awakePet()` sudah tahap Anak.
