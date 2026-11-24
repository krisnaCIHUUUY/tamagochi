// Uji aturan prototipe terhadap GameRules. Pakai: node uji.mjs <root proyek>
import assert from 'node:assert/strict';
import { bacaAturan, buatAturan, mainkan } from './aturan.mjs';
const R = bacaAturan(process.argv[2]), A = buatAturan(R);
const mulai = (o = {}) => ({ ...A.awal, ...o });
// Layar reaksi menghitung ulang tampilan saat selesai; uji memainkannya sebagai satu langkah.
const main = (s, ...ls) => ls.reduce((r, l) => { const x = mainkan(r.s, l); return String(x.log.at(-1)).startsWith('r_') ? { s: mainkan(x.s, A.selesaiReaksi).s, log: x.log } : x; }, { s, log: [] });
const d = (k) => A.demo[k][1], anak = { tahap: 'Anak', umur: 1 };
let n = 0;
const uji = (nama, f) => { try { f(); n++; } catch (e) { console.error('GAGAL', nama, '\n', e.message); process.exitCode = 1; } };

uji('Anak: 2 jam bangun, kenyang 80 → 64, senang 80 → 68', () => { const { s } = main(mulai(anak), d('jam1'), d('jam1')); assert.deepEqual([s.kenyang, s.senang, s.jam], [64, 68, 12]); });
uji('Bayi turun dua kali lebih cepat', () => { const { s } = main(mulai(), d('jam1')); assert.deepEqual([s.kenyang, s.senang], [64, 68]); });
uji('Makan +30, dijepit 100, ditolak di 100', () => {
  let r = main(mulai({ ...anak, kenyang: 18 }), A.aksi.makan); assert.equal(r.s.kenyang, 48); assert.deepEqual(r.log.slice(-1), ['r_makan']);
  r = main(mulai({ ...anak, kenyang: 90 }), A.aksi.makan); assert.equal(r.s.kenyang, 100);
  const t = main(r.s, A.aksi.makan); assert.equal(t.s.kenyang, 100); assert.equal(t.log.at(-1), 'geleng1'); assert.equal(t.s.tunda3, r.s.tunda3);
});
uji('Makan dan Main ditolak saat sakit, Main ditolak saat tidur dan murung', () => {
  for (const o of [{ sakit: true }]) for (const k of ['makan', 'main']) assert.equal(main(mulai(o), A.aksi[k]).log.at(-1), 'geleng1');
  for (const o of [{ tidur: true, jam: 22 }, { murung: true }]) assert.equal(main(mulai(o), A.aksi.main).log.at(-1), 'geleng1');
});
uji('Makan mengobati murung', () => assert.equal(main(mulai({ murung: true, kenyang: 10, senang: 10 }), A.aksi.makan).s.murung, false));
uji('Bersihkan ditolak tanpa kotoran, Obat ditolak saat sehat', () => { for (const k of ['bersihkan', 'obat']) assert.equal(main(mulai(), A.aksi[k]).log.at(-1), 'geleng1'); });
uji('Obat: sembuh setelah dua dosis', () => { let r = main(mulai({ sakit: true }), A.aksi.obat); assert.equal(r.s.sakit, true); r = main(r.s, A.aksi.obat); assert.equal(r.s.sakit, false); assert.equal(r.s.dosis, 0); });
uji('Camilan ke-6 dalam satu jam membuat sakit, +1 jam mengulang hitungan', () => {
  let r = main(mulai(anak), ...Array(5).fill(A.aksi.camilan)); assert.equal(r.s.sakit, false); assert.equal(main(r.s, A.aksi.camilan).s.sakit, true);
  assert.equal(main(r.s, d('jam1'), A.aksi.camilan).s.sakit, false);
});
uji('Kotoran muncul 3 jam setelah makan, maksimal 4', () => {
  let r = main(mulai({ ...anak, kenyang: 30 }), A.aksi.makan, d('jam1'), d('jam1')); assert.equal(r.s.kotoran, 0); r = main(r.s, d('jam1')); assert.equal(r.s.kotoran, 1); assert.equal(r.s.kotor1, true); assert.equal(r.s.kotor2, false);
  assert.equal(main(mulai({ ...anak, tunda3: 9 }), d('jam3')).s.kotoran, 4);
});
uji('Sakit setelah 2 jam dengan ≥ 3 kotoran; sakit setelah meter 0 selama 60 menit', () => {
  let r = main(mulai({ ...anak, kotoran: 3 }), d('jam1')); assert.equal(r.s.sakit, false); assert.equal(main(r.s, d('jam1')).s.sakit, true);
  r = main(mulai({ ...anak, kenyang: 8 }), d('jam1')); assert.equal(r.s.kenyang, 0); assert.equal(r.s.sakit, false); assert.equal(main(r.s, d('jam1')).s.sakit, true);
});
uji('Murung setelah keduanya ≤ 20 selama 6 jam', () => { let r = main(mulai({ ...anak, kenyang: 20, senang: 20, sakit: true }), d('jam3'), d('jam1'), d('jam1')); assert.equal(r.s.murung, false); assert.equal(main(r.s, d('jam1')).s.murung, true); });
uji('Tidur: meter dan kotoran berhenti', () => {
  const r = main(mulai({ ...anak, jam: 21, tidur: true, lampu: false, tunda3: 1 }), d('jam3')); assert.deepEqual([r.s.kenyang, r.s.senang, r.s.kotoran, r.s.jam, r.s.umur], [80, 80, 0, 0, 2]);
});
uji('+3 jam melewati jam tidur: hanya jam bangun yang dihitung', () => { const r = main(mulai({ ...anak, jam: 20 }), d('jam3')); assert.deepEqual([r.s.kenyang, r.s.jam, r.s.tidur, r.s.tampil], [72, 23, true, 'anak-seimbang-tidur']); assert.ok(r.log.includes('Malam')); });
uji('+3 jam melewati jam bangun', () => { const r = main(mulai({ ...anak, jam: 5, tidur: true, lampu: false }), d('jam3')); assert.deepEqual([r.s.kenyang, r.s.jam, r.s.tidur, r.s.lampu], [72, 8, false, true]); });
uji('Lampu menyala semalaman: senang −10; dimatikan: tidak', () => {
  const m = main(mulai({ ...anak, jam: 20 }), d('malam')).s; assert.equal(m.tLampu, true); const dasar = m.senang;
  const p = main(m, d('pagi')).s; assert.equal(p.senang, dasar - 10); assert.equal(p.rewel, true); assert.equal(p.jam, 7);
  assert.equal(main(m, A.aksi.lampu, d('pagi')).s.senang, dasar);
});
uji('Sampai pagi dari siang', () => { const r = main(mulai(anak), d('pagi')); assert.deepEqual([r.s.jam, r.s.tidur, r.s.umur], [7, false, 2]); });
uji('Pergi 48 jam → liburan, lantai 10; Jemput → 50/50, bersih, sehat', () => {
  const r = main(mulai({ ...anak, kotoran: 3, sakit: true }), d('pergi')); assert.equal(r.log.at(-1), 'liburan'); assert.deepEqual([r.s.kenyang, r.s.senang], [10, 10]);
  const j = main(r.s, A.jemput); assert.deepEqual([j.s.kenyang, j.s.senang, j.s.kotoran, j.s.sakit, j.s.murung], [50, 50, 0, false, false]); assert.equal(j.s.balon, 'Aku pulang!');
});
uji('Kelima karakter tercapai, di Remaja dan Dewasa', () => {
  const gaya = { atletis: [A.aksi.main], gembul: [A.aksi.camilan], mandiri: [d('pergi'), A.jemput], seimbang: [A.aksi.main, A.aksi.camilan], rapi: [A.aksi.bersihkan] };
  for (const [c, ls] of Object.entries(gaya)) for (const [t, u, hasil] of [['Anak', 1, 'Remaja'], ['Remaja', 4, 'Dewasa']]) {
    const r = main(mulai({ tahap: t, umur: u, kotoran: c === 'rapi' ? 1 : 0 }), ...ls, d('tahap')); assert.deepEqual([r.s.bentuk, r.s.tahap, r.s[`dapat_${c}`]], [c, hasil, true]); assert.equal(r.log.at(-1), 'evo0');
    assert.equal(r.s.kode, `${hasil.toLowerCase()}-${c}`);
  }
});
uji('Unggul tepat 20% → Si Seimbang', () => { assert.equal(main(mulai({ ...anak, skorMain: 6, skorCamilan: 5 }), d('tahap')).s.bentuk, 'seimbang'); assert.equal(main(mulai({ ...anak, skorMain: 7, skorCamilan: 5 }), d('tahap')).s.bentuk, 'atletis'); });
uji('Bayi → Anak tanpa evolusi; gaya Bayi tidak dihitung', () => { const r = main(mulai(), A.aksi.main, d('tahap')); assert.deepEqual([r.s.tahap, r.s.evolusi, r.s.skorMain], ['Anak', false, 0]); });
uji('Mini game: tiap pola bisa dimenangkan dan bisa meleset; menang +20', () => {
  for (const pola of [0, 1, 2]) for (const ikut of [true, false]) {
    let s = main(mulai({ pola, senang: 40 }), A.gameMulai).s, akhir;
    for (let i = 0; i < 3; i++) { const kanan = main(s, A.tebak('kanan')).s.keKanan; s = main(s, A.tebak(kanan === ikut ? 'kanan' : 'kiri')).s; const l = main(s, A.lanjutGame); s = l.s; akhir = l.log.at(-1); }
    assert.equal(akhir, 'game_akhir'); assert.equal(s.benar, ikut ? 3 : 0); assert.equal(s.senang, ikut ? 60 : 40); assert.equal(s.pola, (pola + 1) % 3);
  }
});
uji('Nasihati +1 kedekatan; panggilan hilang tanpa hukuman bila diabaikan', () => {
  const i = main(mulai({ ...anak, kenyang: 80 }), d('iseng')); assert.equal(i.s.balonIseng, true); assert.equal(main(i.s, A.nasihati).s.kedekatan, 1);
  const a = main(i.s, d('jam1')); assert.deepEqual([a.s.iseng, a.s.kedekatan, a.s.senang], [false, 0, 74]);
});
uji('Pengingat tidak muncul saat tidur atau dimatikan', () => { assert.equal(main(mulai({ tidur: true }), d('notif')).s.notifAda, false); assert.equal(main(mulai(), A.sakelar('ingat'), d('notif')).s.notifAda, false); assert.equal(main(mulai(), d('notif')).s.notifAda, true); });
uji('Jam tidur: 22.00 menunda tidur, batas tidak terlampaui', () => {
  const r = main(mulai({ ...anak, jam: 20 }), A.ubahJam('jamTidur', 1, 18, 23), A.setelahJam); assert.equal(r.s.tMulai, '22.00'); assert.equal(main(r.s, d('malam')).s.jam, 22);
  assert.equal(main(mulai({ jamTidur: 23 }), A.ubahJam('jamTidur', 1, 18, 23)).s.jamTidur, 23);
});
uji('Ulang kembali ke awal', () => { const r = main(mulai({ ...anak, nama: 'Bubu', sakit: true, dapat_rapi: true }), d('ulang')); assert.deepEqual(r.s, A.awal); assert.equal(r.log.at(-1), 'splash'); });
uji('5.000 langkah acak ber-seed: meter 0–100, titik ≤ 2, tampilan sah', () => {
  let x = 7; const acak = (m) => (x = (x * 1103515245 + 12345) % 2147483648) % m;
  const pil = [...Object.values(A.aksi), ...['jam1', 'jam3', 'malam', 'pagi', 'sakit', 'iseng', 'tahap'].map(d), A.nasihati];
  let s = mulai();
  for (let i = 0; i < 5000; i++) {
    if (i % 60 === 0) s = mulai({ bentuk: 'seimbang' });
    const l = acak(40) === 0 ? null : pil[acak(pil.length)];
    s = l ? main(s, l).s : main(s, d('pergi'), A.jemput).s;
    for (const k of ['kenyang', 'senang']) assert.ok(s[k] >= 0 && s[k] <= 100, `${k} ${s[k]}`);
    assert.ok(['tObat', 'tLampu', 'tBersih', 'tMakan', 'tMain', 'tMeterK', 'tMeterS'].filter((t) => s[t]).length <= 2);
    assert.ok(s.kotoran >= 0 && s.kotoran <= 4 && s.jam >= 0 && s.jam < 24, `jam ${s.jam}`);
    assert.equal(s.tidur, s.jam >= s.jamTidur || s.jam < s.jamBangun, `tidur ${s.tidur} jam ${s.jam}`);
    assert.match(s.tampil, /^(bayi-seimbang|anak-seimbang|(remaja|dewasa)-(atletis|gembul|rapi|mandiri|seimbang))-(senang|biasa|lapar|sakit|tidur|murung)$/);
  }
});
console.log(`${n} uji aturan lolos`);
