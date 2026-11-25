#!/usr/bin/env python3
"""M6 2: delay or offset. Runs tb_cmp_slopes.spice twice: each copy on its own bias diode (as on chip),
and all nine copies on ONE shared diode. Separates the static offset (DC sweep) from the true delay and
forms r = (t0(s/2) + 11.5 ns) / (2 (t0(s) + 11.5 ns)).

Usage (in the container, after netlisting tb_cmp_slopes.sch):
  python3 /foss/designs/tt_tsense/xschem/slopes2.py
Writes simulation/slopes2/: the two decks + logs, summary.md.
"""
import os, re, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
OUT = os.path.join(SIM, 'slopes2')
SRC = os.path.join(SIM, 'tb_cmp_slopes.spice')
TL = 11.5          # ns, logic + reset added to the comparator delay (spec t_add)
NAMES = {0.7096: "V_EB3", 0.9605: "V_REF'", 1.2432: "V_REF"}


def shared(src):
    """All copies on nb1's diode: drop bias cells 2-9, rename nb2..nb9 -> nb1."""
    s = re.sub(r'^xb[2-9] .*\n', '', src, flags=re.M)
    return re.sub(r'\bnb[2-9]\b', 'nb1', s)


def run(tag, deck):
    os.makedirs(OUT, exist_ok=True)
    f = os.path.join(OUT, f'{tag}.spice')
    open(f, 'w').write(deck)
    open(os.path.join(OUT, '.spiceinit'), 'w').write(
        'set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset enable_noisy_r\nset numdgt=10\n')
    r = subprocess.run(['ngspice', '-b', f], capture_output=True, text=True, cwd=OUT, timeout=3600)
    open(os.path.join(OUT, f'{tag}.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    vals = {}
    for line in r.stdout.splitlines():
        if line.startswith('RESULT'):
            for k, v in re.findall(r'(\w+)=(\S+)', line):
                vals[k] = float(v)
    return vals


def copies(src):
    """k -> (threshold, slope V/us, crossing time s) from the Vthr/Vcap lines of the netlist."""
    th = {int(k): float(v) for k, v in re.findall(r'^Vthr(\d) vthr\d 0 (\S+)$', src, re.M)}
    out = {}
    for k, v0, t0, t1, v1 in re.findall(r'^Vcap(\d) .*pwl\(0 (\S+) (\S+)u \S+ (\S+)u (\S+)\)', src, re.M):
        k, v0, t0, t1, v1 = int(k), float(v0), float(t0), float(t1), float(v1)
        s = (v1 - v0) / (t1 - t0)                       # V/us
        out[k] = (th[k], s, (t0 + (th[k] - v0) / s) * 1e-6)
    return out


def analyse(vals, cp):
    rows = []
    for row in range(3):
        kf, kh, ks = 3 * row + 1, 3 * row + 2, 3 * row + 3
        cm, sf, _ = cp[kf]
        td = {k: (vals[f'to{k}'] - cp[k][2]) * 1e9 for k in (kf, kh, ks)}     # ns
        vos = (vals[f'trip{ks}'] - cm) * 1e3                                   # mV, static (DC)
        vslow = td[ks] * cp[ks][1]                                             # mV past vthr at the slow trip
        t0 = td[kf] - vos / sf                                                 # mV / (V/us) = ns
        t0h = td[kh] - vos / (sf / 2)
        r = (t0h + TL) / (2 * (t0 + TL))
        r_raw = (td[kh] + TL) / (2 * (td[kf] + TL))
        rows.append(dict(name=NAMES.get(cm, cm), cm=cm, td=td[kf], tdh=td[kh], tds=td[ks], vos=vos,
                         vslow=vslow, t0=t0, t0h=t0h, r=r, r_raw=r_raw))
    return rows


def main():
    src = open(SRC).read()
    cp = copies(src)
    with ThreadPoolExecutor(2) as ex:
        own, sh = ex.map(lambda a: run(*a), [('own', src), ('shared', shared(src))])
    lines = ['# M6 2: delay or offset (tt, 25 C, 1.80 V)', '']
    for tag, vals in (('own diode per copy', own), ('one shared diode', sh)):
        rows = analyse(vals, cp)
        lines += [f'## {tag}', '',
                  f'nb before the ramps {vals["nb0"]:.4f} V; during the runs {vals["nbmin"]:.4f} to {vals["nbmax"]:.4f} V'
                  f' (copy 1\'s nb; shared = everyone\'s)', '',
                  '| threshold | t_d full (ns) | t_d half (ns) | t_d slow (ns) | Vos DC (mV) | slow-ramp reading (mV) '
                  '| t0 full (ns) | t0 half (ns) | r | r without removing Vos |', '|' + '---|' * 10]
        for x in rows:
            lines.append(f'| {x["name"]} {x["cm"]} V | {x["td"]:.2f} | {x["tdh"]:.2f} | {x["tds"]:.1f} | {x["vos"]:+.3f} '
                         f'| {x["vslow"]:+.3f} | {x["t0"]:.2f} | {x["t0h"]:.2f} | {x["r"]:.4f} | {x["r_raw"]:.4f} |')
        lines.append('')
    txt = '\n'.join(lines)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
