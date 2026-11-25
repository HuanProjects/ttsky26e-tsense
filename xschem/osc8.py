#!/usr/bin/env python3
"""M6 8: osc_core on stand-in sources. Runs tb_osc_si.spice at tt, 1.80 V, -20 / 25 / 100 C, full slope (I_ch = I_PTAT/2)
and half slope (I_PTAT/4), with the frozen bgr values at T (V_REF, V_EB3, I_PTAT). Per run: 12.5 REF periods, then
thr_sel -> EB for 14.5 periods. T_REF = mean of the last 4 REF periods, T_EB = mean of EB periods 9-12 (8 discarded).
One REF and one EB period are taken apart: vcap crosses vthr (tc), cmp_raw rises (tcmp), the reset switch gate sw
rises and falls (tswon, tswoff) -> t_d, t_logic, switch-on time, and the dead time tau = tswoff - tc.
Then per T: mu at both slopes, the two-slope extraction (spec M6 step 2) of tau and mu0, and the split of the time
that is neither C*V/I nor tau into a part proportional to the threshold and a fixed part.
Usage (in the container, after netlisting tb_osc_si.sch):  python3 /foss/designs/tt_tsense/xschem/osc8.py
Writes simulation/osc8/: decks, logs, all.json, summary.md.
"""
import json, os, re, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_osc_si.spice')
OUT = os.path.join(SIM, 'osc8')
C_OSC = 5.06e-12
FROZEN = {-20: (1.23914, 0.78681, 2.39474e-6), 25: (1.24324, 0.709608, 2.77111e-6), 100: (1.24413, 0.574525, 3.33661e-6)}
TEMPS = [-20, 25, 100]
R_RAMP = 0.565          # r at V_REF from the comparator ramp bench (section 2, tt 25 C)


def run(job):
    t, half = job
    vref, veb3, ipt = FROZEN[t]
    ich = ipt / 2 / (2 if half else 1)
    tr = 1.066 * C_OSC * vref / ich + 90e-9
    te = 1.066 * C_OSC * veb3 / ich + 90e-9
    ten = 2e-6
    tsw = ten + 12.5 * tr
    tdr, tde = ten + 9.5 * tr, tsw + 10.5 * te
    tstop = tsw + 14.5 * te
    s = open(SRC).read()
    s = re.sub(r'^\.param vdd=.*$', f'.param vdd=1.8 vref={vref} veb3={veb3} ich={ich:.6g} ten={ten:.6g} tsw={tsw:.6g}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = re.sub(r'^Iref VDPWR nb \S+$', f'Iref VDPWR nb {ipt / 2:.6g}', s, flags=re.M)
    s = re.sub(r'^tran 0\.2n \S+', f'tran 0.2n {tstop * 1e6:.3f}u', s, flags=re.M)
    s = re.sub(r'^let tdr = \S+$', f'let tdr = {tdr:.6g}', s, flags=re.M)
    s = re.sub(r'^let tde = \S+$', f'let tde = {tde:.6g}', s, flags=re.M)
    tag = f'{t}_{"half" if half else "full"}'
    d = os.path.join(OUT, tag)
    os.makedirs(d, exist_ok=True)
    deck, log = os.path.join(d, 'deck.spice'), os.path.join(d, 'deck.log')
    if os.path.isfile(log) and os.path.isfile(deck) and open(deck).read() == s and open(log).read().count('\nTAU ') == 2:
        out = open(log).read()            # same deck already ran to the end: reuse its log
    else:
        open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
        open(deck, 'w').write(s)
        r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=7200)
        out = r.stdout
        open(log, 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    edges, tau = [], {}
    for line in out.splitlines():
        m = re.match(r'^r\d+ = ([-+0-9.eE]+)$', line)      # 'print' lines (numdgt 10); the meas echo has wider spacing
        if m:
            edges.append(float(m.group(1)))
        if line.startswith('TAU '):
            kv = dict(re.findall(r'(\w+)=(REF|EB|[-+0-9.eE]+)', line))
            tau[kv['ph']] = {k: float(v) for k, v in kv.items() if k != 'ph'}
    ref = [e for e in edges if e < tsw]
    eb = [e for e in edges if e > tsw]
    pr = [b - a for a, b in zip(ref, ref[1:])]
    pe = [b - a for a, b in zip(eb, eb[1:])]
    T_ref = (ref[-1] - ref[-7]) / 6       # last 6 REF periods
    T_eb = (eb[12] - eb[8]) / 4           # EB periods 9-12 (8 discarded)
    v = dict(temp=t, half=half, vref=vref, veb3=veb3, ich=ich, tsw=tsw, n_ref=len(ref), n_eb=len(eb),
             T_ref=T_ref, T_eb=T_eb, cvi_ref=C_OSC * vref / ich, cvi_eb=C_OSC * veb3 / ich,
             ref_ppm=[(p / T_ref - 1) * 1e6 for p in pr], eb_ppm=[(p / T_eb - 1) * 1e6 for p in pe])
    for ph, x in tau.items():             # differences formed inside ngspice (full precision)
        v[ph] = dict(td=x['td'], tlog=x['tlog'], ton=x['ton'], tau=x['tau'], vth=x['vth'], vmin=x['vmin'])
    return v


def main():
    os.makedirs(OUT, exist_ok=True)
    jobs = [(t, h) for t in TEMPS for h in (False, True)]
    with ThreadPoolExecutor(6) as ex:
        rows = list(ex.map(run, jobs))
    by = {(r['temp'], r['half']): r for r in rows}
    L = ['# M6 8: osc_core on stand-in sources (tt, 1.80 V)', '',
         '## Periods', '',
         '| T (C) | slope | I_ch (uA) | T_REF (us) | C V_REF / I (us) | extra (ns) | T_EB (us) | C V_EB3 / I (us) | extra (ns) | mu | mu0 = 1 - V_EB3/V_REF |',
         '|---|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        r['mu'] = 1 - r['T_eb'] / r['T_ref']
        r['mu0'] = 1 - r['veb3'] / r['vref']
        L.append(f"| {r['temp']} | {'half' if r['half'] else 'full'} | {r['ich'] * 1e6:.4f} | {r['T_ref'] * 1e6:.4f} | {r['cvi_ref'] * 1e6:.4f} "
                 f"| {(r['T_ref'] - r['cvi_ref']) * 1e9:.1f} | {r['T_eb'] * 1e6:.4f} | {r['cvi_eb'] * 1e6:.4f} | {(r['T_eb'] - r['cvi_eb']) * 1e9:.1f} "
                 f"| {r['mu']:.5f} | {r['mu0']:.5f} |")
    L += ['', '## Dead time, measured in the loop (one REF and one EB period)', '',
          '| T (C) | slope | threshold | t_d (ns) | t_logic (ns) | switch on (ns) | tau (ns) | vthr at the crossing - stand-in (mV) | vcap min after release (mV) |',
          '|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        for ph, vx in (('REF', r['vref']), ('EB', r['veb3'])):
            x = r[ph]
            L.append(f"| {r['temp']} | {'half' if r['half'] else 'full'} | {ph} | {x['td'] * 1e9:.2f} | {x['tlog'] * 1e9:.2f} | {x['ton'] * 1e9:.2f} "
                     f"| {x['tau'] * 1e9:.2f} | {(x['vth'] - vx) * 1e3:+.3f} | {x['vmin'] * 1e3:.2f} |")
    L += ['', '## Split of the rest: extra = T - C V/I - tau = a V + b  (two thresholds -> a, b)', '',
          '| T (C) | slope | rest REF (ns) | rest EB (ns) | a V_REF (ns) | b (ns) | C_lin = a I (fF) | Q0 = b I (fC) | V_o = Q0 / (C_osc + C_lin) (mV) |',
          '|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        xr = r['T_ref'] - r['cvi_ref'] - r['REF']['tau']
        xe = r['T_eb'] - r['cvi_eb'] - r['EB']['tau']
        a = (xr - xe) / (r['vref'] - r['veb3'])
        b = xr - a * r['vref']
        r.update(rest_ref=xr, rest_eb=xe, a=a, b=b, clin=a * r['ich'], q0=b * r['ich'], vo=b * r['ich'] / (C_OSC + a * r['ich']))
        L.append(f"| {r['temp']} | {'half' if r['half'] else 'full'} | {xr * 1e9:.1f} | {xe * 1e9:.1f} | {a * r['vref'] * 1e9:.1f} | {b * 1e9:.1f} "
                 f"| {r['clin'] * 1e15:.1f} | {r['q0'] * 1e15:.1f} | {r['vo'] * 1e3:.2f} |")
    L += ['', '## The same split on the threshold vcap actually meets (vthr at the crossing)', '',
          'The threshold shift dV = vthr(crossing) - stand-in costs C_osc dV / I of ramp; taking it out leaves what vcap itself carries.', '',
          '| T (C) | slope | dV REF (mV) | dV EB (mV) | its time REF / EB (ns) | C_lin (fF) | Q0 (fC) | V_o (mV) |',
          '|---|---|---|---|---|---|---|---|']
    for r in rows:
        vr, ve = r['REF']['vth'], r['EB']['vth']
        xr = r['T_ref'] - C_OSC * vr / r['ich'] - r['REF']['tau']
        xe = r['T_eb'] - C_OSC * ve / r['ich'] - r['EB']['tau']
        a = (xr - xe) / (vr - ve)
        b = xr - a * vr
        r.update(dv_ref=vr - r['vref'], dv_eb=ve - r['veb3'], clin2=a * r['ich'], q02=b * r['ich'], vo2=b * r['ich'] / (C_OSC + a * r['ich']))
        L.append(f"| {r['temp']} | {'half' if r['half'] else 'full'} | {r['dv_ref'] * 1e3:+.3f} | {r['dv_eb'] * 1e3:+.3f} "
                 f"| {C_OSC * r['dv_ref'] / r['ich'] * 1e9:.1f} / {C_OSC * r['dv_eb'] / r['ich'] * 1e9:.1f} | {r['clin2'] * 1e15:.1f} "
                 f"| {r['q02'] * 1e15:.1f} | {r['vo2'] * 1e3:.2f} |")
    L += ['', '## Two-slope extraction (spec M6 step 2)', '',
          'r_loop = tau_half / (2 tau_full) at V_REF, from the measured dead times; k = r / (1 - r);',
          '1/mu0_ext = 1/mu_half - k (1/mu_full - 1/mu_half);  tau_ext = (T_REF - T_EB)_full (1/mu_full - 1/mu_half) / (1 - r).', '',
          '| T (C) | mu_full | mu_half | r_loop | tau_ext (ns) | tau measured, full REF (ns) | mu0_ext | mu0 | mu0_ext / mu0 - 1 | - V_o / (V_REF + V_o) | tau_ext, mu0_ext with r = 0.565 |',
          '|---|---|---|---|---|---|---|---|---|---|---|']
    ext = []
    for t in TEMPS:
        f, h = by[(t, False)], by[(t, True)]
        r_loop = h['REF']['tau'] / (2 * f['REF']['tau'])
        out = dict(temp=t, r_loop=r_loop, r_loop_eb=h['EB']['tau'] / (2 * f['EB']['tau']))
        for nm, rr in (('loop', r_loop), ('ramp', R_RAMP)):
            k = rr / (1 - rr)
            d = 1 / f['mu'] - 1 / h['mu']
            out[f'mu0_{nm}'] = 1 / (1 / h['mu'] - k * d)
            out[f'tau_{nm}'] = (f['T_ref'] - f['T_eb']) * d / (1 - rr)
        vo = f['vo']
        L.append(f"| {t} | {f['mu']:.5f} | {h['mu']:.5f} | {r_loop:.4f} | {out['tau_loop'] * 1e9:.2f} | {f['REF']['tau'] * 1e9:.2f} "
                 f"| {out['mu0_loop']:.5f} | {f['mu0']:.5f} | {(out['mu0_loop'] / f['mu0'] - 1) * 100:+.3f} % | {-vo / (f['vref'] + vo) * 100:+.3f} % "
                 f"| {out['tau_ramp'] * 1e9:.2f} ns, {out['mu0_ramp']:.5f} |")
        ext.append(out)
    L += ['', '## Settling (period vs the settled value, ppm)', '']
    for r in rows:
        L.append(f"- {r['temp']} C {'half' if r['half'] else 'full'}: REF " + ' '.join(f'{x:.0f}' for x in r['ref_ppm'])
                 + ' | EB ' + ' '.join(f'{x:.0f}' for x in r['eb_ppm']))
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    json.dump(dict(rows=rows, ext=ext), open(os.path.join(OUT, 'all.json'), 'w'), indent=1)
    print(txt)


if __name__ == '__main__':
    main()
