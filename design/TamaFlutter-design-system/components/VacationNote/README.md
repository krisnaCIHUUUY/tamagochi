# VacationNote

Catatan bertempel selotip yang menggantikan pet setelah 48 jam tanpa perawatan: pet pergi berlibur ke rumah nenek, bukan mati.

**Yang disediakan pemakai:** `petName`, `leftAt` (waktu pergi) untuk keterangan "Pergi sejak Selasa", dan `onPickUp`.

- Kartu `surface-raised`, garis `stroke`, `shadow-float`, sudut `radius-md`, miring −1.5° dengan selotip `yolk` di atas.
- Isi berurutan: chip `luggage` `char-rapi`, judul `tm-title` dalam suara pet, satu kalimat `tm-body`, keterangan `tm-caption` `ink-muted`, lalu Button primary lebar penuh "Jemput <nama>".
- Ruang pet di belakangnya tetap tampil tanpa pet; ActionBar disembunyikan.
- Setelah Jemput: pet masuk dari kanan dengan `ease-bounce` dan mood senang.
- Jangan menyebut berapa lama pemain pergi dengan angka jam; cukup nama hari.
