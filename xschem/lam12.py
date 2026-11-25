"""M6 12a: delta-mu_ramp on the frozen bgr from P4's I(V) (spec delta-mu_ramp row, tb_p4_lambda).

Deck = simulation/tb_bg_pvt.spice (frozen bgr, M5 bench) with the ich pin on a swept source instead of the va
follower. Per point (corner, VDD, T) and slope state (ich_sel 0 = full, 1 = half): .dc of vcap 0 -> 1.30 V,
10 mV steps -> I_ch(v). With t(V) = integral_0^V dv / I(v) (ramp time for a unit cap), the loop's ratio is
mu = 1 - t(V_EB3)/t(V_REF); a constant current gives mu0 = 1 - V_EB3/V_REF. delta-mu = mu - mu0 per slope,
and for the two-slope extraction (r 0.565) 1/mu_x = 1/mu_h - k (1/mu_f - 1/mu_h) -> delta-mu_x = mu_x - mu0.
V_REF and V_EB3 per point from docs/mu_dc.csv. DC only: no comparator, no delay, no reset.

Usage (in the container, bash -l):  python3 /foss/designs/tt_tsense/xschem/lam12.py
  LAM12_ONLY="fs_1.8_-20,..." re-simulates only those points and re-reads the rest for the summary.
Output: simulation/lam12/{all.csv, summary.md}
"""
import csv
import os
import re
import subprocess
from concurrent.futures import ThreadPoolExecutor

import numpy as np

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_bg_pvt.spice')
OUT = os.path.join(SIM, 'lam12')
MU = '/foss/designs/tt_tsense/docs/mu_dc.csv'
CORNERS = ('tt', 'ss', 'ff', 'sf', 'fs')
VDDS = (1.71, 1.8, 1.89)
TEMPS = (-20, 25, 100)
K = 0.565 / 0.435
DV = 0.01

CTRL = """.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
option temp={T}
dc Vich 0 1.3 {dv}
wrdata {out}/{sl}.txt i(vich)
.endc
"""


def deck(c, v, T, out, sl):
    """One deck per slope state, so each .dc starts from its own operating point with the nodesets
    (an `alter` into half slope after the full sweep landed in a wrong state at fs, -20 C)."""
    s = open(SRC).read()
    s = s.replace('sky130.lib.spice tt', f'sky130.lib.spice {c}', 1)
    s = re.sub(r'^Vdd VDPWR 0 1\.8$', f'Vdd VDPWR 0 {v}', s, count=1, flags=re.M)
    for n in ('Vswa swa', 'Vchopb chopb', 'Vi3on i3_on'):
        s = re.sub(rf'^{n} 0 1\.8$', f'{n} 0 {v}', s, count=1, flags=re.M)
    on, onb, dump = (v, 0, 0) if sl == 'full' else (0, v, v)
    s = re.sub(r'^Vichon ich_on 0 1\.8$', f'Vichon ich_on 0 {on}', s, count=1, flags=re.M)
    s = re.sub(r'^Vichonb ich_onb 0 0$', f'Vichonb ich_onb 0 {onb}', s, count=1, flags=re.M)
    s = re.sub(r'^Vichdump ich_dump 0 0$', f'Vichdump ich_dump 0 {dump}', s, count=1, flags=re.M)
    s = re.sub(r'^V4 ich p4 0$', 'Vich ich 0 0.6', s, count=1, flags=re.M)
    s = re.sub(r'\.control.*?\.endc\n', CTRL.format(T=T, dv=DV, out=out, sl=sl), s, count=1, flags=re.S)
    return s


def read(fn):
    a = np.loadtxt(fn)
    return a[:, 0], np.abs(a[:, 1])


def sim(pt):
    c, v, T = pt
    d = os.path.join(OUT, f'{c}_{v}_{T}')
    os.makedirs(d, exist_ok=True)
    for sl in ('full', 'half'):
        open(os.path.join(d, f'deck_{sl}.spice'), 'w').write(deck(c, v, T, d, sl))
        subprocess.run(['ngspice', '-b', f'deck_{sl}.spice'], cwd=d, capture_output=True, text=True, timeout=1200)


def run(pt):
    c, v, T = pt
    d = os.path.join(OUT, f'{c}_{v}_{T}')
    row = next(r for r in csv.DictReader(open(MU)) if r['corner'] == c and abs(float(r['vdd_V']) - v) < 1e-6 and int(float(r['temp_C'])) == T)
    vr, ve = float(row['vref_V']), float(row['veb3_V'])
    mu0 = 1 - ve / vr
    res = dict(corner=c, vdd_V=v, temp_C=T, vref_V=vr, veb3_V=ve, mu0=mu0)
    mus = {}
    for sl in ('full', 'half'):
        x, i = read(os.path.join(d, f'{sl}.txt'))
        t = np.concatenate([[0], np.cumsum(DV / (0.5 * (i[1:] + i[:-1])))])
        tr, te = np.interp(vr, x, t), np.interp(ve, x, t)
        mus[sl] = 1 - te / tr
        res[f'I_{sl}_0.25_nA'] = float(np.interp(0.25, x, i) * 1e9)
        res[f'I_{sl}_1.25_nA'] = float(np.interp(1.25, x, i) * 1e9)
        res[f'dmu_{sl}'] = mus[sl] - mu0
    mux = 1 / (1 / mus['half'] - K * (1 / mus['full'] - 1 / mus['half']))
    res['dmu_x'] = mux - mu0
    return res


def main():
    os.makedirs(OUT, exist_ok=True)
    pts = [(c, v, T) for c in CORNERS for v in VDDS for T in TEMPS]
    only = os.environ.get('LAM12_ONLY', '')  # e.g. "fs_1.71_-20,fs_1.8_-20": re-simulate these, re-read the rest
    todo = [p for p in pts if not only or f'{p[0]}_{p[1]}_{p[2]}' in only.split(',')]
    with ThreadPoolExecutor(8) as ex:
        list(ex.map(sim, todo))
    rows = [run(p) for p in pts]
    keys = list(rows[0])
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, keys)
        w.writeheader()
        w.writerows(rows)
    get = {(r['corner'], r['vdd_V'], r['temp_C']): r for r in rows}
    L = ['# M6 12a: delta-mu_ramp from P4 I(V) on the frozen bgr (DC, 10 mV steps)', '',
         'delta-mu = mu(I(V) integrated) - (1 - V_EB3/V_REF); x = two-slope extraction (r 0.565). Units 1e-3.', '',
         '| corner | VDD | dmu full -20 / 25 / 100 | dmu half -20 / 25 / 100 | dmu_x -20 / 25 / 100 | change of dmu_x, -20 -> 100 | I_full(1.25)/I_full(0.25) - 1, 25 C |',
         '|---|---|---|---|---|---|---|']
    ch = {}
    for c in CORNERS:
        for v in VDDS:
            g = [get[(c, v, T)] for T in TEMPS]
            f3 = lambda k: ' / '.join(f'{x[k] * 1e3:+.3f}' for x in g)
            ch[(c, v)] = g[2]['dmu_x'] - g[0]['dmu_x']
            r25 = g[1]['I_full_1.25_nA'] / g[1]['I_full_0.25_nA'] - 1
            L.append(f"| {c} | {v} | {f3('dmu_full')} | {f3('dmu_half')} | {f3('dmu_x')} | {ch[(c, v)] * 1e3:+.3f} | {r25 * 100:+.2f} % |")
    tt = ch[('tt', 1.8)]
    dev = [x - tt for x in ch.values()]
    L += ['', f'- change of dmu_x over -20 -> 100 C at tt 1.80 V: {tt * 1e3:+.3f}e-3 ({tt / 1.443e-3:+.3f} K at 1.443e-3/K)',
          f'- about tt over 5 corners x 3 VDD: {min(dev) * 1e3:+.3f}e-3 to {max(dev) * 1e3:+.3f}e-3 '
          f'({min(dev) / 1.443e-3:+.3f} to {max(dev) / 1.443e-3:+.3f} K)']
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
