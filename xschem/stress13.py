#!/usr/bin/env python3
"""M7 13b: where the osc_out toggle starts to miss rst pulses, with the local buf_2 (the cell) and without it (the bench's
diagnostic flop on rst). tb_readout_glue.spice at ss -40 C 1.62 V (the spec's glue-timing corner) and tt 27 C 1.80 V;
rst width at VDD/2 swept down from 10 ns and its edges from 1 to 8 ns. A pass = exactly 4 rises for the 8 pulses after
osc_en and none before it.
Usage (in the container, bash -l, after netlisting tb_readout_glue.sch):  python3 /foss/designs/tt_tsense/xschem/stress13.py
Writes simulation/stress13/: decks, logs, all.csv, summary.md.
"""
import csv, os, re, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_readout_glue.spice')
OUT = os.path.join(SIM, 'stress13')
PTS = [('ss', -40, 1.62), ('tt', 27, 1.8)]
EDGES = (1, 3, 5, 8)
WIDTHS = (10, 8, 6, 5, 4, 3, 2, 1.5, 1)
JOBS = [(c, t, v, e, w) for (c, t, v) in PTS for e in EDGES for w in WIDTHS if w >= e]


def run(job):
    c, t, vdd, e, w = job
    s = open(SRC).read()
    s = re.sub(r'sky130\.lib\.spice tt$', f'sky130.lib.spice {c}', s, flags=re.M)
    s = re.sub(r'^\.param vdd=.*$', f'.param vdd={vdd}', s, flags=re.M)
    s = re.sub(r'^\.param trf=.*$', f'.param trf={e}n', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = s.replace("'10n-trf'", f"'{w}n-trf'")
    s = re.sub(r'(val=|\)=)0\.9 ', lambda m: f'{m.group(1)}{vdd / 2:.4f} ', s)
    d = os.path.join(OUT, f'{c}_{t}_{vdd}_e{e}_w{w}')
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=1800)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    m = {}
    for line in r.stdout.splitlines():
        g = re.match(r'^\s*(\w+)\s*=\s*([-+0-9.eE]+)', line)
        if g:
            m[g.group(1)] = float(g.group(2))
    lo = 0.1 * vdd
    buf_ok = all(f'r{k}' in m for k in range(1, 5)) and 'r5' not in m and m.get('pre_max', 9) < lo
    dir_ok = all(f'd{k}' in m for k in (1, 4)) and 'd5' not in m
    return dict(corner=c, temp=t, vdd=vdd, edge_ns=e, width_ns=w, buffered_ok=buf_ok, direct_ok=dir_ok,
                rst_k_rise_ns=m.get('tr_rstk', float('nan')) * 1e9)


def main():
    os.makedirs(OUT, exist_ok=True)
    with ThreadPoolExecutor(8) as ex:
        rows = list(ex.map(run, JOBS))
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    L = ['# M7 13b: toggle vs rst width and edge (pass = 4 rises for 8 pulses, none before osc_en)', '',
         'B = with the local buf_2 (the cell), D = flop straight on rst (bench diagnostic); ok / MISS', '']
    for (c, t, v) in PTS:
        L += [f'## {c}, {t} C, {v} V', '', '| rst edge (ns) | ' + ' | '.join(f'w {x} ns' for x in WIDTHS) + ' |',
              '|---|' + '---|' * len(WIDTHS)]
        for e in EDGES:
            cells = []
            for x in WIDTHS:
                r = next((r for r in rows if (r['corner'], r['temp'], r['vdd'], r['edge_ns'], r['width_ns']) == (c, t, v, e, x)), None)
                cells.append('–' if r is None else f"B {'ok' if r['buffered_ok'] else 'MISS'} / D {'ok' if r['direct_ok'] else 'MISS'}")
            L.append(f'| {e} | ' + ' | '.join(cells) + ' |')
        L.append('')
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
