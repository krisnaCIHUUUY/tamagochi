# Progress — TamaFlutter v1

Rencana: `docs/superpowers/plans/2026-11-19-tamaflutter-v1.md` · Keputusan: `docs/keputusan-teknis.md` · Branch: `develop`

| Fase | Task | Status | Commit |
| --- | --- | --- | --- |
| 0 | 1. Dependensi, scaffold, buang template counter | ✅ Selesai, diverifikasi user | `0ec5f48` |
| 1 | 2. Clock + FakeClock | ✅ Selesai, diverifikasi user | `2a66921` |
| 1 | 3. Enum, GameRules, SleepSchedule, CareStyle, PetState | ✅ Selesai, diverifikasi user | `6c7607b` |
| 1 | 4. SleepSchedule.isAsleepAt | ✅ Selesai, diverifikasi user | `ae35c53` |
| 1 | 5. `simulate` inti | ✅ Selesai, diverifikasi user | `b80c7ca` |
| 1 | 6. Kotoran + lampu + transisi bangun | ✅ Selesai, diverifikasi user | `66caf1e` |
| 1 | 7. Aturan sakit | ✅ Selesai, diverifikasi user | `50b3a72` |
| 1 | 8. Murung, liburan, batas offline | ✅ Selesai, diverifikasi user | `c64189e` |
| 1 | 9. `applyAction`: Makan, Camilan, Main | ✅ Selesai, diverifikasi user | `1f594a7` |
| 1 | 10. Bersihkan, Obat, Lampu, kedekatan, `pickUp` | ✅ Selesai, diverifikasi user | `021126b` |
| 1 | 11. Tahap hidup + gaya perawatan | ✅ Selesai, menunggu verifikasi user | — |
| 1 | 12–14. Domain murni | Belum | — |
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

## Task 4 — SleepSchedule.isAsleepAt (2026-11-20)

- `SleepSchedule.isAsleepAt(t)` memakai `t.toLocal().hour`; mendukung jadwal yang melewati tengah malam (21→7) maupun tidak (13→15). Ditambah `const SleepSchedule._()` (syarat freezed untuk method).
- Extension `PetStateAge` diganti nama menjadi `PetStateTime` dan mendapat `isAsleepAt(now)` (tunda dari Task 3).
- Test `sleep_schedule_test.dart`: 5 batas jadwal default, 2 batas jadwal 13→15, `isAsleepAt uses local time` (Review Focus 3), dan `PetState.isAsleepAt` (RED dulu, lalu GREEN).
- Verifikasi: `flutter test` 14/14 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.

## Task 5 — `simulate` inti (2026-11-20, Mode belajar: implementasi ditulis user)

- `simulation/simulate.dart`: loop per menit (K2), langkah terakhir boleh < 1 menit sehingga `lastUpdated == to`. Variabel lokal di dalam loop, `copyWith` sekali di akhir (persiapan benchmark Task 14).
- Aturan: jam mundur → `state` dikembalikan apa adanya; meter turun hanya saat bangun; pengali tahap (telur 0, bayi 2×, lainnya 1×); clamp 0–100; telur menetas setelah `eggDuration`, `stageStartedAt` dimajukan tepat 5 menit.
- Parameter `offline` sudah ada di signature, baru dipakai di Task 8 (K1).
- Test `simulate_test.dart` (8): awake 2 jam, rentang tidur penuh, jam mundur (`same`), melewati jam tidur, bayi 2×, telur menetas, langkah parsial 90 detik, clamp 0 (RED dulu, lalu GREEN).
- Review: early-return `onVacation` dihapus (bertentangan dengan K10, dikerjakan di Task 8), stub fungsi task lain dihapus, import diganti relatif.
- Verifikasi: `flutter test` 22/22 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.

## Task 6 — Kotoran, lampu, transisi bangun (2026-11-20, Mode belajar: ditulis Claude lalu dijelaskan)

- Loop `simulate` menghitung `asleep` sekali per langkah dan mengingat `wasAsleep`; nilai awalnya diambil 1 µs sebelum `from` agar transisi tepat di `from` (mis. mulai 21.00) tetap terdeteksi.
- Lampu (K12): saat baru tertidur `lightsOnAllSleep = lightsOn`; saat baru bangun senang −10 bila lampu menyala sepanjang tidur, lalu lampu dinyalakan dan flag direset.
- Kotoran (K9): jadwal di `poopDueAt` yang sudah lewat diproses di menit bangun; jumlah dibatasi `maxPoop` (kelebihan dibuang), `firstPoopAt` diisi waktu kotoran pertama **muncul** (07.00 bila jatuh tempo saat tidur), tidak ditimpa bila sudah ada.
- `poopDueAt` disalin (`[...state.poopDueAt]`) karena list freezed tidak bisa diubah.
- Test `simulate_poop_lights_test.dart` (5): muncul 3 jam setelah makan, jatuh tempo saat tidur muncul saat bangun, batas 4, lampu menyala semalam −10, lampu mati tanpa penalti (RED dulu, lalu GREEN).
- Verifikasi: `flutter test` 27/27 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.

## Task 7 — Aturan sakit (2026-11-20, Mode belajar: ditulis Claude lalu dijelaskan)

- Loop `simulate` mengisi `zeroNeedFor` (kenyang atau senang 0) dan `heavyPoopFor` (kotoran ≥ 3), dihitung setelah peluruhan + clamp di langkah yang sama.
- Sakit bila `zeroNeedFor > 60 menit` (ketat, sesuai "> 60 menit") atau `heavyPoopFor >= 2 jam` ("selama 2 jam"). Sakit karena camilan menyusul di Task 9.
- D5: timer hanya berjalan saat bangun; saat tidur berhenti tanpa reset.
- D6: saat jadi sakit kedua timer direset ke 0 dan tidak bertambah selama sakit.
- Test `simulate_sickness_test.dart` (8): 61 vs 59 menit kenyang 0, senang 0, 3 kotoran 2 jam, 2 kotoran 10 jam, reset timer, D5, D6 (RED 6/8 dulu, lalu GREEN).
- Verifikasi: `flutter test` 35/35 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.

## Task 8 — Murung, liburan, batas catch-up offline (2026-11-20, Mode belajar: ditulis Claude lalu dijelaskan)

- Murung: `lowBothFor` bertambah saat kenyang **dan** senang ≤ 20, reset bila salah satu > 20; `isMoody` bila ≥ 6 jam. D7: hanya saat bangun.
- Liburan: `onVacation` bila `t − lastCareAt ≥ 48 jam` (jam dinding, termasuk tidur), dicek setelah waktu maju sehingga tepat 48 jam sudah liburan.
- K10: selama liburan seluruh blok perawatan (lampu, kotoran, peluruhan, timer sakit dan murung) dilewati; waktu, `wasAsleep`, tahap, dan menetas tetap berjalan.
- K1: bila `offline`, batas bawah meter = `min(nilai awal, 10)`; meter yang sudah < 10 tidak dinaikkan dan tidak diturunkan. Berlaku juga untuk penalti lampu.
- Test `simulate_moody_vacation_test.dart` (11): murung 6 jam vs 5j59m, reset timer, D7, liburan 48 jam vs 47j59m, liburan membekukan, tahap tetap maju, batas offline 3 hari, meter < 10, online bisa 0, PRD P0-6 30 hari (RED 7/11 dulu, lalu GREEN).
- Verifikasi: `flutter test` 46/46 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.

## Task 9 — `applyAction`: Makan, Camilan, Main (2026-11-20, Mode belajar: implementasi ditulis user)

- D8: signature ikut rencana, `ActionResult applyAction(...)` dengan `typedef ActionResult = ({PetState state, bool accepted})`; `resolveMood(state, now)` untuk Task 13. Blok "Fungsi murni" di `CLAUDE.md` disesuaikan.
- `simulation/apply_action.dart`: fungsi lokal `reject()` (state asli, `accepted: false`) dan `accept(next)` (mengisi `lastCareAt = now`).
- Makan: ditolak bila kenyang 100 atau sakit; kenyang +30 (maks 100), berat +5, jadwal kotoran `now + 3 jam`, murung dan `lowBothFor` direset.
- Main: ditolak bila tidur, sakit, atau murung; senang +20 (maks 100), berat −5 (min 10).
- Camilan: tidak pernah ditolak; senang +15, kenyang +10, berat +10; `recentSnacks` hanya menyimpan camilan dalam `GameRules.snackWindow` (1 jam, konstanta baru); > 5 → sakit dan timer sakit direset (D6).
- Bersihkan, Obat, Lampu sementara selalu ditolak (Task 10).
- Review: file dipindah dari `rules/` ke `simulation/`; `accept()` belum mengisi `lastCareAt` (ditangkap test) lalu diperbaiki; import dirapikan; `if` diberi kurung kurawal.
- Test `apply_action_test.dart` (14). Verifikasi: `flutter test` 60/60 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.

## Task 10 — Bersihkan, Obat, Lampu, kedekatan, `pickUp` (2026-11-20, Mode belajar: ditulis Claude lalu dijelaskan)

- K10: semua aksi ditolak saat `onVacation` (dicek sebelum `switch`).
- Bersihkan: ditolak bila kotoran 0; kotoran 0 dan `firstPoopAt = null`.
- Obat: ditolak bila tidak sakit; dosis ke-2 menyembuhkan dan mereset `medicineDoses`.
- Lampu (K12): tidak pernah ditolak (kecuali liburan); mematikan lampu saat tidur mengosongkan `lightsOnAllSleep`.
- Kedekatan (K7): `accept(next, needed:)` menambah `bondPerNeededAction`; dibutuhkan = makan saat kenyang < 50, main saat senang < 50, bersihkan, obat, lampu dimatikan saat tidur. Camilan +0.
- `pickUp(state, now)`: hanya bila liburan (selain itu state asli); meter 50, kotoran dan jadwal kotoran dikosongkan, sehat, tidak murung, timer direset, `lastCareAt = now`.
- Test `apply_action_care_test.dart` (16), termasuk `lastCareAt` untuk semua aksi. Verifikasi: `flutter test` 76/76 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.

## Task 11 — Tahap hidup + penghitung gaya perawatan (2026-11-20, Mode belajar: implementasi ditulis user)

- `simulate`: `switch (stage)` memberi durasi tahap (dewasa = `null`); bila tercapai, naik ke `LifeStage.values[index + 1]` dan `stageStartedAt` maju tepat sebesar durasi. Berjalan di luar blok liburan (K10).
- `simulate`: `neglectMinutes` (variabel lokal, `copyWith` sekali di akhir) bertambah per menit penuh sejak tahap Anak bila liburan, atau bangun dengan kenyang/senang ≤ 20 (K6). Shortcut: langkah < 1 menit tidak dihitung.
- `applyAction`: sejak tahap Anak, Main → `plays`, Camilan → `snacks`, Makan → `balancedActions` (K3), Bersihkan ≤ 1 jam sejak kotoran pertama → `timelyCleans` (K6).
- Review: nama variabel diganti ke bahasa Inggris (`neglected`, `stageDuration`), import `life_stage` dibuat relatif, komentar shortcut ditambahkan.
- Test `life_stage_test.dart` (13): batas tiap tahap ±1 menit, `stageStartedAt`, penghitung aksi, bersih tepat waktu, menit terlantar (RED 8/13 dulu, lalu GREEN).
- Verifikasi: `flutter test` 89/89 lulus, `flutter analyze` bersih, domain tanpa `package:flutter`/`dart:io`.
