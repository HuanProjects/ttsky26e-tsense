#!/usr/bin/env python3
"""M6 4: comparator offset Monte Carlo (tt_mm). Reads the netlisted simulation/tb_cmp_mc.spice and replaces its
control block. Per chip (reset = new mismatch draw), at -20 / 25 / 100 C: DC trip across V_REF, then across V_EB3
(same chip, same mismatch); thresholds and the 4/8 diode current follow the frozen bgr at each temperature.
At 25 C also the pair and load Vth differences and gm of M1b / M2b (operating point with vcap = vthr = V_REF).

Usage (in the container, after netlisting tb_cmp_mc.sch):
  python3 /foss/designs/tt_tsense/xschem/mc4.py [nchip] [nproc]     (default 200 8)
  python3 /foss/designs/tt_tsense/xschem/mc4.py analyze             (re-read the logs only)
Writes simulation/mc4/: decks, logs, chips.csv, summary.md.
"""
import csv, math, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
import numpy as np

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_cmp_mc.spice')
OUT = os.path.join(SIM, 'mc4')
FROZEN = {-20: (1.23914, 0.78681, 2.39474e-6), 25: (1.24324, 0.709608, 2.77111e-6), 100: (1.24413, 0.574525, 3.33661e-6)}
SPAN, STEP = 0.005, '20u'
K_COMMON = {25: 0.24, 100: 0.060}        # K/mV, spec Appendix A (common Vos; 100 C after the trim)
K_DIFF = 0.55                            # K/mV, offset difference between the thresholds
P = '@m.xc1.x1.xm{0}.msky130_fd_pr__{1}_01v8_lvt[{2}]'


def control(seed, nchip):
    L = ['.control', f'setseed {seed}', 'let n = 0', f'while n < {nchip}', '  reset']
    for t in (-20, 25, 100):
        vref, veb3, ipt = FROZEN[t]
        L += [f'  option temp={t}', f'  alter @i.xb1.iref[dc] = {ipt / 2:.6g}']
        for cm, v in (('ref', vref), ('eb', veb3)):
            L += [f'  alter vthr dc = {v}', f'  dc vcap {v - SPAN:.6f} {v + SPAN:.6f} {STEP}',
                  f'  meas dc tr when v(cmp_raw)=0.9 rise=1',
                  f'  echo MC seed={seed} chip=$&n t={t} cm={cm} thr={v} trip=$&tr']
        if t == 25:
            L += [f'  alter vthr dc = {vref}', f'  alter vcap dc = {vref}', '  op',
                  f"  let d1 = ({P.format('1a', 'nfet', 'vth')} - {P.format('1b', 'nfet', 'vth')})*1e3",
                  f"  let d2 = ({P.format('2a', 'pfet', 'vth')} - {P.format('2b', 'pfet', 'vth')})*1e3",
                  f"  let g1 = {P.format('1b', 'nfet', 'gm')}", f"  let g2 = {P.format('2b', 'pfet', 'gm')}",
                  '  echo DV seed=' + str(seed) + ' chip=$&n dvth_m1=$&d1 dvth_m2=$&d2 gm1=$&g1 gm2=$&g2']
    L += ['  let n = n + 1', 'end', '.endc']
    return '\n'.join(L)


def run(job):
    name, lib, seed, nchip = job
    s = open(SRC).read()
    s = re.sub(r'sky130\.lib\.spice \S+$', f'sky130.lib.spice {lib}', s, flags=re.M)
    s = re.sub(r'^\.control.*?^\.endc', lambda m: control(seed, nchip), s, flags=re.M | re.S)
    d = os.path.join(OUT, name)
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=7200)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)


def parse():
    chips, dv = {}, {}
    for name in sorted(os.listdir(OUT)):
        f = os.path.join(OUT, name, 'deck.log')
        if not os.path.isfile(f):
            continue
        for line in open(f):
            if line.startswith('MC ') or line.startswith('DV '):
                kv = dict(re.findall(r'(\w+)=(\S+)', line))
                key = (name, int(float(kv['chip'])))
                if line.startswith('MC '):
                    try:
                        chips.setdefault(key, {})[(int(kv['t']), kv['cm'])] = (float(kv['trip']) - float(kv['thr'])) * 1e3
                    except ValueError:
                        pass
                else:
                    dv[key] = {k: float(kv[k]) for k in ('dvth_m1', 'dvth_m2', 'gm1', 'gm2')}
    return chips, dv


def three(x):
    x = np.asarray(x)
    return x.mean(), x.std(ddof=1)


def analyze():
    chips, dv = parse()
    nom = {k: v for k, v in chips.items() if k[0] == 'nominal'}
    mc = {k: v for k, v in chips.items() if k[0] != 'nominal' and len(v) == 6}
    N = len(mc)
    L = [f'# M6 4: comparator offset Monte Carlo (tt_mm, {N} chips with all six points)', '',
         'Vos = DC trip − threshold (mV). Nominal (tt, no mismatch) for reference.', '',
         '| T (°C) | threshold | nominal Vos | MC mean | MC σ | max \\|Vos\\| |', '|---|---|---|---|---|---|']
    nk = next(iter(nom.values())) if nom else {}
    for t in (-20, 25, 100):
        for cm in ('ref', 'eb'):
            m, s = three([c[(t, cm)] for c in mc.values()])
            mx = max(abs(c[(t, cm)]) for c in mc.values())
            L.append(f"| {t} | {'V_REF' if cm == 'ref' else 'V_EB3'} | {nk.get((t, cm), math.nan):+.3f} | {m:+.3f} | {s:.3f} | {mx:.2f} |")
    L += ['', '**Offset difference on the same chip, ΔVos = Vos(V_EB3) − Vos(V_REF):**', '',
          '| T (°C) | mean | σ |', '|---|---|---|']
    d = {t: np.array([c[(t, 'eb')] - c[(t, 'ref')] for c in mc.values()]) for t in (-20, 25, 100)}
    for t in (-20, 25, 100):
        L.append(f'| {t} | {d[t].mean():+.4f} | {d[t].std(ddof=1):.4f} |')
    L += ['', '**Drift of ΔVos from 25 °C (what the trim cannot remove), limit 3σ ≤ 0.2 mV:**', '',
          '| to | mean (systematic, into the μ→T fit) | 3σ (random) | 3σ in K (0.55 K/mV) |', '|---|---|---|---|']
    for t in (-20, 100):
        x = d[t] - d[25]
        L.append(f'| {t} °C | {x.mean():+.4f} mV | {3 * x.std(ddof=1):.4f} mV | {3 * x.std(ddof=1) * K_DIFF:.3f} K |')
    cr = np.array([c[(100, 'ref')] - c[(25, 'ref')] for c in mc.values()])
    L += ['', f'Drift of the common Vos (V_REF) 25 → 100 °C: mean {cr.mean():+.3f} mV, σ {cr.std(ddof=1):.3f} mV.']
    s25 = np.std([c[(25, 'ref')] for c in mc.values()], ddof=1)
    L += [f'Common Vos cost: σ {s25:.3f} mV × 0.24 K/mV = {s25 * 0.24:.3f} K (1σ) before the trim; '
          f'after the 25 °C trim 0.060 K/mV at 100 °C → {3 * s25 * 0.060:.3f} K (3σ).']
    # hand model: Vos ~ -dVth(M1) + (gm2/gm1) dVth(M2)
    keys = [k for k in mc if k in dv]
    if keys:
        a = np.array([[-dv[k]['dvth_m1'], dv[k]['dvth_m2']] for k in keys])
        y = np.array([mc[k][(25, 'ref')] for k in keys])
        coef, *_ = np.linalg.lstsq(a, y, rcond=None)
        ratio = np.median([dv[k]['gm2'] / dv[k]['gm1'] for k in keys])
        res = y - a @ coef
        s1, s2 = np.std(a[:, 0], ddof=1), np.std(a[:, 1], ddof=1)
        L += ['', '**Where the offset comes from (25 °C, V_REF):**', '',
              f'- σ(ΔVth) of the pair M1a − M1b: {s1:.3f} mV; of the load M2a − M2b: {s2:.3f} mV.',
              f'- Fit Vos = a·(−ΔVth_M1) + b·ΔVth_M2: a = {coef[0]:.3f}, b = {coef[1]:.3f}; gm(M2b)/gm(M1b) from the op = {ratio:.3f}; '
              f'residual σ {np.std(res, ddof=1):.3f} mV.',
              f'- Hand RSS: √({s1:.3f}² + ({ratio:.3f}·{s2:.3f})²) = {math.hypot(s1, ratio * s2):.3f} mV against the MC σ {s25:.3f} mV.']
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    with open(os.path.join(OUT, 'chips.csv'), 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['deck', 'chip'] + [f'vos_{cm}_{t}' for t in (-20, 25, 100) for cm in ('ref', 'eb')] + ['dvth_m1', 'dvth_m2', 'gm1', 'gm2'])
        for k, c in mc.items():
            e = dv.get(k, {})
            w.writerow(list(k) + [f'{c[(t, cm)]:.5f}' for t in (-20, 25, 100) for cm in ('ref', 'eb')]
                       + [e.get(x, '') for x in ('dvth_m1', 'dvth_m2', 'gm1', 'gm2')])
    print(txt)


def main():
    if len(sys.argv) > 1 and sys.argv[1] == 'analyze':
        return analyze()
    nchip = int(sys.argv[1]) if len(sys.argv) > 1 else 200
    nproc = int(sys.argv[2]) if len(sys.argv) > 2 else 8
    per = [nchip // nproc + (1 if i < nchip % nproc else 0) for i in range(nproc)]
    jobs = [('nominal', 'tt', 1, 1)] + [(f'mc_s{101 + i}', 'tt_mm', 101 + i, per[i]) for i in range(nproc) if per[i]]
    os.makedirs(OUT, exist_ok=True)
    with ThreadPoolExecutor(nproc + 1) as ex:
        list(ex.map(run, jobs))
    analyze()


if __name__ == '__main__':
    main()
