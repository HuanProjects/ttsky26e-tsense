#!/usr/bin/env python3
"""M6 11c: resolution against M (periods per phase) and conversion time; spec M6 'res_vs_m.py' (Fall: analytic model).
Inputs at tt 25 C 1.80 V: T_REF, T_EB from section 9 (loop on the frozen bgr), crossing jitter from section 11b
(simulation/noise11/all.json, the 100 kHz-1 GHz band; the worse of REF / EB at 25 C, and the worst point at any T as a
second case), P4's thermal charge noise 0.37 ns per REF ramp (hand, spec M6 resolution note; scaled by sqrt(ramp time)),
counter f_cnt = 75 MHz (quantization 1/6 tick^2 per count, both ends), floor 0.015 K (mirror / op-amp 1/f, hand)
combined with the comparator 1-100 kHz band from 11b.
Fast mode: chop A, full slope, M REF + M EB periods, t_conv = (M + 8)(T_REF + T_EB).
Full conversion: chop A/B x full/half x REF/EB, two-slope mu0 with k = r/(1-r), r = 0.565, chop average.
Writes simulation/res11/{summary.md, res_vs_tconv.png}.
"""
import json, os
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

SIM = '/foss/designs/tt_tsense/xschem/simulation'
OUT = os.path.join(SIM, 'res11')
T_REF, T_EB = 4.8855e-6, 2.8322e-6           # section 9, tt 25 C
V_REF, V_EB = 1.24324, 0.709608
F_CNT = 75e6
DMU_DT = 1.443e-3
SIG_P4 = 0.37e-9                              # per REF ramp at full slope (hand)
FLOOR_ARCH = 0.015                            # K, mirror / op-amp 1/f (hand)
R = 0.565
MS = [16, 32, 64, 128, 256, 512, 1024]


def sig_mu(M, tr, te, sc_r, sc_e):
    """sigma of mu = 1 - N_EB/N_REF; sc_* = per-crossing time jitter (s)."""
    nr, ne = M * tr * F_CNT, M * te * F_CNT
    sn_r = np.sqrt(1 / 6 + (np.sqrt(M) * sc_r * F_CNT) ** 2)
    sn_e = np.sqrt(1 / 6 + (np.sqrt(M) * sc_e * F_CNT) ** 2)
    return np.sqrt(sn_e ** 2 + (ne / nr) ** 2 * sn_r ** 2) / nr, np.sqrt(1 / 6 + (ne / nr) ** 2 / 6) / nr


def main():
    os.makedirs(OUT, exist_ok=True)
    nz = json.load(open(os.path.join(SIM, 'noise11', 'all.json')))
    at25 = {r['cm']: r for r in nz if r['temp'] == 25}
    worst = max(r['sig_full_ns'] for r in nz) * 1e-9
    lo = max(r['vn_lo_uV'] for r in nz) * 1e-6
    floor = np.hypot(FLOOR_ARCH, (1 - (1 - V_EB / V_REF)) * lo / V_REF / DMU_DT)
    cases = {'sim 25 C': (at25['REF']['sig_full_ns'] * 1e-9, at25['EB']['sig_full_ns'] * 1e-9),
             'worst point (100 C REF)': (worst, worst)}
    mu_f = 1 - T_EB / T_REF
    mu_h = mu_f + 0.0026                      # section 10: mu half - mu full at 25 C
    k = R / (1 - R)
    L = ['# M6 11c: resolution vs M (tt 25 C; f_cnt 75 MHz)', '',
         f'Floor {floor:.4f} K = {FLOOR_ARCH} K (mirror / op-amp 1/f, hand) with the comparator 1-100 kHz band '
         f'({lo * 1e6:.1f} uV, section 11b). P4 thermal {SIG_P4 * 1e9:.2f} ns per REF ramp (hand), scaled by sqrt(ramp time).', '']
    curves = {}
    for name, (scr, sce) in cases.items():
        p4r, p4e = SIG_P4, SIG_P4 * np.sqrt(V_EB / V_REF)
        cr, ce = np.hypot(scr, p4r), np.hypot(sce, p4e)
        L += [f'## Jitter case: {name}: comparator {scr * 1e9:.3f} / {sce * 1e9:.3f} ns (REF / EB), with P4 {cr * 1e9:.3f} / {ce * 1e9:.3f} ns', '',
              '| M | fast t_conv (ms) | quantization (K) | jitter (K) | floor (K) | fast total (K) | full t_conv (ms) | full total (K) |',
              '|---|---|---|---|---|---|---|---|']
        rows = []
        for M in MS:
            sf, sq = sig_mu(M, T_REF, T_EB, cr, ce)
            sh, _ = sig_mu(M, 2 * T_REF, 2 * T_EB, 2 * cr, 2 * ce)
            tq, tj = sq / DMU_DT, np.sqrt(max(sf ** 2 - sq ** 2, 0)) / DMU_DT
            fast = np.sqrt(sf ** 2 / DMU_DT ** 2 + floor ** 2)
            s_inv = np.sqrt(((1 + k) * sh / mu_h ** 2) ** 2 + (k * sf / mu_f ** 2) ** 2) / np.sqrt(2)
            s_mu0 = mu_f ** 2 * s_inv
            full = np.sqrt((s_mu0 / DMU_DT) ** 2 + floor ** 2)
            tf = (M + 8) * (T_REF + T_EB)
            tfull = 2 * ((M + 8) * (T_REF + T_EB) + (M + 8) * 2 * (T_REF + T_EB))
            rows.append((M, tf, fast, tfull, full))
            L.append(f'| {M} | {tf * 1e3:.2f} | {tq:.4f} | {tj:.4f} | {floor:.4f} | {fast:.4f} | {tfull * 1e3:.2f} | {full:.4f} |')
        curves[name] = rows
        L.append('')
    fig, ax = plt.subplots(figsize=(6.5, 4.2))
    for name, rows in curves.items():
        ls = '-' if name.startswith('sim') else '--'
        ax.loglog([r[1] * 1e3 for r in rows], [r[2] for r in rows], 'o' + ls, color='C0', label=f'fast mode, {name}')
        ax.loglog([r[3] * 1e3 for r in rows], [r[4] for r in rows], 's' + ls, color='C1', label=f'full conversion, {name}')
    for y, lab in ((0.1, '0.1 K'), (0.03, '0.03 K')):
        ax.axhline(y, color='gray', lw=0.8, ls=':')
        ax.text(0.12, y * 1.08, lab, color='gray', fontsize=8)
    ax.set_xlabel('conversion time (ms)')
    ax.set_ylabel('resolution, rms (K)')
    ax.set_title('cmp2s loop, tt 25 C: resolution vs conversion time (M = 16 ... 1024)', fontsize=9)
    ax.grid(True, which='both', lw=0.3)
    ax.legend(fontsize=7)
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, 'res_vs_tconv.png'), dpi=130)
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
