#!/usr/bin/env python3
"""M5 Monte Carlo of the real bgr with the chopped and unchopped trimmed residual.

Reads your netlisted simulation/tb_bg_pvt.spice and writes simulation/mc10/:
  nominal deck (tt) + NPROC mismatch decks (tt_mm, seeds 101..), each running its share of the chips.
  Per chip (reset = new mismatch draw, as in the M3 MC): op in chop states A and B at
  -40/-20/25/100/125 C x 1.71/1.80/1.89 V, normal mode (ich_sel = i3_sel = 0).
Residual (per chip, per VDD, one-point offset trim at 25 C):
  r(T) = [mu(T) - mu_nom(T)] - [mu(25) - mu_nom(25)],   dT = r / 1.443e-3 K
  unchopped mu = mu_A; chopped mu = (mu_A + mu_B)/2.
Targets (spec / budget, 3 sigma): unchopped <= 0.79 / 0.55 K, chopped <= 0.34 / 0.25 K at 100 / -20 C.
3 sigma is reported with its 95 % upper bound 1.09 x (N = 200).
Attribution: each chip error (PNP-only Delta V_EB, P3 and P2 mirror ratios, R3/R1, random Vos) is turned into its
trimmed effect on mu with the Appendix A sensitivities; their sum is checked against the measured chopped residual.

Usage (in the container):  python3 /foss/designs/tt_tsense/xschem/mc10.py [nchip] [nproc]   (default 200 8; about 22 min at 200 10)
                           python3 /foss/designs/tt_tsense/xschem/mc10.py analyze   (re-read the logs in simulation/mc10/ only)
"""
import math, os, re, subprocess, sys
from concurrent.futures import ThreadPoolExecutor
import numpy as np

SIM = '/foss/designs/tt_tsense/xschem/simulation'
SRC = os.path.join(SIM, 'tb_bg_pvt.spice')
OUT = os.path.join(SIM, 'mc10')
TEMPS = [-40, -20, 25, 100, 125]
VDDS = ['1.71', '1.8', '1.89']
SLOPE = 1.443e-3          # d mu / dT, M5 8a, -20..100 C
TARGET = {'unchopped': {100: 0.79, -20: 0.55}, 'chopped': {100: 0.34, -20: 0.25}}
M = '@m.x1.xcore.x1.xmp{0}.msky130_fd_pr__pfet_01v8[id]'

CTL = """.control
setseed {seed}
let n = 0
while n < {nchip}
  reset
  option reltol=1e-6 vntol=1e-9 abstol=1e-15
  set numdgt=10
  foreach t -40 -20 25 100 125
    option temp=$t
    foreach v 1.71 1.8 1.89
      alter vdd = $v
      alter vichon = $v
      alter vi3on = $v
      alter vswa = $v
      alter vswb = 0
      alter vchop = 0
      alter vchopb = $v
      op
      let mu = 1 - v(veb3)/v(vref)
      let vos = (v(x1.vb)-v(x1.va))*1e6
      let ip = 2*i(v7)*1e9
      let i1 = abs({p1})*1e9
      let i2 = abs({p2})*1e9
      let i3 = (abs({p3a}) + abs({p3b}))*1e9
      let i4 = abs(i(v4))*1e9
      set mua = $&mu
      set vosa = $&vos
      set ipa = $&ip
      set i1a = $&i1
      set i2a = $&i2
      set i3a = $&i3
      set i4a = $&i4
      set vrefa = $&v(vref)
      set veb3a = $&v(veb3)
      set vaa = $&v(x1.va)
      set vba = $&v(x1.vb)
      set eb2a = $&v(x1.xcore.eb2)
      alter vswa = 0
      alter vswb = $v
      alter vchop = $v
      alter vchopb = 0
      op
      let mu = 1 - v(veb3)/v(vref)
      let vos = (v(x1.vb)-v(x1.va))*1e6
      echo MC seed={seed} chip=$&n t=$t v=$v mua=$mua mub=$&mu vosa=$vosa vosb=$&vos ip=$ipa i1=$i1a i2=$i2a i3=$i3a i4=$i4a vref=$vrefa veb3=$veb3a va=$vaa vb=$vba eb2=$eb2a
    end
  end
  let n = n + 1
end
.endc
"""


def deck(name, lib, seed, nchip):
    body = re.sub(r'\.control.*?\.endc\n', '', open(SRC).read(), flags=re.S)
    body = re.sub(r'(sky130\.lib\.spice) tt\b', rf'\1 {lib}', body)
    ctl = CTL.format(seed=seed, nchip=nchip, p1=M.format('1'), p2=M.format('2'),
                     p3a=M.format('3a'), p3b=M.format('3b'))
    path = os.path.join(OUT, name + '.spice')
    open(path, 'w').write(body.replace('.end\n', ctl + '.end\n'))
    return path


def run(path):
    log = path.replace('.spice', '.log')
    with open(log, 'w') as f:
        subprocess.run(['ngspice', '-b', os.path.basename(path)], cwd=OUT, stdout=f, stderr=subprocess.STDOUT)
    return parse(log)


def parse(log):
    rows = []
    for line in open(log):
        if line.startswith('MC '):
            d = dict(kv.split('=') for kv in line.split()[1:])
            rows.append({k: (v if k == 'v' else float(v)) for k, v in d.items()})
    return rows


def sd(x):
    return float(np.std(x, ddof=1))


def simulate(nchip, nproc):
    os.makedirs(OUT, exist_ok=True)
    subprocess.run(['cp', os.path.expanduser('~/.spiceinit'), OUT])
    for old in os.listdir(OUT):
        if old.startswith('mc_s') and old.endswith('.log'):
            os.remove(os.path.join(OUT, old))
    per = [nchip // nproc + (1 if i < nchip % nproc else 0) for i in range(nproc)]
    jobs = [deck('nominal', 'tt', 1, 1)] + [deck(f'mc_s{101+i}', 'tt_mm', 101 + i, per[i]) for i in range(nproc) if per[i]]
    with ThreadPoolExecutor(max_workers=len(jobs)) as ex:
        list(ex.map(run, jobs))


def analyze():
    nom = {(r['t'], r['v']): r for r in parse(os.path.join(OUT, 'nominal.log'))}
    chips = {}
    for name in sorted(os.listdir(OUT)):
        if name.startswith('mc_s') and name.endswith('.log'):
            for r in parse(os.path.join(OUT, name)):
                chips.setdefault((r['seed'], r['chip']), {})[(r['t'], r['v'])] = r
    full = {k: c for k, c in chips.items() if len(c) == len(TEMPS) * len(VDDS)}
    off = {k for k, c in full.items() if any(abs(r['vosa'] - r['vosb']) > 4000 or r['ip'] < 1000 for r in c.values())}
    good = [c for k, c in full.items() if k not in off]
    N = len(good)
    out = [f'# M5 Monte Carlo (tt_mm, chips with every point {len(full)} of {len(chips)}, off-design excluded {len(off)}, N = {N})', '']

    def mu(r, chopped):
        return (r['mua'] + r['mub']) / 2 if chopped else r['mua']

    def resid(c, v, t, chopped):
        return ((mu(c[(t, v)], chopped) - mu(nom[(t, v)], chopped))
                - (mu(c[(25.0, v)], chopped) - mu(nom[(25.0, v)], chopped))) / SLOPE

    out += ['## Trimmed temperature residual, 3 sigma (K) [95 % upper bound 1.09x]', '',
            '| VDD | mode | ' + ' | '.join(f'{t} C' for t in TEMPS) + ' | target 100 / -20 C |', '|---|---|' + '---|' * (len(TEMPS) + 1)]
    ok = True
    for v in VDDS:
        for mode in ('unchopped', 'chopped'):
            cells = []
            for t in TEMPS:
                y = np.array([resid(c, v, float(t), mode == 'chopped') for c in good])
                s3 = 3 * sd(y)
                cells.append(f'{s3:.3f} [{1.09*s3:.3f}]')
                if t in TARGET[mode] and v == '1.8':
                    ok &= 1.09 * s3 <= TARGET[mode][t]
            out.append(f'| {v} | {mode} | ' + ' | '.join(cells) + f' | {TARGET[mode][100]} / {TARGET[mode][-20]} |')

    def feat(c, t, v='1.8'):
        """Per-chip errors at (t, v) against the nominal (tt) run, plus each one's effect on mu."""
        r, n = c[(t, v)], nom[(t, v)]
        vt = 8.617e-5 * (t + 273.15)
        m0, g = n['mua'], 10 * (1 - n['mua']) / n['vref']        # d mu / d(Delta V_EB) = K (1 - mu) / V_REF
        e3 = (r['i3'] / r['i1']) / (n['i3'] / n['i1']) - 1
        e2 = (r['i2'] / r['i1']) / (n['i2'] / n['i1']) - 1
        kap = ((r['vref'] - r['veb3']) / r['i3'] / ((r['vb'] - r['eb2']) / r['i2'])) / \
              ((n['vref'] - n['veb3']) / n['i3'] / ((n['vb'] - n['eb2']) / n['i2'])) - 1
        dI = 1.015 * vt * math.log((r['i1'] / r['i2']) / (n['i1'] / n['i2']))      # current-ratio part of Delta V_EB
        pnp = (r['va'] - r['eb2']) - (n['va'] - n['eb2']) - dI                      # PNP-only part of Delta V_EB
        vosr = (r['vosa'] - r['vosb']) / 2 * 1e-6
        return dict(e3=e3, e2=e2, kap=kap, pnp=pnp, vosr=vosr, vref=r['vref'], veb3=r['veb3'], ip=r['ip'], i4=r['i4'],
                    mu_pnp=g * pnp, mu_e2=g * dI, mu_e3=m0 * (1 - m0) * e3, mu_R=m0 * (1 - m0) * kap, mu_vos=-g * vosr)

    f25 = [feat(c, 25.0) for c in good]
    f100 = [feat(c, 100.0) for c in good]
    out += ['', '## Statistics at 25 C, 1.80 V (mean, sigma)', '', '| quantity | mean | sigma |', '|---|---|---|']
    for k, name, sc in [('vosr', 'random Vos (vosA - vosB)/2 (uV)', 1e6), ('e3', 'eps3 = P3/P1 ratio error (%)', 100),
                        ('e2', 'eps2 = P2/P1 ratio error (%)', 100), ('kap', 'R3/R1 ratio error (%)', 100),
                        ('pnp', 'PNP-only Delta V_EB error (uV)', 1e6), ('vref', 'V_REF (V)', 1), ('veb3', 'V_EB3 (V)', 1),
                        ('ip', 'I_PTAT (nA)', 1), ('i4', 'I_P4 = I(vcap) (nA)', 1)]:
        x = np.array([f[k] for f in f25]) * sc
        out.append(f'| {name} | {x.mean():.5g} | {sd(x):.4g} |')
    for k, name, sc in [('pnp', 'PNP-only Delta V_EB drift 25 -> 100 C (uV)', 1e6), ('e3', 'eps3 drift 25 -> 100 C (%)', 100),
                        ('vosr', 'random Vos drift 25 -> 100 C (uV)', 1e6)]:
        x = np.array([(b[k] - a[k]) * sc for a, b in zip(f25, f100)])
        out.append(f'| {name} | {x.mean():.4g} | {sd(x):.4g} |')

    out += ['', '## Where the trimmed residual comes from (1.80 V): 3 sigma of each term, K',
            'Each term = its effect on mu at T minus its effect at 25 C (the trim), / 1.443e-3. '
            'Delta V_EB terms use d mu/d V = K (1 - mu)/V_REF; gain terms use mu (1 - mu) x error.', '',
            '| T | PNP-only Delta V_EB | P3 mirror eps3 | P2/P1 current ratio | R3/R1 | op-amp random Vos | sum of core terms (corr. with chopped) | chopped measured | unchopped measured |',
            '|---|---|---|---|---|---|---|---|---|']
    for t in (100.0, -20.0, 125.0, -40.0):
        ft = [feat(c, t) for c in good]
        tr = {k: np.array([(b[k] - a[k]) / SLOPE for a, b in zip(f25, ft)]) for k in ('mu_pnp', 'mu_e3', 'mu_e2', 'mu_R', 'mu_vos')}
        core = tr['mu_pnp'] + tr['mu_e3'] + tr['mu_e2'] + tr['mu_R']
        ych = np.array([resid(c, '1.8', t, True) for c in good])
        yun = np.array([resid(c, '1.8', t, False) for c in good])
        out.append(f'| {t:g} C | ' + ' | '.join(f'{3*sd(tr[k]):.3f}' for k in ('mu_pnp', 'mu_e3', 'mu_e2', 'mu_R', 'mu_vos')) +
                   f' | {3*sd(core):.3f} ({np.corrcoef(core, ych)[0, 1]:.2f}) | {3*sd(ych):.3f} | {3*sd(yun):.3f} |')
    out += ['', f'MC {"PASS" if ok else "FAIL"} (95 % upper bound of 3 sigma within the targets at 1.80 V)', '']
    text = '\n'.join(out)
    open(os.path.join(OUT, 'summary.md'), 'w').write(text)
    with open(os.path.join(OUT, 'chips.csv'), 'w') as f:
        keys = ['seed', 'chip', 't', 'v', 'mua', 'mub', 'vosa', 'vosb', 'ip', 'i1', 'i2', 'i3', 'i4', 'vref', 'veb3', 'va', 'vb', 'eb2']
        f.write(','.join(keys) + '\n')
        for c in good:
            for r in c.values():
                f.write(','.join(str(r[k]) for k in keys) + '\n')
    print(text)


if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == 'analyze':
        analyze()
    else:
        simulate(int(sys.argv[1]) if len(sys.argv) > 1 else 200, int(sys.argv[2]) if len(sys.argv) > 2 else 8)
        analyze()
