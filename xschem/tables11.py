#!/usr/bin/env python3
"""M6 11a: tadd_table.csv and rcoef_table.csv (spec M6 outputs, Appendix B.5, R14).
Grid: 5 MOS corners x -40 / -20 / 25 / 100 / 125 C x 1.71 / 1.80 / 1.89 V = 75 points.
Per point:
  - the ramp bench tb_cmp_corners.spice (section 3) with the frozen bgr values AT THAT corner, VDD and T
    (V_REF, V_EB3, I_PTAT from docs/mu_dc.csv; V_REF' from simulation/pvt8/i3_table.csv): t_d at full and half slope at
    V_EB3, V_REF' and V_REF, and the static offset from the .dc trip sweep -> t0 = t_d - Vos/s (the true delay, R14);
  - the one-shot bench tb_reset.spice (section 6): t_logic (cmp_raw -> sw) and t_rst (sw on).
t_add = t_d + t_logic + t_rst (what firmware subtracts in fast mode, raw t_d, offset included).
r = (t0_half + t_logic + t_rst) / (2 (t0_full + t_logic + t_rst)) (the two-slope coefficient from the true delay).
r(T) line: least squares over every corner and VDD at the REF threshold; residuals and the spread per T are reported.
Usage (in the container, after netlisting tb_cmp_corners.sch and tb_reset.sch):  python3 /foss/designs/tt_tsense/xschem/tables11.py
Writes simulation/tables11/: decks, logs, tadd_table.csv, rcoef_table.csv, summary.md; copies both tables to docs/.
"""
import csv, math, os, re, shutil, subprocess
from concurrent.futures import ThreadPoolExecutor
import numpy as np
import reset6

SIM = '/foss/designs/tt_tsense/xschem/simulation'
DOCS = '/foss/designs/tt_tsense/docs'
OUT = os.path.join(SIM, 'tables11')
SRC = os.path.join(SIM, 'tb_cmp_corners.spice')
CORNERS = ['tt', 'ss', 'ff', 'sf', 'fs']
TEMPS = [-40, -20, 25, 100, 125]
VDDS = [1.71, 1.8, 1.89]
C_OSC = 5.06e-12
ROWS = [('EB', 1), ("REF'", 3), ('REF', 5)]           # full-slope copy k; half-slope copy is k + 1

MU = {(r['corner'], float(r['vdd_V']), int(float(r['temp_C']))): (float(r['vref_V']), float(r['veb3_V']), float(r['i_ptat_nA']) * 1e-9)
      for r in csv.DictReader(open(os.path.join(DOCS, 'mu_dc.csv')))}
I3 = {(r['corner'], float(r['vdd_V']), int(float(r['temp_C']))): float(r['vref_half_V'])
      for r in csv.DictReader(open(os.path.join(SIM, 'pvt8', 'i3_table.csv')))}


def ramp(job):
    corner, t, vdd = job
    vref, veb3, ipt = MU[(corner, vdd, t)]
    vrefp = I3[(corner, vdd, t)]
    sl = ipt / 2 / C_OSC
    s = re.sub(r'\n\+', ' ', open(SRC).read())
    s = re.sub(r'sky130\.lib\.spice tt$', f'sky130.lib.spice {corner}', s, flags=re.M)
    s = re.sub(r'^\.param vref=.*$', f'.param vref={vref} veb3={veb3} vrefp={vrefp} sl={sl:.6g}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = re.sub(r'^Vdd VDPWR 0 \S+$', f'Vdd VDPWR 0 {vdd}', s, flags=re.M)
    s = re.sub(r'^Iref VDPWR nb \S+$', f'Iref VDPWR nb {ipt / 2:.6g}', s, flags=re.M)
    s = re.sub(r'^tran 0\.2n \S+', f'tran 0.2n {(0.3e-6 + 0.92 / sl + 0.2e-6) * 1e6:.3f}u', s, flags=re.M)
    cms = {1: veb3, 3: vrefp, 5: vref}
    s = re.sub(r'^dc vcap(\d) \S+ \S+ 5u$', lambda m: f'dc vcap{m.group(1)} {cms[int(m.group(1))] - 0.006:.5f} '
               f'{cms[int(m.group(1))] + 0.006:.5f} 5u', s, flags=re.M)
    s = s.replace(')=0.9 ', f')={vdd / 2:.4f} ')
    d = os.path.join(OUT, 'ramp', f'{corner}_{t}_{vdd}')
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=3600)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    v = {}
    for line in r.stdout.splitlines():
        if line.startswith('RESULT'):
            v.update({k: float(x) for k, x in re.findall(r'(\w+)=([-+0-9.eE]+)', line)})
    out = []
    for name, k in ROWS:
        cm = cms[k]
        td = (v.get(f'to{k}', math.nan) - (0.3e-6 + 0.4 / sl)) * 1e9
        tdh = (v.get(f'to{k + 1}', math.nan) - (0.3e-6 + 0.4 / (sl / 2))) * 1e9
        vos = (v.get(f'trip{k}', math.nan) - cm) * 1e3
        out.append(dict(corner=corner, temp=t, vdd=vdd, cm=name, cm_V=cm, slope=sl * 1e-6, td=td, tdh=tdh, vos=vos,
                        t0=td - vos / (sl * 1e-6), t0h=tdh - vos / (sl / 2 * 1e-6)))
    return out


def main():
    os.makedirs(OUT, exist_ok=True)
    reset6.OUT = os.path.join(OUT, 'reset')
    os.makedirs(reset6.OUT, exist_ok=True)
    jobs = [(c, t, v) for c in CORNERS for t in TEMPS for v in VDDS]
    with ThreadPoolExecutor(8) as ex:
        rr = list(ex.map(ramp, jobs))
        rs = list(ex.map(reset6.run, jobs))
    rst = {}
    for rows in rs:
        a = [x for x in rows if x['width_ns'] == 5][0]
        rst[(a['corner'], a['temp'], a['vdd'])] = (a['tlogic_ns'], a['sw_ns'])
    tadd, rco = [], []
    for rows in rr:
        for x in rows:
            tl, tr = rst[(x['corner'], x['temp'], x['vdd'])]
            nom = int(x['corner'] == 'tt' and x['vdd'] == 1.8)
            for sl_name, s_, td in (('full', x['slope'], x['td']), ('half', x['slope'] / 2, x['tdh'])):
                tadd.append(dict(source='sch', corner=x['corner'], vdd_V=x['vdd'], temp_C=x['temp'], cm=x['cm'], slope=sl_name,
                                 slope_V_per_us=round(s_, 5), t_d_ns=round(td, 3), t_logic_ns=round(tl, 3), t_rst_ns=round(tr, 3),
                                 t_add_ns=round(td + tl + tr, 3), nominal=nom))
            r_ = (x['t0h'] + tl + tr) / (2 * (x['t0'] + tl + tr))
            rco.append(dict(corner=x['corner'], vdd_V=x['vdd'], temp_C=x['temp'], cm=x['cm'], vos_mV=round(x['vos'], 4),
                            t0_full_ns=round(x['t0'], 3), t0_half_ns=round(x['t0h'], 3), t_logic_ns=round(tl, 3), t_rst_ns=round(tr, 3),
                            r=round(r_, 5), nominal=nom))
    for name, rows in (('tadd_table.csv', tadd), ('rcoef_table.csv', rco)):
        with open(os.path.join(OUT, name), 'w', newline='') as f:
            w = csv.DictWriter(f, list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
    L = ['# M6 11a: tadd_table and rcoef_table (5 corners x 5 T x 3 VDD, frozen bgr values per point)', '']
    for cm in ('REF', 'EB', "REF'"):
        sel = [x for x in rco if x['cm'] == cm]
        Tv = np.array([x['temp_C'] for x in sel], float)
        rv = np.array([x['r'] for x in sel], float)
        b, a = np.polyfit(Tv, rv, 1)
        res = rv - (a + b * Tv)
        nomres = [x['r'] - (a + b * x['temp_C']) for x in sel if x['nominal']]
        L += [f'## r at {cm}: line r(T) = {a:.5f} + {b * 1e3:.4f}e-3 * T[C]', '',
              f'- residual over all 75 points: max |r - line| = {np.max(np.abs(res)):.4f}; tt 1.80 V points: '
              + ', '.join(f'{v:+.4f}' for v in nomres), '',
              '| T (C) | r tt 1.80 V | r min | r max | spread about the mean | t0 full tt (ns) | t_add full tt (ns) |', '|---|---|---|---|---|---|---|']
        for t in TEMPS:
            x = [y for y in sel if y['temp_C'] == t]
            rr_ = [y['r'] for y in x]
            n = [y for y in x if y['nominal']][0]
            ta = [y for y in tadd if y['cm'] == cm and y['temp_C'] == t and y['nominal'] and y['slope'] == 'full'][0]
            L.append(f"| {t} | {n['r']:.4f} | {min(rr_):.4f} | {max(rr_):.4f} | ±{(max(rr_) - min(rr_)) / 2:.4f} | {n['t0_full_ns']:.2f} | {ta['t_add_ns']:.2f} |")
        L.append('')
    L += ['## t_add, full slope, at REF (ns): min / max over corners and VDD per T', '']
    for t in TEMPS:
        x = [y['t_add_ns'] for y in tadd if y['cm'] == 'REF' and y['temp_C'] == t and y['slope'] == 'full']
        L.append(f'- {t} C: {min(x):.1f} / {max(x):.1f} ns')
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    for name in ('tadd_table.csv', 'rcoef_table.csv'):
        shutil.copy(os.path.join(OUT, name), os.path.join(DOCS, name))
    print(txt)


if __name__ == '__main__':
    main()
