#!/usr/bin/env python3
"""M6 9: osc_core on the frozen bgr. Runs tb_osc.spice at tt 1.80 V (-20 / 25 / 100 C), ss -20 C 1.71 V and fs 100 C 1.71 V,
full slope, state A, with 30 fF added on bgr's ichb (spec R4: the layout capacitance of the ich gate's source side).
Per run: supply ramp, osc_en at 120 us, 12.5 REF periods, thr_sel -> EB for 14.5 periods.
Reports V_REF / V_EB3 / nb / supply current before osc_en and while the loop runs, the V_REF and nb ripple over one
REF period, T_REF (last 6 periods), T_EB (periods 9-12), mu against mu_DC = 1 - V_EB3/V_REF (bandgap at rest),
the dead time in one REF and one EB period, and vthr at the crossing (the R20 shift).
Usage (in the container, after netlisting tb_osc.sch):  python3 /foss/designs/tt_tsense/xschem/osc9.py
Writes simulation/osc9/: decks, logs, all.json, summary.md.
"""
import json, os, re, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_osc.spice')
OUT = os.path.join(SIM, 'osc9')
C_OSC = 5.06e-12
FROZEN = {-20: (1.23914, 0.78681, 2.39474e-6), 25: (1.24324, 0.709608, 2.77111e-6), 100: (1.24413, 0.574525, 3.33661e-6)}
JOBS = [('tt', -20, 1.8), ('tt', 25, 1.8), ('tt', 100, 1.8), ('ss', -20, 1.71), ('fs', 100, 1.71)]
SPEC_F = {-20: 179e3, 25: 206e3, 100: 246e3}
C_ICHB = '30f'


def add_ichb(s):
    """30 fF from ichb to VGND inside the bgr subcircuit (after its header and continuation lines)."""
    L = s.splitlines()
    i = next(k for k, ln in enumerate(L) if ln.startswith('.subckt bgr '))
    i += 1
    while L[i].startswith('+'):
        i += 1
    L.insert(i, f'Cichb ichb VGND {C_ICHB}')
    return '\n'.join(L) + '\n'


def run(job):
    corner, t, vdd = job
    vref, veb3, ipt = FROZEN[t]
    ich = ipt / 2
    tr = 1.066 * C_OSC * vref / ich + 90e-9
    te = 1.066 * C_OSC * veb3 / ich + 90e-9
    ten = 120e-6
    tsw = ten + 12.5 * tr
    tm = dict(ten=ten, tq0=ten - 20e-6, tr0=ten + 3 * tr, tw0=tsw - 1.2 * tr, tsw=tsw, te0=tsw + 9 * te, tend=tsw + 13 * te,
              tdr=ten + 9.5 * tr, tde=tsw + 10.5 * te)
    tstop = tsw + 14.5 * te
    s = add_ichb(open(SRC).read())
    s = re.sub(r'sky130\.lib\.spice tt$', f'sky130.lib.spice {corner}', s, flags=re.M)
    s = re.sub(r'^\.param vdd=.*$', f'.param vdd={vdd} ten={ten:.6g} tsw={tsw:.6g}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = re.sub(r'^tran 0\.2n \S+', f'tran 0.2n {tstop * 1e6:.3f}u', s, flags=re.M)
    for k, v in tm.items():
        s = re.sub(rf'^let {k} = \S+$', f'let {k} = {v:.6g}', s, flags=re.M)
    s = s.replace(')=0.9 ', f')={vdd / 2:.4f} ')
    tag = f'{corner}_{t}_{vdd}'
    d = os.path.join(OUT, tag)
    os.makedirs(d, exist_ok=True)
    deck, log = os.path.join(d, 'deck.spice'), os.path.join(d, 'deck.log')
    if os.path.isfile(log) and os.path.isfile(deck) and open(deck).read() == s and '\nDC2 ' in open(log).read():
        out = open(log).read()            # same deck already ran to the end: reuse its log
    else:
        open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
        open(deck, 'w').write(s)
        r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=14400)
        out = r.stdout
        open(log, 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    edges, tau, dc, dc2 = [], {}, {}, {}
    for line in out.splitlines():
        m = re.match(r'^r\d+ = ([-+0-9.eE]+)$', line)
        if m:
            edges.append(float(m.group(1)))
        if line.startswith('TAU '):
            kv = dict(re.findall(r'(\w+)=(REF|EB|[-+0-9.eE]+)', line))
            tau[kv['ph']] = {k: float(v) for k, v in kv.items() if k != 'ph'}
        if line.startswith('DC2 '):
            dc2 = {k: float(v) for k, v in re.findall(r'(\w+)=([-+0-9.eE]+)', line)}
        if line.startswith('DC '):
            dc = {k: float(v) for k, v in re.findall(r'(\w+)=([-+0-9.eE]+)', line)}
    ref = [e for e in edges if ten < e < tsw]
    eb = [e for e in edges if e > tsw]
    T_ref = (ref[-1] - ref[-7]) / 6
    T_eb = (eb[12] - eb[8]) / 4
    v = dict(corner=corner, temp=t, vdd=vdd, T_ref=T_ref, T_eb=T_eb, n_ref=len(ref), n_eb=len(eb), **dc, **dc2)
    v['mu'] = 1 - T_eb / T_ref
    v['mu_dc'] = 1 - dc['veb_a'] / dc['vref_a']
    v['ref_ppm'] = [((b - a) / T_ref - 1) * 1e6 for a, b in zip(ref, ref[1:])]
    v['eb_ppm'] = [((b - a) / T_eb - 1) * 1e6 for a, b in zip(eb, eb[1:])]
    for ph, x in tau.items():
        v[ph] = x
    return v


def main():
    os.makedirs(OUT, exist_ok=True)
    with ThreadPoolExecutor(5) as ex:
        rows = list(ex.map(run, JOBS))
    L = ['# M6 9: osc_core on the frozen bgr (state A, full slope, 30 fF on ichb)', '',
         '## The bandgap at rest and while the loop runs', '',
         '| corner | T | VDD | V_REF rest (V) | V_REF running - rest (uV) | V_REF ripple p-p (mV) | V_EB3 rest (V) | V_EB3 in EB - rest (uV) '
         '| nb rest (V) | nb running - rest (mV) | nb ripple p-p (mV) | I_DD rest / running (uA) |',
         '|---|---|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        L.append(f"| {r['corner']} | {r['temp']} | {r['vdd']} | {r['vref_a']:.5f} | {r['dvref'] * 1e6:+.2f} "
                 f"| {(r['vref_hi'] - r['vref_lo']) * 1e3:.2f} | {r['veb_a']:.5f} | {r['dveb'] * 1e6:+.2f} | {r['nb_a']:.4f} "
                 f"| {r['dnb'] * 1e3:+.3f} | {(r['nb_hi'] - r['nb_lo']) * 1e3:.2f} | {-r['iq'] * 1e6:.1f} / {-r['ir'] * 1e6:.1f} |")
    L += ['', '## The loop', '',
          '| corner | T | VDD | T_REF (us) | f_REF (kHz) | spec f_REF +-5 % | T_EB (us) | mu | mu_DC | mu / mu_DC - 1 |',
          '|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        f = 1 / r['T_ref']
        sf = SPEC_F[r['temp']]
        L.append(f"| {r['corner']} | {r['temp']} | {r['vdd']} | {r['T_ref'] * 1e6:.4f} | {f / 1e3:.1f} | {sf / 1e3:.0f} ({(f / sf - 1) * 100:+.1f} %) "
                 f"| {r['T_eb'] * 1e6:.4f} | {r['mu']:.5f} | {r['mu_dc']:.5f} | {(r['mu'] / r['mu_dc'] - 1) * 100:+.3f} % |")
    L += ['', '## Dead time and the vthr shift (one REF and one EB period)', '',
          '| corner | T | VDD | threshold | t_d (ns) | t_logic (ns) | switch on (ns) | tau (ns) | vthr - vref at the crossing (mV) '
          '| vthr - running V (mV) | vcap min (mV) |',
          '|---|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        for ph in ('REF', 'EB'):
            x = r[ph]
            base = r['vref_r'] if ph == 'REF' else r['veb_e']
            rel = (x['vth'] - x['vrc']) * 1e3 if ph == 'REF' else float('nan')
            L.append(f"| {r['corner']} | {r['temp']} | {r['vdd']} | {ph} | {x['td'] * 1e9:.2f} | {x['tlog'] * 1e9:.2f} | {x['ton'] * 1e9:.2f} "
                     f"| {x['tau'] * 1e9:.2f} | {rel:+.3f} | {(x['vth'] - base) * 1e3:+.3f} | {x['vmin'] * 1e3:.2f} |")
    L += ['', '## Settling (period vs the settled value, ppm)', '']
    for r in rows:
        L.append(f"- {r['corner']} {r['temp']} C {r['vdd']} V: REF " + ' '.join(f'{x:.0f}' for x in r['ref_ppm'])
                 + ' | EB ' + ' '.join(f'{x:.0f}' for x in r['eb_ppm']))
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    json.dump(rows, open(os.path.join(OUT, 'all.json'), 'w'), indent=1)
    print(txt)


if __name__ == '__main__':
    main()
