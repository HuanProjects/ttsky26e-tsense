#!/usr/bin/env python3
"""M5 7: fan tb_bg_startup.spice out over power-up ramps and summarize.

Usage (in the container, after netlisting tb_bg_startup.sch):
  python3 /foss/designs/tt_tsense/xschem/su7.py            # 7a: tt x -40/27/125 C x 1 us/10 ms x 1.62/1.98 V
  python3 /foss/designs/tt_tsense/xschem/su7.py grid       # 7b: 15 corners, the same T/ramp/VDD, mon 1 and 0
  python3 /foss/designs/tt_tsense/xschem/su7.py stateb     # 7b: tt/ss/ff x -40/125 C x both ramps to 1.62 V, state B
  python3 /foss/designs/tt_tsense/xschem/su7.py dip        # 7c: 1.80 -> 0.8 -> 1.80 V, tt/ss/ff x -40/125 C
  python3 /foss/designs/tt_tsense/xschem/su7.py off        # 7c: startup disabled (MSU2 delvto = 2), tt/ss/ff x -40/27/125 C x both ramps to 1.62 V
  python3 /foss/designs/tt_tsense/xschem/su7.py kick       # 7c: VDD steady at 1.80 V, a 1 uA x 1 us kick on vpg at 30 us; loop right (A) or wrong (W)
  python3 /foss/designs/tt_tsense/xschem/su7.py zero       # tt/ss/ff/sf/fs x -40/27/125 C x 1.62/1.80/1.98 V: start from the zero state (4b/4c), 1 ms
State W starts in state A at the design point; at 10 us only the input switches swap (swa <-> swb, chop left alone),
so the op-amp sees its inputs reversed and the loop sign flips while it sits at the design point.
Writes simulation/su7_<set>/: one deck + log per run, all.csv, summary.md.
"""
import csv, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_bg_startup.spice')
CORNERS = ['tt', 'll', 'hh', 'ss', 'ss_ll', 'ss_hh', 'ff', 'ff_ll', 'ff_hh',
           'sf', 'sf_ll', 'sf_hh', 'fs', 'fs_ll', 'fs_hh']
RAMPS = {'1us': ('1u', 'tran 5n 151u 0 50n', '151u'),      # (tr, tran line, t_end): 150 us after the ramp
         '10ms': ('10m', 'tran 1u 10.15m 0 1u', '10.15m'),
         'dip': ('122u', 'tran 5n 272u 0 50n', '272u'),     # settle counted from the end of the dip
         'kickdn': ('31u', 'tran 5n 220u 0 50n', '220u'),   # settle counted from the end of the kick
         'kickup': ('31u', 'tran 5n 220u 0 50n', '220u'),
         'zero': ('0', 'tran 20n 1m 0 50n', '1m')}          # VDD steady, core forced to the zero state
DIP = 'pwl(0 {vdd} 20u {vdd} 21u 0.8 121u 0.8 122u {vdd})'  # 1 us edges, 100 us at 0.8 V


def runs(which):
    if which == '7a':
        return [dict(c='tt', t=t, r=r, v=v, mon=1, st='A')
                for t in (-40, 27, 125) for r in ('1us', '10ms') for v in ('1.62', '1.98')]
    if which == 'grid':
        return [dict(c=c, t=t, r=r, v=v, mon=m, st='A') for m in (1, 0) for c in CORNERS
                for t in (-40, 27, 125) for r in ('1us', '10ms') for v in ('1.62', '1.98')]
    if which == 'stateb':
        return [dict(c=c, t=t, r=r, v='1.62', mon=1, st=s) for s in ('A', 'B') for c in ('tt', 'ss', 'ff')
                for t in (-40, 125) for r in ('1us', '10ms')]
    if which == 'dip':
        return [dict(c=c, t=t, r='dip', v='1.8', mon=1, st='A') for c in ('tt', 'ss', 'ff') for t in (-40, 125)]
    if which == 'off':
        return [dict(c=c, t=t, r=r, v='1.62', mon=1, st='Aoff') for c in ('tt', 'ss', 'ff')
                for t in (-40, 27, 125) for r in ('1us', '10ms')]
    if which == 'kick':
        return [dict(c='tt', t=t, r=r, v='1.8', mon=1, st=s) for s in ('A', 'W') for t in (-40, 27, 125)
                for r in ('kickdn', 'kickup')]
    if which == 'zero':
        return [dict(c=c, t=t, r='zero', v=v, mon=1, st='A') for c in ('tt', 'ss', 'ff', 'sf', 'fs')
                for t in (-40, 27, 125) for v in ('1.62', '1.8', '1.98')]
    sys.exit('set must be 7a, grid, stateb, dip, off, kick or zero')


def tag(k):
    return f"{k['c']}_{k['v']}V_{k['t']}C_{k['r']}_m{k['mon']}{k['st']}"


def deck(src, k):
    tr, tranline, tend = RAMPS[k['r']]
    v = k['v']
    s = src
    s = re.sub(r'sky130\.lib\.spice tt$', f"sky130.lib.spice {k['c']}", s, flags=re.M)
    s = re.sub(r'^\.param vdd=\S+ tr=\S+$', f'.param vdd={v} tr={tr}', s, flags=re.M)
    s = re.sub(r'v\(x1\.vpg\)=\S+', f'v(x1.vpg)={float(v) - 1.25:.2f}', s)
    s = re.sub(r'^option temp=\S+$', f"option temp={k['t']}", s, flags=re.M)
    s = re.sub(r'^tran .*$', tranline, s, flags=re.M)
    s = re.sub(r'^let tr = \S+$', f'let tr = {tr}', s, flags=re.M)
    s = re.sub(r'at=150u$', f'at={tend}', s, flags=re.M)
    if k['mon'] == 0:   # monitor off: P7's drain parked at VDD, I_PTAT read from the ich copy instead
        s = re.sub(r'^V7 iptat_mon p4 0$', 'V7 iptat_mon VDPWR 0', s, flags=re.M)
        s = s.replace('let ip = 2*i(v7)*1e9', 'let ip = 2*i(v4)*1e9')
    if k['r'] == 'dip':     # start steady at VDD, dip, come back
        s = s.replace('pwl(0 0 {tr} {vdd})', DIP).replace(' pwl(0 0 {tr} 0.70)', '')
    if k['r'] == 'zero':    # as 4b/4c: VDD already up, gate line at the rail, core nodes at 0 V
        s = s.replace(' pwl(0 0 {tr} {vdd})', '').replace(' pwl(0 0 {tr} 0.70)', '')
        s = s.replace('.control\n', f'.ic v(x1.vpg)={v} v(x1.va)=0 v(x1.vb)=0 v(vref)=0\n.control\n', 1)
    if k['r'].startswith('kick'):   # VDD steady; sink (dn) or source (up) 1 uA on vpg for 1 us at 30 us
        s = s.replace(' pwl(0 0 {tr} {vdd})', '').replace(' pwl(0 0 {tr} 0.70)', '')
        amp = '1u' if k['r'] == 'kickdn' else '-1u'
        s = s.replace('.control\n', f'Ikick x1.vpg 0 pulse(0 {amp} 30u 10n 10n 1u)\n.control\n', 1)
    if k['st'].endswith('off'):     # startup disabled, as in 4a/4b
        s = re.sub(r'^(option temp=\S+)$',
                   r'\1\nalter @m.x1.xcore.xsu.xmsu2.msky130_fd_pr__nfet_01v8[delvto]=2', s, flags=re.M)
    if k['st'] == 'W':  # the input pair swaps at 10 us (op and the start stay in state A)
        s = re.sub(r'^Vswa swa 0 .*$', 'Vswa swa 0 dc {vdd} pwl(0 {vdd} 10u {vdd} 10.1u 0)', s, flags=re.M)
        s = re.sub(r'^Vswb swb 0 .*$', 'Vswb swb 0 dc 0 pwl(0 0 10u 0 10.1u {vdd})', s, flags=re.M)
    if k['st'] == 'B':  # chop state B: swap both switch pairs (same loop)
        ramp = re.search(r'^Vswa swa 0 (.*)$', s, flags=re.M).group(1)
        for hi, lo in (('swa', 'swb'), ('chopb', 'chop')):
            s = re.sub(rf'^(V\w+ {hi} 0) .*$', r'\1 0', s, flags=re.M)
            s = re.sub(rf'^(V\w+ {lo} 0) .*$', rf'\1 {ramp}', s, flags=re.M)
    s = s.replace('echo RAMP ', f"echo RAMP corner={k['c']} vdd={v} temp={k['t']} ramp={k['r']} "
                                f"mon={k['mon']} state={k['st']} ")
    return s


def run(path):
    subprocess.run(f'ngspice -b {os.path.basename(path)} > {os.path.basename(path)}.log 2>&1',
                   shell=True, cwd=os.path.dirname(path))
    with open(path + '.log') as f:
        for line in f:
            if line.startswith('RAMP '):
                return dict(kv.split('=', 1) for kv in line.split()[1:])
    return None


def main():
    which = sys.argv[1] if len(sys.argv) > 1 else '7a'
    src = open(SRC).read().replace('\r', '')  # a code block pasted from Windows carries CRs
    if len(re.findall(r'^\.lib ', src, flags=re.M)) != 1:
        sys.exit('tb_bg_startup.spice must have exactly one .lib line: delete the extra one in the code block')
    if 'echo RAMP' not in src:
        sys.exit('netlist tb_bg_startup.sch first')
    out = os.path.join(SIM, f'su7_{which}')
    os.makedirs(out, exist_ok=True)
    # one OpenMP thread per ngspice, so twelve at once do not fight (a .spiceinit here replaces the home one)
    with open(os.path.expanduser('~/.spiceinit')) as f:
        init = re.sub(r'^set num_threads=.*$', 'set num_threads=1', f.read(), flags=re.M)
    open(os.path.join(out, '.spiceinit'), 'w').write(init)
    ks = runs(which)
    paths = []
    for k in ks:
        p = os.path.join(out, tag(k) + '.spice')
        open(p, 'w').write(deck(src, k))
        paths.append(p)
    print(f'{len(ks)} runs, 12 at a time ...', flush=True)
    with ThreadPoolExecutor(12) as ex:
        res = list(ex.map(run, paths))
    rows, bad = [], []
    for k, r in zip(ks, res):
        if r is None:
            bad.append(tag(k)); continue
        rows.append(r)
    cols = list(rows[0].keys()) if rows else []
    with open(os.path.join(out, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, cols); w.writeheader(); w.writerows(rows)

    def fl(r, x):
        try: return float(r[x])
        except ValueError: return float('nan')
    lines = [f'# M5 power-up ramps: set {which}', '',
             'Limits: settle_us <= 100 (vref within 1 % of its end value, counted from the end of the ramp, dip or kick; negative = already settled during the ramp, at the supply in vdd_at_settle); '
             '|dend_mV| <= 0.1 (end value vs the op at the final supply); no stuck state (Iptat_end > 1 uA).', '',
             '| corner | vdd | temp | ramp | mon | state | settle_us | vdd_at_settle | kicks | su_peak | vref_min | vref_end | dend_mV | va_vb_op_uV | flag |',
             '|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|']
    def vset(r):  # the supply when vref last entered its 1 % band (negative settle_us = inside the ramp)
        if r['ramp'] not in ('1us', '10ms'):
            return fl(r, 'vdd')
        trus = 1.0 if r['ramp'] == '1us' else 1e4
        return fl(r, 'vdd') * min(1.0, (fl(r, 'settle_us') + trus) / trus)
    nfail = 0
    for r in rows:
        f = []
        if not fl(r, 'settle_us') <= 100: f.append('SLOW')
        if not abs(fl(r, 'dend_mV')) <= 0.1: f.append('END')
        if not fl(r, 'Iptat_end_nA') > 1000: f.append('STUCK')
        if abs(fl(r, 'va_vb_op_uV')) > 1000: f.append('OP-OFF')
        nfail += bool(f)
        lines.append(f"| {r['corner']} | {r['vdd']} | {r['temp']} | {r['ramp']} | {r['mon']} | {r['state']} | "
                     f"{fl(r, 'settle_us'):.1f} | {vset(r):.3f} | {fl(r, 'kicks'):.0f} | {fl(r, 'su_peak'):.3f} | {fl(r, 'vref_min'):.3f} | "
                     f"{fl(r, 'vref_end'):.5f} | {fl(r, 'dend_mV'):.4f} | {fl(r, 'va_vb_op_uV'):.1f} | {' '.join(f)} |")
    if rows:
        slow = sorted(rows, key=lambda r: -fl(r, 'settle_us'))[:3]
        lines += ['', 'Slowest three: ' + '; '.join(f"{r['corner']} {r['vdd']} V {r['temp']} C {r['ramp']} "
                                                     f"mon {r['mon']} {r['state']}: {fl(r, 'settle_us'):.1f} us"
                                                     for r in slow)]
    lines += ['', f'{len(rows)} runs read, {nfail} flagged, {len(bad)} with no RAMP line' +
              (': ' + ', '.join(bad) if bad else '')]
    open(os.path.join(out, 'summary.md'), 'w').write('\n'.join(lines) + '\n')
    print('\n'.join(lines))


if __name__ == '__main__':
    main()
