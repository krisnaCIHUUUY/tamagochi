// Aturan prototipe sebagai daftar langkah [jenis, ...]. Satu sumber untuk dua pemakai:
// prototipe.mjs mengubahnya menjadi aksi FigCraft, uji.mjs memainkannya di Node.
import fs from 'node:fs';
import path from 'node:path';

// Angka dibaca dari GameRules supaya prototipe tidak punya angka sendiri.
export function bacaAturan(root) {
  const src = fs.readFileSync(path.join(root, 'lib/features/pet/domain/rules/game_rules.dart'), 'utf8');
  const R = {};
  for (const [, n, v] of src.matchAll(/static const (?:double|int) (\w+) = (-?[\d.]+);/g)) R[n] = +v;
  for (const [, n, u, v] of src.matchAll(/static const Duration (\w+) = Duration\((\w+): (\d+)\)/g)) R[n] = +v * { minutes: 1 / 60, hours: 1, days: 24 }[u];
  return new Proxy(R, { get: (o, k) => { if (!(k in o)) throw new Error(`GameRules.${String(k)} tidak ada`); return o[k]; } });
}

export const NAMA = ['Tama', 'Pipi', 'Bubu', 'Kiko'];
export const CHAR = {
  atletis: ['Si Atletis', 'Ramping dan suka melompat.', 'Kamu sering mengajaknya main.'],
  gembul: ['Si Gembul', 'Bulat dan santai.', 'Kamu sering memberi camilan.'],
  rapi: ['Si Rapi', 'Tenang dan berseri.', 'Kandangnya selalu bersih.'],
  mandiri: ['Si Mandiri', 'Cuek tapi hangat.', 'Ia senang saat kamu datang.'],
  seimbang: ['Si Seimbang', 'Paling ekspresif.', 'Rawatanmu selalu seimbang.'],
};
const q = (s) => `"${s}"`;

export function buatAturan(R) {
  const S = (v, e) => ['set', v, String(e)];
  const IF = (...b) => ['if', ...b]; // pasangan syarat, langkah, ..., [langkah lain]
  const GO = (dest) => ['go', dest];

  const namaiUlang = [
    S('tJemput', '"Jemput " + nama'), S('tTumbuh', '"Waktu kamu pergi, " + nama + " tumbuh"'), S('tJadi', 'nama + " jadi"'),
    S('tLihat', '"Lihat " + nama'), S('tHalo', '"Halo, " + nama'), S('tTidur', 'nama + " lagi tidur."'), S('tAlbum', '"Album " + nama'),
    S('tAlbumSub', '"Lihat karakter " + nama'), S('tJamTidur', '"Jam tidur " + nama'), S('tKangen', 'nama + " kangen kamu"'),
    S('tJamSub', '"Saat " + nama + " tidur, aplikasi ikut malam."'), S('tIngat', '"Tidak berbunyi saat " + nama + " tidur."'),
    S('tRawat', '"Rawat " + nama + " dengan caramu."'), S('tTebak', '"Ke mana " + nama + " akan menoleh?"'),
    ...NAMA.map((n, i) => S(`pilih${i}`, `nama == ${q(n)}`)),
  ];
  const jamTeks = (dari, ke) => IF(`${dari} < 10`, [S(ke, `"0" + ${dari} + ".00"`)], [S(ke, `${dari} + ".00"`)]);

  const TINGGI = { 'bayi-seimbang': 63, 'anak-seimbang': 89 };
  for (const [c, u] of Object.entries({ atletis: 90, gembul: 66, rapi: 92, mandiri: 92, seimbang: 76 })) Object.assign(TINGGI, { [`remaja-${c}`]: Math.round(u * 17 / 12), [`dewasa-${c}`]: Math.round(u * 5 / 3) });
  const tinggi = (sela) => [IF(...Object.entries(TINGGI).flatMap(([k, t]) => [`kode == ${q(k)}`, [S('tinggi', t + sela)]]))];
  // Syarat "titik yang sudah tampil kurang dari dua" tanpa variabel penghitung.
  const belumDua = (v) => v.flatMap((x, i) => v.slice(i + 1).map((y) => ` and not (${x} and ${y})`)).join('');
  const TITIK = [
    ['tObat', 'sakit'], ['tLampu', 'tidur and lampu'], ['tBersih', 'kotoran > 0'],
    ['tMakan', `kenyang < ${R.neededMeterThreshold} and not sakit`],
    ['tMain', `senang < ${R.neededMeterThreshold} and not tidur and not sakit and not murung`],
    ['tMeterK', `kenyang <= ${R.moodyThreshold} and not tidur`], ['tMeterS', `senang <= ${R.moodyThreshold} and not tidur`],
  ];
  const balon = (isi, jenis = '') => [S('balon', q(isi)), S('balonBiasa', jenis !== 'iseng'), S('balonIseng', jenis === 'iseng'), S('balonMain', jenis === 'main')];
  const tanpaBalon = [S('balonBiasa', false), S('balonIseng', false), S('balonMain', false)];

  // Semua nilai tampilan dihitung dari state. Dipanggil di akhir setiap interaksi.
  const hitungUlang = [
    S('siang', 'not tidur'), S('cahaya', 'tidur and lampu'), S('lampuMati', 'not lampu'), S('gelap', 'tidur and not lampu'),
    IF('tahap == "Bayi"', [S('kode', '"bayi-seimbang"')], 'tahap == "Anak"', [S('kode', '"anak-seimbang"')],
      'tahap == "Remaja"', [S('kode', '"remaja-" + bentuk')], [S('kode', '"dewasa-" + bentuk')]),
    // Tinggi pet di layar, supaya balon kata pas di atas kepala.
    IF('tidur', tinggi(40), tinggi(8)),
    // K11: tidur > sakit > murung > lapar > senang > biasa
    IF('tidur', [S('tampil', 'kode + "-tidur"')], 'sakit', [S('tampil', 'kode + "-sakit"')], 'murung', [S('tampil', 'kode + "-murung"')],
      `kenyang <= ${R.hungryMoodThreshold}`, [S('tampil', 'kode + "-lapar"')], `senang >= ${R.happyMoodThreshold}`, [S('tampil', 'kode + "-senang"')], [S('tampil', 'kode + "-biasa"')]),
    // D11: Obat > Lampu > Bersihkan > Makan > Main, paling banyak dua titik.
    ...TITIK.map(([v, e], i) => S(v, e + belumDua(TITIK.slice(0, i).map(([x]) => x)))),
    ...[1, 2, 3, 4].map((i) => S(`kotor${i}`, `kotoran >= ${i}`)),
    IF('sakit and not tidur', balon('Aku nggak enak badan.'), 'tidur and lampu', balon('Lampunya terang.'), 'tidur', tanpaBalon,
      'pulang', balon('Aku pulang!'), 'murung', balon('Aku kangen kamu.'), `kenyang <= ${R.hungryMoodThreshold}`, balon('Aku lapar. Makan, yuk?'),
      'kotoran > 0', balon('Bersihkan, yuk?'), 'iseng', balon('Hei, lihat aku!', 'iseng'), 'rewel', balon('Tidurku kurang nyenyak.'),
      'ajak', balon('Tebak arah, yuk?', 'main'), tanpaBalon),
    jamTeks('jam', 'tJam'), jamTeks('jamTidur', 'tMulai'), jamTeks('jamBangun', 'tSelesai'),
    IF('tidur', [S('badgeA', '"Tidur"'), S('badgeB', '"sampai " + tSelesai')], [S('badgeA', 'tahap'), S('badgeB', 'umur + " tahun"')]),
    IF('tidur', [['mode', 'Malam']], [['mode', 'Siang']]),
  ];

  const terhitung = 'tahap != "Bayi"'; // gaya dihitung sejak tahap Anak
  // Satu penulisan, sudah dijepit: di FigCraft setiap penulisan variabel mahal.
  const tambah = (v, n) => IF(`${v} + ${n} > ${R.maxMeter}`, [S(v, R.maxMeter)], [S(v, `${v} + ${n}`)]);
  const kurang = (v, n) => IF(`${v} - (${n}) < ${R.minMeter}`, [S(v, R.minMeter)], [S(v, `${v} - (${n})`)]);
  const mulaiAksi = [S('ajak', false), S('pulang', false), S('rewel', false)];
  const tolak = [GO('geleng1')]; // ditolak: state identik
  // Saat tidur pet tidak melompat: hanya nilainya yang berubah.
  // Nilai tampilan menyusul saat reaksi selesai, supaya reaksi langsung terlihat setelah diketuk.
  const terima = (langkah, reaksi) => [...mulaiAksi, ...langkah, ...(reaksi ? [IF('not tidur', [GO(reaksi)], hitungUlang)] : hitungUlang)];
  const selesaiReaksi = [...hitungUlang, GO('beranda')];
  const aksi = {
    makan: [IF(`kenyang >= ${R.maxMeter} or sakit`, tolak, terima([
      IF(`kenyang < ${R.neededMeterThreshold}`, [S('kedekatan', `kedekatan + ${R.bondPerNeededAction}`)]),
      tambah('kenyang', R.feedFullness), S('tunda3', 'tunda3 + 1'), S('murung', false), S('jamRendah', 0),
    ], 'r_makan'))],
    camilan: terima([
      S('camilan', 'camilan + 1'), tambah('senang', R.snackHappiness), tambah('kenyang', R.snackFullness),
      IF(`camilan > ${R.maxSnacksPerHour}`, [S('sakit', true), S('jamNol', 0), S('jamKotor', 0)]),
      IF(terhitung, [S('skorCamilan', 'skorCamilan + 1')]),
    ], 'r_camilan'),
    main: [IF('tidur or sakit or murung', tolak, terima([
      IF(`senang < ${R.neededMeterThreshold}`, [S('kedekatan', `kedekatan + ${R.bondPerNeededAction}`)]),
      tambah('senang', R.playHappiness), S('ajak', true), IF(terhitung, [S('skorMain', 'skorMain + 1')]),
    ], 'r_main'))],
    bersihkan: [IF('kotoran == 0', tolak, terima([
      S('kedekatan', `kedekatan + ${R.bondPerNeededAction}`),
      IF(`${terhitung} and umurKotor <= ${R.timelyCleanWindow}`, [S('skorBersih', 'skorBersih + 1')]), S('kotoran', 0), ...[1, 2, 3, 4].map((i) => S(`kotor${i}`, false)), S('tBersih', false),
    ], 'r_bersih'))],
    obat: [IF('not sakit', tolak, terima([
      S('kedekatan', `kedekatan + ${R.bondPerNeededAction}`), S('dosis', 'dosis + 1'),
      IF(`dosis >= ${R.medicineDosesToCure}`, [S('sakit', false), S('dosis', 0)]),
    ], 'r_obat'))],
    lampu: terima([
      IF('lampu and tidur', [S('lampuSemalam', false), S('kedekatan', `kedekatan + ${R.bondPerNeededAction}`)]), S('lampu', 'not lampu'),
    ], null),
  };

  // D10: gaya menang bila unggul > 20% atas setiap gaya lain.
  const unggul = (v, lain) => lain.map((o) => `${v} > ${o} * ${R.evolutionLeadRatio}`).join(' and ');
  const skor = { atletis: 'skorMain', gembul: 'skorCamilan', rapi: 'skorBersih', mandiri: 'skorTinggal' };
  const evolusi = [
    IF(...Object.entries(skor).flatMap(([c, v]) => [unggul(v, Object.values(skor).filter((o) => o !== v)), [S('bentuk', q(c))]]), [S('bentuk', '"seimbang"')]),
    ...Object.values(skor).map((v) => S(v, 0)), S('evolusi', true),
    IF(...Object.entries(CHAR).flatMap(([c, [n, ciri, alasan]]) => [`bentuk == ${q(c)}`, [S('charNama', q(n)), S('charCiri', q(ciri)), S('charAlasan', q(alasan)), S(`dapat_${c}`, true), S(`belum_${c}`, false), S(`label_${c}`, q(n))]])),
  ];
  const hariAnak = R.babyDuration / 24, hariRemaja = hariAnak + R.childDuration / 24, hariDewasa = hariRemaja + R.teenDuration / 24;
  const cekTahap = [
    IF(`tahap == "Bayi" and umur >= ${hariAnak}`, [S('tahap', '"Anak"')]),
    IF(`tahap == "Anak" and umur >= ${hariRemaja}`, [...evolusi, S('tahap', '"Remaja"')]),
    IF(`tahap == "Remaja" and umur >= ${hariDewasa}`, [...evolusi, S('tahap', '"Dewasa"')]),
  ];

  const bangun = [IF('lampuSemalam', [kurang('senang', R.lightsOnWakePenalty), S('rewel', true)]), S('tidur', false), S('lampu', true), S('lampuSemalam', false)];
  // Nilai terkecil dari dua ekspresi tanpa variabel sementara.
  const kecil = (x, y, f) => IF(`${x} <= ${y}`, f(x), f(y));
  // `bt` (ekspresi) jam saat bangun: meter turun, kotoran muncul, timer sakit dan murung berjalan.
  const bangunSelama = (bt, kali) => {
    const rk = R.fullnessDecayPerHour * kali, rs = R.happinessDecayPerHour * kali, am = R.moodyThreshold, B = `(${bt})`;
    const tk = `((kenyang - ${am}) / ${rk})`, ts = `((senang - ${am}) / ${rs})`;
    const sejak = (t, v, lain) => [IF(`${t} < 0`, [S(v, `${v} + ${B}`)], `${t} < ${B}`, [S(v, `${v} + ${B} - ${t}`)], lain)];
    return [
      kecil(`(kenyang / ${rk})`, `(senang / ${rs})`, (t) => sejak(t, 'jamNol', [S('jamNol', 0)])),
      IF(`${tk} >= ${ts}`, sejak(tk, 'jamRendah', [S('jamRendah', 0)]), sejak(ts, 'jamRendah', [S('jamRendah', 0)])), // keduanya di bawah ambang
      // K6: satu meter saja di bawah ambang saat bangun = terlantar, dihitung sejak tahap Anak.
      IF(terhitung, [kecil(tk, ts, (t) => sejak(t, 'skorTinggal', []))]),
      kurang('kenyang', `${B} * ${rk}`), kurang('senang', `${B} * ${rs}`),
      IF('kotoran > 0', [S('umurKotor', `umurKotor + ${B}`)], [S('umurKotor', 0)]),
      IF(`kotoran >= ${R.sickPoopThreshold}`, [S('jamKotor', `jamKotor + ${B}`)], [S('jamKotor', 0)]),
      ...[[`${B} >= ${R.poopDelay}`, 'tunda1 + tunda2 + tunda3', [S('tunda1', 0), S('tunda2', 0), S('tunda3', 0)]], [`${B} >= 2 and ${B} < ${R.poopDelay}`, 'tunda1 + tunda2', [S('tunda1', 'tunda3'), S('tunda2', 0), S('tunda3', 0)]], [`${B} < 2`, 'tunda1', [S('tunda1', 'tunda2'), S('tunda2', 'tunda3'), S('tunda3', 0)]]]
        .map(([syarat, n, geser]) => IF(syarat, [IF(`kotoran + ${n} > ${R.maxPoop}`, [S('kotoran', R.maxPoop)], [S('kotoran', `kotoran + ${n}`)]), ...geser])),
      IF(`not sakit and (jamNol >= ${R.sickZeroNeedAfter} or jamKotor >= ${R.sickPoopAfter})`, [S('sakit', true), S('jamNol', 0), S('jamKotor', 0)]),
      IF(`jamRendah >= ${R.moodyAfter}`, [S('murung', true)]),
      S('camilan', 0),
    ];
  };
  const jalanBangun = (bt) => [IF('tahap == "Bayi"', bangunSelama(bt, R.babyDecayMultiplier), bangunSelama(bt, 1))];
  const majuJam = (n) => [IF(`jam + ${n} >= 24`, [S('umur', 'umur + 1'), S('jam', `jam + ${n} - 24`)], [S('jam', `jam + ${n}`)])];
  const tertidur = [S('tidur', true), S('lampuSemalam', 'lampu')];
  // Maju dt jam (paling banyak 3): melewati paling banyak satu batas, tidur atau bangun.
  const lewat = (dt) => [
    ...mulaiAksi, S('iseng', false),
    IF('tidur', [
      IF('jam >= jamTidur', [IF(`${dt} >= 24 - jam + jamBangun`, [...bangun, IF(`${dt} > 24 - jam + jamBangun`, jalanBangun(`${dt} - 24 + jam - jamBangun`))])],
        `${dt} >= jamBangun - jam`, [...bangun, IF(`${dt} > jamBangun - jam`, jalanBangun(`${dt} - jamBangun + jam`))]),
    ], `jam + ${dt} >= jamTidur`, [...jalanBangun('jamTidur - jam'), ...tertidur], jalanBangun(dt)),
    ...majuJam(dt), ...cekTahap,
  ];
  const sampaiTidur = [IF('not tidur', [...mulaiAksi, S('iseng', false), ...jalanBangun('jamTidur - jam'), S('jam', 'jamTidur'), ...tertidur])];
  const tampilkan = [...hitungUlang, ['tutup'], IF('evolusi', [S('tampilSenang', 'kode + "-senang"'), GO('evo0')], [GO('beranda')])];
  const majukan = (dt) => [...lewat(dt), ...tampilkan];

  const pilihNama = NAMA.map((n) => [S('nama', q(n)), ...namaiUlang]);
  const hariPergi = R.vacationAfter / 24;
  const demo = {
    jam1: ['+1 jam', majukan(1)],
    jam3: ['+3 jam', majukan(3)],
    malam: ['Sampai tidur', [...sampaiTidur, ...tampilkan]],
    pagi: ['Sampai pagi', [...sampaiTidur, ...mulaiAksi, IF('jam >= jamTidur', [S('umur', 'umur + 1')]), ...bangun, S('jam', 'jamBangun'), ...cekTahap, ...tampilkan]],
    pergi: ['Pergi 48 jam', [
      ...mulaiAksi, S('iseng', false),
      // K1: waktu offline tidak menurunkan meter di bawah 10. shortcut: 48 jam selalu cukup untuk sampai di lantai itu.
      IF(`kenyang > ${R.offlineFloor}`, [S('kenyang', R.offlineFloor)]), IF(`senang > ${R.offlineFloor}`, [S('senang', R.offlineFloor)]),
      // shortcut: 20 jam terlantar (bangun 28 jam, meter ≤ 20 setelah sekitar 8 jam); hitung tepat bila skor perlu dibandingkan.
      IF(terhitung, [S('skorTinggal', 'skorTinggal + 20')]),
      S('umur', `umur + ${hariPergi}`), ...cekTahap, S('libur', true), ...hitungUlang, ['mode', 'Siang'], ['tutup'], GO('liburan'),
    ]],
    tahap: ['Naik tahap', [
      ...mulaiAksi, IF('tahap == "Bayi"', [S('umur', hariAnak)], 'tahap == "Anak"', [S('umur', hariRemaja)], 'tahap == "Remaja"', [S('umur', hariDewasa)]), ...cekTahap, ...tampilkan,
    ]],
    sakit: ['Jatuh sakit', [...mulaiAksi, S('sakit', true), ...tampilkan]],
    iseng: ['Panggilan iseng', [...mulaiAksi, S('iseng', true), ...tampilkan]],
    notif: ['Kirim pengingat', [S('notifAda', 'ingat and not tidur'), S('notifKosong', 'not notifAda'), ['tutup'], GO('kunci')]],
    ulang: ['Ulang dari awal', null], // diisi di bawah: kembali ke nilai awal
  };
  const jemput = [
    S('kenyang', R.pickUpMeter), S('senang', R.pickUpMeter), S('kotoran', 0), S('tunda1', 0), S('tunda2', 0), S('tunda3', 0), S('sakit', false), S('dosis', 0), S('murung', false),
    S('jamNol', 0), S('jamKotor', 0), S('jamRendah', 0), S('umurKotor', 0), S('libur', false),
    S('tidur', 'jam >= jamTidur or jam < jamBangun'), S('lampu', true), S('lampuSemalam', 'tidur'), S('pulang', true), ...hitungUlang, IF('evolusi', [S('tampilSenang', 'kode + "-senang"')]), GO('pulang'),
  ];
  const nasihati = [S('iseng', false), S('kedekatan', `kedekatan + ${R.bondPerNeededAction}`), GO('r_nasihat')];
  const sakelar = (v) => [IF(v, [S(v, false), S(`${v}Teks`, '"tidak"')], [S(v, true), S(`${v}Teks`, '"ya"')])];
  // Batas agar jadwal tetap melewati tengah malam dan rentang demo tetap benar.
  const ubahJam = (v, d, min, max) => [IF(d > 0 ? `${v} < ${max}` : `${v} > ${min}`, [S(v, `${v} ${d > 0 ? '+' : '-'} 1`)]), jamTeks('jamTidur', 'tMulai'), jamTeks('jamBangun', 'tSelesai')];
  const setelahJam = [IF('not tidur and (jam >= jamTidur or jam < jamBangun)', [S('tidur', true), S('lampuSemalam', 'lampu')], 'tidur and jam < jamTidur and jam >= jamBangun', bangun), ...hitungUlang];

  // Mini game: arah jawaban dari tabel tetap per permainan (tidak ada acak di FigCraft).
  const KANAN = [[1, 0, 1], [0, 0, 1], [1, 1, 0]];
  const kanan = KANAN.flatMap((r, p) => r.flatMap((v, i) => (v ? [`(pola == ${p} and ronde == ${i + 1})`] : []))).join(' or ');
  const titikRonde = [1, 2, 3].flatMap((i) => [S(`bintang${i}`, `benar >= ${i}`)]);
  const gameMulai = [S('ajak', false), S('ronde', 1), S('benar', 0), S('tRonde', '"Ronde 1 dari 3"'), ...titikRonde, S('tampilSenang', 'kode + "-senang"'), S('tampilBiasa', 'kode + "-biasa"'), ...hitungUlang];
  const tebak = (pilih) => [
    S('keKanan', kanan), IF(`keKanan == ${pilih === 'kanan'}`, [S('benar', 'benar + 1'), S('tHasil', '"Tepat!"')], [S('tHasil', '"Hampir."')]),
    ...titikRonde, IF('keKanan', [GO('game_kanan')], [GO('game_kiri')]),
  ];
  const menang = 2;
  const lanjutGame = [IF('ronde >= 3', [
    S('pola', 'pola + 1'), IF(`pola >= ${KANAN.length}`, [S('pola', 0)]),
    IF(`benar >= ${menang}`, [tambah('senang', R.playHappiness), S('tAkhir', '"Seru sekali!"'), S('tAkhirSub', '"Tebakanmu jitu. Aku senang."'), ...hitungUlang, S('tampilGame', 'kode + "-senang"')],
      [S('tAkhir', '"Seru, ya."'), S('tAkhirSub', '"Aku susah ditebak. Coba lagi, yuk?"'), ...hitungUlang, S('tampilGame', 'kode + "-biasa"')]),
    GO('game_akhir'),
  ], [S('ronde', 'ronde + 1'), S('tRonde', '"Ronde " + ronde + " dari 3"'), GO('game_tebak')])];

  // ---------- nilai awal ----------
  const awal = {
    nama: 'Tama', kenyang: R.startFullness, senang: R.startHappiness, kotoran: 0, tunda1: 0, tunda2: 0, tunda3: 0, sakit: false, dosis: 0, murung: false,
    tahap: 'Bayi', bentuk: 'seimbang', umur: 0, kedekatan: 0, camilan: 0, jam: 10, tidur: false, lampu: true, lampuSemalam: false, jamTidur: R.sleepStartHour, jamBangun: R.sleepEndHour,
    jamNol: 0, jamRendah: 0, jamKotor: 0, umurKotor: 0, skorMain: 0, skorCamilan: 0, skorBersih: 0, skorTinggal: 0,
    ajak: false, pulang: false, rewel: false, iseng: false, libur: false, evolusi: false, suara: true, getar: true, ingat: true, suaraTeks: 'ya', getarTeks: 'ya', ingatTeks: 'ya',
    notifAda: true, notifKosong: false, ronde: 1, benar: 0, pola: 0, keKanan: false, tinggi: 0, lamaTidur: 21, lamaBangun: 7, tRonde: '', tHasil: '', tAkhir: '', tAkhirSub: '', tampilGame: 'bayi-seimbang-senang',
    tampilSenang: 'bayi-seimbang-senang', tampilBiasa: 'bayi-seimbang-biasa', charNama: 'Si Seimbang', charCiri: '', charAlasan: '',
  };
  for (const c of Object.keys(CHAR)) Object.assign(awal, { [`dapat_${c}`]: false, [`belum_${c}`]: true, [`label_${c}`]: 'Masih rahasia' });
  // Nilai turunan: jalankan langkah yang sama, supaya awal dan interaksi tidak pernah berbeda.
  const jenis = { tJam: '', kode: '', balon: '', balonBiasa: false, balonIseng: false, balonMain: false };
  Object.assign(awal, jenis);
  const dunia = mainkan(awal, [...namaiUlang, ...hitungUlang, ...titikRonde, S('tRonde', '"Ronde 1 dari 3"')]).s;
  dunia.balon = ''; dunia.tHasil = 'Tepat!'; dunia.tAkhir = 'Seru sekali!'; dunia.tAkhirSub = 'Tebakanmu jitu. Aku senang.';
  dunia.charCiri = CHAR.seimbang[1]; dunia.charAlasan = CHAR.seimbang[2];
  demo.ulang[1] = [...Object.entries(dunia).map(([k, v]) => S(k, typeof v === 'string' ? q(v) : v)), ['mode', 'Siang'], ['tutup'], GO('splash')];

  const bukaJam = [S('lamaTidur', 'jamTidur'), S('lamaBangun', 'jamBangun')];
  const batalJam = [S('jamTidur', 'lamaTidur'), S('jamBangun', 'lamaBangun'), jamTeks('jamTidur', 'tMulai'), jamTeks('jamBangun', 'tSelesai')];

  return { selesaiReaksi, bukaJam, batalJam, awal: dunia, aksi, demo, jemput, nasihati, sakelar, ubahJam, setelahJam, pilihNama, gameMulai, tebak, lanjutGame, hitungUlang, S, IF, GO };
}

// ---------- penerjemah kecil ----------
export const keJs = (e) => e.replace(/("[^"]*")|\b(and|or|not)\b|==|!=/g, (m, s, k) => s ?? { and: '&&', or: '||', not: '!', '==': '===', '!=': '!==' }[k ?? m]);
export function mainkan(s0, langkah) {
  const s = { ...s0 }, log = [];
  const nilai = (e) => {
    const js = keJs(e);
    const r = new Function('s', `with (s) { return (${js}); }`)(new Proxy(s, { has: (o, k) => typeof k === 'string' && k !== 'undefined', get: (o, k) => { if (typeof k === 'symbol') return undefined; if (!(k in o)) throw new Error(`variabel ${k} tidak ada: ${e}`); return o[k]; } }));
    return r;
  };
  const jalan = (ls) => {
    for (const [op, ...x] of ls) {
      if (op === 'set') {
        const v = nilai(x[1]);
        if (s[x[0]] !== undefined && typeof s[x[0]] !== typeof v) throw new Error(`jenis ${x[0]}: ${typeof s[x[0]]} ≠ ${typeof v} (${x[1]})`);
        s[x[0]] = v;
      } else if (op === 'if') {
        for (let i = 0; i < x.length; i += 2) {
          if (i + 1 === x.length) { jalan(x[i]); break; }
          if (nilai(x[i])) { jalan(x[i + 1]); break; }
        }
      } else log.push(x[0] ?? op);
    }
  };
  jalan(langkah);
  return { s, log };
}
