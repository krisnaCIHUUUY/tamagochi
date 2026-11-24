# Membuat ulang prototipe

Jalankan dari akar proyek (butuh Node dan FigCraft 0.18):

```bash
node design/v2/sumber/uji.mjs .
node design/v2/sumber/prototipe.mjs "D:/FLUTTER PROJECT/tamagochi" design/v2/sumber/ikon skrip.json "D:/FLUTTER PROJECT/tamagochi/design/v2/png-prototipe"
figcraft-cli run skrip.json --out design/v2/TamaFlutter-prototipe.figcraft
```

`aturan.mjs` memuat aturan (angka dibaca dari `game_rules.dart`), `prototipe.mjs` layar dan interaksi, `dasar.mjs` token, pet, dan komponen.

Ikon: Material Icons Round, lisensi Apache 2.0 (`ikon/LICENSE`).
