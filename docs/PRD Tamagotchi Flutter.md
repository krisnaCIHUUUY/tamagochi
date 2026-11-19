# PRD Tamagotchi Flutter

## Ringkasan dan problem statement

TamaFlutter (nama kerja) adalah peliharaan virtual ala Tamagotchi versi ramah untuk anak dan remaja, dibangun dengan Flutter, berjalan 100% offline, dan dibagikan sebagai file APK. Pet tidak bisa mati; kelalaian membuatnya murung atau pergi berlibur, dan cara pemain merawatnya menentukan menjadi karakter apa ia saat dewasa.

**Masalah utama yang diselesaikan adalah masalah belajar, bukan pasar.** Pengembang sudah mahir membuat aplikasi CRUD (Henshin: Clean Architecture, Bloc + freezed, Drift dengan migrasi teruji, get\_it, go\_router), tetapi belum pernah membuat aplikasi yang datanya berubah sendiri seiring waktu dan belum pernah memakai animasi. Tamagotchi memaksa keduanya: state yang berjalan walau aplikasi ditutup, dan karakter yang terasa hidup di layar.

Untuk pemain, masalahnya adalah banyak game peliharaan virtual terlalu menghukum (pet mati, rasa bersalah) atau terlalu menuntut (notifikasi terus-menerus). Versi ini menukar ancaman dengan ikatan: pemain kembali karena sayang, bukan karena takut.

## Goals

Proyek berhasil bila dua kemampuan baru, simulasi waktu dan animasi, dikuasai dan terbukti lewat aplikasi yang benar-benar dimainkan.

**Tujuan belajar**

1. **Mesin simulasi waktu yang deterministik.** Fungsi murni `simulate(state, from, to)` menghasilkan state yang sama untuk input yang sama, dan seluruh aturan game dites tanpa widget.
2. **Animasi dengan widget Flutter murni.** Menguasai implicit animation, `AnimationController` + `Tween` + `CurvedAnimation`, dan `CustomPainter`, termasuk siklus hidup ticker dan `dispose`.
3. **Waktu dan lifecycle di level aplikasi.** Ticker saat app terbuka, catch-up saat app dibuka kembali, dan (P1) notifikasi lokal terjadwal di Android.

**Tujuan produk**

4. **Pet terasa hidup dan konsisten.** Status pet setelah app ditutup berapa lama pun masuk akal dan tidak pernah menghukum secara permanen.
5. **Evolusi terasa sebagai kejutan yang adil.** Setiap gaya perawatan bisa menghasilkan karakter dewasa yang berbeda, dan tidak ada hasil yang "gagal".

## Non-goals

Yang tidak dikerjakan di v1 sengaja dibatasi agar fokus tetap pada simulasi waktu dan animasi.

| Di luar cakupan | Alasan |
| --- | --- |
| Rilis ke Play Store | Proyek belajar; APK sudah cukup, dan urusan kebijakan store untuk aplikasi anak tidak menambah pelajaran Flutter. |
| Akun, backend, fitur sosial | Butuh server dan memunculkan urusan privasi data anak. Itu proyek belajar yang berbeda. |
| Game engine Flame | Pet di satu layar tidak butuh physics atau collision; tujuannya justru menguasai sistem animasi Flutter sendiri. |
| Kematian pet | Target pemain anak dan remaja; diganti mekanik murung dan liburan. |
| Grafis pixel-art atau aset ilustrasi | Jebakan waktu terbesar proyek belajar. v1 memakai pet yang digambar `CustomPainter`. |
| Monetisasi, iklan, analytics | Tidak relevan untuk APK pribadi. |

## Persona dan user stories

Ada tiga pengguna: anak (sekitar 8–12 tahun), remaja (13–17 tahun), dan pengembang sendiri sebagai pemain sekaligus penguji.

**Anak**

- Sebagai anak, saya ingin memberi makan dan bermain dengan pet hanya dengan satu ketukan, supaya bisa merawatnya tanpa membaca banyak teks.
- Sebagai anak, saya ingin melihat dari wajah pet apakah ia lapar, senang, atau sakit, supaya tahu apa yang harus dilakukan tanpa membuka menu status.
- Sebagai anak, saya ingin pet saya tetap ada walau saya lupa membukanya beberapa hari, supaya saya tidak sedih atau merasa bersalah.
- Sebagai anak, saya ingin pet bereaksi lucu saat saya merawatnya, supaya merawatnya terasa menyenangkan.

**Remaja**

- Sebagai remaja, saya ingin pet saya berevolusi menjadi karakter yang berbeda tergantung cara saya merawatnya, supaya ada alasan mencoba gaya perawatan lain.
- Sebagai remaja, saya ingin pet ikut tidur saat saya tidur atau sekolah, supaya saya tidak dihukum karena jadwal saya sendiri.
- Sebagai remaja, saya ingin melihat umur dan tahap hidup pet, supaya saya merasa ikut membesarkannya.

**Pengembang**

- Sebagai pengembang, saya ingin menjalankan simulasi 7 hari dalam satu unit test, supaya bisa memverifikasi aturan game tanpa menunggu waktu nyata.
- Sebagai pengembang, saya ingin mempercepat waktu di build debug, supaya bisa melihat evolusi dan mode liburan dalam hitungan menit.

**Kasus tepi**

- Jam perangkat dimundurkan: pet tidak boleh mendapat waktu negatif atau meter yang naik sendiri.
- App dibuka setelah 30 hari: hasil tetap masuk akal, tidak macet, dan pet sedang berlibur.
- App dimatikan paksa di tengah aksi: state terakhir yang tersimpan tetap utuh.

## Aturan game

Semua angka di bawah adalah nilai awal untuk disetel lewat playtest, disimpan di satu file konfigurasi (`GameRules`), bukan tersebar di kode.

**Status pet**

| Status | Rentang | Berubah karena |
| --- | --- | --- |
| Kenyang | 0–100 | Turun 8/jam saat bangun; naik +30 per makan, +10 per camilan |
| Senang | 0–100 | Turun 6/jam saat bangun; naik +20 per main, +15 per camilan |
| Kotoran | 0–4 tumpukan | Muncul 1 tumpukan sekitar 3 jam setelah makan; hilang saat dibersihkan |
| Sakit | ya/tidak | Lihat aturan sakit di bawah |
| Berat | gram | Naik saat makan/camilan, turun saat main |
| Kedekatan | 0–100 | Naik setiap aksi rawat yang dibutuhkan; tidak pernah turun lebih dari 10 per hari |
| Umur | hari | 1 hari nyata = 1 tahun pet |

**Aksi pemain**

| Aksi | Efek | Ditolak bila |
| --- | --- | --- |
| Makan | Kenyang +30, berat +5 | Kenyang sudah 100 atau sedang sakit |
| Camilan | Senang +15, kenyang +10, berat +10 | Lebih dari 5 camilan per jam memicu sakit perut |
| Main | Senang +20, berat −5 | Sedang tidur atau sakit |
| Bersihkan | Kotoran jadi 0 | Tidak ada kotoran |
| Obat | Sembuh setelah 2 dosis | Tidak sedang sakit |
| Lampu | Mematikan lampu saat pet tidur | — |

**Waktu tidur.** Default 21.00–07.00, bisa diubah. Selama tidur, kenyang dan senang tidak turun dan kotoran tidak muncul. Lampu yang dibiarkan menyala hanya membuat pet sedikit rewel saat bangun (senang −10), tanpa penalti lain.

**Sakit.** Pet jatuh sakit bila kenyang atau senang berada di 0 lebih dari 60 menit, ada 3 tumpukan kotoran atau lebih selama 2 jam, atau makan camilan terlalu banyak. Tidak ada sakit acak di v1, supaya penyebabnya selalu bisa dipahami anak. Sakit tidak pernah berujung kematian.

**Murung dan liburan (pengganti kematian).**

- **Murung**: kenyang dan senang sama-sama ≤ 20 selama 6 jam. Pet tampak sedih dan menolak main sampai diberi makan.
- **Liburan**: total 48 jam tanpa aksi rawat. Pet meninggalkan catatan bahwa ia ke rumah nenek. Saat app dibuka, pemain menekan "Jemput", pet pulang dengan kenyang dan senang 50, kotoran 0, dan tanpa sakit.
- **Batas catch-up**: waktu offline tidak pernah menurunkan kenyang atau senang di bawah 10. Pet yang lama ditinggal tampak lapar dan bosan, bukan hancur.

**Siklus hidup**

| Tahap | Lama | Catatan |
| --- | --- | --- |
| Telur | 5 menit | Menetas otomatis |
| Bayi | 1 hari | Kebutuhan dua kali lebih cepat turun |
| Anak | 3 hari | Gaya perawatan mulai dihitung |
| Remaja | 4 hari | Evolusi pertama ditentukan di akhir tahap Anak |
| Dewasa | seterusnya | Evolusi kedua ditentukan di akhir tahap Remaja |

**Evolusi berdasarkan gaya perawatan.** Sejak tahap Anak, aplikasi menghitung lima penghitung gaya: jumlah main, jumlah camilan, jumlah bersih-bersih tepat waktu, menit terlantar, dan jumlah aksi seimbang. Di setiap titik evolusi, gaya yang paling dominan menentukan karakter berikutnya; bila tidak ada yang unggul lebih dari 20%, hasilnya karakter Seimbang.

| Gaya dominan | Karakter dewasa | Ciri |
| --- | --- | --- |
| Sering diajak main | Si Atletis | Ramping, aktif, melompat-lompat |
| Sering diberi camilan | Si Gembul | Bulat, santai, suka tidur siang |
| Kandang selalu bersih | Si Rapi | Tenang, wajah berseri |
| Sering ditinggal | Si Mandiri | Cuek tapi senang saat dijemput |
| Tidak ada yang dominan | Si Seimbang | Karakter paling ekspresif |

Penghitung gaya disimpan tersembunyi dan direset setelah setiap evolusi, seperti care mistake pada Tamagotchi asli, supaya hasil evolusi tetap terasa sebagai kejutan.

## Requirements P0 (wajib untuk v1)

Tujuh requirement ini adalah versi terkecil yang sudah menjawab kedua tujuan belajar; tanpa salah satunya, proyek kehilangan intinya.

**P0-1 Mesin simulasi waktu.** Fungsi murni Dart `simulate(PetState state, {required DateTime from, required DateTime to})` menerapkan semua aturan game untuk rentang waktu tersebut.

- [ ] Tidak mengimpor Flutter atau database; waktu selalu masuk lewat parameter atau `Clock` yang diinjeksi.
- [ ] Input yang sama selalu menghasilkan output yang sama (tanpa `Random` tanpa seed).
- [ ] Given pet bangun dengan kenyang 80, when 2 jam berlalu, then kenyang 64.
- [ ] Given rentang waktu sepenuhnya di jam tidur, then kenyang dan senang tidak berubah.
- [ ] Given `to` lebih awal dari `from` (jam dimundurkan), then state dikembalikan tanpa perubahan.
- [ ] Simulasi 30 hari selesai di bawah 50 ms di perangkat uji.

**P0-2 Catch-up dan ticker.** State tetap akurat baik saat app terbuka maupun setelah lama ditutup.

- [ ] Saat app terbuka, ticker memanggil `simulate` setiap 60 detik.
- [ ] Saat `AppLifecycleState.resumed`, app mensimulasikan dari `lastUpdated` sampai sekarang sebelum menampilkan pet.
- [ ] Ticker berhenti saat app di-pause dan tidak ada timer yang bocor setelah `dispose`.

**P0-3 Aksi rawat.** Enam aksi (makan, camilan, main, bersihkan, obat, lampu) bekerja sesuai tabel aksi.

- [ ] Setiap aksi pertama-tama menyimulasikan waktu sampai sekarang, baru menerapkan efeknya.
- [ ] Aksi yang ditolak menampilkan reaksi pet (geleng kepala), bukan pesan error teks.
- [ ] Tombol aksi minimal 48×48 dp dan bisa dipahami lewat ikon tanpa membaca.

**P0-4 Penyimpanan lokal.** Satu pet tersimpan permanen di perangkat.

- [ ] State disimpan setelah setiap aksi dan setiap kali app di-pause.
- [ ] Force close di tengah aksi tidak merusak data; app terbuka dengan state tersimpan terakhir.
- [ ] Skema punya nomor versi dan migrasi diuji (pola yang sama dengan Henshin).

**P0-5 Siklus hidup dan evolusi.** Pet melewati Telur, Bayi, Anak, Remaja, Dewasa dan berevolusi berdasarkan gaya perawatan.

- [ ] Kelima karakter dewasa terbukti bisa dicapai lewat unit test yang menyimulasikan gaya perawatan berbeda.
- [ ] Evolusi yang terjadi saat app tertutup ditampilkan sebagai animasi kejutan saat app dibuka.

**P0-6 Murung, liburan, dan batas catch-up.** Tidak ada jalur yang membuat pet mati atau rusak permanen.

- [ ] Given app tidak dibuka 30 hari, when dibuka, then pet sedang berlibur dan tombol "Jemput" tersedia.
- [ ] Waktu offline tidak pernah menurunkan kenyang atau senang di bawah 10.

**P0-7 Pet yang hidup di layar.** Pet digambar dengan `CustomPainter` dan dianimasikan dengan widget Flutter murni.

- [ ] Animasi diam (bernapas dan berkedip) berjalan terus memakai `AnimationController`.
- [ ] Ekspresi wajah berubah untuk minimal lima mood: senang, biasa, lapar, sakit, tidur.
- [ ] Setiap aksi rawat punya reaksi singkat (lompat, mengunyah, berputar) memakai implicit atau explicit animation.
- [ ] Animasi diam tidak membuat frame melebihi 16 ms di profile mode.

## Requirements P1 dan P2

P1 dikerjakan setelah semua P0 selesai; P2 tidak dibangun, tetapi arsitektur v1 tidak boleh menutup jalannya.

| Kode | Requirement | Acceptance criteria utama | Konsep yang dipelajari |
| --- | --- | --- | --- |
| P1-1 | Notifikasi lokal terjadwal | Maksimal 3 notifikasi per hari, tidak pernah di jam tidur, nada bersahabat ("Tama kangen kamu") | `flutter_local_notifications`, izin notifikasi Android 13+, exact alarm Android 12+ |
| P1-2 | Jadwal tidur yang bisa diatur | Pemain memilih jam tidur dan bangun; simulasi langsung memakai jadwal baru | Pengaturan tersimpan, time picker |
| P1-3 | Mode debug percepatan waktu | Di build debug, 1 menit nyata bisa disetel menjadi 1 jam pet | Clock injection, `kDebugMode` |
| P1-4 | Mini game sederhana | Satu game tebak arah ala Tamagotchi asli; menang menambah senang | Gesture, `AnimatedSwitcher` |
| P1-5 | Panggilan iseng dan nasihat | Pet sesekali memanggil tanpa kebutuhan; menekan "Nasihati" menambah kedekatan | Event acak dengan seed yang bisa dites |
| P1-6 | Album evolusi | Galeri karakter yang pernah dicapai, yang belum tampil sebagai siluet | Daftar, `Hero` animation |
| P1-7 | Suara dan getaran | Bunyi pendek per aksi; getar saat evolusi; bisa dimatikan | `vibration` (sudah dipakai di Henshin), audio |
| P2-1 | Sprite pixel-art | Mengganti `CustomPainter` tanpa mengubah logika | Abstraksi `PetRenderer` |
| P2-2 | Generasi dan banyak pet | Pet dewasa bisa menurunkan telur baru | Skema data mendukung banyak pet |
| P2-3 | Mode klasik (bisa mati) | Opsi terpisah untuk pemain nostalgia | Aturan sebagai konfigurasi, bukan kondisi tersebar |
| P2-4 | Widget home screen | Wajah pet tampil di layar utama Android | `home_widget`, platform channel |
| P2-5 | Fitur sosial | Mengunjungi pet teman | Butuh backend; proyek terpisah |

## Pendekatan teknis

Pola Henshin dipakai ulang, tetapi intinya berbeda: bukan kumpulan usecase CRUD, melainkan satu fungsi simulasi murni yang dibungkus Bloc tipis.

&#91;embedded content: arsitektur · 3 lapisan, 1 fungsi inti\]

Ticker, app yang dibuka lagi, dan aksi pemain semuanya masuk ke PetBloc, yang selalu memanggil `simulate()` lebih dulu lalu menyimpan hasilnya.

**Alur satu aksi (misalnya Makan)**

1. `PetBloc` menerima `FeedPressed`.
2. `simulate(state, from: state.lastUpdated, to: clock.now())` membawa pet ke waktu sekarang.
3. Efek makan diterapkan lewat fungsi murni `applyAction(state, CareAction.feed)`.
4. Hasil disimpan lewat `PetRepository`, lalu dipancarkan ke UI.
5. `PetPainter` menggambar mood baru dan reaksi mengunyah diputar.

**Stack**

| Bagian | Pilihan | Status bagi pengembang |
| --- | --- | --- |
| State management | flutter\_bloc + freezed | Sudah dikuasai (Henshin) |
| DI | get\_it | Sudah dikuasai |
| Penyimpanan | Drift atau JSON (open question) | Sudah dikuasai |
| Waktu | `Clock` yang diinjeksi, pola `_now = now ?? DateTime.now` | Sudah dikuasai, kini jadi pusat |
| Animasi | Implicit animation, `AnimationController`, `CustomPainter` | **Baru** |
| Lifecycle tingkat app | `WidgetsBindingObserver` di root, `Stream.periodic` | **Baru** (sebelumnya hanya di satu layar) |
| Notifikasi (P1) | flutter\_local\_notifications | **Baru** |

**Struktur folder**

Strukturnya feature-first seperti Henshin, dengan satu perbedaan besar: domain berisi folder `simulation/` berupa fungsi murni, bukan folder `usecases/`.

```text
lib/
├── main.dart
├── app.dart
├── injection_container.dart          # get_it: Clock, repository, bloc
├── core/
│   ├── clock/
│   │   ├── clock.dart                # abstract Clock { DateTime now(); }
│   │   ├── system_clock.dart
│   │   └── accelerated_clock.dart    # P1-3: debug percepatan waktu
│   ├── storage/                      # Drift atau JSON (open question)
│   ├── theme/
│   └── utils/
└── features/
    ├── pet/
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── pet_state.dart        # freezed: meter, umur, tahap, lastUpdated
    │   │   │   ├── life_stage.dart       # enum Telur, Bayi, Anak, Remaja, Dewasa
    │   │   │   ├── mood.dart             # enum senang, biasa, lapar, sakit, tidur, murung
    │   │   │   ├── care_action.dart      # enum makan, camilan, main, bersihkan, obat, lampu
    │   │   │   ├── care_style.dart       # penghitung gaya perawatan (tersembunyi)
    │   │   │   └── pet_character.dart    # Atletis, Gembul, Rapi, Mandiri, Seimbang
    │   │   ├── rules/
    │   │   │   └── game_rules.dart       # semua angka laju dan ambang di satu tempat
    │   │   ├── simulation/
    │   │   │   ├── simulate.dart         # simulate(state, from, to)
    │   │   │   ├── apply_action.dart     # applyAction(state, action, now)
    │   │   │   ├── evolution.dart        # pilih karakter dari care_style
    │   │   │   └── mood_resolver.dart    # state ke Mood untuk painter
    │   │   └── repositories/
    │   │       └── pet_repository.dart   # abstract: load(), save()
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── pet_state_model.dart  # mapping ke JSON atau tabel Drift
    │   │   └── repositories/
    │   │       └── pet_repository_impl.dart
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── pet_bloc.dart         # Tick, Resumed, ActionPressed, Jemput
    │       │   ├── pet_event.dart
    │       │   └── pet_view_state.dart   # bukan pet_state, hindari bentrok nama
    │       ├── lifecycle/
    │       │   └── pet_lifecycle_listener.dart  # resumed, paused, ticker 60 detik
    │       ├── painter/
    │       │   ├── pet_painter.dart      # CustomPainter: badan, mata, mulut per mood
    │       │   └── character_shapes.dart # bentuk tiap karakter dewasa
    │       ├── animation/
    │       │   ├── idle_animator.dart    # bernapas + berkedip (AnimationController)
    │       │   └── reaction_animator.dart # lompat, mengunyah, geleng
    │       ├── screens/
    │       │   └── pet_screen.dart
    │       └── widgets/
    │           ├── action_bar.dart
    │           ├── status_meters.dart
    │           └── vacation_note.dart    # catatan liburan + tombol Jemput
    ├── settings/                         # P1-2 jadwal tidur
    └── notifications/                    # P1-1 notifikasi lokal

test/
├── helpers/
│   ├── fake_clock.dart
│   └── pet_state_fixtures.dart
└── features/pet/
    ├── domain/simulation/
    │   ├── simulate_test.dart
    │   ├── apply_action_test.dart
    │   ├── evolution_test.dart           # kelima karakter dewasa tercapai
    │   └── simulate_benchmark_test.dart  # 30 hari < 50 ms
    ├── data/pet_repository_impl_test.dart
    └── presentation/pet_bloc_test.dart
```

- **Tidak ada folder `usecases/`.** `simulate` dan `applyAction` sudah menjadi usecase-nya; membungkus tiap aksi dalam kelas `FeedPet`, `PlayWithPet`, dan seterusnya hanya menambah lapisan tanpa manfaat.
- **`domain/` tidak boleh mengimpor `package:flutter`.** Aturan ini membuat Fase 1 bisa diselesaikan dan dites tanpa UI.
- **`Clock` ada di `core/`** karena dipakai lintas fitur: simulasi, notifikasi, dan mode debug.
- **Bloc state dinamai `PetViewState`** supaya tidak bentrok dengan entitas `PetState` di domain.
- **`painter/` dan `animation/` dipisah**: painter hanya menggambar satu frame dari mood dan nilai animasi, animator yang mengatur waktunya.

Navigasi cukup satu layar utama plus layar pengaturan; go\_router tidak wajib untuk v1.

## Tech stack rekomendasi

Stack v1 sengaja kecil: tiga paket inti yang sudah dikuasai dari Henshin, tanpa database dan tanpa router, ditambah paket baru hanya untuk notifikasi dan testing waktu.

**Paket**

| Paket | Versi | Dipakai untuk | Fase |
| --- | --- | --- | --- |
| flutter\_bloc | ^9.1.1 | `PetBloc`, event Tick/Resumed/aksi | 2 |
| freezed + freezed\_annotation | ^4.0.0 / ^3.1.0 | `PetState`, `PetViewState`, event immutable | 1 |
| json\_serializable + json\_annotation | ^6.14.1 / terbaru | Serialisasi `PetState` ke file JSON | 2 |
| get\_it | ^9.3.0 | Injeksi `Clock`, repository, bloc | 2 |
| path\_provider | ^2.1.6 | Lokasi file simpanan pet | 2 |
| google\_fonts | ^8.2.1 | Font bulat yang ramah anak | 4 |
| flutter\_local\_notifications | ^21.0.0 | Pengingat lembut (P1-1) | P1 |
| timezone + flutter\_timezone | terbaru | Jadwal notifikasi sesuai zona waktu perangkat (P1-1) | P1 |
| vibration | ^3.2.1 | Getar saat evolusi (P1-7) | P1 |
| build\_runner (dev) | ^2.16.0 | Generate freezed dan json | 1 |
| bloc\_test (dev) | ^10.0.0 | Test urutan state `PetBloc` | 2 |
| mocktail (dev) | terbaru | Mock `PetRepository` di test bloc | 2 |
| fake\_async (dev) | terbaru | Test ticker 60 detik tanpa menunggu | 2 |
| flutter\_lints (dev) | ^6.0.0 | Lint standar | 1 |

Versi bertanda caret mengikuti Henshin atau sudah dicek di pub.dev; "terbaru" berarti ambil saat menambahkan paket:

```bash
flutter pub add flutter_bloc freezed_annotation json_annotation get_it path_provider
flutter pub add dev:build_runner dev:freezed dev:json_serializable dev:bloc_test dev:mocktail dev:fake_async
```

**Sengaja tidak dipakai di v1**: drift (lihat ADR-1), go\_router (cuma satu layar utama), dartz (`simulate` adalah fungsi total yang tidak bisa gagal, jadi `Either` tidak menambah apa-apa), Flame, Rive, dan Lottie (non-goal).

### ADR-1 Penyimpanan: satu file JSON

**Status:** Proposed. Menjawab open question tentang Drift atau JSON.

Data v1 hanya satu dokumen `PetState`. Drift memberi migrasi teruji, tetapi untuk satu baris data itu menambah codegen dan skema tanpa pelajaran baru, karena Drift sudah dikuasai.

| Opsi | Kompleksitas | Pelajaran baru | Siap untuk banyak pet (P2-2) |
| --- | --- | --- | --- |
| **File JSON + `schemaVersion` (dipilih)** | Rendah | Atomic write, migrasi manual | Ya, simpan sebagai daftar |
| Drift | Sedang | Hampir tidak ada | Ya |
| shared\_preferences | Rendah | Tidak ada | Canggung untuk dokumen bersarang |

**Konsekuensi:** tulis ke file sementara lalu `rename` agar force close tidak merusak data (P0-4). Migrasi berupa fungsi `migrate(json, fromVersion)` yang dites seperti migrasi Drift di Henshin. Bila P2-2 dikerjakan, `PetRepository` bisa diganti ke Drift tanpa menyentuh domain.

### ADR-2 Sumber waktu: interface `Clock` sendiri

**Status:** Proposed.

Semua aturan bergantung pada waktu, dan mode debug (P1-3) butuh waktu yang bisa dipercepat.

| Opsi | Kelebihan | Kekurangan |
| --- | --- | --- |
| **`abstract class Clock` + get\_it (dipilih)** | Eksplisit, sama dengan pola `_now` di Henshin, mudah diganti `AcceleratedClock` | Satu file tambahan |
| Paket `clock` (`withClock`) | Tidak perlu meneruskan clock ke mana-mana | Bergantung pada Zone, lebih sulit dilacak saat debug |
| `DateTime.now()` langsung | Paling cepat ditulis | Tidak bisa dites, melanggar P0-1 |

**Konsekuensi:** `simulate` tetap menerima `from` dan `to` sebagai parameter; hanya bloc yang memanggil `clock.now()`.

### ADR-3 Ticker: `Stream.periodic` di dalam bloc

**Status:** Proposed.

Saat app terbuka, pet perlu diperbarui setiap 60 detik dan ticker harus berhenti saat app di-pause.

| Opsi | Kelebihan | Kekurangan |
| --- | --- | --- |
| **`Stream.periodic` di `PetBloc` (dipilih)** | Logika waktu satu tempat, dites dengan fake\_async | Bloc perlu event `Paused`/`Resumed` |
| `Timer.periodic` di widget | Sederhana | Logika bocor ke UI, mudah lupa `cancel` |
| `Ticker` per frame | Presisi tinggi | Boros baterai; 60 kali per detik untuk kebutuhan per menit |

**Konsekuensi:** `PetLifecycleListener` hanya menerjemahkan `AppLifecycleState` menjadi event bloc; ticker animasi (`AnimationController`) tetap terpisah dan hanya mengurus tampilan.

### ADR-4 Notifikasi (P1): dijadwalkan saat app di-pause, waktunya diprediksi `simulate`

**Status:** Proposed, dikerjakan setelah v1.

Tanpa backend, notifikasi harus dijadwalkan di perangkat sebelum app ditutup.

| Opsi | Kelebihan | Kekurangan |
| --- | --- | --- |
| **flutter\_local\_notifications, jadwal inexact (dipilih)** | Tanpa izin exact alarm; prediksi memakai fungsi `simulate` yang sama | Bisa meleset beberapa menit, tidak masalah untuk pet |
| Jadwal exact alarm | Tepat waktu | Butuh izin tambahan di Android 12+ |
| Background worker berkala | Bisa menjalankan simulasi di latar | Rumit, tidak dijamin jalan, tidak perlu karena catch-up sudah ada |

**Konsekuensi:** saat `paused`, app menyimulasikan ke depan untuk mencari kapan kenyang atau senang pertama kali turun di bawah 30, lalu menjadwalkan satu notifikasi di luar jam tidur. Saat `resumed`, semua jadwal dibatalkan.

Sumber versi: [bloc\_test changelog](https://pub.dev/packages/bloc_test/changelog), [flutter\_local\_notifications di ecosyste.ms](https://packages.ecosyste.ms/api/v1/registries/pub.dev/packages/flutter_local_notifications), dan pubspec Henshin.

## Success metrics

Karena ini proyek belajar tanpa analytics, keberhasilan diukur dari kualitas kode dan playtest kecil, bukan jumlah pengguna.

| Jenis | Metrik | Target | Cara mengukur |
| --- | --- | --- | --- |
| Leading | Cakupan test lapisan domain | ≥ 90% | `flutter test --coverage` pada folder domain |
| Leading | Waktu `simulate` untuk 30 hari | < 50 ms | Benchmark sederhana di unit test |
| Leading | Frame animasi diam | 0 frame > 16 ms selama 60 detik | DevTools, profile mode, perangkat fisik |
| Leading | Karakter dewasa yang bisa dicapai | 5 dari 5 | Unit test per gaya perawatan |
| Lagging | Playtest 7 hari dengan 3 pemain (anak/remaja) | ≥ 2 dari 3 masih membuka app di hari ke-7 | Tanya langsung dan catat |
| Lagging | Pemain paham kenapa pet sakit atau murung | ≥ 2 dari 3 bisa menjelaskan sendiri | Wawancara singkat setelah playtest |
| Lagging | Pemahaman pengembang | Bisa menjelaskan tanpa catatan: catch-up, `AnimationController`, `CustomPainter` | Tulis ringkasan belajar di README |

## Open questions

Dua pertanyaan pertama perlu dijawab sebelum Fase 1 karena mengubah bentuk `PetState`.

- [ ] **(Blocking, desain)** Apakah batas catch-up "tidak di bawah 10" terasa wajar, atau pet yang lama ditinggal justru perlu terlihat lebih menyedihkan agar ada konsekuensi?
- [ ] **(Blocking, engineering)** Simulasi dilakukan per menit (sederhana, mudah dites) atau per kejadian berikutnya (lebih efisien, lebih rumit)? Usulan: per menit dulu, ganti bila benchmark gagal.
- [ ] **(Engineering)** Penyimpanan memakai Drift seperti Henshin, atau cukup satu dokumen JSON? Drift lebih berat untuk satu baris data, tetapi menyiapkan P2-2 (banyak pet).
- [ ] **(Desain)** Bagaimana tampilan kelima karakter dewasa bila hanya memakai bentuk geometri `CustomPainter`?
- [ ] **(Desain)** Apakah lima menit untuk telur menetas terlalu lama bagi anak yang baru membuka app?
- [ ] **(Playtest)** Apakah laju turun kenyang 8 per jam terlalu cepat untuk anak yang bersekolah 7 jam sehari?

## Timeline dan fase

Tidak ada tenggat keras; proyek dibagi empat fase yang masing-masing ditutup oleh satu gerbang yang bisa diverifikasi.

&#91;embedded content: fase pengerjaan · 4 fase, 4 gerbang\]

Setiap fase baru dimulai setelah gerbang fase sebelumnya lolos; dua open question yang blocking harus dijawab sebelum Fase 1.

- **Fase 1 tanpa UI** sengaja: semua aturan di bagian Aturan game dibuktikan lewat `flutter test` sebelum ada satu pun widget.
- **Mode debug percepatan waktu (P1-3)** ditarik ke Fase 3 karena dibutuhkan untuk melihat evolusi dan liburan tanpa menunggu berhari-hari.
- **P1 lain** baru dikerjakan setelah gerbang Fase 4, dimulai dari notifikasi lokal karena paling banyak mengajarkan hal baru.
