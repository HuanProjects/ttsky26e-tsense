#!/usr/bin/env python3
"""M5 9: the chop checks on the real bgr (tb_bg_chop), built from your netlisted tb_bg_pvt bench.

Reads simulation/tb_bg_pvt.spice (netlist tb_bg_pvt.sch first) and writes simulation/chop9/:

  op   (9a)  op in chop states A and B at -20/25/100 C, delvto on ota2s MP1 = 0, 1.14 mV (the modelled
             3-sigma Vos, ~1.05 mV input-referred) and 10 mV.
             Checks (spec M5 chop row, reworded after 9a):
               |muA - muB|/2 >= 0.9 x |muA - mu0|          (10 mV)
               |muA - mu0| / |avg - mu0| >= 10             (10 mV)
               |avg - mu0| <= 1e-5 after the 25 C trim     (1.14 mV)
  tran (9b)  one tran per (temp, delvto): starts in state A, toggles chop A->B at 200 us, ich_sel 0->1 at
             400 us, i3_sel 0->1 at 600 us, stops at 800 us.
             Stand-in drive for the M7 non-overlap cells (not built yet): 1 ns edges, 5 ns gaps;
             swa/swb break-before-make, chop/chopb make-before-break, the dump switch closes before the TG opens.
             Checks: I_PTAT, V_REF and V_EB3 back within 0.01 % <= 36 us after each toggle;
                     I(vcap) 1.40 / 0.70 uA +-3 %; output branch 2.79 / 1.40 uA +-3 % (25 C, delvto = 0,
                     where the spec sets them).
             Gear integration: with the default trapezoidal method the 0 V meter sources V4/V7 keep a
             spurious ~+140 nA after the chop edges that decays over ~2 ms, while the P4/P7 device currents
             do not move. Gear removes it (i(v4) back to 1385.51 nA by 50 us).

Usage (in the container):  python3 /foss/designs/tt_tsense/xschem/chop9.py op|tran|all
"""
import os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_bg_pvt.spice')
OUT = os.path.join(SIM, 'chop9')
TEMPS = [-20, 25, 100]
MP1 = '@m.x1.xota.xmp1.msky130_fd_pr__pfet_01v8_lvt[delvto]'
P3A = '@m.x1.xcore.x1.xmp3a.msky130_fd_pr__pfet_01v8[id]'
P3B = '@m.x1.xcore.x1.xmp3b.msky130_fd_pr__pfet_01v8[id]'
DUMP3 = '@m.x1.xs_i3dump.msky130_fd_pr__nfet_01v8[id]'
T_TOG = [200e-6, 400e-6, 600e-6]
T_END = 800e-6
TOL = 1e-4          # 0.01 %
SETTLE_MAX = 36e-6


def netlist_body():
    """Everything in tb_bg_pvt.spice except its .control ... .endc block."""
    text = open(SRC).read()
    return re.sub(r'\.control.*?\.endc\n', '', text, flags=re.S)


def run(deck_path):
    log = deck_path.replace('.spice', '.log')
    with open(log, 'w') as f:
        subprocess.run(['ngspice', '-b', os.path.basename(deck_path)], cwd=OUT, stdout=f, stderr=subprocess.STDOUT)
    return open(log).read()


# ---------------------------------------------------------------- 9a: op
OP_CTL = """.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
set numdgt=10
let vd = 1.8
foreach t -20 25 100
  option temp=$t
  foreach dv 0 0.00114 0.01
    alter {mp1} = $dv
    alter vswa = $&vd
    alter vswb = 0
    alter vchop = 0
    alter vchopb = $&vd
    op
    let mu = 1 - v(veb3)/v(vref)
    let vos = (v(x1.vb)-v(x1.va))*1e6
    let ip = 2*i(v7)*1e9
    set mua = $&mu
    set vosa = $&vos
    set ipa = $&ip
    alter vswa = 0
    alter vswb = $&vd
    alter vchop = $&vd
    alter vchopb = 0
    op
    let mu = 1 - v(veb3)/v(vref)
    let vos = (v(x1.vb)-v(x1.va))*1e6
    let ip = 2*i(v7)*1e9
    echo CHOP temp=$t dv=$dv mua=$mua mub=$&mu vosA_uV=$vosa vosB_uV=$&vos IptatA_nA=$ipa IptatB_nA=$&ip vrefB=$&v(vref) veb3B=$&v(veb3)
  end
end
.endc
"""


def do_op():
    path = os.path.join(OUT, 'op9a.spice')
    with open(path, 'w') as f:
        f.write(netlist_body().replace('.end\n', OP_CTL.format(mp1=MP1) + '.end\n'))
    log = run(path)
    rows = {}
    for line in log.splitlines():
        if line.startswith('CHOP '):
            d = dict(kv.split('=') for kv in line.split()[1:])
            rows[(int(d['temp']), float(d['dv']))] = {k: float(v) for k, v in d.items()}
    if len(rows) != 9:
        sys.exit(f'op9a: expected 9 CHOP lines, got {len(rows)}; see {path.replace(".spice", ".log")}')
    out = ['## 9a, op (tt, 1.80 V)', '',
           '| T (C) | delvto | mu0 | muA | muB | avg - mu0 | halfdiff / A shift | cancellation | VosA / VosB (uV) | I_PTAT A / B (nA) |',
           '|---|---|---|---|---|---|---|---|---|---|']
    err14 = {}
    ok = True
    for t in TEMPS:
        mu0 = rows[(t, 0.0)]['mua']
        for dv in (0.00114, 0.01):
            r = rows[(t, dv)]
            a, b = r['mua'], r['mub']
            avg = (a + b) / 2
            sh = a - mu0
            ratio = abs(a - b) / 2 / abs(sh)
            canc = abs(sh) / abs(avg - mu0) if avg != mu0 else float('inf')
            if dv == 0.01:
                ok &= ratio >= 0.9 and canc >= 10
            else:
                err14[t] = avg - mu0
            out.append(f'| {t} | {dv*1e3:g} mV | {mu0:.6f} | {a:.6f} | {b:.6f} | {avg-mu0:+.3e} | {ratio:.3f} | {canc:.1f}x | '
                       f'{r["vosA_uV"]:.1f} / {r["vosB_uV"]:.1f} | {r["IptatA_nA"]:.1f} / {r["IptatB_nA"]:.1f} |')
        z = rows[(t, 0.0)]
        if abs(z['mua'] - z['mub']) > 2e-6:
            ok = False
            out.append(f'| {t} | 0 | state A and B differ at delvto = 0: {z["mua"]} vs {z["mub"]} (check the state sources) |')
    trim = {t: err14[t] - err14[25] for t in TEMPS}
    ok &= all(abs(v) <= 1e-5 for v in trim.values())
    out += ['', 'At 1.14 mV after the 25 C trim (avg - mu0 minus its 25 C value): ' +
            ', '.join(f'{t} C {v:+.2e}' for t, v in trim.items()) + ' (limit 1e-5)',
            f'Sign: muA - muB at +10 mV, 25 C = {rows[(25, 0.01)]["mua"] - rows[(25, 0.01)]["mub"]:+.6f}',
            f'9a {"PASS" if ok else "FAIL"}', '']
    return '\n'.join(out)


# ---------------------------------------------------------------- 9b: tran
def pwl_step(t0, v0, v1, edge=1e-9):
    return f'PWL(0 {v0} {t0:.9e} {v0} {t0 + edge:.9e} {v1})'


def drive_lines():
    """Stand-in non-overlap drive; vd = 1.8 V."""
    g, vd = 5e-9, 1.8
    tc, ti, t3 = T_TOG
    return {
        'Vswa':     f'Vswa swa 0 {pwl_step(tc, vd, 0)}',            # break ...
        'Vswb':     f'Vswb swb 0 {pwl_step(tc + g, 0, vd)}',        # ... before make
        'Vchop':    f'Vchop chop 0 {pwl_step(tc, 0, vd)}',          # make ...
        'Vchopb':   f'Vchopb chopb 0 {pwl_step(tc + g, vd, 0)}',    # ... before break
        'Vichdump': f'Vichdump ich_dump 0 {pwl_step(ti, 0, vd)}',   # dump closes first
        'Vichon':   f'Vichon ich_on 0 {pwl_step(ti + g, vd, 0)}',   # then the TG opens
        'Vichonb':  f'Vichonb ich_onb 0 {pwl_step(ti + g, 0, vd)}',
        'Vi3dump':  f'Vi3dump i3_dump 0 {pwl_step(t3, 0, vd)}',
        'Vi3on':    f'Vi3on i3_on 0 {pwl_step(t3 + g, vd, 0)}',
        'Vi3onb':   f'Vi3onb i3_onb 0 {pwl_step(t3 + g, 0, vd)}',
    }


TRAN_CTL = """.control
option reltol=1e-5 vntol=1e-8 abstol=1e-14 method=gear
option temp={temp}
alter {mp1} = {dv}
save v(vref) v(veb3) i(v7) i(v4) v(x1.vpg) {p3a} {p3b} {dump3}
tran 20n {tend} 0 50n
let ip = 2*i(v7)
let br = abs({p3a}) + abs({p3b}) - abs({dump3})
set wr_singlescale
set wr_vecnames
wrdata {wr} v(vref) v(veb3) ip i(v4) br v(x1.vpg)
.endc
"""


def tran_deck(temp, dv):
    tag = f'tr_{temp}C_dv{int(round(dv*1e3))}mV'
    body = netlist_body()
    for name, line in drive_lines().items():
        body = re.sub(rf'^{name} .*$', line, body, flags=re.M)
    ctl = TRAN_CTL.format(temp=temp, mp1=MP1, dv=dv, p3a=P3A, p3b=P3B, dump3=DUMP3,
                          tend=f'{T_END:.6e}', wr=tag + '.txt')
    path = os.path.join(OUT, tag + '.spice')
    with open(path, 'w') as f:
        f.write(body.replace('.end\n', ctl + '.end\n'))
    return path, tag


def settle(ts, xs, t0, t1):
    """Final = mean over [t1-5us, t1-0.5us]; settle = last time after t0 outside +-TOL x final, minus t0."""
    fin = [x for t, x in zip(ts, xs) if t1 - 5e-6 <= t <= t1 - 0.5e-6]
    final = sum(fin) / len(fin)
    last = t0
    for t, x in zip(ts, xs):
        if t0 < t < t1 and abs(x - final) > TOL * abs(final):
            last = t
    return final, last - t0


def do_tran():
    jobs = [tran_deck(t, dv) for t in TEMPS for dv in (0.0, 0.01)]
    with ThreadPoolExecutor(max_workers=6) as ex:
        list(ex.map(lambda j: run(j[0]), jobs))
    names = ['V_REF', 'V_EB3', 'I_PTAT', 'I(vcap)', 'branch']
    out = ['## 9b, tran toggles (tt, 1.80 V; stand-in non-overlap drive)', '',
           '| T (C) | delvto | window | V_REF (V) | V_EB3 (V) | I_PTAT (nA) | I(vcap) (nA) | branch (nA) | settle V_REF / V_EB3 / I_PTAT (us) | vpg min..max (V) |',
           '|---|---|---|---|---|---|---|---|---|---|']
    ok = True
    edges = [0.0] + T_TOG + [T_END]
    labels = ['start (A)', 'chop A->B', 'ich_sel 1', 'i3_sel 1']
    for path, tag in jobs:
        data = os.path.join(OUT, tag + '.txt')
        if not os.path.exists(data):
            out.append(f'| {tag} | no data, see {tag}.log |')
            ok = False
            continue
        rows = [list(map(float, l.split())) for l in open(data).read().splitlines()[1:] if l.strip()]
        ts = [r[0] for r in rows]
        temp, dv = tag.split('_')[1][:-1], tag.split('dv')[1]
        for k in range(4):
            t0, t1 = edges[k], edges[k + 1]
            fin, st = zip(*[settle(ts, [r[j + 1] for r in rows], t0, t1) for j in range(5)])
            vpg = [r[6] for r in rows if t0 < r[0] < t1]
            s3 = st[:3]
            if k > 0:
                ok &= max(s3) <= SETTLE_MAX
            if temp == '25' and dv == '0mV':
                exp_ich = 1400 if k < 2 else 700
                exp_br = 2790 if k < 3 else 1400
                ok &= abs(abs(fin[3]) * 1e9 / exp_ich - 1) <= 0.03 and abs(fin[4] * 1e9 / exp_br - 1) <= 0.03
            out.append(f'| {temp} | {dv} | {labels[k]} | {fin[0]:.5f} | {fin[1]:.5f} | {fin[2]*1e9:.1f} | {abs(fin[3])*1e9:.1f} | '
                       f'{fin[4]*1e9:.1f} | {" / ".join(f"{s*1e6:.1f}" for s in s3)} | {min(vpg):.3f}..{max(vpg):.3f} |')
    out += ['', f'9b {"PASS" if ok else "FAIL"} (settle <= 36 us to 0.01 %; I(vcap) and branch within 3 %)', '']
    return '\n'.join(out)


if __name__ == '__main__':
    mode = sys.argv[1] if len(sys.argv) > 1 else 'all'
    os.makedirs(OUT, exist_ok=True)
    subprocess.run(['cp', os.path.expanduser('~/.spiceinit'), OUT])
    parts = []
    if mode in ('op', 'all'):
        parts.append(do_op())
    if mode in ('tran', 'all'):
        parts.append(do_tran())
    text = '\n'.join(parts)
    open(os.path.join(OUT, f'summary_{mode}.md'), 'w').write(text)
    print(text)
