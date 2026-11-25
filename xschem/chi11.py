#!/usr/bin/env python3
"""M6 11e: where does the -20 C chi_loop miss come from (section 11)?
tb_osc_tog.spice held in one state per run (chop A), 30 fF on ichb, reltol 1e-4, osc_en at 120 us, about 10 periods.
States: i3_sel 0/1 x full/half x REF/EB, at -20 and 25 C (16 runs, in parallel).
A 0 V source between the bgr vcap pin and the vcap node measures I_ch.
Per period (periods 5 on) the period is split into: ramp (rst falls -> vcap crosses vthr), t_d (crossing ->
cmp_raw rises), logic (cmp_raw -> rst rises), reset (rst rises -> rst falls). Also: vcap at ramp start, vthr and
vref at the crossing against the DC table value, the mean I_ch over the ramp, and the charge Q = int I_ch dt.
Then mu per state, the two-slope mu0 (r 0.565), chi (chop A) against chi_nom, and the half-slope-only check
(tau_h from the normal-mode two-slope, applied to the i3_sel = 1 half-slope periods).
Usage (in the container, after netlisting tb_osc_tog.sch):  python3 /foss/designs/tt_tsense/xschem/chi11.py [variant]
Variants (diagnostics only; bgr stays frozen), each writing simulation/chi11_<variant>/:
  lvt    the ich transmission gate inside bgr (XS_ichon_n/p, frozen as standard nfet 2/0.5 + pfet 4/0.5) swapped to
         lvt devices of the same size (spec R4: ichb lifts above vcap while the ramp crosses the gate's dead zone)
  ideal  the same gate replaced by an ideal switch (500 ohm on, 1e12 off, driven by ich_on)
  ss     frozen design at ss, 1.71 V, -20 C only (the R4 check point)
"""
import csv, json, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
import numpy as np
import tog10

VARIANT = sys.argv[1] if len(sys.argv) > 1 and __name__ == '__main__' else ''
SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_osc_tog.spice')
T_ENV = os.environ.get('CHI11_T', '')  # optional: CHI11_T=100 runs only those temperatures (own folder)
OUT = os.path.join(SIM, 'chi11' + (f'_{VARIANT}' if VARIANT else '') + (f'_{T_ENV.replace(",", "_")}' if T_ENV else ''))
CORNER, VDD = ('ss', 1.71) if VARIANT == 'ss' else ('tt', 1.8)
TEN, C_OSC = 120e-6, 5.06e-12
TEMPS = tuple(int(t) for t in T_ENV.split(',')) if T_ENV else ((-20,) if VARIANT == 'ss' else (-20, 25))
STATES = [(T, i3, sl, th) for T in TEMPS for i3 in (0, 1) for sl in ('full', 'half') for th in ('REF', 'EB')]
K = 0.565 / 0.435


def deck(st):
    T, i3, sl, th = st
    ipt, V = tog10.VALS[T]
    t_est = 1.076 * C_OSC * V[(i3, th)] / (ipt / 2 / (2 if sl == 'half' else 1)) + 100e-9
    s = open(SRC).read()
    L = s.splitlines()
    i = next(k for k, ln in enumerate(L) if ln.startswith('.subckt bgr '))
    i += 1
    while L[i].startswith('+'):
        i += 1
    L.insert(i, 'Cichb ichb VGND 30f')
    s = '\n'.join(L) + '\n'
    s = re.sub(r'^(x1 .*?) vcap (.* bgr)$', r'\1 vcap_i \2', s, flags=re.M)
    assert ' vcap_i ' in s
    s = s.replace('Vmon iptat_mon 0 0.7', 'Vmon iptat_mon 0 0.7\nVichm vcap_i vcap 0')
    for src, net, lv in (('Vich', 'ich_sel', sl == 'half'), ('Vi3', 'i3_sel', i3), ('Vchop', 'chop_sel', 0), ('Vsel', 'thr_sel', th == 'EB')):
        s, n = re.subn(rf'^{src} {net} 0 .*$', f'{src} {net} 0 {int(lv) * VDD}', s, flags=re.M)
        assert n == 1
    if VARIANT == 'lvt':
        s, n1 = re.subn(r'^(XS_ichon_n .*?)sky130_fd_pr__nfet_01v8 ', r'\1sky130_fd_pr__nfet_01v8_lvt ', s, flags=re.M)
        s, n2 = re.subn(r'^(XS_ichon_p .*?)sky130_fd_pr__pfet_01v8 ', r'\1sky130_fd_pr__pfet_01v8_lvt ', s, flags=re.M)
        assert n1 == 1 and n2 == 1
    if VARIANT == 'ideal':
        s, n1 = re.subn(r'^XS_ichon_n .*\n(\+.*\n)*', 'Sich ichb ich ich_on VGND swich\n', s, flags=re.M)
        s, n2 = re.subn(r'^XS_ichon_p .*\n(\+.*\n)*', '', s, flags=re.M)
        assert n1 == 1 and n2 == 1
        s = s.replace('.option method=gear', '.model swich sw vt=0.9 vh=0.1 ron=500 roff=1e12\n.option method=gear')
    if VARIANT == 'ss':
        s, n1 = re.subn(r'^(\.lib \S+sky130\.lib\.spice) tt$', r'\1 ss', s, flags=re.M)
        s, n2 = re.subn(r'^\.param vdd=1\.8 ', '.param vdd=1.71 ', s, flags=re.M)
        assert n1 == 1 and n2 == 1
    s = re.sub(r'^\.temp \S+$', f'.temp {T}', s, flags=re.M)
    s = s.replace('.option method=gear', '.option method=gear reltol=1e-4')
    s = re.sub(r'^save .*$', 'save rst vcap x2.vthr cmp_raw vref veb3 x1.vpg vichm#branch', s, flags=re.M)
    s = re.sub(r'^tran 0\.2n \S+', f'tran 0.2n {(TEN + 10.5 * t_est) * 1e6:.3f}u', s, flags=re.M)
    return s


def run(st):
    T, i3, sl, th = st
    d = os.path.join(OUT, f'{T}_{i3}_{sl}_{th}')
    os.makedirs(d, exist_ok=True)
    s, raw = deck(st), os.path.join(d, 'tog.raw')
    if not (os.path.isfile(raw) and os.path.isfile(os.path.join(d, 'deck.spice')) and open(os.path.join(d, 'deck.spice')).read() == s):
        open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\n')
        open(os.path.join(d, 'deck.spice'), 'w').write(s)
        r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=14400)
        open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    w = tog10.read_raw(raw)
    g = lambda part: w[next(n for n in w if n.lower() == part)]
    t, rst, vc, vt, cr = w['time'], g('v(rst)'), g('v(vcap)'), g('v(x2.vthr)'), g('v(cmp_raw)')
    vr, ve, ic = g('v(vref)'), g('v(veb3)'), g('i(vichm)')
    h = VDD / 2

    def edges(y, lvl, rising=True):
        k = np.where((y[:-1] < lvl) & (y[1:] >= lvl))[0] if rising else np.where((y[:-1] >= lvl) & (y[1:] < lvl))[0]
        return t[k] + (lvl - y[k]) * (t[k + 1] - t[k]) / (y[k + 1] - y[k])

    def at(y, tt):
        return float(np.interp(tt, t, y))

    up, dn, cu = edges(rst, h), edges(rst, h, False), edges(cr, h)
    dn = dn[dn > TEN]
    per = []
    for j in range(len(dn) - 1):
        a = dn[j]
        nx_up = up[up > a]
        if len(nx_up) == 0:
            break
        b = nx_up[0]
        m = (t >= a) & (t <= b)
        idx = np.where(m)[0]
        dv = vc[idx] - vt[idx]
        k = np.where((dv[:-1] < 0) & (dv[1:] >= 0))[0]
        if len(k) == 0:
            continue
        k0 = idx[k[0]]
        tc = t[k0] + (-dv[k[0]]) * (t[k0 + 1] - t[k0]) / (dv[k[0] + 1] - dv[k[0]])
        tcmp = cu[(cu > tc)][0]
        nx_dn = dn[dn > b]
        if len(nx_dn) == 0:
            break
        mr = (t >= a) & (t <= tc)
        Q = float(np.trapezoid(ic[mr], t[mr]))
        per.append(dict(ramp=tc - a, td=tcmp - tc, logic=b - tcmp, reset=nx_dn[0] - b, T=nx_dn[0] - a,
                        v0=at(vc, a), vthr_c=at(vt, tc), vref_c=at(vr, tc), veb_c=at(ve, tc),
                        slope=(at(vc, tc + 1e-9) - at(vc, tc - 1e-9)) / 2e-9, I=Q / (tc - a), Q=Q))
    per = per[4:]
    avg = {k: float(np.mean([p[k] for p in per])) for k in per[0]}
    avg['n'] = len(per)
    avg['T_std_ppm'] = float(np.std([p['T'] for p in per]) / avg['T'] * 1e6)
    _, V = tog10.VALS[T]
    avg['vdc'] = V[(i3, th)]
    return st, avg


def main():
    os.makedirs(OUT, exist_ok=True)
    with ThreadPoolExecutor(len(STATES)) as ex:
        res = dict(ex.map(run, STATES))
    json.dump({str(k): v for k, v in res.items()}, open(os.path.join(OUT, 'all.json'), 'w'), indent=1)
    tag = {'lvt': ' -- DIAGNOSTIC: ich TG swapped to lvt', 'ideal': ' -- DIAGNOSTIC: ich TG replaced by an ideal switch',
           'ss': ' -- frozen design at ss, 1.71 V'}.get(VARIANT, '')
    L = [f'# M6 11e: one state per run, period split ({CORNER} {VDD:.2f} V, chop A, reltol 1e-4, periods 5 on){tag}', '',
         '| T | i3 | slope | thr | n | T (us) | ramp (us) | t_d (ns) | logic (ns) | reset (ns) | v0 (mV) | vthr_c - V_DC (mV) | vref_c - V_DC (mV) | slope (V/us) | I_ch (uA) | Q (fC) |',
         '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|']
    for st, a in res.items():
        T, i3, sl, th = st
        vdc = a['vdc']
        vnode = a['vref_c'] if th == 'REF' else a['veb_c']
        L.append(f"| {T} | {i3} | {sl} | {th} | {a['n']} | {a['T'] * 1e6:.6f} | {a['ramp'] * 1e6:.6f} | {a['td'] * 1e9:.3f} | {a['logic'] * 1e9:.3f} "
                 f"| {a['reset'] * 1e9:.3f} | {a['v0'] * 1e3:+.3f} | {(a['vthr_c'] - vdc) * 1e3:+.3f} | {(vnode - vdc) * 1e3:+.3f} "
                 f"| {a['slope'] * 1e-6:.5f} | {a['I'] * 1e6:.5f} | {a['Q'] * 1e15:.2f} |")
    if VARIANT == 'ss':
        L += ['', '(V_DC column = tt table values; ignore it at ss.)']
    L += ['', '## mu per (T, i3, slope) and the two-slope mu0 (r 0.565)', '', '| T | i3 | mu full | mu half | mu0 | mu0 from t_d removed |', '|---|---|---|---|---|---|']
    M0, MU = {}, {}
    P = {st: a['T'] for st, a in res.items()}
    for T in TEMPS:
        for i3 in (0, 1):
            mu = {sl: 1 - P[(T, i3, sl, 'EB')] / P[(T, i3, sl, 'REF')] for sl in ('full', 'half')}
            mu0 = 1 / (1 / mu['half'] - K * (1 / mu['full'] - 1 / mu['half']))
            mt = {sl: 1 - (P[(T, i3, sl, 'EB')] - res[(T, i3, sl, 'EB')]['td']) / (P[(T, i3, sl, 'REF')] - res[(T, i3, sl, 'REF')]['td']) for sl in ('full', 'half')}
            L.append(f"| {T} | {i3} | {mu['full']:.6f} | {mu['half']:.6f} | {mu0:.6f} | {mt['full']:.6f} / {mt['half']:.6f} |")
            M0[(T, i3)], MU[(T, i3)] = mu0, mu
    L += ['', '## chi (chop A only) against chi_nom: two-slope check and half-slope-only check', '']
    for T in TEMPS:
        cn = next(float(r['chi_nom']) for r in csv.DictReader(open(os.path.join(SIM, 'pvt8', 'i3_table.csv')))
                  if r['corner'] == CORNER and abs(float(r['vdd_V']) - VDD) < 1e-6 and int(float(r['temp_C'])) == T)
        m0, m1 = M0[(T, 0)], M0[(T, 1)]
        f, hf = MU[(T, 0)]['full'], MU[(T, 0)]['half']
        tau_h = K * (1 / f - 1 / hf) * (P[(T, 0, 'half', 'REF')] - P[(T, 0, 'half', 'EB')])
        m1h = 1 / (1 / MU[(T, 1)]['half'] - tau_h / (P[(T, 1, 'half', 'REF')] - P[(T, 1, 'half', 'EB')]))
        chi = lambda x: 10 * (1 - m0) / m0 - 5 * (1 - x) / x - 1 / 3
        L.append(f'- {T} C: chi_nom {cn:.4f}; two-slope check chi {chi(m1):.4f} ({chi(m1) - cn:+.4f}); '
                 f'half-slope-only check (tau_h {tau_h * 1e9:.2f} ns) chi {chi(m1h):.4f} ({chi(m1h) - cn:+.4f}); mu0 {m0:.6f}')
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
