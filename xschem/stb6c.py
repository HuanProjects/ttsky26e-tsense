#!/usr/bin/env python3
"""M5 6c: the loop-gain grid on the real bgr loop (spec M5 step 5, tb_bg_stb row).

Phase 1, chop state A: 15 corners x -40/-20/0/25/50/75/100/125 C x 1.62/1.71/1.80/1.89/1.98 V,
         each with iptat_mon_en = 1 and 0 (1200 points; stb6.py decks, one per corner/VDD/monitor state).
Phase 2, chop state B: tt plus the two corners with the lowest state-A PM, at every T and VDD, both monitor states.
Guaranteed points: -20..100 C and 1.71..1.89 V (the 5b grid). The rest (-40/125 C, 1.62/1.98 V) are characterized.
Limits at guaranteed points: PM >= 60 deg, GM >= 10 dB, 50 kHz <= f_u <= 300 kHz, angle T(1 Hz) within +-45 deg.
An operating point with I_PTAT < 1 uA or |va - vb| > 1 mV in either copy is off-design: listed, then left out.

Usage (in the container, after netlisting tb_bg_k.sch):  python3 /foss/designs/tt_tsense/xschem/stb6c.py
Writes simulation/s6c/: the decks and logs, t_<tag>.txt Bode data, all.csv, summary.md.
"""
import os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from stb6 import deck, tag_of, sim

CORNERS = 'tt ll hh ss ss_ll ss_hh ff ff_ll ff_hh sf sf_ll sf_hh fs fs_ll fs_hh'.split()
TEMPS = ['-40', '-20', '0', '25', '50', '75', '100', '125']
VDDS = ['1.62', '1.71', '1.8', '1.89', '1.98']
GT, GV = {'-20', '0', '25', '50', '75', '100'}, {'1.71', '1.8', '1.89'}
out = f'{sim}/s6c'
src = open(f'{sim}/tb_bg_k.spice').read()
assert '.subckt bgr ' in src, 'netlist tb_bg_k.sch first'
os.makedirs(out, exist_ok=True)
for f in os.listdir(out):
    os.remove(f'{out}/{f}')

# one OpenMP thread per ngspice, so many at once do not fight (a .spiceinit here replaces the home one)
home = os.path.expanduser('~/.spiceinit')
init = open(home).read() if os.path.exists(home) else 'set ngbehavior=hsa\nset ng_nomodcheck\n'
init = re.sub(r'^set num_threads=.*$', '', init, flags=re.M) + 'set num_threads=1\n'
open(f'{out}/.spiceinit', 'w').write(init)


def run(job):
    """One deck per corner, VDD, monitor and chop state, with every temperature inside (the models load once)."""
    corner, vdd, mon, state = job
    name = tag_of(corner, vdd, 'all', mon, state)
    open(f'{out}/stb_{name}.spice', 'w').write(deck(src, corner, vdd, TEMPS, mon, state, wr='.'))
    log = subprocess.run(['ngspice', '-b', f'stb_{name}.spice'], cwd=out, capture_output=True, text=True).stdout
    open(f'{out}/stb_{name}.log', 'w').write(log)
    rs = {t: dict(corner=corner, vdd=vdd, temp=t, mon=mon, state=state, tag=tag_of(corner, vdd, t, mon, state))
          for t in TEMPS}
    r = None
    for line in log.splitlines():
        if line.startswith('OPCHK '):
            r = rs.get(re.search(r' temp=(\S+)', line).group(1))
        if line.startswith(('OPCHK ', 'STB ')) and r is not None:
            for kv in line.split()[1:]:
                k, _, v = kv.partition('=')
                if k not in r:
                    try:
                        r[k] = float(v)
                    except ValueError:
                        r[k] = None
    return list(rs.values())


def fan(jobs):
    with ThreadPoolExecutor(min(os.cpu_count(), 12)) as ex:
        return [r for rs in ex.map(run, jobs) for r in rs]


def num(r, k):
    v = r.get(k)
    return v if isinstance(v, float) else None


def off(r):
    i1, i2, vos = num(r, 'Iptat_v_nA'), num(r, 'Iptat_i_nA'), num(r, 'va_vb_uV')
    return None in (i1, i2, vos) or min(i1, i2) < 1000 or abs(vos) > 1000


def fails(r):
    pm, gm, fu, ph = (num(r, k) for k in ('PM_deg', 'GM_dB', 'fu_Hz', 'T0_phase_deg'))
    bad = []
    if pm is None or pm < 60: bad.append(f'PM {pm}')
    if gm is None or gm < 10: bad.append(f'GM {gm}')
    if fu is None or not 50e3 <= fu <= 300e3: bad.append(f'f_u {fu}')
    if ph is None or abs(ph) > 45: bad.append(f'angle T(1 Hz) {ph}')
    return bad


guar = lambda r: r['temp'] in GT and r['vdd'] in GV
where = lambda r: f"{r['corner']} {r['vdd']} V {r['temp']} C mon={r['mon']}"
L = []
say = lambda s='': (print(s), L.append(s))

print('phase 1: state A, 150 decks x 8 temperatures (a few minutes) ...', flush=True)
A = fan([(c, v, m, 'A') for c in CORNERS for v in VDDS for m in ('1', '0')])
bad = [r for r in A if off(r)]
okA = [r for r in A if not off(r)]

# the two worst corners by state-A PM over the guaranteed points, then state B there and at tt
pmin = {c: min(num(r, 'PM_deg') or 0 for r in okA if r['corner'] == c and guar(r)) for c in CORNERS}
worst = [c for c in sorted(pmin, key=pmin.get) if c != 'tt'][:2]
print(f'phase 2: state B at tt, {worst[0]}, {worst[1]}, 30 decks x 8 temperatures ...', flush=True)
B = fan([(c, v, m, 'B') for c in ['tt'] + worst for v in VDDS for m in ('1', '0')])
bad += [r for r in B if off(r)]
okB = [r for r in B if not off(r)]

keys = ['corner', 'vdd', 'temp', 'mon', 'state', 'Iptat_v_nA', 'Iptat_i_nA', 'va_vb_uV', 'T0_dB', 'T0_phase_deg',
        'fu_Hz', 'PM_deg', 'f180_Hz', 'GM_dB', 'Tv_at_fu_dB', 'Ti_at_fu_dB']
with open(f'{out}/all.csv', 'w') as f:
    f.write(','.join(keys) + '\n')
    for r in A + B:
        f.write(','.join(str(r.get(k)) for k in keys) + '\n')

say('# M5 6c: loop-gain grid summary')
say()
say(f'{len(A)} state-A points, {len(B)} state-B points; {len(bad)} off-design operating points (left out below).')
for r in bad:
    say(f"- OFF-DESIGN {where(r)} state {r['state']}: Iptat_v {r.get('Iptat_v_nA')} nA, Iptat_i {r.get('Iptat_i_nA')} nA, "
        f"va-vb {r.get('va_vb_uV')} uV")


def span(rs, k, f=lambda x: x):
    rs = [r for r in rs if num(r, k) is not None]
    lo, hi = min(rs, key=lambda r: r[k]), max(rs, key=lambda r: r[k])
    return f'{f(lo[k]):.4g} ({where(lo)}) .. {f(hi[k]):.4g} ({where(hi)})'


for name, sel in (('Guaranteed points', guar), ('Characterized points (-40/125 C or 1.62/1.98 V)', lambda r: not guar(r))):
    rs = [r for r in okA if sel(r)]
    say()
    say(f'## {name}, state A, both monitor states ({len(rs)} points)')
    say(f"- PM (deg): {span(rs, 'PM_deg')}")
    say(f"- GM (dB): {span(rs, 'GM_dB')}")
    say(f"- f_u (kHz): {span(rs, 'fu_Hz', lambda x: x / 1e3)}")
    say(f"- T0 (dB): {span(rs, 'T0_dB')}")
    say(f"- angle T(1 Hz) (deg): {span(rs, 'T0_phase_deg')}")
    fl = [(r, fails(r)) for r in rs if fails(r)]
    say(f'- against the limits: {len(fl)} of {len(rs)} miss' + (':' if fl else ''))
    for r, why in fl:
        say(f'  - {where(r)}: ' + ', '.join(why))

say()
say('## Per corner, state A, guaranteed points (both monitor states)')
say()
say('| corner | PM min (deg) | GM min (dB) | f_u min (kHz) | f_u max (kHz) | PM min, all points (deg) |')
say('|---|---|---|---|---|---|')
for c in CORNERS:
    g = [r for r in okA if r['corner'] == c and guar(r)]
    a = [r for r in okA if r['corner'] == c]
    f = lambda rs, k, h: h((num(r, k) for r in rs if num(r, k) is not None))
    say(f"| {c} | {f(g, 'PM_deg', min):.2f} | {f(g, 'GM_dB', min):.2f} | {f(g, 'fu_Hz', min) / 1e3:.1f} | "
        f"{f(g, 'fu_Hz', max) / 1e3:.1f} | {f(a, 'PM_deg', min):.2f} |")

say()
say('## Lowest PM anywhere (Bode data in s6c/t_<tag>.txt: freq, dB, phase, Tv dB, Ti dB)')
for r in sorted(okA, key=lambda r: num(r, 'PM_deg') or 0)[:3]:
    say(f"- t_{r['tag']}.txt: PM {r['PM_deg']:.2f} deg, f_u {r['fu_Hz'] / 1e3:.1f} kHz, GM {r['GM_dB']:.2f} dB")

idx = {(r['corner'], r['vdd'], r['temp'], r['mon'], r['state']): r for r in okA + okB}
say()
say('## iptat_mon_en = 0 against 1 (same corner, VDD, T, state A)')
d = [(idx[k[:3] + ('0', 'A')], r) for k, r in idx.items() if k[3:] == ('1', 'A') and k[:3] + ('0', 'A') in idx]
say(f"- PM(0) - PM(1): {min(a['PM_deg'] - b['PM_deg'] for a, b in d):+.2f} .. {max(a['PM_deg'] - b['PM_deg'] for a, b in d):+.2f} deg")
say(f"- f_u(0) / f_u(1) - 1: {min(a['fu_Hz'] / b['fu_Hz'] - 1 for a, b in d) * 100:+.2f} .. "
    f"{max(a['fu_Hz'] / b['fu_Hz'] - 1 for a, b in d) * 100:+.2f} %")

say()
say(f"## State B against state A (tt, {worst[0]}, {worst[1]}; every T, VDD and monitor state)")
d = [(r, idx[k[:4] + ('A',)]) for k, r in idx.items() if k[4] == 'B' and k[:4] + ('A',) in idx]
for k, u in (('PM_deg', 'deg'), ('GM_dB', 'dB'), ('T0_dB', 'dB'), ('T0_phase_deg', 'deg')):
    say(f"- {k} B - A: {min(b[k] - a[k] for b, a in d):+.3g} .. {max(b[k] - a[k] for b, a in d):+.3g} {u}")
say(f"- f_u B / A - 1: {min(b['fu_Hz'] / a['fu_Hz'] - 1 for b, a in d) * 100:+.3g} .. "
    f"{max(b['fu_Hz'] / a['fu_Hz'] - 1 for b, a in d) * 100:+.3g} %")
fl = [(r, fails(r)) for r in okB if guar(r) and fails(r)]
say(f'- state B against the limits (guaranteed points): {len(fl)} of {len([r for r in okB if guar(r)])} miss')
for r, why in fl:
    say(f'  - {where(r)}: ' + ', '.join(why))

open(f'{out}/summary.md', 'w').write('\n'.join(L) + '\n')
print('\nwrote s6c/summary.md and s6c/all.csv')
