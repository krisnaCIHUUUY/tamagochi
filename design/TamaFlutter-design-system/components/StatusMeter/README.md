# StatusMeter

Meter Kenyang atau Senang dalam lima pip, seperti hati pada Tamagotchi asli, sehingga anak bisa membacanya tanpa angka.

**Yang disediakan pemakai:** `kind` (`hunger` atau `happy`), `value` (0–100 dari `PetState`), dan `sleeping` (bool).

- Setiap pip mewakili 20 poin. Pip terakhir yang sedang terisi diisi sebagian, jadi 68 = tiga pip penuh dan satu pip 40%.
- Kenyang: ikon `rice_bowl`, isi `meter-hunger`. Senang: ikon `favorite`, isi `meter-happy`. Bagian kosong `meter-track`, garis `stroke`.
- **Rendah** (nilai ≤ 20): chip bergoyang dua kali (`dur-shake`) dan mendapat titik `attention`. Label tidak berubah.
- **Tidur**: ikon `bedtime` di samping label; meter tidak turun selama jam tidur.
- Perubahan nilai beranimasi `dur-meter` dengan `ease-standard`.
- Semantik: `Semantics(label: 'Kenyang: 3 dari 5', value: '68')`.

```dart
StatusMeter(kind: MeterKind.hunger, value: state.hunger, sleeping: state.isSleeping)
```
