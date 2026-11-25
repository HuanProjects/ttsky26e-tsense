#!/usr/bin/env python3
"""M6 7: threshold mux. Fans tb_thrmux.spice out over tt ss ff sf fs x -20 25 100 C x 1.71 1.8 1.89 V
(V_REF / V_EB3 = the frozen bgr values at T). Per point: worst R_on over 0.5-1.3 V of a standard and an lvt TG (and where),
R_on at 0.96 V (V_REF'), lvt TG off-leakage, break-before-make gaps of the thrmux gate signals (at VDD/2), and how long
vthr takes to settle within 0.1 mV after each switch. R_on curves (tt 25 C 1.8 V, ss -20 C 1.71 V) go to ron_*.txt.
Usage (in the container, after netlisting tb_thrmux.sch):  python3 /foss/designs/tt_tsense/xschem/mux7.py
Writes simulation/mux7/: decks, logs, all.csv, summary.md.
"""
import csv, os, re, shutil, subprocess
from concurrent.futures import ThreadPoolExecutor

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_thrmux.spice')
OUT = os.path.join(SIM, 'mux7')
CORNERS = ['tt', 'ss', 'ff', 'sf', 'fs']
TEMPS = [-20, 25, 100]
VDDS = [1.71, 1.8, 1.89]
FROZEN = {-20: (1.23914, 0.78681), 25: (1.24324, 0.709608), 100: (1.24413, 0.574525)}


def run(job):
    corner, t, vdd = job
    vref, veb3 = FROZEN[t]
    s = open(SRC).read()
    s = re.sub(r'sky130\.lib\.spice \S+$', f'sky130.lib.spice {corner}', s, flags=re.M)
    s = re.sub(r'^\.param vdd=.*$', f'.param vdd={vdd} vref={vref} veb3={veb3}', s, flags=re.M)
    s = re.sub(r'^\.temp \S+$', f'.temp {t}', s, flags=re.M)
    s = s.replace(')=0.9 ', f')={vdd / 2:.4f} ')
    s = s.replace('v(vthr)=0.7097 ', f'v(vthr)={veb3 + 1e-4:.6f} ').replace('v(vthr)=1.2431 ', f'v(vthr)={vref - 1e-4:.6f} ')
    tag = f'{corner}_{t}_{vdd}'
    d = os.path.join(OUT, tag)
    os.makedirs(d, exist_ok=True)
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(os.path.join(d, 'deck.spice'), 'w').write(s)
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d, timeout=3600)
    open(os.path.join(d, 'deck.log'), 'w').write(r.stdout + '\n--- stderr\n' + r.stderr)
    v = dict(corner=corner, temp=t, vdd=vdd)
    for line in r.stdout.splitlines():
        if line.split(' ')[0] in ('RON', 'LEAK', 'BBM'):
            v.update({k: float(x) for k, x in re.findall(r'(\w+)=([-+0-9.eE]+)', line)})
        m = re.match(r'^(rsmax|rlmax)\s*=\s*\S+\s+at=\s*(\S+)', line)
        if m:
            v[m.group(1) + '_at'] = float(m.group(2))
    if (corner, t, vdd) in (('tt', 25, 1.8), ('ss', -20, 1.71)) and os.path.isfile(os.path.join(d, 'ron_curve.txt')):
        shutil.copy(os.path.join(d, 'ron_curve.txt'), os.path.join(OUT, f'ron_{corner}_{t}_{vdd}.txt'))
    # break-before-make at VDD/2: to V_EB3 (A) and back to V_REF (B)
    v['gapA_ps'] = (min(v['a3'], v['a4']) - max(v['a1'], v['a2'])) * 1e12
    v['gapB_ps'] = (min(v['b3'], v['b4']) - max(v['b1'], v['b2'])) * 1e12
    v['settle_eb_ns'] = (v['s1'] - 1e-6) * 1e9
    v['settle_ref_us'] = (v['s2'] - 3e-6) * 1e6
    v['dip_mV'] = (vref - v['vrmin']) * 1e3
    return v


def main():
    os.makedirs(OUT, exist_ok=True)
    jobs = [(c, t, v) for c in CORNERS for t in TEMPS for v in VDDS]
    with ThreadPoolExecutor(8) as ex:
        rows = list(ex.map(run, jobs))
    keys = sorted({k for r in rows for k in r}, key=lambda k: list(rows[0].keys()).index(k) if k in rows[0] else 99)
    with open(os.path.join(OUT, 'all.csv'), 'w', newline='') as f:
        w = csv.DictWriter(f, keys)
        w.writeheader()
        w.writerows(rows)
    def worst(key, f=max):
        r = f(rows, key=lambda r: r[key])
        return r[key], r
    rs, rsr = worst('rsmax')
    rl, rlr = worst('rlmax')
    lk, lkr = worst('ilr_nA', max)
    hot = [r for r in rows if r['temp'] == 100]
    lk100 = max(max(r['ilr_nA'], r['ile_nA']) for r in hot)
    ga, gar = worst('gapA_ps', min)
    gb, gbr = worst('gapB_ps', min)
    L = ['# M6 7: threshold mux (45 points)', '',
         f"- Standard TG (nfet_01v8 2/0.5 + pfet_01v8 4/0.5), worst R_on over 0.5–1.3 V: {rs / 1e3:.0f} kOhm at {rsr['rsmax_at']:.3f} V "
         f"({rsr['corner']}, {rsr['temp']} C, {rsr['vdd']} V); at 0.96 V up to {max(r['rs096'] for r in rows) / 1e3:.0f} kOhm.",
         f"- lvt TG (nfet_01v8_lvt 2/0.5 + pfet_01v8_lvt 4/0.5), worst R_on over 0.5–1.3 V: {rl / 1e3:.2f} kOhm at {rlr['rlmax_at']:.3f} V "
         f"({rlr['corner']}, {rlr['temp']} C, {rlr['vdd']} V); limit 10 kOhm.",
         f"- lvt TG off-leakage at 100 C (between V_REF and V_EB3): max {lk100:.4f} nA; limit 0.1 nA.",
         f"- Break-before-make at VDD/2: to V_EB3 min {ga:+.0f} ps ({gar['corner']}, {gar['temp']} C, {gar['vdd']} V); "
         f"back to V_REF min {gb:+.0f} ps ({gbr['corner']}, {gbr['temp']} C, {gbr['vdd']} V).",
         f"- vthr within 0.1 mV of V_EB3 after {min(r['settle_eb_ns'] for r in rows):.0f}–{max(r['settle_eb_ns'] for r in rows):.0f} ns; "
         f"of V_REF after {min(r['settle_ref_us'] for r in rows):.2f}–{max(r['settle_ref_us'] for r in rows):.2f} us "
         f"(vref dips {min(r['dip_mV'] for r in rows):.0f}–{max(r['dip_mV'] for r in rows):.0f} mV when the 0.5 pF shares with the 2 pF decap).", '',
         '| corner | T | VDD | std R_on max (kOhm) @ V | std @0.96 V | lvt R_on max (kOhm) @ V | lvt leak (nA) | gap A / B (ps) | settle EB (ns) / REF (us) |',
         '|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        L.append(f"| {r['corner']} | {r['temp']} | {r['vdd']} | {r['rsmax'] / 1e3:.0f} @ {r['rsmax_at']:.2f} | {r['rs096'] / 1e3:.0f} "
                 f"| {r['rlmax'] / 1e3:.2f} @ {r['rlmax_at']:.2f} | {max(r['ilr_nA'], r['ile_nA']):.4f} | {r['gapA_ps']:+.0f} / {r['gapB_ps']:+.0f} "
                 f"| {r['settle_eb_ns']:.0f} / {r['settle_ref_us']:.2f} |")
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'summary.md'), 'w').write(txt + '\n')
    print(txt)


if __name__ == '__main__':
    main()
