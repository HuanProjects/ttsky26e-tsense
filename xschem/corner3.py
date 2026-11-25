#!/usr/bin/env python3
"""M6 3: cmp2s over corners. Fans tb_cmp_corners.spice out over 5 MOS corners x -20/25/100 C x 1.71/1.89 V
(thresholds, slope and the bias current follow the frozen bgr at each temperature), then reruns
sf / -20 C / 1.71 V with M3 at the spec's original 3/1.

Usage (in the container, after netlisting tb_cmp_corners.sch):
  python3 /foss/designs/tt_tsense/xschem/corner3.py
Writes simulation/corner3/: one deck + log per point, all.csv, summary.md.
"""
import csv, math, os, re, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
OUT = os.path.join(SIM, 'corner3')
SRC = os.path.join(SIM, 'tb_cmp_corners.spice')
CORNERS = ['tt', 'ss', 'ff', 'sf', 'fs']
TEMPS = [-20, 25, 100]
VDDS = [1.71, 1.89]
TL = 11.5                       # ns, logic + reset
C_OSC = 5.06e-12
# frozen bgr at tt, 1.80 V: T -> (V_REF, V_EB3, I_PTAT); V_REF' = half-current (i3_sel = 1) V_REF
FROZEN = {-20: (1.23914, 0.78681, 2.39474e-6), 25: (1.24324, 0.709608, 2.77111e-6), 100: (1.24413, 0.574525, 3.33661e-6)}
VREFP = {-20: 0.999488, 25: 0.960526, 100: 0.88947}
ROWS = [('V_EB3', 1), ("V_REF'", 3), ('V_REF', 5)]      # full-slope copy k; half-slope copy is k + 1


def flat(s):
    return re.sub(r'\n\+', ' ', s)


def deck(src, corner, t, vdd, m3=None):
    vref, veb3, ipt = FROZEN[t]
    sl = ipt / 2 / C_OSC                              # V/s
    s = re.sub(r'sky130\.lib\.spice tt$', f'sky130.lib.spice {corner}', src, flags=re.M)
    s = re.sub(r'^\.param vref=.*$', f'.param vref={vref} veb3={veb3} vrefp={VREFP[t]} sl={sl:.6g}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = re.sub(r'^Vdd VDPWR 0 \S+$', f'Vdd VDPWR 0 {vdd}', s, flags=re.M)
    s = re.sub(r'^Iref VDPWR nb \S+$', f'Iref VDPWR nb {ipt / 2:.6g}', s, flags=re.M)
    s = re.sub(r'^tran 0\.2n \S+', f'tran 0.2n {(0.3e-6 + 0.92 / sl + 0.2e-6) * 1e6:.3f}u', s, flags=re.M)
    cms = {1: veb3, 3: VREFP[t], 5: vref}
    s = re.sub(r'^dc vcap(\d) \S+ \S+ 5u$', lambda m: f'dc vcap{m.group(1)} {cms[int(m.group(1))] - 0.006:.5f} '
               f'{cms[int(m.group(1))] + 0.006:.5f} 5u', s, flags=re.M)
    if m3:                                            # M3 = W x mult (spec 3/1 = W 3, mult 1), junction terms rescaled
        w, mult = m3
        geo = (f'W={w} nf=1 ad={w * 0.29:.4g} as={w * 0.29:.4g} pd={2 * (w + 0.29):.4g} ps={2 * (w + 0.29):.4g} '
               f'nrd={0.29 / w:.4g} nrs={0.29 / w:.4g}')
        s = re.sub(r'^(XM3 .*?)W=4 nf=1 ad=\S+ as=\S+ pd=\S+ ps=\S+ nrd=\S+ nrs=\S+(.*?)mult=3 m=3',
                   rf'\1{geo}\2mult={mult} m={mult}', s, flags=re.M)
        assert f'mult={mult} m={mult}' in s.split('XM3 ')[1].split('\n')[0], 'M3 line not rewritten'
    return s, sl, cms


def run(job):
    tag, corner, t, vdd, m3 = job
    src = flat(open(SRC).read())
    s, sl, cms = deck(src, corner, t, vdd, m3)
    d = os.path.join(OUT, tag)
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=3600)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    v, flip, marg = {}, {}, {}
    for line in r.stdout.splitlines():
        if line.startswith('RESULT'):
            v.update({k: float(x) for k, x in re.findall(r'(\w+)=([-+0-9.eE]+)', line)})
        elif line.startswith('FLIP') or line.startswith('MARGIN'):
            d_ = {k: float(x) for k, x in re.findall(r'(\w+)=([-+0-9.eE]+)', line)}
            (flip if line.startswith('FLIP') else marg)[int(d_.pop('k'))] = d_
    rows = []
    for name, k in ROWS:
        cm = cms[k]
        tcf = 0.3e-6 + 0.4 / sl
        tch = 0.3e-6 + 0.4 / (sl / 2)
        td = (v.get(f'to{k}', math.nan) - tcf) * 1e9
        tdh = (v.get(f'to{k + 1}', math.nan) - tch) * 1e9
        vos = (v.get(f'trip{k}', math.nan) - cm) * 1e3
        t0 = td - vos / (sl * 1e-6)                   # mV / (mV/ns)
        t0h = tdh - vos / (sl / 2 * 1e-6)
        r_ = (t0h + TL) / (2 * (t0 + TL))
        f, fh = flip.get(k, {}), flip.get(k + 1, {})
        rows.append(dict(tag=tag, corner=corner, temp=t, vdd=vdd, m3=f'{m3[0]}x{m3[1]}' if m3 else '4x3',
                         thr=name, cm=round(cm, 5), td=td, tdh=tdh, vos=vos, t0=t0, t0h=t0h, r=r_,
                         **{f'flip_{n}': min(f.get(n, math.nan), fh.get(n, math.nan)) for n in ('m1a', 'm1b', 'm2b', 'm3', 'mnb3')},
                         n1_flip=f.get('n1', math.nan), tail_flip=f.get('tail', math.nan),
                         **{f'dc_{n}': marg.get(k, {}).get(n, math.nan) for n in ('m1a', 'm1b', 'm2a', 'm2b', 'm3', 'mnb3', 'mnb4')}))
    return rows


def main():
    os.makedirs(OUT, exist_ok=True)
    jobs = [(f'{c}_{t}_{v}', c, t, v, None) for c in CORNERS for t in TEMPS for v in VDDS]
    jobs.append(('sf_-20_1.71_m3spec', 'sf', -20, 1.71, (3, 1)))
    with ThreadPoolExecutor(8) as ex:
        rows = [r for rs in ex.map(run, jobs) for r in rs]
    keys = list(rows[0].keys())
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, keys)
        w.writeheader()
        w.writerows(rows)
    a = [r for r in rows if r['m3'] == '4x3']
    L = ['# M6 3: cmp2s over corners (adopted set C)', '',
         '| corner | T | VDD | t_d EB3 | t_d REF\' | t_d REF | EB3 − REF | r EB3 | r REF\' | r REF | Vos EB3/REF (mV) '
         '| worst flip margin (mV, device, threshold) |', '|' + '---|' * 12]
    for c in CORNERS:
        for t in TEMPS:
            for vd in VDDS:
                g = {r['thr']: r for r in a if r['corner'] == c and r['temp'] == t and r['vdd'] == vd}
                worst = min(((r[f'flip_{n}'], n, r['thr']) for r in g.values() for n in ('m1a', 'm1b', 'm2b', 'm3', 'mnb3')),
                            key=lambda x: x[0] if not math.isnan(x[0]) else 1e9)
                L.append(f"| {c} | {t} | {vd} | {g['V_EB3']['td']:.1f} | {g[chr(86)+'_REF'+chr(39)]['td']:.1f} | {g['V_REF']['td']:.1f} "
                         f"| {g['V_EB3']['td'] - g['V_REF']['td']:+.1f} | {g['V_EB3']['r']:.3f} | {g[chr(86)+'_REF'+chr(39)]['r']:.3f} "
                         f"| {g['V_REF']['r']:.3f} | {g['V_EB3']['vos']:+.2f} / {g['V_REF']['vos']:+.2f} "
                         f"| {worst[0]:.0f} ({worst[1]}, {worst[2]}) |")
    td = [r['td'] for r in a]
    rr = [r['r'] for r in a]
    L += ['', f'All points: t_d {min(td):.1f}–{max(td):.1f} ns; r {min(rr):.3f}–{max(rr):.3f}; '
          f'Vos {min(r["vos"] for r in a):+.2f} to {max(r["vos"] for r in a):+.2f} mV']
    for t in TEMPS:
        x = [r['r'] for r in a if r['temp'] == t]
        L.append(f'- r at {t} C: {min(x):.3f}–{max(x):.3f} (spread ±{(max(x) - min(x)) / 2:.3f})')
    dif = {(c, t, vd): next(r for r in a if r['corner'] == c and r['temp'] == t and r['vdd'] == vd and r['thr'] == 'V_EB3')['td']
           - next(r for r in a if r['corner'] == c and r['temp'] == t and r['vdd'] == vd and r['thr'] == 'V_REF')['td']
           for c in CORNERS for t in TEMPS for vd in VDDS}
    sup = [abs(dif[(c, t, 1.89)] - dif[(c, t, 1.71)]) for c in CORNERS for t in TEMPS]
    L += [f'- t_d(EB3) − t_d(REF): {min(dif.values()):+.1f} to {max(dif.values()):+.1f} ns; '
          f'largest change between 1.71 and 1.89 V at one corner/T: {max(sup):.1f} ns', '']
    L += ['## sf, −20 C, 1.71 V: adopted M3 12/1 vs spec M3 3/1', '',
          '| M3 | threshold | t_d | t_d half | r | n1 at flip | tail at flip | margin at flip M1a / M1b / M2b / M3 / MNB3 (mV) |',
          '|---|---|---|---|---|---|---|---|']
    for r in rows:
        if r['corner'] == 'sf' and r['temp'] == -20 and r['vdd'] == 1.71:
            L.append(f"| {r['m3']} | {r['thr']} | {r['td']:.1f} | {r['tdh']:.1f} | {r['r']:.3f} | {r['n1_flip']:.3f} | {r['tail_flip']:.3f} "
                     f"| {r['flip_m1a']:.0f} / {r['flip_m1b']:.0f} / {r['flip_m2b']:.0f} / {r['flip_m3']:.0f} / {r['flip_mnb3']:.0f} |")
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
