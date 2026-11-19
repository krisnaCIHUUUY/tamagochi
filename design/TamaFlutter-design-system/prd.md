# Peta ke PRD

Setiap requirement UI di PRD Tamagotchi Flutter punya komponen dan token di sistem ini. Pakai tabel ini untuk memilih komponen saat mengerjakan sebuah requirement.

| Requirement | Komponen | Token kunci |
| --- | --- | --- |
| P0-3 Aksi rawat, tombol minimal 48 x 48 dp dan bisa dipahami lewat ikon | ActionButton, ActionBar | `size-action`, `size-touch-min`, `shadow-lip`, chip `meter-*` |
| P0-3 Aksi ditolak tampil sebagai reaksi pet, bukan teks error | ActionButton (`refused`), Pet | `dur-shake` |
| P0-5 Tahap hidup dan umur | StageBadge | `tm-numeral` |
| P0-5 Evolusi saat app tertutup tampil sebagai kejutan | EvolutionReveal | `dur-reveal`, `tm-display`, `char-*` |
| P0-6 Liburan dan tombol Jemput | VacationNote, Button | `shadow-float`, `yolk` |
| P0-6 Murung, bukan mati | Pet (`murung`) | `pet-ink`, `char-rapi` (air mata) |
| P0-7 Animasi diam bernapas dan berkedip | Pet | `dur-breathe`, `ease-breathe`, `dur-blink` |
| P0-7 Lima mood atau lebih | Pet: senang, biasa, lapar, sakit, tidur, murung | `pet-cheek`, `sick` |
| P0-7 Reaksi singkat per aksi | Pet, ActionButton | `dur-react`, `ease-bounce` |
| Meter Kenyang dan Senang | StatusMeter | `meter-hunger`, `meter-happy`, `size-pip` |
| Waktu tidur (meter berhenti) | StatusMeter (`paused`), StageBadge, tema Malam | tema `malam` |
| Layar utama | PetScreen | `room`, `surface` |
| P1-1 Notifikasi bernada bersahabat | Suara dan teks di README | pet berbicara sebagai "aku" |
| P1-2 Jadwal tidur | Button `quiet` ("Ubah jam tidur") | `accent` |

Belum dirancang karena masih P1/P2: layar Pengaturan lengkap, mini game (P1-4), album evolusi (P1-6), dan widget home screen (P2-4).
