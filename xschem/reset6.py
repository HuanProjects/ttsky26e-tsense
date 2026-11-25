#!/usr/bin/env python3
"""M6 6: self-timed one-shot + reset switch. Fans tb_reset.spice out over tt ss ff sf fs x -20 25 100 C x 1.71 1.8 1.89 V.
Per point and per cmp_raw width (5 ns, 40 ns): rst width, sw (switch gate) width, sw fall time (90 -> 10 %),
t_logic (cmp_raw -> sw), the pedestal with the real driver edge, and t_on / (R_on C) with R_on from simulation/rsw5/grid.csv.
Usage (in the container, after netlisting tb_reset.sch and running rsw5.py):  python3 /foss/designs/tt_tsense/xschem/reset6.py
Writes simulation/reset6/: decks, logs, all.csv, summary.md.
"""
import csv, os, re, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_reset.spice')
OUT = os.path.join(SIM, 'reset6')
CORNERS = ['tt', 'ss', 'ff', 'sf', 'fs']
TEMPS = [-20, 25, 100]
VDDS = [1.71, 1.8, 1.89]
C_OSC = 5.06e-12
T_CK = 400.1e-9                      # cmp_raw crosses VDD/2


def run(job):
    corner, t, vdd = job
    s = open(SRC).read()
    s = re.sub(r'sky130\.lib\.spice \S+$', f'sky130.lib.spice {corner}', s, flags=re.M)
    s = re.sub(r'^\.param vdd=\S+$', f'.param vdd={vdd}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = s.replace(')=0.9 ', f')={vdd / 2:.4f} ').replace(')=1.62 ', f')={0.9 * vdd:.4f} ').replace(')=0.18 ', f')={0.1 * vdd:.4f} ')
    d = os.path.join(OUT, f'{corner}_{t}_{vdd}')
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=1800)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    rows = []
    for line in r.stdout.splitlines():
        if line.startswith('R k='):
            v = {k: float(x) for k, x in re.findall(r'(\w+)=([-+0-9.eE]+)', line)}
            rows.append(dict(corner=corner, temp=t, vdd=vdd, width_ns=5 if v['k'] == 1 else 40,
                             rst_ns=(v['trf'] - v['trr']) * 1e9, sw_ns=(v['tsf'] - v['tsr']) * 1e9,
                             fall_ns=(v['t10'] - v['t90']) * 1e9, tlogic_ns=(v['tsr'] - T_CK) * 1e9,
                             vpre_V=v['vpre'], ped0_mV=v['ped0'] * 1e3, ped_mV=v['ped'] * 1e3, again_V=v['again']))
    return rows


def main():
    os.makedirs(OUT, exist_ok=True)
    ron = {(r['corner'], int(r['temp']), float(r['vdd'])): float(r['ron'])
           for r in csv.DictReader(open(os.path.join(SIM, 'rsw5', 'grid.csv')))}
    jobs = [(c, t, v) for c in CORNERS for t in TEMPS for v in VDDS]
    with ThreadPoolExecutor(8) as ex:
        rows = [r for rs in ex.map(run, jobs) for r in rs]
    for r in rows:
        r['ron'] = ron[(r['corner'], r['temp'], r['vdd'])]
        r['ratio'] = r['sw_ns'] * 1e-9 / (r['ron'] * C_OSC)
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)
    def rng(key, sel=lambda r: True):
        x = [r[key] for r in rows if sel(r)]
        return min(x), max(x)
    L = ['# M6 6: self-timed one-shot and reset switch (45 points x cmp_raw 5 / 40 ns)', '',
         '| corner | T | VDD | rst 5 / 40 ns in (ns) | sw on (ns) | sw fall (ns) | t_logic (ns) | R_on (ohm) | sw on / R_on C | pedestal (mV) |',
         '|---|---|---|---|---|---|---|---|---|---|']
    for c in CORNERS:
        for t in TEMPS:
            for v in VDDS:
                a, b = [r for r in rows if r['corner'] == c and r['temp'] == t and r['vdd'] == v]
                L.append(f"| {c} | {t} | {v} | {a['rst_ns']:.2f} / {b['rst_ns']:.2f} | {a['sw_ns']:.2f} | {a['fall_ns']:.2f} "
                         f"| {a['tlogic_ns']:.2f} | {a['ron']:.0f} | {a['ratio']:.1f} | {a['ped_mV']:+.2f} |")
    d = max(abs(a['rst_ns'] - b['rst_ns']) for a, b in zip(rows[0::2], rows[1::2]))
    L += ['', f"- rst width {rng('rst_ns')[0]:.2f}–{rng('rst_ns')[1]:.2f} ns; 5 ns vs 40 ns cmp_raw differ by at most {d:.3f} ns.",
          f"- sw on {rng('sw_ns')[0]:.2f}–{rng('sw_ns')[1]:.2f} ns; sw fall (90→10 %) {rng('fall_ns')[0]:.2f}–{rng('fall_ns')[1]:.2f} ns; "
          f"t_logic {rng('tlogic_ns')[0]:.2f}–{rng('tlogic_ns')[1]:.2f} ns.",
          f"- sw on / (R_on C): min {rng('ratio')[0]:.1f} (limit 7).",
          f"- pedestal {rng('ped_mV')[0]:+.2f} to {rng('ped_mV')[1]:+.2f} mV (at the osc_en release {rng('ped0_mV')[0]:+.2f} to {rng('ped0_mV')[1]:+.2f}).",
          f"- vcap before the reset {rng('vpre_V')[0]:.3f}–{rng('vpre_V')[1]:.3f} V; largest rst after the pulse {rng('again_V')[1] * 1e3:.3f} mV (no retrigger)."]
    for t in TEMPS:
        x = [r['ped_mV'] for r in rows if r['temp'] == t]
        tt = next(r['ped_mV'] for r in rows if r['temp'] == t and r['corner'] == 'tt' and r['vdd'] == 1.8)
        L.append(f"- pedestal at {t} C: tt {tt:+.2f} mV, spread about tt {min(x) - tt:+.2f} / {max(x) - tt:+.2f} mV")
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
