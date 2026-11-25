#!/usr/bin/env python3
"""M6 10a: swdrv gaps and overlaps. Fans tb_swdrv.spice out over tt ss ff sf fs x -20 25 100 C x 1.71 1.8 1.89 V.
Gaps (ns, break before make, must be > 0): ich and i3 'on' fall -> 'dump' rise and back, both for the NMOS gate (on) and
for the TG fully off (onb, the PMOS gate); swa -> swb and back. Overlaps (ns, make before break, must be > 0): chop / chopb.
Usage (in the container, after netlisting tb_swdrv.sch):  python3 /foss/designs/tt_tsense/xschem/sw10.py
Writes simulation/sw10/: decks, logs, all.csv, summary.md.
"""
import csv, os, re, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_swdrv.spice')
OUT = os.path.join(SIM, 'sw10')
JOBS = [(c, t, v) for c in ('tt', 'ss', 'ff', 'sf', 'fs') for t in (-20, 25, 100) for v in (1.71, 1.8, 1.89)]
KEYS = ['g_ich_01', 'g_ich_01_full', 'g_ich_10', 'g_ich_10_full', 'g_i3_01', 'g_i3_01_full', 'g_i3_10', 'g_i3_10_full',
        'g_sw_ab', 'g_sw_ba', 'o_chop_ab', 'o_chop_ba', 't_last']


def run(job):
    corner, t, vdd = job
    s = open(SRC).read()
    s = re.sub(r'sky130\.lib\.spice tt$', f'sky130.lib.spice {corner}', s, flags=re.M)
    s = re.sub(r'^\.param vdd=.*$', f'.param vdd={vdd}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = s.replace(')=0.9 ', f')={vdd / 2:.4f} ')
    d = os.path.join(OUT, f'{corner}_{t}_{vdd}')
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=600)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    v = dict(corner=corner, temp=t, vdd=vdd)
    for line in r.stdout.splitlines():
        if line.startswith('GAPS '):
            v.update({k: float(x) for k, x in re.findall(r'(\w+)=([-+0-9.eE]+)', line)})
    return v


def main():
    os.makedirs(OUT, exist_ok=True)
    with ThreadPoolExecutor(8) as ex:
        rows = list(ex.map(run, JOBS))
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, ['corner', 'temp', 'vdd'] + KEYS)
        w.writeheader()
        w.writerows(rows)
    L = ['# M6 10a: swdrv gaps and overlaps, 50 fF loads (45 points)', '',
         '| quantity | min (ns) | at | max (ns) | at | sign |', '|---|---|---|---|---|---|']
    for k in KEYS:
        lo = min(rows, key=lambda r: r[k])
        hi = max(rows, key=lambda r: r[k])
        ok = 'ok' if k == 't_last' or lo[k] > 0 else 'WRONG'
        L.append(f"| {k} | {lo[k]:.3f} | {lo['corner']} {lo['temp']} C {lo['vdd']} V | {hi[k]:.3f} | {hi['corner']} {hi['temp']} C {hi['vdd']} V | {ok} |")
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
