#!/usr/bin/env python3
"""M7 14: the three rings (ring3 = ring_n /32, ring_p /32, ring_d /16) over PVT, from tb_ring3.spice.
Adds 1.5 fF of wire to every ring node (as the spec's R6 quick check). Per point: ring frequency (first-stage node,
averaged over 40 periods; 20 for ring_d; max step 10 ps (5 ps: f within 0.2 %)), first divider flop (must be exactly f/2), pad output (100 fF; must be f/32 or
f/16), f_n/f_p. Points: 5 corners x -20/25/100 C x 1.71/1.80/1.89 V (the guaranteed grid) plus ss -40 C 1.62 V and
ff -40 C 1.98 V (slowest and fastest first flop).
Mode 'pull': rsup = 10 ohm in the supply; all three rings on vs each ring alone, at tt 25 C 1.80 V and ff -20 C 1.89 V
(spec section 11 item 15: within 1e-4).
Usage (in the container, bash -l, after netlisting tb_ring3.sch):  python3 /foss/designs/tt_tsense/xschem/ring14.py [pull]
Writes simulation/ring14/ (or ring14_pull/): decks, logs, all.csv, summary.md; the sweep also writes docs/ring_table.csv.
"""
import csv, os, re, shutil, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_ring3.spice')
PULL = len(sys.argv) > 1 and sys.argv[1] == 'pull'
OUT = os.path.join(SIM, 'ring14_pull' if PULL else 'ring14')
GRID = [(c, t, v) for c in ('tt', 'ss', 'ff', 'sf', 'fs') for t in (-20, 25, 100) for v in (1.71, 1.8, 1.89)]
EXTRA = [('ss', -40, 1.62), ('ff', -40, 1.98)]
NODES = {'ring_n': 31, 'ring_p': 31, 'ring_d': 16}
DIV = {'n': 32, 'p': 32, 'd': 16}


def deck(c, t, v, rsup=0.001, solo=None):
    s = open(SRC).read()
    s = re.sub(r'sky130\.lib\.spice tt$', f'sky130.lib.spice {c}', s, flags=re.M)
    s = re.sub(r'^\.param vdd=.*$', f'.param vdd={v}', s, flags=re.M)
    s = re.sub(r'^\.param rsup=.*$', f'.param rsup={rsup}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = re.sub(r'\)=0\.9 ', f')={v / 2:.4f} ', s)
    s = s.replace('tran 5p ', f"tran {os.environ.get('RING_STEP', '10p')} ")   # max step: 10p unless RING_STEP is set
    for name, n in NODES.items():
        caps = '\n'.join(f'Cw{k} r{k} VGND 1.5f' for k in range(n))
        s = re.sub(rf'^(\.subckt {name} .*)$', lambda m: m.group(1) + '\n' + caps, s, count=1, flags=re.M)
    if solo:
        keep = 'x' + solo
        body = re.search(r'^\.subckt ring3 .*?^\.ends', s, flags=re.M | re.S).group(0)
        new = '\n'.join(l for l in body.splitlines() if not (re.match(r'^x[npd] ', l) and not l.startswith(keep + ' ')))
        s = s.replace(body, new)
    return s


def run(job):
    c, t, v, rsup, solo = job
    tag = f'{c}_{t}_{v}' + (f'_r{rsup:g}' if rsup > 0.01 else '') + (f'_solo{solo}' if solo else '')
    d = os.path.join(OUT, tag)
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(deck(c, t, v, rsup, solo))
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=3600)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    m = {}
    for line in r.stdout.splitlines():
        g = re.match(r'^\s*(\w+)\s*=\s*([-+0-9.eE]+)', line)
        if g:
            m[g.group(1)] = float(g.group(2))
    f = lambda a, b, n: n / (m[b] - m[a]) * 1e-6 if a in m and b in m else float('nan')
    row = dict(corner=c, temp=t, vdd=v, rsup=rsup, solo=solo or '', done='RING_DONE' in r.stdout,
               f_n=f('n_a', 'n_b', 40), f_p=f('p_a', 'p_b', 40), f_d=f('d_a', 'd_b', 20),
               fq_n=f('nq_a', 'nq_b', 20), fq_p=f('pq_a', 'pq_b', 20), fq_d=f('dq_a', 'dq_b', 7),
               pad_n=f('no_a', 'no_b', 1), pad_p=f('po_a', 'po_b', 1), pad_d=f('do_a', 'do_b', 1),
               i_run_uA=-m.get('i_run', float('nan')) * 1e6, vdd_min=m.get('vdd_min', float('nan')))
    row['ratio'] = row['f_n'] / row['f_p'] if row['f_p'] == row['f_p'] and row['f_p'] else float('nan')
    for k in 'npd':
        fr, fq, fo = row[f'f_{k}'], row[f'fq_{k}'], row[f'pad_{k}']
        row[f'div_ok_{k}'] = abs(2 * fq / fr - 1) < 0.005 and abs(DIV[k] * fo / fr - 1) < 0.01 if fr == fr else False
    return row


def sweep():
    jobs = [p + (0.001, None) for p in GRID + EXTRA]
    with ThreadPoolExecutor(8) as ex:
        rows = list(ex.map(run, jobs))
    keys = list(rows[0])
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as fh:
        w = csv.DictWriter(fh, keys)
        w.writeheader()
        w.writerows(rows)
    with open('/foss/designs/tt_tsense/docs/ring_table.csv', 'w', newline='') as fh:
        w = csv.writer(fh)
        w.writerow(['corner', 'vdd_V', 'temp_C', 'f_ring_n_MHz', 'f_ring_p_MHz', 'f_ring_d_MHz', 'fn_over_fp',
                    'pad_uo1_MHz', 'pad_uo3_MHz', 'pad_uo6_MHz'])
        for r in rows:
            w.writerow([r['corner'], r['vdd'], r['temp'], f"{r['f_n']:.4f}", f"{r['f_p']:.4f}", f"{r['f_d']:.4f}",
                        f"{r['ratio']:.5f}", f"{r['pad_n']:.4f}", f"{r['pad_p']:.4f}", f"{r['pad_d']:.4f}"])
    g = {(r['corner'], r['temp'], r['vdd']): r for r in rows}
    L = [f'# M7 14: three rings over PVT ({len(rows)} runs; 1.5 fF per ring node, 100 fF per pad)', '',
         '| corner | T (C) | VDD | f_n / f_p / f_d ring (MHz) | uo1 / uo3 / uo6 pad (MHz) | f_n/f_p | dividers | I (uA) |',
         '|---|---|---|---|---|---|---|---|']
    for r in rows:
        dv = 'ok' if all(r[f'div_ok_{k}'] for k in 'npd') else 'FAIL ' + ''.join(k for k in 'npd' if not r[f'div_ok_{k}'])
        L.append(f"| {r['corner']} | {r['temp']} | {r['vdd']} | {r['f_n']:.1f} / {r['f_p']:.1f} / {r['f_d']:.1f} | "
                 f"{r['pad_n']:.2f} / {r['pad_p']:.2f} / {r['pad_d']:.2f} | {r['ratio']:.4f} | {dv} | {r['i_run_uA']:.1f} |")
    gr = [g[p] for p in GRID]
    L += ['', '## Checks', '']
    for k, pin in (('n', 'uo1'), ('p', 'uo3'), ('d', 'uo6')):
        lo = min(gr, key=lambda r: r[f'pad_{k}'])
        hi = max(gr, key=lambda r: r[f'pad_{k}'])
        ok = 5 <= lo[f'pad_{k}'] and hi[f'pad_{k}'] <= 15
        L.append(f"- {pin}: {lo[f'pad_{k}']:.2f} ({lo['corner']} {lo['temp']} C {lo['vdd']} V) to {hi[f'pad_{k}']:.2f} MHz "
                 f"({hi['corner']} {hi['temp']} C {hi['vdd']} V) over the 45 guaranteed points: {'inside' if ok else 'OUTSIDE'} 5-15 MHz")
    for p in EXTRA:
        r = g[p]
        L.append(f"- {p[0]} {p[1]} C {p[2]} V: first flops f_q0 = f/2 ({', '.join(f'{k} {2 * r[f'fq_{k}'] / r[f'f_{k}'] - 1:+.1e}' for k in 'npd')}); "
                 f"all dividers {'ok' if all(r[f'div_ok_{k}'] for k in 'npd') else 'FAIL'}; rings {r['f_n']:.0f} / {r['f_p']:.0f} / {r['f_d']:.0f} MHz")
    L.append(f"- every divider exact at all {len(rows)} points: {sum(all(r[f'div_ok_{k}'] for k in 'npd') for r in rows)} / {len(rows)}")
    # f_n/f_p against (T, VDD) at tt, and the skew corners
    T, V = (-20, 25, 100), (1.71, 1.8, 1.89)
    L += ['', '## f_n/f_p at tt and the skew corners', '', '| T (C) | VDD | tt | sf vs tt | fs vs tt | ss vs tt | ff vs tt |', '|---|---|---|---|---|---|---|']
    dsk = []
    for t in T:
        for v in V:
            b = g[('tt', t, v)]['ratio']
            dd = {c: (g[(c, t, v)]['ratio'] / b - 1) * 100 for c in ('sf', 'fs', 'ss', 'ff')}
            dsk.append(min(abs(dd['sf']), abs(dd['fs'])))
            L.append(f"| {t} | {v} | {b:.4f} | {dd['sf']:+.2f} % | {dd['fs']:+.2f} % | {dd['ss']:+.2f} % | {dd['ff']:+.2f} % |")
    rt = [g[('tt', t, v)]['ratio'] for t in T for v in V]
    dT = max(abs((g[('tt', 100, v)]['ratio'] / g[('tt', -20, v)]['ratio'] - 1) / 120) for v in V) * 100
    dV = max(abs((g[('tt', t, 1.89)]['ratio'] / g[('tt', t, 1.71)]['ratio'] - 1) / 18) for t in T) * 100
    err = dT * 1 + dV * 1
    L += ['', f"- at tt over -20...100 C x 1.71-1.89 V: f_n/f_p {min(rt):.4f}-{max(rt):.4f} ({(max(rt) / min(rt) - 1) * 100:.1f} % wide)",
          f"- sensitivity at tt: {dT:.3f} %/C, {dV:.3f} % per 10 mV -> a +-1 C and +-10 mV error in (T_hat, VDD_est) moves it {err:.2f} %",
          f"- reworded item 14: smallest |sf or fs - tt| = {min(dsk):.2f} % (needs >= 2 %), ratio to the (T, VDD) error {min(dsk) / err:.1f}x (needs >= 5x)"]
    # D5 ring coefficients (item 11)
    f0 = g[('tt', 25, 1.8)]['f_d']
    cT = (g[('tt', 100, 1.8)]['f_d'] / g[('tt', -20, 1.8)]['f_d'] - 1) / 120 * 100
    cV = (g[('tt', 25, 1.89)]['f_d'] / g[('tt', 25, 1.71)]['f_d'] - 1) / 18 * 100
    L += ['', f"- ring_d (item 11): {f0:.2f} MHz at tt 25 C 1.80 V; {cT:+.3f} %/C; {cV:+.3f} % per 10 mV"]
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


def pull():
    pts = [('tt', 25, 1.8), ('ff', -20, 1.89)]
    jobs = [p + (10.0, s) for p in pts for s in (None, 'n', 'p', 'd')]
    with ThreadPoolExecutor(8) as ex:
        rows = list(ex.map(run, jobs))
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as fh:
        w = csv.DictWriter(fh, list(rows[0]))
        w.writeheader()
        w.writerows(rows)
    L = ['# M7 14b: ring-to-ring pulling (10 ohm in the supply; all three rings on vs each alone)', '',
         '| point | ring | all on (MHz) | alone (MHz) | difference | VDD min, all on |', '|---|---|---|---|---|---|']
    for p in pts:
        allr = next(r for r in rows if (r['corner'], r['temp'], r['vdd']) == p and not r['solo'])
        for k in 'npd':
            so = next(r for r in rows if (r['corner'], r['temp'], r['vdd']) == p and r['solo'] == k)
            dlt = allr[f'f_{k}'] / so[f'f_{k}'] - 1
            L.append(f"| {p[0]} {p[1]} C {p[2]} V | ring_{k} | {allr[f'f_{k}']:.4f} | {so[f'f_{k}']:.4f} | {dlt * 1e6:+.0f} ppm | {allr['vdd_min']:.4f} V |")
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    os.makedirs(OUT, exist_ok=True)
    pull() if PULL else sweep()
