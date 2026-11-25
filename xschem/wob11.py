#!/usr/bin/env python3
"""M6 11d: is the period-to-period wobble of section 10 the solver or the circuit?
tb_osc_tog.spice held in one state (i3 0, chop A, full slope, REF; all selects 0), 30 fF on ichb, tt 25 C 1.80 V,
osc_en at 120 us, about 22 periods. Two runs: the default tolerances, and reltol = 1e-4 (10x tighter).
rst edges from the raw file (linear interpolation at VDD/2); periods 5-22 against their mean (ppm), the rms of
period-to-period steps, and the spread of 4-period means.
Usage (in the container, after netlisting tb_osc_tog.sch):  python3 /foss/designs/tt_tsense/xschem/wob11.py
Writes simulation/wob11/{default,tight}/ and simulation/wob11/summary.md.
"""
import os, re, subprocess
from concurrent.futures import ThreadPoolExecutor
import numpy as np
import tog10

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_osc_tog.spice')
OUT = os.path.join(SIM, 'wob11')
TSTOP = 120e-6 + 22.5 * 4.886e-6


def run(tag):
    s = open(SRC).read()
    L = s.splitlines()
    i = next(k for k, ln in enumerate(L) if ln.startswith('.subckt bgr '))
    i += 1
    while L[i].startswith('+'):
        i += 1
    L.insert(i, 'Cichb ichb VGND 30f')
    s = '\n'.join(L) + '\n'
    s = re.sub(r'^tran 0\.2n \S+', f'tran 0.2n {TSTOP * 1e6:.3f}u', s, flags=re.M)
    if tag == 'tight':
        s = s.replace('.option method=gear', '.option method=gear reltol=1e-4')
        assert 'reltol=1e-4' in s
    d = os.path.join(OUT, tag)
    os.makedirs(d, exist_ok=True)
    raw = os.path.join(d, 'tog.raw')
    if not (os.path.isfile(raw) and os.path.isfile(os.path.join(d, 'deck.spice')) and open(os.path.join(d, 'deck.spice')).read() == s):
        open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\n')
        open(os.path.join(d, 'deck.spice'), 'w').write(s)
        r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=14400)
        open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    w = tog10.read_raw(raw)
    t, r_ = w['time'], w['v(rst)']
    up = np.where((r_[:-1] < 0.9) & (r_[1:] >= 0.9))[0]
    e = t[up] + (0.9 - r_[up]) * (t[up + 1] - t[up]) / (r_[up + 1] - r_[up])
    q = np.diff(e)[4:]
    ppm = (q / q.mean() - 1) * 1e6
    m4 = [ppm[j:j + 4].mean() for j in range(len(ppm) - 3)]
    return dict(tag=tag, n=len(q), T=q.mean(), ppm=ppm, step_rms=float(np.sqrt(np.mean(np.diff(ppm) ** 2))),
                m4_spread=float(max(m4) - min(m4)), npts=len(t))


def main():
    os.makedirs(OUT, exist_ok=True)
    with ThreadPoolExecutor(2) as ex:
        res = list(ex.map(run, ['default', 'tight']))
    L = ['# M6 11d: period wobble, default vs tight solver tolerance (state A, full slope, REF, tt 25 C 1.80 V)', '']
    for r in res:
        L += [f"- {r['tag']}: {r['n']} periods, mean T {r['T'] * 1e6:.6f} us, {r['npts']} time points; "
              f"period-to-period step rms {r['step_rms']:.1f} ppm; 4-period means spread {r['m4_spread']:.1f} ppm",
              '  periods vs mean (ppm): ' + ' '.join(f'{x:.0f}' for x in r['ppm'])]
    d, t_ = res
    L.append(f"\nMean period, tight vs default: {(t_['T'] / d['T'] - 1) * 1e6:+.1f} ppm")
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
