#!/usr/bin/env python3
"""M6 10b: the control toggles on the frozen bgr, through swdrv. tt, 25 C, 1.80 V, 30 fF on ichb (spec R4).
16 steps, one control changed per step (thr_sel, chop_sel, ich_sel, i3_sel), about 13 periods each:
  i3 0: A full REF, A full EB, B full EB, B full REF, B half REF, B half EB, A half EB, A half REF,
  i3 1: A half REF, A half EB, B half EB, B half REF, B full REF, B full EB, A full EB, A full REF.
The rst edges come from the binary raw file (linear interpolation at VDD/2), not from .meas (7 digits: 0.1 ns at 1 ms).
Per step: periods after the change vs the mean of periods 9-12 (ppm), the first period from which every later one is
within 10 ppm, and the per-period mean of vref, veb3 and vpg against their settled value (uV).
Then mu per state, the two-slope mu0 (r = 0.565 from the ramp bench, section 2), the chop average, the chop difference
and chi = 10 (1 - mu0)/mu0 - 5 (1 - mu0')/mu0' - 1/3 against chi_nom from simulation/pvt8/i3_table.csv.
Usage (in the container, after netlisting tb_osc_tog.sch):  python3 /foss/designs/tt_tsense/xschem/tog10.py
Writes simulation/tog10/: deck, log, tog.raw, all.json, summary.md.
"""
import csv, json, os, re, subprocess, sys
import numpy as np

# Optional argument: temperature in C (-20, 25 or 100; default 25). Output goes to simulation/tog10 (25 C) or tog10_<T>.
TEMP = int(sys.argv[1]) if len(sys.argv) > 1 and __name__ == '__main__' else 25
SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_osc_tog.spice')
OUT = os.path.join(SIM, 'tog10' if TEMP == 25 else f'tog10_{TEMP}')
C_OSC, VDD, TEN = 5.06e-12, 1.8, 120e-6
# frozen bgr at tt 1.80 V: I_PTAT, and V_REF / V_EB3 with i3_sel 0 and 1 (docs/mu_dc.csv, simulation/pvt8/i3_table.csv)
VALS = {25: (2.77111e-6, {(0, 'REF'): 1.24324, (0, 'EB'): 0.709608, (1, 'REF'): 0.960526, (1, 'EB'): 0.691732}),
        -20: (2.39474e-6, {(0, 'REF'): 1.23914, (0, 'EB'): 0.78681, (1, 'REF'): 0.999488, (1, 'EB'): 0.771656}),
        100: (3.33661e-6, {(0, 'REF'): 1.24413, (0, 'EB'): 0.574525, (1, 'REF'): 0.88947, (1, 'EB'): 0.552089})}
IPT, V = VALS[TEMP]
SEQ = [(0, 'A', 'full', 'REF'), (0, 'A', 'full', 'EB'), (0, 'B', 'full', 'EB'), (0, 'B', 'full', 'REF'),
       (0, 'B', 'half', 'REF'), (0, 'B', 'half', 'EB'), (0, 'A', 'half', 'EB'), (0, 'A', 'half', 'REF'),
       (1, 'A', 'half', 'REF'), (1, 'A', 'half', 'EB'), (1, 'B', 'half', 'EB'), (1, 'B', 'half', 'REF'),
       (1, 'B', 'full', 'REF'), (1, 'B', 'full', 'EB'), (1, 'A', 'full', 'EB'), (1, 'A', 'full', 'REF')]
R_RAMP, R_LOOP = 0.565, 0.559
S_MU = 4.4e-3          # d mu / d Vos per mV at 25 C (spec M6 step 2, C2)


def t_est(st):
    i3, ch, sl, th = st
    ich = IPT / 2 / (2 if sl == 'half' else 1)
    return 1.076 * C_OSC * V[(i3, th)] / ich + (88e-9 if sl == 'full' else 100e-9)


def pwl(levels, times):
    s, cur = f'0 {levels[0] * VDD}', levels[0]
    for lv, t in zip(levels[1:], times[1:]):
        if lv != cur:
            s += f' {t:.9g} {cur * VDD} {t + 0.2e-9:.9g} {lv * VDD}'
            cur = lv
    return f'pwl({s})'


def read_raw(path):
    b = open(path, 'rb').read()
    k = b.index(b'Binary:\n')
    head = b[:k].decode()
    nv = int(re.search(r'No\. Variables:\s*(\d+)', head).group(1))
    npt = int(re.search(r'No\. Points:\s*(\d+)', head).group(1))
    names = [ln.split()[1] for ln in head.split('Variables:')[-1].strip().splitlines()]
    data = np.frombuffer(b[k + 8:k + 8 + 8 * nv * npt], dtype='<f8').reshape(npt, nv)
    return {n: data[:, i] for i, n in enumerate(names)}


def main():
    os.makedirs(OUT, exist_ok=True)
    times = [TEN]
    for st in SEQ:
        times.append(times[-1] + 13.5 * t_est(st))
    tstop = times[-1]
    s = open(SRC).read()
    L = s.splitlines()
    i = next(k for k, ln in enumerate(L) if ln.startswith('.subckt bgr '))
    i += 1
    while L[i].startswith('+'):
        i += 1
    L.insert(i, 'Cichb ichb VGND 30f')
    s = '\n'.join(L) + '\n'
    lv = dict(ich=[1 if st[2] == 'half' else 0 for st in SEQ], i3=[st[0] for st in SEQ],
              chop=[1 if st[1] == 'B' else 0 for st in SEQ], sel=[1 if st[3] == 'EB' else 0 for st in SEQ])
    for src, net, key in (('Vich', 'ich_sel', 'ich'), ('Vi3', 'i3_sel', 'i3'), ('Vchop', 'chop_sel', 'chop'), ('Vsel', 'thr_sel', 'sel')):
        s = re.sub(rf'^{src} {net} 0 .*$', f'{src} {net} 0 {pwl(lv[key], times)}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {TEMP}', s, flags=re.M)
    s = re.sub(r'^tran 0\.2n \S+', f'tran 0.2n {tstop * 1e6:.3f}u', s, flags=re.M)
    deck, log, raw = (os.path.join(OUT, f) for f in ('deck.spice', 'deck.log', 'tog.raw'))
    if not (os.path.isfile(raw) and os.path.isfile(deck) and open(deck).read() == s and 'TOGDONE' in open(log).read()):
        open(os.path.join(OUT, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
        open(deck, 'w').write(s)
        r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=OUT, timeout=14400)
        open(log, 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    w = read_raw(raw)
    key = lambda part: next(n for n in w if part in n.lower())
    t, rst = w['time'], w[key('rst')]
    nodes = {'vref': w[key('vref')], 'veb3': w[key('veb3')], 'vpg': w[key('vpg')]}
    h = VDD / 2
    up = np.where((rst[:-1] < h) & (rst[1:] >= h))[0]
    edges = t[up] + (h - rst[up]) * (t[up + 1] - t[up]) / (rst[up + 1] - rst[up])

    def pmean(y, a, b):
        m = (t >= a) & (t <= b)
        return float(np.trapezoid(y[m], t[m]) / (t[m][-1] - t[m][0]))

    steps = []
    for k, st in enumerate(SEQ):
        e = edges[(edges > times[k]) & (edges < times[k + 1])]
        q = np.diff(e)
        Ts = float(np.mean(q[8:12]))
        ppm = [(x / Ts - 1) * 1e6 for x in q]
        later = [j for j in range(len(q)) if all(abs(p) <= 10 for p in ppm[j:])]
        nd = {}
        for n, y in nodes.items():
            pm = [pmean(y, e[j], e[j + 1]) for j in range(len(q))]
            ref = float(np.mean(pm[8:12]))
            nd[n] = dict(settled=ref, dev_uV=[(x - ref) * 1e6 for x in pm])
        steps.append(dict(state=st, changed=None if k == 0 else [c for c, a, b in zip(('i3_sel', 'chop_sel', 'ich_sel', 'thr_sel'), SEQ[k - 1], st) if a != b][0],
                          T=Ts, n=len(q), ppm=ppm, settled_from=(later[0] + 1) if later else None, nodes=nd))
    T = {s['state']: s['T'] for s in steps}
    mu = {(i3, ch, sl): 1 - T[(i3, ch, sl, 'EB')] / T[(i3, ch, sl, 'REF')] for i3 in (0, 1) for ch in 'AB' for sl in ('full', 'half')}
    ext = {}
    for i3 in (0, 1):
        for ch in 'AB':
            mf, mh = mu[(i3, ch, 'full')], mu[(i3, ch, 'half')]
            for nm, rr in (('ramp', R_RAMP), ('loop', R_LOOP)):
                k_ = rr / (1 - rr)
                ext[(i3, ch, nm)] = 1 / (1 / mh - k_ * (1 / mf - 1 / mh))
    chi_nom = next(float(r['chi_nom']) for r in csv.DictReader(open(os.path.join(SIM, 'pvt8', 'i3_table.csv')))
                   if r['corner'] == 'tt' and float(r['vdd_V']) == VDD and int(float(r['temp_C'])) == TEMP)
    res = {}
    for nm in ('ramp', 'loop'):
        m0 = (ext[(0, 'A', nm)] + ext[(0, 'B', nm)]) / 2
        m1 = (ext[(1, 'A', nm)] + ext[(1, 'B', nm)]) / 2
        res[nm] = dict(mu0=m0, mu0p=m1, chi=10 * (1 - m0) / m0 - 5 * (1 - m1) / m1 - 1 / 3,
                       vos_mV=(ext[(0, 'A', nm)] - ext[(0, 'B', nm)]) / 2 / S_MU, vos_p_mV=(ext[(1, 'A', nm)] - ext[(1, 'B', nm)]) / 2 / S_MU)
    mu_dc, mu_dcp = 1 - V[(0, 'EB')] / V[(0, 'REF')], 1 - V[(1, 'EB')] / V[(1, 'REF')]
    out = [f'# M6 10b: control toggles on the frozen bgr through swdrv (tt, {TEMP} C, 1.80 V)', '',
           f'{len(edges)} rst edges from the raw file; steps of 13.5 estimated periods.', '',
           '## Settling after each change (periods after the change vs the mean of periods 9-12)', '',
           '| step | state (i3, chop, slope, thr) | changed | T (us) | periods 1-12 (ppm) | within 10 ppm from period | slowest node, period 1 / period 8 (uV) |',
           '|---|---|---|---|---|---|---|']
    for k, s_ in enumerate(steps):
        worst = max(s_['nodes'], key=lambda n: abs(s_['nodes'][n]['dev_uV'][0]))
        dv = s_['nodes'][worst]['dev_uV']
        out.append(f"| {k + 1} | {s_['state']} | {s_['changed'] or 'osc_en'} | {s_['T'] * 1e6:.5f} | {' '.join(f'{p:.0f}' for p in s_['ppm'][:12])} "
                   f"| {s_['settled_from']} | {worst} {dv[0]:+.0f} / {dv[7]:+.1f} |")
    out += ['', '## mu per state', '', '| i3_sel | chop | slope | mu |', '|---|---|---|---|']
    for (i3, ch, sl), m in mu.items():
        out.append(f'| {i3} | {ch} | {sl} | {m:.6f} |')
    out += ['', '## Two-slope mu0, chop average, chi', '',
            f'mu_DC at rest (frozen bgr): {mu_dc:.5f} (i3_sel 0), {mu_dcp:.5f} (i3_sel 1). chi_nom (i3_table, tt 1.8 V {TEMP} C) = {chi_nom:.4f}.', '',
            '| r | mu0 A | mu0 B | mu0 chop | mu0\' A | mu0\' B | mu0\' chop | Vos est (mV) / half-current mode | chi | chi - chi_nom |',
            '|---|---|---|---|---|---|---|---|---|---|']
    for nm, rr in (('ramp', R_RAMP), ('loop', R_LOOP)):
        q_ = res[nm]
        out.append(f"| {rr} | {ext[(0, 'A', nm)]:.6f} | {ext[(0, 'B', nm)]:.6f} | {q_['mu0']:.6f} | {ext[(1, 'A', nm)]:.6f} | {ext[(1, 'B', nm)]:.6f} "
                   f"| {q_['mu0p']:.6f} | {q_['vos_mV']:+.3f} / {q_['vos_p_mV']:+.3f} | {q_['chi']:.4f} | {q_['chi'] - chi_nom:+.4f} |")
    txt = '\n'.join(out)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    json.dump(dict(times=times, steps=[{**s_, 'state': list(s_['state'])} for s_ in steps],
                   mu={str(k): v for k, v in mu.items()}, ext={str(k): v for k, v in ext.items()}, res=res, chi_nom=chi_nom),
              open(os.path.join(OUT, 'all.json'), 'w'), indent=1)
    print(txt)


if __name__ == '__main__':
    main()
