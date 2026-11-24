// Menulis skrip perintah FigCraft untuk prototipe penuh TamaFlutter.
// Pakai: node prototipe.mjs <root proyek> <folder ikon> <out.json> [folder png]
import { fs, path, root, outJson, pngDir, setup, comps, screens, ref, cmd, $, AGE_TYPE, compPage, node, frame, text, scalePath, iconPath, icon, lip, float, sticker, registry, shelf, comp, inst, petTop, drawPet, chip, dot, ACTIONS, action, iconBtn, button, toggle, poop, W, IN, H, pakai } from './dasar.mjs';
import { bacaAturan, buatAturan, CHAR, NAMA } from './aturan.mjs';

const A = buatAturan(bacaAturan(root)), { IF, GO, S } = A;
// Properti varian baru ada setelah komponen digabung jadi set, jadi ikatannya ditulis paling akhir.
const ikatVarian = [];
const bind = (id, field, variable) => { if (field.startsWith('componentProperties/')) { ikatVarian.push([id, field, variable]); return id; } cmd('variable.bind', { ids: [id], field, variable }); return id; };
const tampak = (id, v) => bind(id, 'visible', v);
const teksV = (p, v, style, o = {}) => bind(text(p, String(A.awal[v] ?? v) || ' ', style, { name: v, ...o }), 'characters', v);
// Titik ganti huruf di gambar statis tidak perlu; tengah = kotak selebar w, rata tengah.
const tengah = (w, o = {}) => ({ w, textAlign: 'center', ...o });

// ---------- variabel ----------
pakai(setup);
cmd('variable.createCollection', { name: 'State' });
for (const [name, value] of Object.entries(A.awal)) cmd('variable.create', { collection: 'State', name, type: typeof value === 'string' ? 'string' : typeof value, value });

// ---------- pet ----------
const TAHAP = { bayi: [100, ['seimbang']], anak: [140, ['seimbang']], remaja: [170, Object.keys(CHAR)], dewasa: [200, Object.keys(CHAR)] };
const MOOD = ['senang', 'biasa', 'lapar', 'sakit', 'tidur', 'murung'];
const ALAS = 200 * 104 / 120; // garis kaki di kotak 200
function skala(root, build) { // anak ikut membesar saat instance diubah ukurannya (dipakai napas)
  const buf = comps, dari = buf.length;
  build();
  const ids = buf.slice(dari).filter((c) => c.command === 'node.create').map((c) => ref(c.as));
  cmd('node.set', { ids, constraints: { horizontal: 'scale', vertical: 'scale' } });
}
const petKode = (kode, mood, kedip = false) => comp('Pet', `Tampil=${kode}-${mood}, Kedip=${kedip ? 'ya' : 'tidak'}`, 200, 200, (r) => skala(r, () => {
  const [t, b] = kode.split('-'), s = TAHAP[t][0];
  drawPet(frame(r, { x: (200 - s) / 2, y: ALAS - s * 104 / 120, w: s, h: s, name: 'badan' }), b, mood, s, kedip);
}));
for (const [t, [, bentuk]] of Object.entries(TAHAP)) for (const b of bentuk) for (const m of MOOD) for (const k of [false, true]) petKode(`${t}-${b}`, m, k);
// Pet terikat `tampil`. napas: skala 1.03 dengan kaki tetap di tempat.
function taruhPet(p, x, y, { napas = false, kedip = false, rot, v = 'tampil' } = {}) {
  const n = napas ? 206 : 200;
  const i = inst(petKode('bayi-seimbang', 'senang', kedip), p, x + (200 - n) / 2, y + ALAS - ALAS * n / 200, null, { name: 'pet', width: n, height: n, ...(rot ? { rotation: rot } : {}) });
  return bind(i, 'componentProperties/Tampil', v);
}
const siluet = (b) => comp('PetSiluet', `Bentuk=${b}`, 200, 200, (r) => skala(r, () => drawPet(r, b, 'siluet', 200)));
const telur = () => comp('Telur', 'Telur', 200, 200, (r) => skala(r, () => drawPet(r, 'telur', 'biasa', 200)));
for (const b of Object.keys(CHAR)) siluet(b);

// ---------- bagian hidup ----------
// Batang selebar 100 px: nilai meter langsung jadi lebar, tanpa variabel piksel terpisah.
const PIP = (100 - 16) / 5;
const meterHidup = (kind) => comp('MeterHidup', `Jenis=${kind}`, 156, 42, (r) => {
  const [ic, color, px, titik] = kind === 'Kenyang' ? ['rice_bowl', 'meter-hunger', 'kenyang', 'tMeterK'] : ['favorite', 'meter-happy', 'senang', 'tMeterS'];
  chip(r, 36, color, ic, 20, { y: 3 });
  tampak(dot(r, 23, -4), titik);
  text(r, kind, 'tm-label', { x: 48, y: 0 });
  tampak(icon(r, 'bedtime', 18, 'ink-muted', { x: 122, y: 1 }), 'tidur');
  for (let i = 0; i < 5; i++) { // satu batang yang sama dilihat lewat lima pip
    const f = frame(r, { x: 48 + i * (PIP + 4), y: 26, w: PIP, h: 16, name: `pip ${i + 1}`, radius: 8, fill: $('meter-track'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside', clip: true });
    bind(node('rectangle', f, { x: -i * (PIP + 4), y: 0, w: A.awal[px], h: 16, name: 'isi', fill: $(color) }), 'width', px);
  }
});
const badgeHidup = () => comp('BadgeHidup', 'BadgeHidup', 240, 40, (r) => {
  tampak(chip(r, 28, 'char-gembul', 'cake', 16), 'siang'); tampak(chip(r, 28, 'char-rapi', 'bedtime', 16), 'tidur');
  teksV(r, 'badgeA', 'tm-label'); text(r, '·', 'tm-label', { fill: 'ink-muted' }); teksV(r, 'badgeB', AGE_TYPE);
}, { ...sticker, cornerRadius: 20, layout: 'horizontal', gap: 8, padding: [2, 14, 2, 6], crossAlign: 'center', sizingH: 'hug', sizingV: 'fixed' });
const sakelarHidup = (v) => { const i = toggle(true); toggle(false); return (p) => bind(inst(i, p), 'componentProperties/Nyala', `${v}Teks`); };

function ruangIsi(r, h, { hidup = true } = {}) {
  const fy = Math.round(h * 0.78);
  node('rectangle', r, { x: 2, y: fy, w: IN - 4, h: h - fy - 2, name: 'lantai', fill: $('surface'), cornerRadius: [0, 0, 22, 22] });
  node('rectangle', r, { x: 2, y: fy, w: IN - 4, h: 2, name: 'garis lantai', fill: $('outline') });
  const win = frame(r, { x: 24, y: 24, w: 112, h: 112, name: 'jendela', radius: 24, fill: $('surface'), stroke: $('outline'), strokeWeight: 4, strokeAlign: 'inside', clip: true });
  const pagi = frame(win, { w: 112, h: 112, name: 'siang' });
  node('ellipse', pagi, { x: 54, y: 20, w: 36, h: 36, name: 'matahari', fill: $('yolk') });
  node('rectangle', pagi, { x: 20, y: 62, w: 60, h: 22, cornerRadius: 11, name: 'awan', fill: $('room') });
  node('ellipse', pagi, { x: 32, y: 46, w: 32, h: 32, name: 'awan', fill: $('room') });
  if (hidup) {
    tampak(pagi, 'siang');
    const mlm = tampak(frame(win, { w: 112, h: 112, name: 'malam' }), 'tidur');
    node('ellipse', mlm, { x: 54, y: 22, w: 36, h: 36, name: 'bulan', fill: $('yolk') });
    node('ellipse', mlm, { x: 44, y: 16, w: 34, h: 34, name: 'bayang bulan', fill: $('surface') });
    for (const [x, y] of [[22, 26], [32, 72], [76, 78]]) node('star', mlm, { x, y, w: 8, h: 8, name: 'bintang', fill: $('yolk') });
    tampak(node('ellipse', r, { x: 128, y: -20, w: 240, h: 240, name: 'cahaya', fills: [{ type: 'radialGradient', stops: ['#ffd35c73', '#ffd35c00'] }] }), 'cahaya');
  }
  node('rectangle', r, { x: 247, y: 2, w: 2, h: 46, name: 'kabel lampu', fill: $('stroke') });
  for (const [nyala, v] of hidup ? [[true, 'lampu'], [false, 'lampuMati']] : [[true]]) {
    const l = frame(r, { x: 228, y: 48, w: 40, h: 36, name: nyala ? 'lampu nyala' : 'lampu mati' });
    node('ellipse', l, { x: 10, y: 18, w: 20, h: 18, name: 'bohlam', fill: $(nyala ? 'yolk' : 'meter-track'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'center' });
    node('vector', l, { path: 'M0 28 Q0 0 20 0 Q40 0 40 28Z', name: 'kap lampu', fill: $(nyala ? 'yolk' : 'surface-raised'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'center', strokeJoin: 'round' });
    if (v) tampak(l, v);
  }
  node('ellipse', r, { x: 54, y: fy + 14, w: 220, h: 52, name: 'karpet', fill: $('surface-raised'), stroke: $('outline'), strokeWeight: 2, strokeAlign: 'inside' });
  return fy;
}
const TR = 414, FY = Math.round(TR * 0.78), KAKI = FY + 44;
const ruangHidup = () => comp('RuangHidup', 'RuangHidup', IN, TR, (r) => {
  ruangIsi(r, TR);
  [[28, 8], [256, 14], [64, 46], [218, 48]].forEach(([x, dy], i) => tampak(inst(poop(), r, x, FY + dy), `kotor${i + 1}`));
}, { fill: $('room'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside', cornerRadius: 24, clip: true });
const kartuBalon = (p, h, isi) => {
  const f = frame(p, { w: 256, h: h + 12, name: 'balon kata' });
  node('vector', f, { path: `M118 ${h - 2} L128 ${h + 10} L138 ${h - 2}`, name: 'ekor', fill: $('surface-raised'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'center', strokeJoin: 'round' });
  const b = frame(f, { w: 256, h, name: 'kartu', ...sticker, radius: 16 });
  node('rectangle', f, { x: 121, y: h - 3, w: 14, h: 4, name: 'sambungan', fill: $('surface-raised') });
  isi(b);
  return f;
};

// ---------- interaksi (ditulis di akhir, setelah semua layar ada) ----------
const frames = {}, antre = [];
const on = (id, langkah, o = {}) => { antre.push([id, langkah, o]); return id; };
const ke = (id, dest, o) => on(id, [GO(dest)], o);
const HALUS = { transition: 'smartAnimate', dur: 360, easing: 'easeOutBack' };
const DORONG = { transition: 'push', arah: 'left', dur: 240 }, BALIK = { transition: 'push', arah: 'right', dur: 240 };

// ---------- rangka layar ----------
pakai(screens);
cmd('page.select', { id: 1 });
const POS = {};
let baris = 0, kolom = 0;
const barisBaru = (judul) => { baris++; kolom = 0; text(null, judul, 'tm-display', { x: 0, y: (baris - 1) * 1000 - 72, name: `judul ${judul}` }); };
function layar(key, title, o = {}) {
  const f = frame(null, { x: kolom++ * 420, y: (baris - 1) * 1000, w: W, h: o.h ?? H, name: title, fill: $(o.fill ?? 'surface'), clip: true, radius: o.sheet ? undefined : 24, ...(o.sheet ? { cornerRadius: [24, 24, 0, 0] } : {}) });
  frames[key] = { id: f, title };
  return f;
}
// Jam ponsel = pintu ke mode demo. Bukan bagian aplikasi.
function jam(f, aktif = true) {
  const b = frame(f, { x: 16, y: 0, w: IN, h: 34, name: 'bar ponsel (mode demo)' });
  teksV(b, 'tJam', 'tm-caption', { x: 8, y: 6, fill: 'ink-muted' });
  if (!aktif) return;
  icon(b, 'fast_forward', 18, 'ink-muted', { x: 252, y: 7 }); text(b, 'demo', 'tm-caption', { x: 274, y: 6, fill: 'ink-muted' });
  on(b, [['buka', 'demo']], { transition: 'moveIn', arah: 'top', dur: 240, pemicu: 'mouseUp' });
}
const kepala = (f, judul, dest, variabel) => {
  ke(inst(iconBtn('arrow_back'), f, 16, 36), dest, BALIK);
  return variabel ? teksV(f, variabel, 'tm-title', { x: 80, y: 46 }) : text(f, judul, 'tm-title', { x: 80, y: 46 });
};
const tombol = (p, variant, label, x, y, o = {}, ic = null) => {
  const i = inst(button(variant, ic), p, x, y, { Label: label.startsWith('=') ? String(A.awal[label.slice(1)]) : label }, o);
  if (label.startsWith('=')) bind(i, 'componentProperties/Label', label.slice(1));
  return i;
};
const kilau = (R, x, y, s) => { const f = frame(R, { x, y, w: s, h: s, name: 'kilau' }); node('vector', f, { path: scalePath(iconPath('auto_awesome'), s / 24), name: 'auto_awesome', fill: $('yolk'), stroke: $('pet-ink'), strokeWeight: 1, strokeAlign: 'center', strokeJoin: 'round' }); return f; };

// ---------- pembuka ----------
barisBaru('Pembuka');
const ruangPenuh = (f, y, h, name = 'ruang') => frame(f, { x: 16, y, w: IN, h, name, fill: $('room'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside', radius: 24, clip: true });
{
  const f = layar('splash', 'Pembuka · Splash');
  const R = ruangPenuh(f, 40, 736);
  text(R, 'TamaFlutter', { ...AGE_TYPE, fontSize: 48, lineHeight: 56 }, tengah(IN, { y: 120 }));
  text(R, 'Teman kecil di sakumu', 'tm-body', tengah(IN, { y: 184, fill: 'ink-muted' }));
  node('ellipse', R, { x: 64, y: 480, w: 200, h: 44, name: 'panggung', fill: $('surface-raised'), stroke: $('outline'), strokeWeight: 2, strokeAlign: 'inside' });
  inst(telur(), R, 64, 320, null, { name: 'telur' }); kilau(R, 40, 300, 44); kilau(R, 246, 330, 36);
  ke(tombol(R, 'primary', 'Mulai', 32, 640), 'nama', DORONG);
}
{
  const f = layar('nama', 'Pembuka · Beri nama');
  kepala(f, 'Beri nama', 'splash');
  inst(telur(), f, 100, 96, null, { name: 'telur', width: 160, height: 160 });
  text(f, 'Siapa namaku?', 'tm-display', tengah(IN, { x: 16, y: 280 }));
  pilihNama(f, 344);
  ke(tombol(f, 'primary', 'Pakai nama ini', 48, 704), 'telur1', HALUS);
}
function pilihNama(f, y) {
  NAMA.forEach((n, i) => {
    const k = frame(f, { x: 16, y: y + i * 76, w: IN, h: 64, name: `nama ${n}`, ...sticker, radius: 16 });
    lip(k);
    text(k, n, 'tm-title', { x: 20, y: 20 });
    node('ellipse', k, { x: 280, y: 20, w: 24, h: 24, name: 'lingkaran', stroke: $('ink-muted'), strokeWeight: 2, strokeAlign: 'inside', fill: $('surface-raised') });
    tampak(icon(k, 'check_circle', 28, 'accent', { x: 278, y: 18 }), `pilih${i}`);
    on(k, A.pilihNama[i]);
  });
}
for (const [i, rot] of [0, 7, -7, 0].entries()) {
  const key = `telur${i + 1}`, f = layar(key, `Pembuka · Telur ${['diam', 'goyang kanan', 'goyang kiri', 'retak'][i]}`);
  jam(f, false);
  const R = ruangPenuh(f, 104, 672); ruangIsi(R, 672, { hidup: false });
  inst({ id: badgeTelur().id }, f, 16, 40);
  inst(telur(), R, 64, 376, null, { name: 'telur', ...(rot ? { rotation: rot } : {}) });
  if (i === 3) { kilau(R, 40, 420, 44); kilau(R, 246, 400, 40); kilau(R, 60, 520, 28); }
  const b = kartuBalon(R, 48, (k) => text(k, i === 3 ? 'Aku datang!' : 'Sebentar lagi aku menetas.', 'tm-body', tengah(256, { y: 12 })));
  cmd('node.set', { ids: [b], x: 36, y: 332 });
  on(f, [GO(['telur2', 'telur3', 'telur4', 'menetas'][i])], { ms: [1400, 160, 160, 700][i], transition: 'smartAnimate', dur: [140, 140, 140, 360][i], easing: i === 3 ? 'easeOutBack' : 'easeInOut' });
}
function badgeTelur() {
  return comp('StageBadge', 'Telur', 200, 40, (r) => { chip(r, 28, 'yolk', 'egg', 16); text(r, 'Telur', 'tm-label'); text(r, '·', 'tm-label', { fill: 'ink-muted' }); text(r, 'hampir menetas', 'tm-label'); },
    { ...sticker, cornerRadius: 20, layout: 'horizontal', gap: 8, padding: [2, 14, 2, 6], crossAlign: 'center', sizingH: 'hug', sizingV: 'fixed' });
}
{
  const f = layar('menetas', 'Pembuka · Menetas');
  jam(f, false);
  const R = ruangPenuh(f, 104, 672); ruangIsi(R, 672, { hidup: false });
  taruhPet(R, 64, 395); kilau(R, 50, 440, 44); kilau(R, 240, 420, 36); kilau(R, 76, 540, 28);
  teksV(R, 'tHalo', 'tm-display', tengah(296, { x: 16, y: 260 }));
  text(R, 'Aku lahir hari ini.', 'tm-body', tengah(296, { x: 16, y: 306, fill: 'ink-muted' }));
  ke(tombol(R, 'primary', 'Mulai merawat', 32, 592), 'beranda', HALUS);
}

// ---------- Beranda ----------
barisBaru('Beranda dan reaksi');
// Layar Beranda berganti untuk napas; onClick hilang bila pergantian jatuh di antara jari turun dan naik,
// dan mouseDown memunculkan kilatan petunjuk klik. mouseUp: 40 dari 40 ketukan diterima saat diuji.
const NAIK = { ...HALUS, pemicu: 'mouseUp' };
function beranda(key, title, { pose = {}, alat, aktif = false } = {}) {
  const f = layar(key, title);
  jam(f, aktif);
  inst(badgeHidup(), f, 16, 40, null, { name: 'badge' });
  const gear = inst(iconBtn('settings'), f, 296, 36, null, { name: 'setelan' });
  inst(ruangHidup(), f, 16, 104, null, { name: 'ruang' });
  const R = frame(f, { x: 16, y: 104, w: IN, h: TR, name: 'panggung', radius: 24, clip: true });
  teksV(R, 'tTidur', 'tm-body', tengah(280, { x: 24, y: 152 })); tampak({ $ref: screensLast() }, 'gelap');
  tampak(text(R, 'Main lagi besok pagi.', 'tm-body', tengah(280, { x: 24, y: 176 })), 'gelap');
  // Balon menempel di atas kepala: pengganjal setinggi pet.
  if (!alat && !pose.rot) {
    const st = frame(R, { x: 36, y: 0, w: 256, h: KAKI, name: 'tempat balon', layout: 'vertical', mainAlign: 'max', crossAlign: 'center', sizingH: 'fixed', sizingV: 'fixed' });
    const biasa = kartuBalon(st, 48, (k) => teksV(k, 'balon', 'tm-body', tengah(256, { y: 12 })));
    tampak(biasa, 'balonBiasa');
    if (aktif) on(biasa, [IF('balonMain', [...A.gameMulai, GO('game_mulai')])], NAIK);
    const ajak = kartuBalon(st, 112, (k) => {
      teksV(k, 'balon', 'tm-body', tengah(256, { y: 12 }));
      const b = tombol(k, 'secondary', 'Nasihati', 28, 46, { width: 200, height: 48 });
      if (aktif) on(b, A.nasihati, NAIK);
    });
    tampak(ajak, 'balonIseng');
    bind(node('rectangle', st, { w: 10, h: A.awal.tinggi, name: 'pengganjal', fill: 'none' }), 'height', 'tinggi');
  }
  taruhPet(R, 64 + (pose.dx ?? 0), KAKI - ALAS + (pose.dy ?? 0), pose);
  alat?.(R);
  inst(meterHidup('Kenyang'), f, 16, 534, null, { name: 'meter kenyang' }); inst(meterHidup('Senang'), f, 188, 534, null, { name: 'meter senang' });
  const bar = frame(f, { x: 16, y: 592, w: IN, h: 184, name: 'ActionBar', fill: $('surface'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside', radius: 24 });
  const btn = {};
  Object.keys(ACTIONS).forEach((id, i) => {
    const x = 12 + (i % 3) * 104, y = 12 + Math.floor(i / 3) * 84;
    // Tombol turun digambar di layar reaksi: changeTo saat mouseDown menelan klik di FigCraft.
    const turun = key === `r_${id}` || (id === 'bersihkan' && key === 'r_bersih');
    const buat = (st, v) => { const a = inst(action(id, st), bar, x, y + (turun ? 3 : 0), null, { name: st === 'istirahat' ? `${id} istirahat` : id}); return v ? tampak(a, v) : a; };
    btn[id] = id === 'lampu' ? [buat('biasa')] : key.startsWith('r_') ? [buat(turun ? 'ditekan' : 'biasa')] : [buat('biasa', 'siang'), buat('istirahat', 'tidur')];
    const t = { makan: 'tMakan', main: 'tMain', bersihkan: 'tBersih', obat: 'tObat', lampu: 'tLampu' }[id];
    if (t) tampak(dot(bar, x + 83, y - 7), t);
  });
  if (aktif) {
    ke(gear, 'pengaturan', { ...DORONG, pemicu: 'mouseUp' });
    for (const [id, l] of Object.entries(btn)) for (const a of l) on(a, A.aksi[id], NAIK);
  }
  return { f, R };
}
function screensLast() { for (let i = screens.length - 1; i >= 0; i--) if (screens[i].command === 'node.create') return screens[i].as; }
// Napas dan kedip = pergantian empat layar Beranda yang sama: di FigCraft 0.18 afterDelay pada varian
// hanya berjalan sekali, jadi komponen interaktif tidak bisa berulang. dur-breathe 2400 = 1200 + 1200, kedip 120 tiap sekitar 3 detik.
const FASE = [['beranda', {}, 700], ['beranda_b', { napas: true }, 1200], ['beranda_c', {}, 1200], ['beranda_d', { kedip: true }, 120]];
FASE.forEach(([key, pose], i) => beranda(key, i ? `Beranda · ${pose.kedip ? 'kedip' : pose.napas ? 'tarik napas' : 'lepas napas'} ${i + 1}` : 'Beranda', { aktif: true, pose }));
const setir = (key, dest, ms, o = {}) => on(frames[key].id, typeof dest === 'string' ? [GO(dest)] : dest, { ms, transition: 'smartAnimate', dur: 360, easing: 'easeOutBack', ...o });
const benda = (ic, color, x, y, s = 56) => (R) => { const c = chip(R, s, color, ic, Math.round(s * 0.56), { x, y }); cmd('node.set', { ids: [c], name: `alat ${ic}` }); };
FASE.forEach(([key, , ms], i) => setir(key, FASE[(i + 1) % FASE.length][0], ms, i >= 2 ? { transition: 'instant', dur: 0 } : { dur: 1200, easing: 'easeInOut' }));
const REAKSI = {
  r_makan: ['Makan', { dy: -36 }, benda('rice_bowl', 'meter-hunger', 240, 262)],
  r_camilan: ['Camilan', { dy: -18, rot: 0 }, benda('cookie', 'char-gembul', 32, 262)],
  r_main: ['Main', { dy: -52, dx: 14 }, benda('sports_soccer', 'meter-happy', 26, 300, 64)],
  r_bersih: ['Bersihkan', { dy: -12 }, (R) => { benda('cleaning_services', 'char-rapi', 244, 296)(R); kilau(R, 36, 316, 44); kilau(R, 84, 360, 28); kilau(R, 214, 366, 28); }],
  r_obat: ['Obat', { dy: -8 }, benda('medication', 'sick', 240, 262)],
  r_nasihat: ['Nasihati', { dy: -20 }, benda('favorite', 'meter-happy', 244, 244, 48)],
};
for (const [key, [nm, pose, alat]] of Object.entries(REAKSI)) { beranda(key, `Reaksi · ${nm}`, { pose, alat }); setir(key, A.selesaiReaksi, 1300); }
// dur-shake 420: tiga ayunan ±8°. Titik putar di tengah kotak pet.
[8, -8, 8].forEach((rot, i) => { beranda(`geleng${i + 1}`, `Ditolak · geleng ${i + 1}`, { pose: { rot } }); setir(`geleng${i + 1}`, i < 2 ? `geleng${i + 2}` : 'beranda', 200, { dur: 140, easing: 'easeInOut' }); });

// ---------- liburan ----------
barisBaru('Liburan');
{
  const f = layar('liburan', 'Liburan · Catatan');
  jam(f); inst(badgeHidup(), f, 16, 40);
  ke(inst(iconBtn('settings'), f, 296, 36), 'pengaturan', DORONG);
  const R = ruangPenuh(f, 104, 672); ruangIsi(R, 672, { hidup: false });
  const note = frame(R, { x: 18, y: 190, w: 292, h: 318, name: 'VacationNote' });
  const card = frame(note, { w: 292, h: 318, name: 'kartu', ...sticker, radius: 16, layout: 'vertical', gap: 8, padding: [32, 16, 20, 16], sizingH: 'fixed', sizingV: 'hug' });
  float(card);
  chip(card, 36, 'char-rapi', 'luggage', 20);
  text(card, 'Aku ke rumah nenek dulu', 'tm-title', { wrap: 'fill' });
  text(card, 'Jemput aku kalau kamu sudah siap, ya.', 'tm-body', { wrap: 'fill' });
  text(card, 'Pergi sejak dua hari lalu', 'tm-caption', { fill: 'ink-muted' });
  frame(card, { w: 10, h: 4, name: 'jarak' });
  on(tombol(card, 'primary', '=tJemput', 0, 0, { sizingH: 'fill' }, 'home'), A.jemput, { transition: 'dissolve', dur: 240 });
  node('rectangle', note, { x: 102, y: -12, w: 88, h: 24, name: 'selotip', fill: $('yolk'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside', cornerRadius: 4, rotation: -3 });
  cmd('node.set', { ids: [note], rotation: 1.5 });
}
beranda('pulang', 'Liburan · Pet berjalan masuk', { pose: { dx: 300 }, alat: () => {} });
setir('pulang', [IF('evolusi', [GO('evo0')], [GO('beranda')])], 300, { dur: 900, easing: 'easeOut' });

// ---------- evolusi ----------
barisBaru('Evolusi');
function evo(key, title) {
  const f = layar(key, title), R = ruangPenuh(f, 40, 736, 'EvolutionReveal');
  teksV(R, 'tTumbuh', 'tm-caption', tengah(264, { x: 32, y: 88, fill: 'ink-muted' }));
  node('ellipse', R, { x: 64, y: 358, w: 200, h: 44, name: 'panggung', fill: $('surface-raised'), stroke: $('outline'), strokeWeight: 2, strokeAlign: 'inside' });
  return R;
}
// evo0 menelan jeda hitung FigCraft, supaya kilau selalu terlihat utuh.
evo('evo0', 'Evolusi · Mulai'); setir('evo0', 'evo1', 1);
{ const R = evo('evo1', 'Evolusi · Kilau (0–30%)'); kilau(R, 134, 226, 60); kilau(R, 84, 190, 36); kilau(R, 210, 186, 44); kilau(R, 94, 290, 32); kilau(R, 206, 300, 28); setir('evo1', 'evo2', 900); }
{ const R = evo('evo2', 'Evolusi · Siluet (30–60%)'); bind(inst(siluet('seimbang'), R, 64, 208, null, { name: 'siluet' }), 'componentProperties/Bentuk', 'bentuk'); kilau(R, 48, 176, 44); kilau(R, 238, 226, 36); kilau(R, 56, 300, 28); setir('evo2', 'evo3', 700, { transition: 'dissolve', dur: 360, easing: 'easeOut' }); }
{
  const R = evo('evo3', 'Evolusi · Karakter (60–100%)');
  bind(inst(petKode('dewasa-seimbang', 'senang'), R, 64, 208, null, { name: 'pet' }), 'componentProperties/Tampil', 'tampilSenang');
  kilau(R, 26, 150, 44); kilau(R, 262, 170, 36); kilau(R, 24, 316, 28); kilau(R, 278, 306, 32);
  teksV(R, 'tJadi', 'tm-display', tengah(280, { x: 24, y: 432 })); teksV(R, 'charNama', 'tm-display', tengah(280, { x: 24, y: 470 }));
  teksV(R, 'charCiri', 'tm-body', tengah(296, { x: 16, y: 528 })); teksV(R, 'charAlasan', 'tm-body', tengah(296, { x: 16, y: 552 }));
  on(tombol(R, 'primary', '=tLihat', 32, 640), [S('evolusi', false), ...A.hitungUlang, GO('beranda')], HALUS);
}

// ---------- pengaturan, album ----------
barisBaru('Pengaturan dan album');
{
  const f = layar('pengaturan', 'Pengaturan');
  on(inst(iconBtn('arrow_back'), f, 16, 36), [IF('libur', [GO('liburan')], [GO('beranda')])], BALIK); text(f, 'Pengaturan', 'tm-title', { x: 80, y: 46 });
  const list = frame(f, { x: 16, y: 104, w: IN, h: 600, name: 'daftar', layout: 'vertical', gap: 16, sizingH: 'fixed', sizingV: 'hug' });
  const card = (name) => frame(list, { w: IN, h: 72, name, ...sticker, radius: 16, layout: 'vertical', gap: 8, padding: [12, 16, 12, 16], sizingH: 'fixed', sizingV: 'hug' });
  const isi = (p, t, style, o = {}) => (t.startsWith('=') ? teksV(p, t.slice(1), style, { wrap: 'fill', ...o }) : text(p, t, style, { wrap: 'fill', ...o }));
  const row = (p, ic, color, label, sub) => {
    const r = frame(p, { w: 296, h: 48, name: label, layout: 'horizontal', gap: 12, crossAlign: 'center', sizingH: 'fill', sizingV: 'hug', minHeight: 48 });
    chip(r, 36, color, ic, 20);
    const t = frame(r, { w: 100, h: 40, name: 'teks', layout: 'vertical', sizingH: 'fill', sizingV: 'hug' });
    isi(t, label, 'tm-label');
    if (sub) isi(t, sub, 'tm-caption', { fill: 'ink-muted' });
    return r;
  };
  const SHEET = { transition: 'moveIn', arah: 'top', dur: 240 };
  const cn = card('Nama pet'), nm = row(cn, 'pets', 'char-gembul', 'Nama pet', '=nama'); icon(nm, 'edit', 24, 'accent'); on(cn, [['buka', 'sheetNama']], SHEET);
  const cj = card('Jam tidur'); row(cj, 'bedtime', 'char-rapi', '=tJamTidur', '=tJamSub');
  const jr = frame(cj, { w: 296, h: 64, name: 'jam', layout: 'horizontal', gap: 8, sizingH: 'fill', sizingV: 'hug' });
  for (const [l, v] of [['Tidur', 'tMulai'], ['Bangun', 'tSelesai']]) { const b = frame(jr, { w: 140, h: 60, name: l, fill: $('surface'), radius: 8, layout: 'vertical', gap: 4, padding: 8, crossAlign: 'center', sizingH: 'fill', sizingV: 'hug' }); text(b, l, 'tm-caption', { fill: 'ink-muted' }); teksV(b, v, 'tm-numeral'); }
  on(tombol(cj, 'quiet', 'Ubah jam tidur', 0, 0, { sizingH: 'fill', height: 48 }), [...A.bukaJam, ['buka', 'sheetJam']], SHEET);
  const ct = card('Suara dan getar');
  for (const [ic, c, l, s, v] of [['volume_up', 'char-atletis', 'Suara', null, 'suara'], ['vibration', 'char-mandiri', 'Getar', null, 'getar'], ['notifications', 'yolk', 'Pengingat', '=tIngat', 'ingat']]) { const r = row(ct, ic, c, l, s); sakelarHidup(v)(r); on(r, A.sakelar(v)); }
  const ca = card('Album'), al = row(ca, 'collections_bookmark', 'char-atletis', '=tAlbum', '=tAlbumSub'); icon(al, 'chevron_right', 24, 'ink-muted'); ke(ca, 'album', DORONG);
  text(f, 'TamaFlutter bisa dimainkan tanpa internet.', 'tm-caption', tengah(IN, { x: 16, y: 760, fill: 'ink-muted' }));
}
{
  const f = layar('album', 'Album');
  kepala(f, '', 'pengaturan', 'tAlbum');
  ['telur', ...Object.keys(CHAR).sort((a) => (a === 'seimbang' ? -1 : 0))].forEach((c, i) => {
    const t = frame(f, { x: 16 + (i % 2) * 172, y: 112 + Math.floor(i / 2) * 208, w: 156, h: 192, name: c, ...sticker, radius: 16, clip: true });
    const top = frame(t, { x: 2, y: 2, w: 152, h: 136, name: 'ruang', fill: $('room'), cornerRadius: [14, 14, 0, 0] });
    const o = { width: 110, height: 110 };
    if (c === 'telur') { inst(telur(), top, 21, 14, null, o); text(t, 'Telur', 'tm-label', tengah(156, { y: 154 })); ke(t, 'd_telur', HALUS); return; }
    tampak(inst(petKode(`dewasa-${c}`, 'senang'), top, 21, 14, null, { ...o, name: 'pet' }), `dapat_${c}`); tampak(inst(siluet(c), top, 21, 14, null, { ...o, name: 'siluet' }), `belum_${c}`);
    teksV(t, `label_${c}`, 'tm-label', tengah(156, { y: 154 }));
    on(t, [IF(`dapat_${c}`, [GO(`d_${c}`)])], HALUS);
  });
  teksV(f, 'tRawat', 'tm-caption', tengah(IN, { x: 16, y: 756, fill: 'ink-muted' }));
}
for (const [c, [nm, ciri, alasan]] of Object.entries({ telur: ['Telur', 'Awal dari semuanya.', 'Semua teman lahir dari sini.'], ...CHAR })) {
  const f = layar(`d_${c}`, `Album · ${nm}`);
  kepala(f, nm, 'album');
  const R = ruangPenuh(f, 104, 400);
  node('ellipse', R, { x: 54, y: 300, w: 220, h: 52, name: 'karpet', fill: $('surface-raised'), stroke: $('outline'), strokeWeight: 2, strokeAlign: 'inside' });
  inst(c === 'telur' ? telur() : petKode(`dewasa-${c}`, 'senang'), R, 64, 148, null, { name: 'pet' }); kilau(R, 40, 96, 40); kilau(R, 250, 120, 32);
  text(f, nm, 'tm-display', tengah(IN, { x: 16, y: 540 }));
  text(f, `${ciri}\n${alasan}`, 'tm-body', tengah(IN, { x: 16, y: 588 }));
}

// ---------- mini game ----------
barisBaru('Mini game tebak arah');
function arena(key, title, { pet = 'tampilSenang', dx = 0, rot } = {}) {
  const f = layar(key, title);
  text(f, 'Tebak arah', 'tm-title', { x: 80, y: 46 });
  ke(inst(iconBtn('close'), f, 16, 36), 'beranda', BALIK);
  const R = ruangPenuh(f, 104, 414);
  node('rectangle', R, { x: 2, y: FY, w: IN - 4, h: TR - FY - 2, name: 'lantai', fill: $('surface'), cornerRadius: [0, 0, 22, 22] });
  node('ellipse', R, { x: 54, y: FY + 14, w: 220, h: 52, name: 'karpet', fill: $('surface-raised'), stroke: $('outline'), strokeWeight: 2, strokeAlign: 'inside' });
  bind(inst(petKode('bayi-seimbang', 'senang'), R, 64 + dx, KAKI - ALAS, null, { name: 'pet', ...(rot ? { rotation: rot } : {}) }), 'componentProperties/Tampil', pet);
  return { f, R };
}
const bintang = (R) => { for (let i = 0; i < 3; i++) { icon(R, 'star', 36, 'outline', { x: 98 + i * 48, y: 64, name: `bintang kosong ${i + 1}` }); tampak(icon(R, 'star', 36, 'char-gembul', { x: 98 + i * 48, y: 64, name: `bintang ${i + 1}` }), `bintang${i + 1}`); } };
{
  const { f, R } = arena('game_mulai', 'Mini game · Mulai');
  teksV(R, 'tTebak', 'tm-title', tengah(296, { x: 16, y: 40 }));
  text(f, 'Tebak tiga kali.\nDua tebakan tepat, kamu menang.', 'tm-body', tengah(IN, { x: 16, y: 548 }));
  ke(tombol(f, 'primary', 'Ayo main', 48, 640), 'game_tebak', HALUS);
}
{
  const { f, R } = arena('game_tebak', 'Mini game · Tebak', { pet: 'tampilBiasa' });
  teksV(R, 'tRonde', 'tm-label', tengah(IN, { y: 28 })); bintang(R);
  text(f, 'Kiri atau kanan?', 'tm-title', tengah(IN, { x: 16, y: 548 }));
  for (const [i, [arah, ic]] of [['kiri', 'arrow_back'], ['kanan', 'arrow_forward']].entries()) on(tombol(f, 'primary', arah[0].toUpperCase() + arah.slice(1), 16 + i * 172, 616, { width: 156, height: 72, name: arah }, ic), A.tebak(arah), HALUS);
}
for (const [arah, s] of [['kiri', -1], ['kanan', 1]]) {
  const { f, R } = arena(`game_${arah}`, `Mini game · Menoleh ke ${arah}`, { dx: s * 56, rot: -s * 8 });
  teksV(R, 'tRonde', 'tm-label', tengah(IN, { y: 28 })); bintang(R);
  chip(R, 48, 'yolk', s < 0 ? 'arrow_back' : 'arrow_forward', 26, { x: s < 0 ? 24 : 256, y: 168 });
  teksV(f, 'tHasil', 'tm-display', tengah(IN, { x: 16, y: 560 }));
  setir(`game_${arah}`, A.lanjutGame, 1100);
}
{
  const { f, R } = arena('game_akhir', 'Mini game · Hasil', { pet: 'tampilGame' });
  bintang(R);
  teksV(f, 'tAkhir', 'tm-display', tengah(IN, { x: 16, y: 540 })); teksV(f, 'tAkhirSub', 'tm-body', tengah(IN, { x: 16, y: 584 }));
  on(tombol(f, 'primary', 'Main lagi', 48, 640), [...A.gameMulai, GO('game_tebak')], HALUS);
  ke(tombol(f, 'quiet', 'Selesai', 48, 712), 'beranda', HALUS);
}

// ---------- pengingat ----------
barisBaru('Pengingat dan mode demo');
{
  const f = layar('kunci', 'Pengingat · Layar kunci', { fill: 'room' });
  teksV(f, 'tJam', { ...AGE_TYPE, fontSize: 48, lineHeight: 56 }, tengah(IN, { x: 16, y: 120 }));
  text(f, 'Selasa', 'tm-body', tengah(IN, { x: 16, y: 180, fill: 'ink-muted' }));
  const n = frame(f, { x: 16, y: 260, w: IN, h: 96, name: 'pengingat', ...sticker, radius: 16 });
  float(n); chip(n, 48, 'char-gembul', 'pets', 26, { x: 16, y: 24 });
  text(n, 'TamaFlutter', 'tm-caption', { x: 80, y: 12, fill: 'ink-muted' }); teksV(n, 'tKangen', 'tm-label', { x: 80, y: 34 }); text(n, 'Mampir sebentar, yuk?', 'tm-caption', { x: 80, y: 60 });
  tampak(n, 'notifAda'); ke(n, 'beranda', HALUS);
  tampak(text(f, 'Tidak ada pengingat sekarang.', 'tm-body', tengah(IN, { x: 16, y: 290, fill: 'ink-muted' })), 'notifKosong');
  ke(tombol(f, 'secondary', 'Buka TamaFlutter', 48, 680), 'beranda', HALUS);
}
// Sheet (overlay)
const sheet = (key, title, h) => { const f = layar(key, title, { h, sheet: true, fill: 'surface-raised' }); cmd('node.set', { ids: [f], stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside' }); return f; };
{
  const f = sheet('demo', 'Mode demo', 440);
  text(f, 'Mode demo', 'tm-title', { x: 20, y: 20 }); text(f, 'Bukan bagian aplikasi.', 'tm-caption', { x: 20, y: 48, fill: 'ink-muted' });
  Object.values(A.demo).forEach(([label, l], i) => on(tombol(f, i === 9 ? 'quiet' : 'secondary', label, 16 + (i % 2) * 168, 88 + Math.floor(i / 2) * 66, { width: 160, height: 52 }), l));
}
{
  const f = sheet('sheetJam', 'Pengaturan · Ubah jam tidur', 452);
  teksV(f, 'tJamTidur', 'tm-title', tengah(IN, { x: 16, y: 28 }));
  for (const [i, [l, v, j, min, max]] of [['Tidur', 'tMulai', 'jamTidur', 18, 23], ['Bangun', 'tSelesai', 'jamBangun', 5, 9]].entries()) {
    const c = frame(f, { x: 16 + i * 168, y: 82, w: 160, h: 212, name: l, fill: $('surface'), stroke: $('outline'), strokeWeight: 2, strokeAlign: 'inside', radius: 16 });
    text(c, l, 'tm-label', tengah(160, { y: 14 }));
    on(inst(iconBtn('keyboard_arrow_up'), c, 56, 42), A.ubahJam(j, 1, min, max)); teksV(c, v, 'tm-numeral', tengah(160, { y: 108 })); on(inst(iconBtn('keyboard_arrow_down'), c, 56, 146), A.ubahJam(j, -1, min, max));
  }
  on(tombol(f, 'primary', 'Simpan', 16, 310, { width: IN }), [...A.setelahJam, ['tutup']]);
  on(tombol(f, 'quiet', 'Nanti saja', 16, 378, { width: IN, height: 48 }), [...A.batalJam, ['tutup']]);
}
{
  const f = sheet('sheetNama', 'Pengaturan · Ganti nama', 464);
  text(f, 'Siapa namaku?', 'tm-title', tengah(IN, { x: 16, y: 28 }));
  pilihNama(f, 72);
  on(tombol(f, 'primary', 'Selesai', 16, 388, { width: IN }), [['tutup']]);
}

// ---------- tulis interaksi ----------
const tujuan = (k) => { if (!frames[k]) throw new Error(`layar ${k} tidak ada`); return frames[k].id; };
const kompilasi = (ls) => ls.map(([op, ...x]) => {
  // Menulis variabel membuat FigCraft menghitung ulang dokumen (puluhan ms), jadi tulis hanya bila nilainya berubah.
  if (op === 'set') return { type: 'conditional', blocks: [{ expression: `${x[0]} != (${x[1]})`, actions: [{ type: 'setVariable', variable: x[0], expression: x[1] }] }] };
  if (op === 'go') return { type: 'navigate', dest: tujuan(x[0]) };
  if (op === 'mode') return { type: 'conditional', blocks: [{ expression: `mode(Warna) != "${x[0]}"`, actions: [{ type: 'setVariableMode', collection: 'Warna', mode: x[0] }] }] };
  if (op === 'tutup') return { type: 'closeOverlay' };
  if (op === 'buka') return { type: 'openOverlay', dest: tujuan(x[0]), position: 'bottomCenter', close_on_outside: x[0] === 'demo', background: '#1f234073' };
  if (op === 'if') { const blocks = []; for (let i = 0; i < x.length; i += 2) blocks.push(i + 1 === x.length ? { actions: kompilasi(x[i]) } : { expression: x[i], actions: kompilasi(x[i + 1]) }); return { type: 'conditional', blocks }; }
  throw new Error(op);
});
const graf = {};
for (const [id, ls, o] of antre) {
  const p = { id, trigger: o.ms ? { type: 'afterDelay', ms: o.ms } : { type: o.pemicu ?? 'onClick' }, actions: kompilasi(ls) };
  if (o.transition) Object.assign(p, { transition: { type: o.transition, ...(o.arah ? { direction: o.arah } : {}) }, durationMs: o.dur ?? 240 }, o.easing ? { easing: o.easing } : {});
  cmd('proto.interaction.add', p);
}
cmd('proto.flow.add', { start: frames.splash.id, name: 'Aplikasi' });
cmd('proto.flow.add', { start: frames.beranda.id, name: 'Langsung ke Beranda' });

// Pemeriksa: setiap layar terjangkau dari Splash dan punya jalan keluar.
{
  const induk = {}; for (const c of screens) if (c.as && c.params.parent?.$ref) induk[c.as] = c.params.parent.$ref;
  const akar = (as) => (induk[as] ? akar(induk[as]) : as);
  const punya = Object.fromEntries(Object.entries(frames).map(([k, v]) => [v.id.$ref, k]));
  const tj = (ls) => ls.flatMap(([op, ...x]) => (op === 'go' || op === 'buka' ? [x[0]] : op === 'if' ? x.filter(Array.isArray).flatMap(tj) : []));
  const tutup = (ls) => ls.some(([op, ...x]) => op === 'tutup' || (op === 'if' && x.filter(Array.isArray).some(tutup)));
  for (const [id, ls] of antre) { const k = punya[akar(id.$ref)]; (graf[k] ??= { ke: new Set(), tutup: false }); tj(ls).forEach((d) => graf[k].ke.add(d)); graf[k].tutup ||= tutup(ls); }
  const lihat = new Set(['splash']), q = ['splash'];
  while (q.length) for (const d of graf[q.pop()]?.ke ?? []) if (!lihat.has(d)) { lihat.add(d); q.push(d); }
  const takTerjangkau = Object.keys(frames).filter((k) => !lihat.has(k)), buntu = Object.keys(frames).filter((k) => !graf[k] || (!graf[k].ke.size && !graf[k].tutup));
  if (takTerjangkau.length || buntu.length) throw new Error(`tak terjangkau: ${takTerjangkau}; buntu: ${buntu}`);
}

// ---------- susun komponen ----------
pakai(comps);
let sy = 0;
const gabung = [];
for (const [set, s] of Object.entries(shelf)) {
  const kolomMaks = 24, tinggi = Math.max(...s.items.map(([, h]) => h)), lebar = 240;
  if (s.items.length > kolomMaks) s.items.forEach(([as], i) => cmd('node.set', { ids: [ref(as)], x: 420 + (i % kolomMaks) * lebar, y: sy + Math.floor(i / kolomMaks) * (tinggi + 32) }));
  else cmd('node.set', { ids: s.items.map(([as]) => ref(as)), y: sy });
  sy += Math.ceil(s.items.length / kolomMaks) * (tinggi + 32) + 64;
  gabung.push([set, s.items.map(([as]) => ref(as))]);
}
cmd('page.select', { id: compPage });
for (const [set, ids] of gabung) {
  if (ids.length < 2) { cmd('node.set', { ids, name: set }); continue; }
  const r = cmd('component.combineVariants', { ids }, `set_${set}`);
  cmd('node.set', { ids: [r], name: set });
}
pakai(screens);
for (const [id, field, variable] of ikatVarian) cmd('variable.bind', { ids: [id], field, variable });
cmd('page.select', { id: 1 });
const slug = (t) => t.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/-$/, '');
const ekspor = pngDir ? Object.entries(frames).filter(([k]) => !/^(beranda_|evo0)/.test(k)).map(([, { id, title }], i) => ({ command: 'file.export', params: { ids: [id], format: 'png', scale: 2, path: path.join(pngDir, `${String(i + 1).padStart(2, '0')}-${slug(title)}.png`) } })) : [];
fs.writeFileSync(outJson, JSON.stringify([...setup, ...comps, ...screens, ...ekspor]));
fs.writeFileSync(outJson.replace('.json', '.frames.json'), JSON.stringify(Object.fromEntries(Object.entries(frames).map(([k, v]) => [k, v.title]))));
console.log({ perintah: setup.length + comps.length + screens.length, layar: Object.keys(frames).length, komponen: registry.size, interaksi: antre.length });
