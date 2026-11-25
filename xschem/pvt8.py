#!/usr/bin/env python3
"""M5 8b: fan tb_bg_pvt.spice out over 15 corners x 5 supplies (8 temperatures inside each deck),
check the spec rows, and write i3_table.csv.

Usage (in the container, after netlisting tb_bg_pvt.sch):
  python3 /foss/designs/tt_tsense/xschem/pvt8.py
Writes simulation/pvt8/: one deck + log per corner/supply, all.csv, i3_table.csv, summary.md.
Guaranteed points: -20..100 C and 1.71/1.80/1.89 V. -40/125 C and 1.62/1.98 V are characterized (reported, not judged).
"""
import csv, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_bg_pvt.spice')
CORNERS = ['tt', 'll', 'hh', 'ss', 'ss_ll', 'ss_hh', 'ff', 'ff_ll', 'ff_hh',
           'sf', 'sf_ll', 'sf_hh', 'fs', 'fs_ll', 'fs_hh']
VDDS = ['1.62', '1.71', '1.8', '1.89', '1.98']
G_T = {-20, 0, 25, 50, 75, 100}
G_V = {'1.71', '1.8', '1.89'}

# (row name, column, lo, hi, applies to) -- the spec's M5 rows that tb_bg_pvt owns
LIMITS = [
    ('I_PTAT 2.0-4.0 uA', 'Iptat_nA', 2000, 4000, 'PVT'),
    ('V_REF 1.23-1.28 V (B14)', 'vref_V', 1.23, 1.28, 'PVT'),
    ('I_B/I_PTAT 0.45-0.55', 'IB_ratio', 0.45, 0.55, 'PVT'),
    ('tail V_SD - V_dsat >= 50 mV', 'tail_margin_mV', 50, None, 'PVT'),
    ('P3 V_SD - V_dsat >= 0.1 V', 'p3_margin_mV', 100, None, 'PVT'),
    ('vpg 0.19-0.95 V', 'vpg_V', 0.19, 0.95, 'PVT'),
    ('su <= 0.2 V (normal)', 'su_mV', None, 200, 'PVT'),
    ('startup static <= 0.1 uA', 'Imsu1_nA', None, 100, 'PVT'),
    ('|Vos| <= 1 mV (else off-design OP)', 'vos_abs_uV', None, 1000, 'PVT'),
    ("V_REF' 0.50-1.30 V", 'vref_V', 0.50, 1.30, 'HALF'),
    ("V_EB3' 0.50-1.30 V", 'veb3_V', 0.50, 1.30, 'HALF'),
    ('rho 0.49-0.51', 'rho', 0.49, 0.51, 'HALF'),
    ("su <= 0.2 V (i3_sel 1)", 'su_mV', None, 200, 'HALF'),
    ('I(vcap) half 0.485-0.515', 'Ich_ratio', 0.485, 0.515, 'SLOPE'),
]
CV_LIMIT = 2.6e-4   # |mu(1.89) - mu(1.71)| = 1 C/V


def deck(src, c, v):
    s = re.sub(r'sky130\.lib\.spice tt$', f'sky130.lib.spice {c}', src, flags=re.M)
    s = re.sub(r'^(V\w+ \w+ 0) 1\.8$', rf'\1 {v}', s, flags=re.M)
    s = re.sub(r'^let vd = \S+$', f'let vd = {v}', s, flags=re.M)
    s = re.sub(r'v\(x1\.vpg\)=\S+', f'v(x1.vpg)={float(v) - 1.25:.2f}', s)
    for tag in ('PVT', 'HALF', 'SLOPE'):
        s = s.replace(f'echo {tag} temp=', f'echo {tag} corner={c} vdd={v} temp=')
    return s


def confirm_deck(src, c, v, t):
    """An op that lands off-design (|Vos| > 1 mV) is checked the 5b way: power up with a 1 us ramp, 300 us."""
    s = deck(src, c, v)
    s = re.sub(r'^(V\w+ \w+ 0) ' + re.escape(v) + '$', rf'\1 pwl(0 0 1u {v})', s, flags=re.M)
    s = re.sub(r'^\.nodeset .*\n', '', s, flags=re.M)
    ctl = (f'.control\noption reltol=1e-4\noption temp={t}\ntran 20n 300u 0 50n\n'
           'let ip = 2*i(v7)*1e9\nlet vos = (v(x1.vb)-v(x1.va))*1e6\n'
           'meas tran ipe find ip at=300u\nmeas tran vre find v(vref) at=300u\nmeas tran vose find vos at=300u\n'
           f'echo CONFIRM corner={c} vdd={v} temp={t} Iptat_nA=$&ipe vref_V=$&vre vos_uV=$&vose\n.endc\n')
    return re.sub(r'^\.control\n.*?^\.endc\n', lambda m: ctl, s, flags=re.M | re.S)


def run(path):
    subprocess.run(f'ngspice -b {os.path.basename(path)} > {os.path.basename(path)}.log 2>&1',
                   shell=True, cwd=os.path.dirname(path))
    out = []
    with open(path + '.log') as f:
        for line in f:
            w = line.split()
            if w and w[0] in ('PVT', 'HALF', 'SLOPE', 'CONFIRM'):
                out.append((w[0], dict(kv.split('=', 1) for kv in w[1:])))
    return out


def fnum(x):
    try: return float(x)
    except (TypeError, ValueError): return float('nan')


def main():
    src = open(SRC).read().replace('\r', '')
    if len(re.findall(r'^\.lib ', src, flags=re.M)) != 1:
        sys.exit('tb_bg_pvt.spice must have exactly one .lib line (the CORNER symbol gives it)')
    if 'echo PVT temp=' not in src:
        sys.exit('netlist tb_bg_pvt.sch first')
    out = os.path.join(SIM, 'pvt8')
    os.makedirs(out, exist_ok=True)
    with open(os.path.expanduser('~/.spiceinit')) as f:
        init = re.sub(r'^set num_threads=.*$', 'set num_threads=1', f.read(), flags=re.M)
    open(os.path.join(out, '.spiceinit'), 'w').write(init)
    paths = []
    for c in CORNERS:
        for v in VDDS:
            p = os.path.join(out, f'p_{c}_{v}.spice')
            open(p, 'w').write(deck(src, c, v))
            paths.append(p)
    print(f'{len(paths)} decks (8 temperatures x 3 states each), 12 at a time ...', flush=True)
    with ThreadPoolExecutor(12) as ex:
        res = list(ex.map(run, paths))

    # merge the three lines of each point
    pts = {}
    for lines in res:
        for tag, d in lines:
            k = (d['corner'], d['vdd'], int(float(d['temp'])))
            pts.setdefault(k, {})[tag] = d
    nexp = len(CORNERS) * len(VDDS) * 8
    rows = []
    for (c, v, t), p in sorted(pts.items(), key=lambda kv: (CORNERS.index(kv[0][0]), float(kv[0][1]), kv[0][2])):
        r = {'corner': c, 'vdd': v, 'temp': t, 'guaranteed': int(t in G_T and v in G_V)}
        for tag in ('PVT', 'HALF', 'SLOPE'):
            for key, val in p.get(tag, {}).items():
                if key not in ('corner', 'vdd', 'temp'):
                    r[f'{tag}.{key}'] = val
        if 'PVT.vos_uV' in r:
            r['PVT.vos_abs_uV'] = abs(fnum(r['PVT.vos_uV']))
        r['op_off'] = int(not fnum(r.get('PVT.vos_abs_uV')) <= 1000)
        rows.append(r)
    # power up every off-design point by transient (does the real circuit get to the design point?)
    off = [r for r in rows if r['op_off']]
    if off:
        cpaths = []
        for r in off:
            p = os.path.join(out, f"c_{r['corner']}_{r['vdd']}_{r['temp']}.spice")
            open(p, 'w').write(confirm_deck(src, r['corner'], r['vdd'], r['temp']))
            cpaths.append(p)
        print(f'{len(off)} off-design op points: confirming by transient ...', flush=True)
        with ThreadPoolExecutor(12) as ex:
            cres = list(ex.map(run, cpaths))
        for r, lines in zip(off, cres):
            for tag, d in lines:
                for key in ('Iptat_nA', 'vref_V', 'vos_uV'):
                    r[f'CONFIRM.{key}'] = d.get(key)
    cols = []
    for r in rows:
        for k in r:
            if k not in cols: cols.append(k)
    with open(os.path.join(out, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, cols); w.writeheader(); w.writerows(rows)
    with open(os.path.join(out, 'i3_table.csv'), 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['corner', 'vdd_V', 'temp_C', 'rho', 'vref_half_V', 'veb3_half_V', 'mu_half', 'su_half_mV', 'chi_nom', 'op_off'])
        for r in rows:   # op_off = 1: the normal-state op landed off-design, so this row's numbers are not real
            w.writerow([r['corner'], r['vdd'], r['temp']] + [r.get(f'HALF.{k}', '') for k in
                        ('rho', 'vref_V', 'veb3_V', 'mu', 'su_mV', 'chi_nom')] + [r['op_off']])

    # judge
    L = ['# M5 PVT x VDD (`tb_bg_pvt`, `pvt8.py`)', '',
         f'{len(rows)} points read of {nexp} (15 corners x 5 VDD x 8 T). Guaranteed = -20..100 C and 1.71-1.89 V; '
         'the rest is characterized (range shown, not judged).', '',
         '| row | guaranteed min .. max (where) | characterized min .. max | guaranteed fails |', '|---|---|---|---|']
    fails = []
    for name, col, lo, hi, tag in LIMITS:
        key = f'{tag}.{col}'
        ok = lambda r: col == 'vos_abs_uV' or not r['op_off']   # off-design op points are listed below, not judged
        g = [(fnum(r.get(key)), r) for r in rows if r['guaranteed'] and key in r and ok(r)]
        a = [(fnum(r.get(key)), r) for r in rows if key in r and ok(r)]
        if not a:
            L.append(f'| {name} | no data | | |'); continue
        gmin = min(g, key=lambda x: x[0]); gmax = max(g, key=lambda x: x[0])
        amin = min(a, key=lambda x: x[0])[0]; amax = max(a, key=lambda x: x[0])[0]
        bad = [(x, r) for x, r in g if (lo is not None and not x >= lo) or (hi is not None and not x <= hi)]
        for x, r in bad:
            fails.append(f"{name}: {r['corner']} {r['vdd']} V {r['temp']} C = {x:g}")
        where = lambda x: f"{x[1]['corner']} {x[1]['vdd']} V {x[1]['temp']} C"
        L.append(f'| {name} | {gmin[0]:.5g} ({where(gmin)}) .. {gmax[0]:.5g} ({where(gmax)}) | '
                 f'{amin:.5g} .. {amax:.5g} | {len(bad)} |')
    # core C/V
    cv = []
    for c in CORNERS:
        for t in sorted(G_T):
            a = next((r for r in rows if r['corner'] == c and r['vdd'] == '1.71' and r['temp'] == t), None)
            b = next((r for r in rows if r['corner'] == c and r['vdd'] == '1.89' and r['temp'] == t), None)
            if a and b and not (a['op_off'] or b['op_off']):
                cv.append((fnum(b['PVT.mu']) - fnum(a['PVT.mu']), c, t))
    if cv:
        w = max(cv, key=lambda x: abs(x[0]))
        nbad = sum(abs(x[0]) > CV_LIMIT for x in cv)
        L.append(f'| core C/V: abs(mu(1.89) - mu(1.71)) <= 2.6e-4 | worst {w[0]:+.3e} ({w[1]} {w[2]} C) | | {nbad} |')
        fails += [f'C/V: {c} {t} C = {d:+.3e}' for d, c, t in cv if abs(d) > CV_LIMIT]
    # reports (no limit here)
    tt25 = next((r for r in rows if r['corner'] == 'tt' and r['vdd'] == '1.8' and r['temp'] == 25), None)
    tt0 = next((r for r in rows if r['corner'] == 'tt' and r['vdd'] == '1.8' and r['temp'] == -20), None)
    tt1 = next((r for r in rows if r['corner'] == 'tt' and r['vdd'] == '1.8' and r['temp'] == 100), None)
    L += ['', '**Reports (tt, 1.80 V):**']
    if tt25:
        L.append(f"- mu_DC(25 C) = {fnum(tt25['PVT.mu']):.5f} (spec 0.434 +/- 0.025); "
                 f"I_PTAT(25 C) = {fnum(tt25['PVT.Iptat_nA']):.1f} nA; Vos(25 C) = {fnum(tt25['PVT.vos_uV']):.1f} uV")
    if tt0 and tt1:
        L.append(f"- dmu/dT over -20..100 C = {(fnum(tt1['PVT.mu']) - fnum(tt0['PVT.mu'])) / 120:.4e} /K (spec 1.456e-3 +/- 5 %)")
    h125 = [(fnum(r.get('PVT.Imsu2_pA')), r) for r in rows if r['temp'] == 125 and 'PVT.Imsu2_pA' in r]
    if h125:
        m = max(h125, key=lambda x: x[0])
        L.append(f"- MSU2 leakage into vpg at 125 C: max {m[0]:.3g} pA ({m[1]['corner']} {m[1]['vdd']} V), limit 1000 pA")
    chi = [fnum(r.get('HALF.chi_nom')) for r in rows if r['guaranteed'] and 'HALF.chi_nom' in r and not r['op_off']]
    if chi:
        L.append(f'- chi_nom over the guaranteed points: {min(chi):.4f} .. {max(chi):.4f} (i3_table.csv has every point)')
        # spread over corners and VDD at each T (limit 0.02; -20 C is a documented exception at 0.023)
        L.append('- chi_nom spread per T (limit 0.02). A half-mode op can still land off-design, '
                 'so confirm an outlying end by transient:')
        for t in sorted(G_T):
            s = sorted((fnum(r['HALF.chi_nom']), r) for r in rows
                       if r['guaranteed'] and r['temp'] == t and 'HALF.chi_nom' in r and not r['op_off'])
            if s:
                lo, hi = s[0], s[-1]
                L.append(f"  - {t} C: spread {hi[0] - lo[0]:.4f} (min {lo[1]['corner']} {lo[1]['vdd']} V, "
                         f"max {hi[1]['corner']} {hi[1]['vdd']} V)")
    offr = [r for r in rows if r['op_off']]
    if offr:
        L += ['', f'**{len(offr)} op points landed off-design** (|Vos| > 1 mV); they are left out of every row above except the Vos row. '
              'Each was powered up with a 1 us ramp instead (300 us):', '',
              '| corner | vdd | temp | guaranteed | op: I_PTAT nA, vref V, Vos uV | ramp, 300 us: I_PTAT nA, vref V, Vos uV |', '|---|---|---|---|---|---|']
        for r in offr:
            L.append(f"| {r['corner']} | {r['vdd']} | {r['temp']} | {r['guaranteed']} | "
                     f"{fnum(r.get('PVT.Iptat_nA')):.1f}, {fnum(r.get('PVT.vref_V')):.5f}, {fnum(r.get('PVT.vos_uV')):.0f} | "
                     f"{fnum(r.get('CONFIRM.Iptat_nA')):.1f}, {fnum(r.get('CONFIRM.vref_V')):.5f}, {fnum(r.get('CONFIRM.vos_uV')):.1f} |")
    L += ['', f'**{len(fails)} guaranteed failures**' + (':' if fails else '.')] + [f'- {x}' for x in fails[:40]]
    if len(rows) < nexp:
        L.append(f'\n**{nexp - len(rows)} points missing** - check the .log files in pvt8/.')
    open(os.path.join(out, 'summary.md'), 'w').write('\n'.join(L) + '\n')
    print('\n'.join(L))


if __name__ == '__main__':
    main()
