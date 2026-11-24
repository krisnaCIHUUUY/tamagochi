// Dasar berkas FigCraft TamaFlutter: token, gaya teks, pet, dan komponen UI. Dipakai prototipe.mjs.
import fs from 'node:fs';
import path from 'node:path';
const [root, iconDir, outJson, pngDir] = process.argv.slice(2);
const tokens = JSON.parse(fs.readFileSync(path.join(root, 'design/TamaFlutter-design-system/tokens.json'), 'utf8'));

const setup = [], comps = [], screens = [], links = [];
let buf = setup, seq = 0;
const ref = (as) => ({ $ref: as });
function cmd(command, params, as) { const step = { command, params }; if (as) step.as = as; buf.push(step); return as ? ref(as) : null; }
const $ = (name) => ({ $var: name });

// ---------- font, token, gaya teks ----------
for (const f of ['Fredoka-SemiBold', 'Lexend-Regular', 'Lexend-SemiBold']) cmd('text.loadFont', { path: path.join(root, `assets/fonts/${f}.ttf`) });
cmd('page.rename', { id: 1, name: 'Layar' });
const compPage = cmd('page.add', { name: 'Komponen' }, 'compPage');
const col = cmd('variable.createCollection', { name: 'Warna', modes: ['Siang', 'Malam'] }, 'colWarna');
const val = (v) => (typeof v === 'string' ? { siang: v, malam: v } : v);
for (const t of tokens.color.tokens) {
  const v = val(t.value);
  const alias = (s) => (s.startsWith('{') ? { alias: s.slice(1, -1) } : s);
  cmd('variable.create', { collection: col, name: t.name, type: 'color', values: { Siang: alias(v.siang), Malam: alias(v.malam) }, description: t.usage });
}
cmd('variable.create', { collection: col, name: 'shadow-lip', type: 'color', values: { Siang: '#1f2340', Malam: '#070914' } });
cmd('variable.create', { collection: col, name: 'shadow-float', type: 'color', values: { Siang: '#1f234024', Malam: '#00000080' } });
const dim = cmd('variable.createCollection', { name: 'Ukuran', modes: ['Nilai'] }, 'colDim');
const radii = {};
for (const g of ['spacing', 'radius', 'size', 'border']) for (const t of tokens[g].tokens) {
  const n = parseFloat(t.value);
  cmd('variable.create', { collection: dim, name: t.name, type: 'number', value: n, description: t.usage });
  if (g === 'radius') radii[n] = t.name;
}
const TYPE = {};
for (const g of tokens.type.groups) for (const s of g.styles) TYPE[s.name] = {
  fontFamily: g.family === 'display' ? 'Fredoka' : 'Lexend',
  fontStyle: s.fontWeight === 600 ? 'SemiBold' : 'Regular',
  fontSize: parseFloat(s.fontSize), lineHeight: parseFloat(s.lineHeight),
};
// Ukuran khusus dari README komponen Button dan StageBadge.
const BUTTON_TYPE = { fontFamily: 'Lexend', fontStyle: 'SemiBold', fontSize: 17, lineHeight: 20 };
const AGE_TYPE = { fontFamily: 'Fredoka', fontStyle: 'SemiBold', fontSize: 16, lineHeight: 20 };

buf = comps;
cmd('page.select', { id: compPage });
{
  let y = 0;
  for (const [name, t] of Object.entries(TYPE)) {
    const as = `sample_${name}`;
    cmd('node.create', { type: 'text', text: name, x: 0, y, props: { ...t, fill: $('ink') } }, as);
    cmd('style.create', { type: 'text', name, from: ref(as) });
    y += t.lineHeight + 16;
  }
}

// ---------- pembantu ----------
function node(type, parent, p = {}) {
  const { x = 0, y = 0, w, h, name, path: d, text, radius, closed, ...props } = p;
  const as = `n${++seq}`;
  const params = { type, x, y, select: false, props };
  if (parent) params.parent = parent;
  if (w !== undefined) params.width = w;
  if (h !== undefined) params.height = h;
  if (name) params.name = name;
  if (d) { params.path = d; if (closed !== undefined) params.closed = closed; }
  if (text !== undefined) params.text = text;
  if (radius !== undefined) props.cornerRadius = radius;
  cmd('node.create', params, as);
  if (radius !== undefined && radii[radius]) cmd('variable.bind', { ids: [ref(as)], field: 'cornerRadius', variable: radii[radius] });
  return ref(as);
}
const frame = (parent, p) => node('frame', parent, { fill: 'none', clip: false, ...p });
function text(parent, s, style, p = {}) {
  const { wrap, fill = 'ink', ...rest } = p;
  const t = typeof style === 'string' ? TYPE[style] : style;
  const id = node('text', parent, { text: s, name: rest.name ?? s, ...t, fill: $(fill), ...rest });
  if (typeof style === 'string') cmd('style.apply', { ids: [id], style });
  if (wrap === 'fill') cmd('node.set', { ids: [id], textAutoResize: 'height', sizingH: 'fill' });
  return id;
}
function scalePath(d, k) { // menskalakan path SVG, termasuk flag busur yang menempel
  let cmdc = '', out = '', i = 0, arg = 0;
  const num = /[+-]?(?:\d+\.?\d*|\.\d+)(?:e[+-]?\d+)?/y;
  while (i < d.length) {
    const ch = d[i];
    if (/[a-zA-Z]/.test(ch)) { cmdc = ch; arg = 0; out += ch; i++; continue; }
    if (/[\s,]/.test(ch)) { i++; continue; }
    const isArc = cmdc === 'a' || cmdc === 'A', p = arg % 7;
    if (isArc && (p === 3 || p === 4)) { out += ` ${ch}`; i++; arg++; continue; }
    num.lastIndex = i;
    const m = num.exec(d);
    if (!m) throw new Error(`path: ${d.slice(i)}`);
    out += ` ${isArc && p === 2 ? m[0] : +(parseFloat(m[0]) * k).toFixed(4)}`;
    i = num.lastIndex; arg++;
  }
  return out;
}
console.assert(scalePath('M1 2a.5.5 0 01-.5 1z', 2) === 'M 2 4a 1 1 0 0 1 -1 2z', scalePath('M1 2a.5.5 0 01-.5 1z', 2));
function iconPath(name) {
  const svg = fs.readFileSync(path.join(iconDir, `${name}.svg`), 'utf8');
  const ds = [...svg.matchAll(/<path([^>]*)\/?>/g)].filter(([, a]) => !a.includes('fill="none"')).map(([, a]) => a.match(/\sd="([^"]+)"/)[1]);
  for (const [, cx, cy, r] of svg.matchAll(/<circle cx="([\d.]+)" cy="([\d.]+)" r="([\d.]+)"/g)) ds.push(`M${cx - r} ${cy}a${r} ${r} 0 1 0 ${2 * r} 0a${r} ${r} 0 1 0 ${-2 * r} 0Z`);
  return ds.join(' ');
}
function icon(parent, name, size, fill = 'ink', p = {}) {
  const f = frame(parent, { w: size, h: size, name: `icon/${name}`, ...p });
  node('vector', f, { path: scalePath(iconPath(name), size / 24), name, fill: $(fill), stroke: 'none' });
  return f;
}
const lip = (id, dy = 4) => { cmd('node.set', { ids: [id], effects: [{ type: 'dropShadow', color: '#1f2340', offset: [0, dy], radius: 0 }] }); cmd('variable.bind', { ids: [id], field: 'effects/0/color', variable: 'shadow-lip' }); };
const float = (id) => { cmd('node.set', { ids: [id], effects: [{ type: 'dropShadow', color: '#1f234024', offset: [0, 8], radius: 24 }] }); cmd('variable.bind', { ids: [id], field: 'effects/0/color', variable: 'shadow-float' }); };
const sticker = { fill: $('surface-raised'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside' };

// Komponen dibuat sekali di halaman Komponen saat pertama dipakai.
const registry = new Map(), shelf = {};
function comp(set, variant, w, h, build, opts = {}) {
  const key = `${set}|${variant}`;
  if (!registry.has(key)) {
    const prev = buf; buf = comps;
    const s = (shelf[set] ??= { row: Object.keys(shelf).length, x: 420 });
    const as = `c${++seq}`;
    cmd('node.create', { type: 'component', name: variant, x: s.x, y: 0, width: w, height: h, select: false, props: { fill: 'none', clip: false, ...opts } }, as);
    s.x += w + 32; (s.items ??= []).push([as, h]);
    const extra = build(ref(as)) ?? {};
    registry.set(key, { id: ref(as), ...extra });
    buf = prev;
  }
  return registry.get(key);
}
function inst(c, parent, x = 0, y = 0, props, set = {}) {
  const as = `i${++seq}`;
  cmd('instance.create', { component: c.id, x, y, parent }, as);
  if (props) cmd('instance.setProperties', { ids: [ref(as)], properties: props });
  if (Object.keys(set).length) cmd('node.set', { ids: [ref(as)], ...set });
  return ref(as);
}
const labelProp = (c, t, name) => cmd('component.addProperty', { id: c, name, type: 'text', layer: t });

// ---------- Pet ----------
const SHAPES = {
  seimbang: { b: [22, 28, 76, 68, 34], c: 'char-seimbang' }, atletis: { b: [32, 14, 56, 82, 28], c: 'char-atletis' },
  gembul: { b: [12, 38, 96, 58, 29], c: 'char-gembul' }, rapi: { b: [24, 30, 72, 66, 26], c: 'char-rapi' }, mandiri: { b: [24, 26, 72, 70, 33], c: 'char-mandiri' },
};
const petTop = (shape) => (shape === 'telur' ? 20 : shape === 'mandiri' || shape === 'rapi' ? 12 : SHAPES[shape].b[1]);
// kedip: mata tertutup sebentar; hanya mood bermata terbuka yang punya.
function drawPet(root, shape, mood, size, kedip = false) {
    const k = size / 120, sc = (d) => d.replace(/-?\d*\.?\d+/g, (n) => +(n * k).toFixed(3));
    const ink = { stroke: $('pet-ink'), strokeWeight: 3 * k, strokeAlign: 'center' };
    const sil = mood === 'siluet', col = (c) => $(sil ? 'pet-ink' : c);
    const ell = (cx, cy, rx, ry, p) => node('ellipse', root, { x: (cx - rx) * k, y: (cy - ry) * k, w: 2 * rx * k, h: 2 * ry * k, stroke: 'none', ...p });
    const line = (d, p = {}) => node('vector', root, { path: sc(d), fill: 'none', ...ink, strokeCap: 'round', strokeJoin: 'round', ...p });
    const box = (x, y, w, h, r, p) => node('rectangle', root, { x: x * k, y: y * k, w: w * k, h: h * k, cornerRadius: r * k, ...ink, ...p });
    if (shape === 'telur') {
      ell(60, 64, 34, 44, { name: 'cangkang', fill: col('pet-egg'), ...ink });
      if (!sil) { ell(46, 52, 7, 7, { fill: $('yolk') }); ell(72, 80, 9, 9, { fill: $('yolk') }); ell(74, 44, 4, 4, { fill: $('yolk') }); line('M34 66 L44 60 L52 68 L60 60 L68 68 L76 60 L86 66', { name: 'retakan', strokeWeight: 2.5 * k }); }
      return;
    }
    const { b: [x, y, w, h, r], c } = SHAPES[shape];
    ell(60 - w * 0.22, 98, 10, 6, { name: 'kaki', fill: col(c), ...ink }); ell(60 + w * 0.22, 98, 10, 6, { name: 'kaki', fill: col(c), ...ink });
    if (shape === 'mandiri') { line('M74 30 Q82 12 94 18', { name: 'antena' }); ell(95, 17, 5, 5, { name: 'ujung antena', fill: col(c), ...ink }); }
    if (shape === 'rapi') node('vector', root, { name: 'daun', path: sc('M60 32 Q50 14 60 12 Q70 14 60 32Z'), fill: col('char-atletis'), ...ink, strokeWeight: 2.5 * k, strokeJoin: 'round' });
    box(x, y, w, h, r, { name: 'tubuh', fill: col(c) });
    if (sil) return;
    if (shape === 'atletis') box(30, 30, 60, 9, 4, { name: 'ikat kepala', fill: $('meter-happy'), strokeWeight: 2.5 * k });
    if (shape === 'gembul') ell(60, 80, 22, 11, { name: 'perut', fill: $('pet-egg'), opacity: 0.85 });
    const ey = y + h * 0.44, ex = Math.min(15, w * 0.2), L = 60 - ex, R = 60 + ex;
    if (mood !== 'murung') for (const cx of [L - 9, R + 9]) ell(cx, ey + 10, 6, 3.5, { name: 'pipi', fill: $(mood === 'sakit' ? 'sick' : 'pet-cheek'), opacity: 0.9 });
    const eyes = (dy = 0) => { for (const cx of [L, R]) { if (kedip) { line(`M${cx - 4} ${ey + dy} L${cx + 4} ${ey + dy}`, { name: 'mata' }); continue; } ell(cx, ey + dy, 4, 5.5, { name: 'mata', fill: $('pet-ink') }); ell(cx + 1.5, ey + dy - 2, 1.5, 1.5, { name: 'kilau', fill: $('pet-highlight') }); } };
    const face = {
      senang() { for (const cx of [L, R]) line(`M${cx - 4} ${ey + 1} Q${cx} ${ey - 6} ${cx + 4} ${ey + 1}`, { name: 'mata' }); node('vector', root, { name: 'mulut', path: sc(`M52 ${ey + 12} Q60 ${ey + 25} 68 ${ey + 12}Z`), fill: $('pet-ink'), ...ink, strokeWeight: 2 * k, strokeJoin: 'round' }); },
      biasa() { eyes(); line(`M55 ${ey + 15} Q60 ${ey + 19} 65 ${ey + 15}`, { name: 'mulut' }); },
      lapar() { eyes(-1); line(`M${L - 5} ${ey - 8} L${L + 4} ${ey - 12}`, { name: 'alis' }); line(`M${R + 5} ${ey - 8} L${R - 4} ${ey - 12}`, { name: 'alis' }); ell(60, ey + 16, 4, 5, { name: 'mulut', fill: $('pet-ink') }); },
      sakit() { for (const cx of [L, R]) line(`M${cx - 5} ${ey} L${cx + 5} ${ey}`, { name: 'mata' }); line(`M50 ${ey + 16} q2.5 -4 5 0 q2.5 4 5 0 q2.5 -4 5 0 q2.5 4 5 0`, { name: 'mulut' }); node('vector', root, { name: 'keringat', path: sc('M90 36 q5 7 0 10 q-5 -3 0 -10Z'), fill: $('char-rapi'), ...ink, strokeWeight: 2 * k }); },
      tidur() { for (const cx of [L, R]) line(`M${cx - 5} ${ey - 1} Q${cx} ${ey + 5} ${cx + 5} ${ey - 1}`, { name: 'mata' }); ell(60, ey + 16, 2.5, 3, { name: 'mulut', fill: $('pet-ink') }); for (const [zx, zy, zs] of [[96, 18, 15], [107, 8, 11]]) text(root, 'z', { fontFamily: 'Fredoka', fontStyle: 'SemiBold', fontSize: Math.max(14, zs * k) }, { x: zx * k, y: zy * k, fill: 'ink-muted' }); },
      murung() { eyes(1); line(`M${L - 6} ${ey - 7} L${L + 4} ${ey - 10}`, { name: 'alis' }); line(`M${R + 6} ${ey - 7} L${R - 4} ${ey - 10}`, { name: 'alis' }); line(`M53 ${ey + 19} Q60 ${ey + 12} 67 ${ey + 19}`, { name: 'mulut' }); node('vector', root, { name: 'air mata', path: sc(`M44 ${ey + 7} q3 5 0 8 q-3 -3 0 -8Z`), fill: $('char-rapi'), ...ink, strokeWeight: 1.5 * k }); },
    };
    face[mood]();
}

// ---------- komponen UI ----------
const chip = (parent, size, color, ic, isz, p = {}) => {
  const plain = color === 'surface-raised';
  const f = frame(parent, { w: size, h: size, radius: 9999, name: 'chip', fill: $(color), stroke: $(plain ? 'stroke' : 'pet-ink'), strokeWeight: 2, strokeAlign: 'inside', layout: 'horizontal', mainAlign: 'center', crossAlign: 'center', sizingH: 'fixed', sizingV: 'fixed', ...p });
  icon(f, ic, isz, p.ink ?? (plain ? 'ink-muted' : 'pet-ink'));
  return f;
};
const dot = (parent, x, y, abs) => { const d = frame(parent, { x, y, w: 20, h: 20, name: 'attention', radius: 9999, fill: $('attention'), ...(abs ? { absolute: true } : {}) }); node('ellipse', d, { x: 2, y: 2, w: 16, h: 16, fill: $('attention'), stroke: $('surface-raised'), strokeWeight: 2, strokeAlign: 'inside' }); return d; };
const ACTIONS = { makan: ['Makan', 'restaurant', 'meter-hunger'], camilan: ['Camilan', 'cookie', 'char-gembul'], main: ['Main', 'sports_soccer', 'meter-happy'], bersihkan: ['Bersihkan', 'cleaning_services', 'char-rapi'], obat: ['Obat', 'medication', 'sick'], lampu: ['Lampu', 'lightbulb', 'yolk'] };
const action = (id, state) => comp('ActionButton', `Aksi=${ACTIONS[id][0]}, Keadaan=${state}`, 96, 72, (root) => {
  const [label, ic, color] = ACTIONS[id], rest = state === 'istirahat';
  const face = frame(root, { w: 96, h: 72, name: 'muka', ...sticker, radius: 16, layout: 'vertical', gap: 4, mainAlign: 'center', crossAlign: 'center', sizingH: 'fixed', sizingV: 'fixed', ...(rest ? { dashes: [5, 4] } : {}) });
  if (!rest) lip(face, state.startsWith('ditekan') ? 1 : 4);
  chip(face, 32, rest ? 'surface-raised' : color, ic, 18);
  text(face, label, 'tm-label', { fill: rest ? 'ink-muted' : 'ink' });
  if (state.includes('dibutuhkan')) dot(root, 83, -7);
});

const PIP = (108 - 16) / 5;
const meter = (kind, value, { sleeping = false, needed = false } = {}) => comp('StatusMeter', `Jenis=${kind}, Nilai=${value}, Keadaan=${sleeping ? 'tidur' : needed ? 'rendah' : 'biasa'}`, 156, 42, (root) => {
  const [ic, color] = kind === 'Kenyang' ? ['rice_bowl', 'meter-hunger'] : ['favorite', 'meter-happy'];
  chip(root, 36, color, ic, 20, { y: 3 });
  if (needed) dot(root, 23, -4);
  text(root, kind, 'tm-label', { x: 48, y: 0 });
  if (sleeping) icon(root, 'bedtime', 18, 'ink-muted', { x: 122, y: 1 });
  for (let i = 0; i < 5; i++) {
    const pct = Math.max(0, Math.min(1, (value - i * 20) / 20));
    const f = frame(root, { x: 48 + i * (PIP + 4), y: 26, w: PIP, h: 16, name: `pip ${i + 1}`, radius: 8, fill: $('meter-track'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside' });
    if (pct > 0) node('rectangle', f, { x: 2, y: 2, w: (PIP - 4) * pct, h: 12, fill: $(color), cornerRadius: pct === 1 ? 6 : [Math.min(6, (PIP - 4) * pct), 0, 0, Math.min(6, (PIP - 4) * pct)] });
  }
});
const badge = (ic, color, stage, age) => comp('StageBadge', `Keadaan=${stage}, Keterangan=${age}`, 240, 40, (root) => {
  chip(root, 28, color, ic, 16);
  text(root, stage, 'tm-label'); text(root, '·', 'tm-label', { fill: 'ink-muted' }); text(root, age, AGE_TYPE);
}, { ...sticker, cornerRadius: 20, layout: 'horizontal', gap: 8, padding: [2, 14, 2, 6], crossAlign: 'center', sizingH: 'hug', sizingV: 'fixed' });
const iconBtn = (ic) => comp('IconButton', `Ikon=${ic}`, 48, 48, (root) => { lip(root); icon(root, ic, 24); }, { ...sticker, cornerRadius: 24, layout: 'horizontal', mainAlign: 'center', crossAlign: 'center', sizingH: 'fixed', sizingV: 'fixed' });
const button = (variant, ic) => comp('Button', `Varian=${variant}, Ikon=${ic ?? 'tanpa'}`, 264, 56, (root) => {
  if (variant !== 'quiet') lip(root);
  const color = { primary: 'on-yolk', secondary: 'ink', quiet: 'accent' }[variant];
  if (ic) icon(root, ic, 22, color);
  labelProp(root, text(root, 'Label', BUTTON_TYPE, { fill: color }), 'Label');
}, { cornerRadius: 28, layout: 'horizontal', gap: 8, padding: [0, 24, 0, 24], mainAlign: 'center', crossAlign: 'center', sizingH: 'fixed', sizingV: 'fixed', ...(variant === 'quiet' ? {} : { ...sticker, fill: $(variant === 'primary' ? 'yolk' : 'surface-raised') }) });
const toggle = (on) => comp('Switch', `Nyala=${on ? 'ya' : 'tidak'}`, 56, 32, (root) => { node('ellipse', root, { x: on ? 28 : 4, y: 4, w: 24, h: 24, fill: $(on ? 'on-accent' : 'stroke') }); }, { cornerRadius: 16, fill: $(on ? 'accent' : 'meter-track'), stroke: $('stroke'), strokeWeight: 2, strokeAlign: 'inside' });
const poop = () => comp('Kotoran', 'Kotoran', 44, 40, (root) => {
  for (const [x, y, w, h] of [[2, 24, 40, 14], [8, 13, 28, 14], [14, 2, 16, 14]]) node('rectangle', root, { x, y, w, h, cornerRadius: 7, fill: $('char-gembul'), stroke: $('pet-ink'), strokeWeight: 3, strokeAlign: 'center' });
});

const W = 360, IN = 328, H = 800;
const pakai = (b) => { const lama = buf; buf = b; return lama; };
export { fs, path, root, outJson, pngDir, setup, comps, screens, ref, cmd, $, TYPE, AGE_TYPE, compPage, node, frame, text, scalePath, iconPath, icon, lip, float, sticker, registry, shelf, comp, inst, labelProp, petTop, drawPet, chip, dot, ACTIONS, action, PIP, iconBtn, button, toggle, poop, W, IN, H, pakai };
