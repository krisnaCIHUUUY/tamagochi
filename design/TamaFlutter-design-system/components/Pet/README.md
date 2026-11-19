# Pet

Gambar pet yang dilukis `PetPainter` (CustomPainter) dari bentuk geometri saja: tubuh persegi bulat, dua kaki oval, mata, mulut, dan pipi.

**Yang disediakan pemakai:** `mood` (dari `moodResolver(state)`), `shape` (tahap atau karakter dewasa), serta nilai animasi `breath` (0–1) dan `blink` (0–1) dari `IdleAnimator`. Painter hanya menggambar satu frame; waktu diatur animator.

**Proporsi** (kotak 120 x 120, diskalakan ke `size-pet`):

| Bentuk | Tubuh (x, y, w, h, radius) | Ciri |
| --- | --- | --- |
| Si Seimbang, juga Bayi/Anak/Remaja | 22, 28, 76, 68, r34 | ekspresi paling lengkap |
| Si Atletis | 32, 14, 56, 82, r28 | tinggi ramping, ikat kepala `meter-happy` |
| Si Gembul | 12, 38, 96, 58, r29 | lebar, perut `pet-egg` |
| Si Rapi | 24, 30, 72, 66, r26 | daun `char-atletis` di kepala |
| Si Mandiri | 24, 26, 72, 70, r33 | antena ke samping |
| Telur | elips 34 x 44 | `pet-egg`, bintik `yolk`, retakan zigzag |

Skala tahap dari `size-pet` (200): Bayi 0.5, Anak 0.7, Remaja 0.85, Dewasa 1.0.

**Mood** (mata pada 44% tinggi tubuh, mulut 15 unit di bawahnya):

| Mood | Mata | Mulut | Tambahan |
| --- | --- | --- | --- |
| senang | lengkung terbalik | senyum terbuka terisi | pipi `pet-cheek` |
| biasa | oval terbuka dengan kilau `pet-highlight` | senyum kecil | pipi |
| lapar | oval, alis cemas (ujung dalam naik) | bulat "o" | — |
| sakit | garis datar | bergelombang | pipi `sick`, keringat `char-rapi` |
| tidur | lengkung tertutup | "o" kecil | dua huruf z `ink-muted` |
| murung | oval turun, alis sedih | cemberut | air mata `char-rapi`, tanpa pipi |

- Garis luar `pet-ink` setebal `border-pet` (3), ujung bulat.
- Napas: skala tubuh 1.00–1.03 dari kaki (`dur-breathe`, `ease-breathe`); kaki tidak ikut membesar.
- Kedipan: mata terbuka menjadi garis selama `dur-blink`. Mood senang dan tidur tidak berkedip.
- Tidak ada tengkorak, mata silang, atau warna abu-abu untuk keadaan apa pun.
- Semantik: `Semantics(label: 'Tama, lapar', image: true)`.

```dart
CustomPaint(size: const Size.square(200), painter: PetPainter(mood: Mood.lapar, shape: PetShape.seimbang, breath: breath.value, blink: blink.value))
```
