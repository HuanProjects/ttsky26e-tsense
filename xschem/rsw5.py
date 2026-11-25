#!/usr/bin/env python3
"""M6 5: reset switch (nfet_01v8 12/0.5, two fingers). Reads the netlisted simulation/tb_rsw.spice.
  grid: tt ss ff sf fs x -20 25 100 125 C x 1.71 1.8 1.89 V -> R_on, leakage, pedestal at a 2 ns gate fall
  edge sweep: tt, 25 C, 1.8 V, gate fall time 0.05 ... 100 ns -> pedestal
Usage (in the container, after netlisting tb_rsw.sch):  python3 /foss/designs/tt_tsense/xschem/rsw5.py
Writes simulation/rsw5/: decks, logs, grid.csv, edge.csv, summary.md.
"""
import csv, os, re, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_rsw.spice')
OUT = os.path.join(SIM, 'rsw5')
CORNERS = ['tt', 'ss', 'ff', 'sf', 'fs']
TEMPS = [-20, 25, 100, 125]
VDDS = [1.71, 1.8, 1.89]
EDGES = [0.05, 0.1, 0.2, 0.5, 1, 2, 5, 10, 20, 50, 100]      # ns
C_OSC = 5.06e-12


def run(job):
    tag, corner, t, vdd, tf = job
    s = open(SRC).read()
    s = re.sub(r'sky130\.lib\.spice \S+$', f'sky130.lib.spice {corner}', s, flags=re.M)
    s = re.sub(r'^\.param vdd=\S+ tf=\S+$', f'.param vdd={vdd} tf={tf}n', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = re.sub(r'^tran 0\.01n \S+ 0 0\.01n$', f'tran 0.01n {20 + tf + 50:g}n 0 {min(0.01, tf / 20):g}n', s, flags=re.M)
    s = re.sub(r'^meas tran ped find v\(vcap\) at=\S+$', f'meas tran ped find v(vcap) at={20 + tf + 40:g}n', s, flags=re.M)
    d = os.path.join(OUT, tag)
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=1800)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    v = dict(corner=corner, temp=t, vdd=vdd, tf_ns=tf)
    for line in r.stdout.splitlines():
        if line.startswith('OP ') or line.startswith('PED '):
            v.update({k: float(x) for k, x in re.findall(r'(\w+)=([-+0-9.eE]+)', line)})
    return v


def main():
    os.makedirs(OUT, exist_ok=True)
    grid = [(f'g_{c}_{t}_{v}', c, t, v, 2) for c in CORNERS for t in TEMPS for v in VDDS]
    edge = [(f'e_{tf}', 'tt', 25, 1.8, tf) for tf in EDGES]
    with ThreadPoolExecutor(8) as ex:
        res = list(ex.map(run, grid + edge))
    g, e = res[:len(grid)], res[len(grid):]
    for name, rows in (('grid.csv', g), ('edge.csv', e)):
        with open(os.path.join(OUT, name), 'w', newline='') as f:
            w = csv.DictWriter(f, list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
    guar = [r for r in g if -20 <= r['temp'] <= 100 and r['vdd'] in (1.71, 1.8, 1.89)]
    worst = max(guar, key=lambda r: r['ron'])
    hot = [r for r in g if r['temp'] == 125]
    leak = max(hot, key=lambda r: r['ioff_nA'])
    ped = [r['ped_mV'] for r in guar]
    tt = next(r for r in g if r['corner'] == 'tt' and r['temp'] == 25 and r['vdd'] == 1.8)
    L = ['# M6 5: reset switch nfet_01v8 12/0.5 (two fingers), C_osc 5.06 pF', '',
         f"- R_on: tt 25 C 1.8 V {tt['ron']:.0f} ohm; worst guaranteed point {worst['ron']:.0f} ohm "
         f"({worst['corner']}, {worst['temp']} C, {worst['vdd']} V); limit 280 ohm.",
         f"- 7 R_on C at that point: {7 * worst['ron'] * C_OSC * 1e9:.2f} ns (t_rst 10-12.5 ns).",
         f"- Leakage at 125 C (drain 1.3 V, gate 0): max {leak['ioff_nA']:.3f} nA ({leak['corner']}, {leak['vdd']} V); limit 1 nA.",
         f"- tt 25 C: Vth {tt['vth']:.3f} V, C_gg (on) {tt['cgg_on_fF']:.1f} fF, overlap C_ov (from the 0.25 V sub-threshold step) {tt['cov_fF']:.2f} fF.",
         f"- Pedestal at a 2 ns gate fall over the guaranteed grid: {min(ped):+.2f} to {max(ped):+.2f} mV (tt 25 C {tt['ped_mV']:+.2f} mV).", '',
         '| corner | T | VDD | R_on (ohm) | leak (nA) | pedestal @ 2 ns (mV) | C_ov (fF) |', '|---|---|---|---|---|---|---|']
    for r in g:
        L.append(f"| {r['corner']} | {r['temp']} | {r['vdd']} | {r['ron']:.0f} | {r['ioff_nA']:.4f} | {r['ped_mV']:+.2f} | {r['cov_fF']:.2f} |")
    L += ['', '## Pedestal vs gate fall time (tt, 25 C, 1.8 V)', '', '| fall time (ns) | pedestal (mV) |', '|---|---|']
    for r in e:
        L.append(f"| {r['tf_ns']:g} | {r['ped_mV']:+.3f} |")
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
