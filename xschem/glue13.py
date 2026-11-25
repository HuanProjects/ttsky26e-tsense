#!/usr/bin/env python3
"""M7 13: readout_glue over PVT. Fans tb_readout_glue.spice out over tt ss ff sf fs x -40 27 125 C x 1.62 1.80 1.98 V,
with the 10 ns rst pulses (every 1 µs; the spec bench uses 4.55 µs, the toggle is static) at 3 ns and at 5 ns edges (90 runs; tran step 0.05 ns, 0.5 ns let the solver miss flop transitions). Per run: osc_out (uo0) must rise exactly 4 times for the
8 pulses after osc_en (rise 5 must not exist), stay 0 while osc_en = 0 (one pulse arrives then), and have edges <= 2 ns
into 100 fF; the default state (all ui_in = 0) and every buffer/complement after ui1..ui7 rise are checked; static
supply current is averaged in three quiet windows. A second toggle flop on rst without the local buf_2 (bench only)
is counted the same way. Thresholds scale with VDD (0.5 / 0.1 / 0.9 of VDD).
Usage (in the container, bash -l, after netlisting tb_readout_glue.sch):  python3 /foss/designs/tt_tsense/xschem/glue13.py [one]
Writes simulation/glue13/: decks, logs, all.csv, summary.md.
"""
import csv, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_readout_glue.spice')
OUT = os.path.join(SIM, 'glue13')
JOBS = [(c, t, v, e) for e in (3, 5) for c in ('tt', 'ss', 'ff', 'sf', 'fs') for t in (-40, 27, 125) for v in (1.62, 1.8, 1.98)]
if len(sys.argv) > 1 and sys.argv[1] == 'one':
    JOBS = [('ff', -40, 1.8, 3), ('tt', -40, 1.98, 3)]


def deck(corner, t, vdd, e):
    s = open(SRC).read()
    s = re.sub(r'sky130\.lib\.spice tt$', f'sky130.lib.spice {corner}', s, flags=re.M)
    s = re.sub(r'^\.param vdd=.*$', f'.param vdd={vdd}', s, flags=re.M)
    s = re.sub(r'^\.param trf=.*$', f'.param trf={e}n', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    for a, b in (('0.9', 0.5), ('0.18', 0.1), ('1.62', 0.9)):
        s = re.sub(rf'(val=|\)=){re.escape(a)} ', lambda m: f'{m.group(1)}{vdd * b:.4f} ', s)
    return s


def run(job):
    corner, t, vdd, e = job
    d = os.path.join(OUT, f'{corner}_{t}_{vdd}_{e}ns')
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(deck(*job))
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=1800)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    m = {}
    for line in r.stdout.splitlines():
        g = re.match(r'^\s*(\w+)\s*=\s*([-+0-9.eE]+)', line)
        if g:
            m[g.group(1)] = float(g.group(2))
    hi, lo = 0.9 * vdd, 0.1 * vdd
    ties = [k for k in m if k.startswith('tmx_')] + ['tie_max']
    v = dict(corner=corner, temp=t, vdd=vdd, edge_ns=e, done='GLUE_DONE' in r.stdout,
             rises=sum(f'r{k}' in m for k in range(1, 6)), falls_4=('f4' in m) and ('f5' not in m),
             pre_max=m.get('pre_max', float('nan')),
             tr_ns=m.get('tr', float('nan')) * 1e9, tf_ns=m.get('tf', float('nan')) * 1e9,
             t_rst_ns=m.get('t_rst', float('nan')) * 1e9, t_rstk_ns=m.get('t_rstk', float('nan')) * 1e9,
             tr_rstk_ns=m.get('tr_rstk', float('nan')) * 1e9,
             direct_rises=sum(f'd{k}' in m for k in (1, 4, 5)) if 'd1' in m else 0,
             direct_ok=('d4' in m) and ('d5' not in m), cmp_ok=('c9' in m) and ('c10' not in m),
             i_def_nA=-m.get('i_def', float('nan')) * 1e9, i_run_nA=-m.get('i_run', float('nan')) * 1e9,
             i_all1_nA=-m.get('i_all1', float('nan')) * 1e9,
             default_ok=(m.get('v_def', 9) < lo and m.get('oe_def', 9) < lo and min(m.get(k, 0) for k in ('oeb_def', 'tsb_def', 'vmb_def', 'imb_def', 'bg_def')) > hi),
             on_ok=(min(m.get(k, 0) for k in ('ts_on', 'vm_on', 'im_on', 'ich_on', 'chop_on', 'ring_on', 'i3_on')) > hi
                    and max(m.get(k, 9) for k in ('tsb_on', 'vmb_on', 'imb_on')) < lo),
             tie_max_mV=max(m.get(k, 9) for k in ties) * 1e3, n_ties=len(ties))
    v['toggle_ok'] = v['done'] and v['rises'] == 4 and v['falls_4'] and v['pre_max'] < lo
    return v


def main():
    os.makedirs(OUT, exist_ok=True)
    with ThreadPoolExecutor(8) as ex:
        rows = list(ex.map(run, JOBS))
    keys = list(rows[0])
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, keys)
        w.writeheader()
        w.writerows(rows)
    ok = lambda k: sum(bool(r[k]) for r in rows)
    ext = lambda k: (min(rows, key=lambda r: r[k]), max(rows, key=lambda r: r[k]))
    at = lambda r: f"{r['corner']} {r['temp']} C {r['vdd']} V {r['edge_ns']} ns"
    L = [f'# M7 13: readout_glue over PVT ({len(rows)} runs: 5 corners x -40/27/125 C x 1.62/1.80/1.98 V x rst edges 3/5 ns)', '',
         f"- osc_out toggles once per rst (4 rises, 4 falls, none before osc_en): {ok('toggle_ok')} / {len(rows)}",
         f"- default state (all ui_in = 0): {ok('default_ok')} / {len(rows)}; every buffer and complement after ui1..ui7 rise: {ok('on_ok')} / {len(rows)}",
         f"- cmp_raw -> uo2 passes all 9 pulses (8 after osc_en, 1 before), no extra: {ok('cmp_ok')} / {len(rows)}",
         f"- tie-offs ({rows[0]['n_ties']} pins): max {max(r['tie_max_mV'] for r in rows):.3f} mV",
         f"- diagnostic, toggle flop on rst without the local buf_2: correct count in {ok('direct_ok')} / {len(rows)}", '',
         '| quantity | min | at | max | at |', '|---|---|---|---|---|']
    for k in ('pre_max', 'tr_ns', 'tf_ns', 't_rst_ns', 't_rstk_ns', 'tr_rstk_ns', 'i_def_nA', 'i_run_nA', 'i_all1_nA'):
        a, b = ext(k)
        L.append(f'| {k} | {a[k]:.4g} | {at(a)} | {b[k]:.4g} | {at(b)} |')
    bad = [r for r in rows if not (r['toggle_ok'] and r['default_ok'] and r['on_ok'] and r['cmp_ok'])]
    if bad:
        L += ['', 'Failing runs:'] + [f"- {at(r)}: rises {r['rises']}, falls_4 {r['falls_4']}, pre_max {r['pre_max']:.3f}, default {r['default_ok']}, on {r['on_ok']}, cmp {r['cmp_ok']}, done {r['done']}" for r in bad]
    nd = [r for r in rows if not r['direct_ok']]
    if nd:
        L += ['', 'Diagnostic (no local buf_2) miscounts at:'] + [f"- {at(r)}: rises seen {r['direct_rises']}" for r in nd]
    i125 = [r for r in rows if r['temp'] == 125 and r['corner'] == 'ff']
    if i125:
        L += ['', f"- static current at ff, 125 C: {max(max(r['i_def_nA'], r['i_run_nA'], r['i_all1_nA']) for r in i125):.1f} nA worst (limit 1000 nA)"]
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
