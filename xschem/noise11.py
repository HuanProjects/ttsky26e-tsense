#!/usr/bin/env python3
"""M6 11b: comparator noise at the trip point -> crossing jitter (spec tb_cmp_noise, Fall version).
tb_cmp_noise.spice at tt 1.80 V, -20 / 25 / 100 C, at the V_REF and V_EB3 thresholds (frozen bgr values), bias
I_PTAT/2 into the 4/8 diode. Output noise at n1 (first stage) referred to vcap with the low-frequency gain A0 (from
onoise / inoise at 1 kHz). Bands: the per-crossing band 100 kHz-1 GHz (faster than a period, so each crossing gets a
fresh sample: this is the jitter) and 1-100 kHz (slower than a period: it moves many crossings together, part of the floor).
sigma_cross = v_n(100 kHz-1 GHz) / s, s = I_PTAT / (2 C_osc); at half slope it doubles.
Usage (in the container, after netlisting tb_cmp_noise.sch):  python3 /foss/designs/tt_tsense/xschem/noise11.py
Writes simulation/noise11/: decks, logs, noise spectra, summary.md, all.json.
"""
import json, os, re, subprocess
from concurrent.futures import ThreadPoolExecutor
import numpy as np

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_cmp_noise.spice')
OUT = os.path.join(SIM, 'noise11')
C_OSC = 5.06e-12
FROZEN = {-20: (1.23914, 0.78681, 2.39474e-6), 25: (1.24324, 0.709608, 2.77111e-6), 100: (1.24413, 0.574525, 3.33661e-6)}
F_SPLIT = 100e3


def run(job):
    t, cm = job
    vref, veb3, ipt = FROZEN[t]
    vth = vref if cm == 'REF' else veb3
    s = open(SRC).read()
    s = re.sub(r'^\.param vdd=.*$', f'.param vdd=1.8 vthr={vth} vcapdc={vth}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = re.sub(r'^Iref VDPWR nb \S+$', f'Iref VDPWR nb {ipt / 2:.6g}', s, flags=re.M)
    s = re.sub(r'^let lo = \S+$', f'let lo = {vth - 0.004:.5f}', s, flags=re.M)
    s = re.sub(r'^let hi = \S+$', f'let hi = {vth + 0.004:.5f}', s, flags=re.M)
    d = os.path.join(OUT, f'{t}_{cm}')
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=1800)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    trip = float(re.search(r'^trip = (\S+)$', r.stdout, re.M).group(1))
    a = np.loadtxt(os.path.join(d, 'noise.txt'))
    f, on, inn = a[:, 0], a[:, 1], a[:, 3]
    gain = on / inn
    a0 = gain[0]
    f3 = float(np.interp(a0 / np.sqrt(2), gain[::-1], f[::-1]))
    def band(lo, hi):
        m = (f >= lo) & (f <= hi)
        return float(np.sqrt(np.trapezoid(on[m] ** 2, f[m])) / a0)
    sl = ipt / 2 / C_OSC
    vn_hi, vn_lo = band(F_SPLIT, 1e9), band(1e3, F_SPLIT)
    dens = {k: float(np.interp(k, f, inn)) for k in (1e3, 1e5, 1e7)}
    return dict(temp=t, cm=cm, vthr=vth, vos_uV=(trip - vth) * 1e6, a0=float(a0), f3_MHz=f3 / 1e6,
                en_1k=dens[1e3] * 1e9, en_100k=dens[1e5] * 1e9, en_10M=dens[1e7] * 1e9,
                vn_hi_uV=vn_hi * 1e6, vn_lo_uV=vn_lo * 1e6, slope=sl * 1e-6,
                sig_full_ns=vn_hi / sl * 1e9, sig_half_ns=vn_hi / (sl / 2) * 1e9, sig_lo_full_ns=vn_lo / sl * 1e9)


def main():
    os.makedirs(OUT, exist_ok=True)
    jobs = [(t, cm) for t in (-20, 25, 100) for cm in ('REF', 'EB')]
    with ThreadPoolExecutor(6) as ex:
        rows = list(ex.map(run, jobs))
    L = ['# M6 11b: comparator noise at the trip point (tt 1.80 V)', '',
         '| T (C) | threshold | Vos (uV) | A0 at n1 | n1 -3 dB (MHz) | e_n 1 kHz / 100 kHz / 10 MHz (nV/rtHz) | v_n 0.1-1000 MHz (uV) '
         '| v_n 1-100 kHz (uV) | s (V/us) | sigma_cross full / half (ns) | 1-100 kHz part at full slope (ns) |',
         '|---|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        L.append(f"| {r['temp']} | {r['cm']} | {r['vos_uV']:+.1f} | {r['a0']:.1f} | {r['f3_MHz']:.2f} | {r['en_1k']:.1f} / {r['en_100k']:.1f} / {r['en_10M']:.1f} "
                 f"| {r['vn_hi_uV']:.1f} | {r['vn_lo_uV']:.1f} | {r['slope']:.4f} | {r['sig_full_ns']:.3f} / {r['sig_half_ns']:.3f} | {r['sig_lo_full_ns']:.3f} |")
    L.append(f"\nWorst sigma_cross at full slope: {max(r['sig_full_ns'] for r in rows):.3f} ns (limit 0.54 ns); at half slope "
             f"{max(r['sig_half_ns'] for r in rows):.3f} ns.")
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    json.dump(rows, open(os.path.join(OUT, 'all.json'), 'w'), indent=1)
    print(txt)


if __name__ == '__main__':
    main()
