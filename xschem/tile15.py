#!/usr/bin/env python3
"""M8: the whole tile driven at its pins, from the schematic netlist and from the flat extraction.

Netlists (built by "prep" into the output folder):
  sch    the tile's LVS netlist (mag/lvs_cells/tt_um_huanprojects_tsense.spice with montg and dig_top) on top of
         the five frozen netlists
  pex    mag/pex.sh's flat extraction (C only), with the MIM overlap that Magic counts twice taken out
         (section 2 of results_m8) and the zero-valued capacitors dropped
  schq / pexq   the same two without the 816 transistors of the three rings, for the long 0.2 ns runs (the rings
         are off during a conversion; their nets become VGND in the parasitics). In pexq, couplings under 0.05 fF
         are moved to VGND on both sides, so every net keeps its total capacitance. prep checks pexq's devices
         against schq in netgen.

Runs (tt unless said; the numbers are in docs/results_m8.md):
  mu       DC start, osc_en (ui_in[0]) at 3 us, 8.5 REF periods (the last 5 measured), thr_sel (ui_in[1]) -> EB for
           11.5 periods (periods 6-10 measured); 0.2 ns step, reltol 1e-4 (M6 section 11d). schq and pexq at
           -20 / 25 / 100 C 1.80 V at full and half slope, and ss -20 C 1.71 V, fs 100 C 1.71 V at full slope.
  sens     pexq at 25 C with the wiring capacitance of one group of comparator nets removed at a time.
  modes    every input pin in turn (25 C, 1.80 V, 1 ns step): REF, EB, half slope, chop state B, half current, the
           two analog monitors. schq and pexq (sch adds a ring phase: hours).
  stb      the bandgap loop by double injection (M5 section 6) on two copies of the tile, sch and pex.
  startup  sch and pex: supply ramps to 1.62 V (1 us and 10 ms at tt 27 C, ss -40 C, ff 125 C), every input 0.
  rings    pex: ring_en at 1 ns, 10 ps step, the three pad frequencies with the extracted wiring.
  speed    8 us of the mu deck, to time the solver.

Usage (in the container, after mag/pex.sh):  python3 tile15.py prep, then mu | sens | modes | stb | startup | rings
Environment: TILE15_JOBS = runs at a time (keep it at or under the number of cores).
Writes simulation/tile15/: the netlists, <run>/deck.spice and deck.log, <mode>.json, <mode>.md.
"""
import collections, json, os, re, subprocess, sys, time
from concurrent.futures import ThreadPoolExecutor

ROOT = os.environ.get('TSENSE', '/foss/designs/tt_tsense')
SIM = os.path.join(ROOT, 'xschem/simulation')
OUT = os.environ.get('TILE15_OUT', os.path.join(SIM, 'tile15'))
PEXDIR = os.environ.get('TILE_PEX', os.path.join(ROOT, 'mag/pex'))
TOP = 'tt_um_huanprojects_tsense'
LIB = '/foss/pdks/sky130A/libs.tech/combined/sky130.lib.spice'
HD = '/foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice'
NETGEN_SETUP = '/foss/pdks/sky130A/libs.tech/netgen/sky130A_setup.tcl'
FROZEN = ['bgr', 'osc_core', 'swdrv', 'readout_glue', 'ring3']
CELLS = ['montg', 'dig_top', TOP]
C_OSC = 5.06e-12
# frozen bgr at tt 1.80 V (freeze_m5 / mu_dc.csv): V_REF, V_EB3, I_PTAT
DC = {-20: (1.23914, 0.78681, 2.39474e-6), 25: (1.24324, 0.709608, 2.77111e-6), 100: (1.24413, 0.574525, 3.33661e-6)}
# Magic's met4-met3 overlap over one MIM unit (the bare unit cells through pex.sh; results_m8 section 2), fF, and the
# nets it lands on: (top plate, bottom plate, units, fF per unit)
MIM_FIX = [('osc_core_0.vcap', 'VGND', 4, 55.2292), ('vref_decap_0.vref', 'VGND', 2, 43.6988),
           ('bgr_0.xota.xrz.cz', 'bgr_0.xota.OUT', 8, 55.2292)]
C_LUMP = 0.05      # fF: pexq moves smaller couplings to VGND

# node names: the same nets in the two netlists (instance xdut)
P_SCH = dict(rst='xdut.rst', vcap='xdut.vcap', vthr='xdut.xosc.vthr', cmp='xdut.cmp_raw', sw='xdut.xosc.xos.sw',
             vref='xdut.vref', veb3='xdut.veb3', nb='xdut.xbgr.xcore.nb', vpg='xdut.xbgr.vpg', su='xdut.su',
             n1='xdut.xosc.xcmp.n1', x='xdut.ib_cmp2')
P_PEX = dict(rst='xdut.osc_core_0.rst', vcap='xdut.osc_core_0.vcap', vthr='xdut.osc_core_0.xmux.vthr',
             cmp='xdut.osc_core_0.cmp_raw', sw='xdut.osc_core_0.xos.xmrst.g0', vref='xdut.vref_decap_0.vref',
             veb3='xdut.osc_core_0.veb3', nb='xdut.bgr_0.xcore.xsu.nb', vpg='xdut.bgr_0.xota.out', su='xdut.dig_top_0.su',
             x='xdut.osc_core_0.ib_cmp2')
PROBE = {'sch': P_SCH, 'schq': P_SCH, 'pex': P_PEX, 'pexq': P_PEX}
SUBCKT = {'sch': TOP, 'schq': TOP, 'pex': 'tile_flat', 'pexq': 'tile_flat'}


# ------------------------------------------------------------------------------------------------------- netlists
def conv(path):
    """xschem writes a top-level cell as comments (**.subckt ... **.ends): turn those lines back into a subckt"""
    out, top = [], False
    for ln in open(path).read().splitlines():
        if ln.startswith('**.subckt '):
            out.append(ln[2:]); top = True
        elif top and ln.startswith('*+'):
            out.append(ln[1:])
        elif ln.startswith('**.ends'):
            out.append(ln[2:]); top = False
        elif ln.strip().lower() == '.end':
            top = False
        else:
            out.append(ln); top = False
    return '\n'.join(out) + '\n'


def sch_netlist(rings=True):
    s = ''.join(conv(os.path.join(SIM, f + '.spice')) for f in FROZEN)
    for c in CELLS:
        t = open(os.path.join(ROOT, 'mag/lvs_cells', c + '.spice')).read()
        if c == 'dig_top' and not rings:
            t, n = re.subn(r'^xring .*\n', '', t, flags=re.M)
            assert n == 1
        s += t + '\n'
    return s


def capval(v):
    m = re.match(r'([-+0-9.eE]+)([a-z]*)$', v)
    return float(m.group(1)) * {'f': 1.0, '': 1e15, 'p': 1e3, 'a': 1e-3}[m.group(2)]


def read_flat():
    """the flat extraction: port list, device lines (name, nodes, model, params), capacitors (a, b, fF)"""
    lvs = open(os.path.join(PEXDIR, TOP + '.lvs.spice')).read().replace('\n+', ' ')
    ports = re.search(r'^\.subckt \S+ (.*)$', lvs, flags=re.M).group(1).split()
    X, C = [], []
    for ln in open(os.path.join(PEXDIR, TOP + '.pex.spice')).read().replace('\n+', ' ').splitlines():
        t = ln.split()
        if ln[:1] == 'X':
            i = next(k for k, x in enumerate(t) if x.startswith('sky130'))
            X.append((t[0], t[1:i], t[i], t[i + 1:]))
        elif ln[:1] == 'C':
            C.append([t[1], t[2], capval(t[3])])
    return ports, X, C


def mim_fix(C):
    """take Magic's met4-met3 overlap over each MIM unit out of the capacitor between its plates"""
    log = []
    for top, bot, n, per in MIM_FIX:
        hit = [c for c in C if {c[0], c[1]} == {top, bot}]
        tot = sum(c[2] for c in hit)
        assert hit and tot > n * per, (top, bot, tot)
        big = max(hit, key=lambda c: c[2])
        big[2] -= n * per
        log.append((top, bot, tot, n * per, tot - n * per))
    return log


def ring_nets(X):
    """nets of the three rings: everything reached from a net named xring..., not through ring_en or a supply"""
    sup = {'VDPWR', 'VGND'}
    a1 = {n for x in X if len(x[1]) == 4 and x[1][1] == 'ui_in[6]' for n in (x[1][0], x[1][2])} - sup
    ren = {n for x in X if len(x[1]) == 4 and x[1][1] in a1 for n in (x[1][0], x[1][2])} - sup
    assert len(a1) == 1 and len(ren) == 1, (a1, ren)
    adj = collections.defaultdict(set)
    for x in X:
        ns = [n for n in x[1] if n not in sup and n not in ren]
        for a in ns:
            adj[a].update(ns)
    seen = {n for x in X for n in x[1] if 'xring' in n} - ren
    todo = list(seen)
    while todo:
        for b in adj[todo.pop()]:
            if b not in seen:
                seen.add(b); todo.append(b)
    return seen, ren.pop()


def flat_netlist(ports, X, C, name='tile_flat', caps=True):
    L = ['.subckt %s %s' % (name, ' '.join(ports))]
    L += ['%s %s %s %s' % (x[0], ' '.join(x[1]), x[2], ' '.join(x[3])) for x in X]
    if caps:
        L += ['C%d %s %s %.6gf' % (k, a, b, v) for k, (a, b, v) in enumerate(C)]
    return '\n'.join(L) + '\n.ends\n'


def add_dummies(net):
    """mag/lvs_dummies.txt: layout-only devices with every terminal on one supply; they go into the LVS copy only"""
    add = collections.defaultdict(list)
    for ln in open(os.path.join(ROOT, 'mag/lvs_dummies.txt')):
        if ln.strip() and not ln.startswith('#'):
            c, rest = ln.split(None, 1)
            add[c].append(rest.rstrip())
    out, cur = [], None
    for ln in net.splitlines():
        t = ln.split()
        if t and t[0] == '.subckt':
            cur = t[1]
        if t and t[0] == '.ends' and cur in add:
            out += add[cur]
        out.append(ln)
    return '\n'.join(out) + '\n'


def prep():
    os.makedirs(OUT, exist_ok=True)
    w = lambda f, s: open(os.path.join(OUT, f), 'w').write(s)
    w('dut_sch.spice', sch_netlist())
    w('dut_schq.spice', sch_netlist(rings=False))
    ports, X, C = read_flat()
    n0, c0 = len(C), sum(c[2] for c in C)
    fix = mim_fix(C)
    C = [c for c in C if c[2] > 0 and c[0] != c[1]]
    w('dut_pex.spice', flat_netlist(ports, X, C))
    # pexq: without the rings
    rn, ren = ring_nets(X)
    Xq = [x for x in X if not any(n in rn for n in x[1])]
    gnd = collections.Counter()
    Cq = []
    for a, b, v in C:
        a = 'VGND' if a in rn else a
        b = 'VGND' if b in rn else b
        if a == b:
            continue
        if 'VGND' in (a, b):
            gnd[b if a == 'VGND' else a] += v
        elif v < C_LUMP:
            gnd[a] += v; gnd[b] += v
        else:
            Cq.append([a, b, v])
    Cq += [[n, 'VGND', v] for n, v in sorted(gnd.items())]
    w('dut_pexq.spice', flat_netlist(ports, Xq, Cq))
    # the reduced device list is still the tile without ring3: netgen against schq
    w('lvs_pexq.spice', flat_netlist(ports, Xq, [], caps=False))
    w('lvs_schq.spice', '.include %s\n' % HD + add_dummies(sch_netlist(rings=False)) + '.end\n')
    r = subprocess.run(['netgen', '-batch', 'lvs', 'lvs_pexq.spice tile_flat', 'lvs_schq.spice ' + TOP, NETGEN_SETUP, 'lvs_pexq.out'],
                       capture_output=True, text=True, cwd=OUT)
    rep = open(os.path.join(OUT, 'lvs_pexq.out')).read()
    verdict = [ln for ln in rep.splitlines() if re.search(r'match uniquely|do not match|property errors|Netlists do not', ln, re.I)]
    L = ['# tile15 prep', '',
         '- extraction: %d devices, %d capacitors, %.1f fF in all' % (len(X), n0, c0),
         '- MIM overlap taken out (net pair: extracted, removed, left, fF): '
         + '; '.join('%s / %s: %.2f, %.2f, %.2f' % f for f in fix),
         '- pex: %d capacitors (zero-valued ones dropped), %.1f fF' % (len(C), sum(c[2] for c in C)),
         '- rings: %d nets, %d devices; ring_en = %s' % (len(rn), len(X) - len(Xq), ren),
         '- pexq: %d devices, %d capacitors (%d couplings of %.2f fF or more), %.1f fF'
         % (len(Xq), len(Cq), sum(1 for c in Cq if 'VGND' not in c[:2]), C_LUMP, sum(c[2] for c in Cq)),
         '- pexq devices against schq (netgen): ' + ' / '.join(v.strip() for v in verdict)]
    w('prep.md', '\n'.join(L) + '\n')
    print('\n'.join(L))


# ---------------------------------------------------------------------------------------------------------- bench
def top_node(p):
    if p == 'VGND':
        return '0'
    if p == 'VDPWR':
        return 'vdpwr'
    m = re.match(r'(\w+)\[(\d)\]', p)
    if m:
        return {'ua': 'ua', 'ui_in': 'ui', 'uo_out': 'uo', 'uio_in': 'uii', 'uio_out': 'uio', 'uio_oe': 'uie'}[m.group(1)] + m.group(2)
    return p


def bench(var, corner, temp, vdd_src, ui, opts='method=gear reltol=1e-4', nodeset=True):
    f = os.path.join(OUT, 'dut_%s.spice' % var)
    net = open(f).read()
    name = SUBCKT[var]
    pl = re.search(r'^\.subckt %s (.*(?:\n\+.*)*)' % re.escape(name), net, flags=re.M).group(1).replace('\n+', ' ').split()
    L = ['* tile15: the tile at its pins (%s)' % var,
         'xdut ' + ' '.join(top_node(p) for p in pl) + ' ' + name,
         'Vdd vdpwr 0 ' + vdd_src]
    for k in range(8):
        L += ['Vui%d ui%d 0 %s' % (k, k, ui.get(k, '0')), 'Vuii%d uii%d 0 0' % (k, k), 'Cuo%d uo%d 0 100f' % (k, k),
              'Cuio%d uio%d 0 20f' % (k, k), 'Cuie%d uie%d 0 20f' % (k, k)]
    if var.endswith('q'):          # the ring outputs have no driver left
        L += ['Rq%d uo%d 0 1k' % (k, k) for k in (1, 3, 6)]
    L += ['Vclk clk 0 0', 'Vena ena vdpwr 0', 'Vrstn rst_n vdpwr 0']
    # analog pins: pad 500 ohm + 5 pF; ua[0] into a 1 Gohm meter (pull-down cut), ua[1] into 100 kohm
    L += ['Rua0 ua0 ua0p 500', 'Cua0 ua0p 0 5p', 'Rm0 ua0p 0 1e9', 'Rua1 ua1 ua1p 500', 'Cua1 ua1p 0 5p', 'Rl1 ua1p 0 100k']
    L += ['Vua%d ua%d 0 0' % (k, k) for k in range(2, 8)]
    L += ['.lib %s %s' % (LIB, corner), '.include %s' % HD, '.include %s' % f, '.temp %g' % temp, '.option ' + opts]
    if nodeset:
        L += ['.nodeset v(%s)=1.24 v(%s)=0.71' % (PROBE[var]['vref'], PROBE[var]['veb3'])]
    return '\n'.join(L) + '\n'


def step(t, v0, v1, edge=1e-9):
    return 'pwl(0 %g %.9g %g %.9g %g)' % (v0, t, v0, t + edge, v1)


def pwl(points, edge=1e-9):
    """points: [(t, level)] -> a pwl source that starts at the first level and steps at each t"""
    s, lev = ['0 %g' % points[0][1]], points[0][1]
    for t, v in points[1:]:
        s += ['%.9g %g' % (t, lev), '%.9g %g' % (t + edge, v)]
        lev = v
    return 'pwl(' + ' '.join(s) + ')'


def run_deck(tag, deck):
    d = os.path.join(OUT, tag)
    os.makedirs(d, exist_ok=True)
    f, log = os.path.join(d, 'deck.spice'), os.path.join(d, 'deck.log')
    if os.path.isfile(log) and os.path.isfile(f) and open(f).read() == deck and 'TILE15_DONE' in open(log).read():
        return open(log).read()
    open(os.path.join(d, '.spiceinit'), 'w').write('set num_threads=1\nset ngbehavior=hsa\nset ng_nomodcheck\nset numdgt=10\n')
    open(f, 'w').write(deck)
    t0 = time.time()
    r = subprocess.run(['ngspice', '-b', 'deck.spice'], capture_output=True, text=True, cwd=d)
    open(log, 'w').write(r.stdout + '\n--- stderr\n' + r.stderr + '\nWALL %.1f s\n' % (time.time() - t0))
    return r.stdout


def edges(out, key):
    return [float(m.group(1)) for m in re.finditer(r'^%s\d+ = ([-+0-9.eE]+)$' % key, out, flags=re.M)]


def kv(out, key):
    for line in out.splitlines():
        if line.startswith(key + ' '):
            return {k: float(v) for k, v in re.findall(r'(\w+)=([-+0-9.eE]+)', line)}
    return {}


def meas_edges(key, node, level, n, kind='rise', td=None):
    return [x for k in range(1, n + 1) for x in
            ('meas tran %s%d when v(%s)=%.4f %s=%d%s' % (key, k, node, level, kind, k, '' if td is None else ' td=%.9g' % td),
             'print %s%d' % (key, k))]


# ---------------------------------------------------------------------------------------------------------------- mu
def mu_deck(var, corner, temp, vdd, slope='full', short=False):
    vref, veb3, ipt = DC[temp]
    ich = ipt / 2 if slope == 'full' else ipt / 4
    tr = 1.10 * C_OSC * vref / ich + 90e-9
    te = 1.10 * C_OSC * veb3 / ich + 90e-9
    ten = 3e-6
    tsw = ten + 8.5 * tr
    tstop = tsw + 11.5 * te
    if short:
        tstop = 8e-6
    p = PROBE[var]
    ui = {0: step(ten, 0, vdd), 1: step(tsw, 0, vdd)}
    if slope == 'half':
        ui[4] = 'dc %g' % vdd           # ich_sel
    head = bench(var, corner, temp, 'dc %g' % vdd, ui)
    tm = dict(ten=ten, tq0=1e-6, tr0=ten + 2 * tr, tw0=tsw - 1.2 * tr, tsw=tsw, te0=tsw + 5 * te, tend=tsw + 10 * te,
              tdr=ten + 5.5 * tr, tde=tsw + 7.5 * te)
    half = vdd / 2
    c = ['.control',
         'save v(%s) v(%s) v(%s) v(%s) v(%s) v(%s) v(%s) v(%s) v(%s) v(uo0) v(uo2) v(uo4) v(uo5) v(uo7) v(uio0) v(uie0) v(ua0p) v(ua1p) vdd#branch'
         % (p['rst'], p['vcap'], p['vthr'], p['cmp'], p['sw'], p['vref'], p['veb3'], p['nb'], p['x']),
         'tran 0.2n %.6gu 0 0.2n' % (tstop * 1e6)]
    c += ['let %s = %.9g' % kvp for kvp in tm.items()]
    c += ['meas tran vref0 find v(%s) at=1n' % p['vref'], 'meas tran veb0 find v(%s) at=1n' % p['veb3'],
          'meas tran uo40 find v(uo4) at=1n', 'echo OP vref0=$&vref0 veb0=$&veb0 uo40=$&uo40']
    if short:
        c += ['echo TILE15_DONE', '.endc']
        return head + '\n'.join(c) + '\n.end\n', tm
    c += meas_edges('r', p['rst'], half, 24)
    c += meas_edges('u', 'uo0', half, 24, 'cross')
    for ph, td in (('REF', 'tdr'), ('EB', 'tde')):
        c += ['meas tran tc when v(%s)=v(%s) rise=1 td=$&%s' % (p['vcap'], p['vthr'], td),
              'meas tran tx when v(%s)=%.4f rise=1 td=$&tc' % (p['x'], half),
              'meas tran tcmp when v(%s)=%.4f rise=1 td=$&tc' % (p['cmp'], half),
              'meas tran trst when v(%s)=%.4f rise=1 td=$&tc' % (p['rst'], half),
              'meas tran trstf when v(%s)=%.4f fall=1 td=$&tc' % (p['rst'], half),
              'meas tran tswon when v(%s)=%.4f rise=1 td=$&tc' % (p['sw'], half),
              'meas tran tswoff when v(%s)=%.4f fall=1 td=$&tc' % (p['sw'], half),
              'meas tran vth find v(%s) at=$&tc' % p['vthr'],
              'meas tran vrc find v(%s) at=$&tc' % p['vref'],
              'meas tran vec find v(%s) at=$&tc' % p['veb3'],
              'let tto = tswoff + 300n',
              'meas tran vmin min v(%s) from=$&tswoff to=$&tto' % p['vcap'],
              'let dx = tx - tc', 'let dtd = tcmp - tc', 'let dlog = tswon - tcmp', 'let don = tswoff - tswon',
              'let dtau = tswoff - tc', 'let wrst = trstf - trst',
              'echo TAU%s tx=$&dx td=$&dtd tlog=$&dlog ton=$&don tau=$&dtau wrst=$&wrst vth=$&vth vrc=$&vrc vec=$&vec vmin=$&vmin' % ph]
    c += ['meas tran vref_a avg v(%s) from=$&tq0 to=$&ten' % p['vref'],
          'meas tran veb_a avg v(%s) from=$&tq0 to=$&ten' % p['veb3'],
          'meas tran nb_a avg v(%s) from=$&tq0 to=$&ten' % p['nb'],
          'meas tran iq avg i(vdd) from=$&tq0 to=$&ten',
          'meas tran vref_r avg v(%s) from=$&tr0 to=$&tsw' % p['vref'],
          'meas tran nb_r avg v(%s) from=$&tr0 to=$&tsw' % p['nb'],
          'meas tran ir avg i(vdd) from=$&tr0 to=$&tsw',
          'meas tran vref_hi max v(%s) from=$&tw0 to=$&tsw' % p['vref'],
          'meas tran vref_lo min v(%s) from=$&tw0 to=$&tsw' % p['vref'],
          'meas tran nb_hi max v(%s) from=$&tw0 to=$&tsw' % p['nb'],
          'meas tran nb_lo min v(%s) from=$&tw0 to=$&tsw' % p['nb'],
          'meas tran veb_e avg v(%s) from=$&te0 to=$&tend' % p['veb3'],
          'meas tran uo4_q avg v(uo4) from=$&tq0 to=$&ten',
          'meas tran uo0_q max v(uo0) from=0 to=$&ten',
          'meas tran uo5_m max v(uo5)', 'meas tran uo7_m max v(uo7)', 'meas tran uio0_m max v(uio0)', 'meas tran uie0_m max v(uie0)',
          'meas tran ua0_m max v(ua0p)', 'meas tran ua1_m max v(ua1p)',
          'let dvref = vref_r - vref_a', 'let dvth_r = 0', 'echo DV dvref=$&dvref',
          'echo DC vref_a=$&vref_a veb_a=$&veb_a nb_a=$&nb_a iq=$&iq vref_r=$&vref_r nb_r=$&nb_r ir=$&ir vref_hi=$&vref_hi '
          'vref_lo=$&vref_lo nb_hi=$&nb_hi nb_lo=$&nb_lo veb_e=$&veb_e',
          'echo PIN uo4_q=$&uo4_q uo0_q=$&uo0_q uo5_m=$&uo5_m uo7_m=$&uo7_m uio0_m=$&uio0_m uie0_m=$&uie0_m ua0_m=$&ua0_m ua1_m=$&ua1_m',
          'echo TILE15_DONE', '.endc']
    return head + '\n'.join(c) + '\n.end\n', tm


def mu_run(job):
    var, corner, temp, vdd, slope = job
    deck, tm = mu_deck(var, corner, temp, vdd, slope)
    out = run_deck('mu_%s_%s_%g_%g%s' % (var, corner, temp, vdd, '' if slope == 'full' else '_half'), deck)
    r, u = edges(out, 'r'), edges(out, 'u')
    ref = [e for e in r if tm['ten'] < e < tm['tsw']]
    eb = [e for e in r if e > tm['tsw']]
    v = dict(var=var, corner=corner, temp=temp, vdd=vdd, slope=slope, n_ref=len(ref), n_eb=len(eb), n_rst=len(r), n_uo0=len(u))
    v['T_ref'] = (ref[-1] - ref[-6]) / 5
    v['T_eb'] = (eb[10] - eb[5]) / 5
    v['mu'] = 1 - v['T_eb'] / v['T_ref']
    v['uo0_lag'] = [b - a for a, b in zip(r, u)]
    v['ref_ppm'] = [((b - a) / v['T_ref'] - 1) * 1e6 for a, b in zip(ref, ref[1:])]
    v['eb_ppm'] = [((b - a) / v['T_eb'] - 1) * 1e6 for a, b in zip(eb, eb[1:])]
    for k in ('OP', 'DC', 'PIN', 'DV'):
        v.update(kv(out, k))
    v['REF'], v['EB'] = kv(out, 'TAUREF'), kv(out, 'TAUEB')
    v['mu_dc'] = 1 - v['veb_a'] / v['vref_a']
    return v


MU_PTS = [('tt', 25, 1.8, 'full'), ('tt', -20, 1.8, 'full'), ('tt', 100, 1.8, 'full'), ('ss', -20, 1.71, 'full'), ('fs', 100, 1.71, 'full'),
          ('tt', 25, 1.8, 'half'), ('tt', -20, 1.8, 'half'), ('tt', 100, 1.8, 'half')]
R_LOOP = 0.565          # the r of M6 sections 10 and 11 in the two-slope formula


def mu_main(args):
    which = [a for a in args if not a.startswith('-')] or ['schq', 'pexq']
    pts = MU_PTS[:3] if '-tt' in args else MU_PTS
    jobs = [(var, c, t, v, s) for c, t, v, s in pts for var in which]
    with ThreadPoolExecutor(int(os.environ.get('TILE15_JOBS', '6'))) as ex:
        rows = list(ex.map(mu_run, jobs))
    json.dump(rows, open(os.path.join(OUT, 'mu.json'), 'w'), indent=1)
    by = {(r['var'], r['corner'], r['temp'], r['vdd'], r['slope']): r for r in rows}
    rows = [by[(var, c, t, v, s)] for c, t, v, s in pts for var in which]
    tag = lambda r: '%s | %s %g C %g V %s' % (r['var'], r['corner'], r['temp'], r['vdd'], r['slope'])
    L = ['# tile15 mu: the tile at its pins, schematic and extracted (rings left out, state A)', '',
         '| netlist | point | V_REF rest (V) | V_EB3 rest (V) | I_DD rest / running (uA) | T_REF (us) | f_REF (kHz) | T_EB (us) | mu | mu_DC | mu / mu_DC - 1 |',
         '|---|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        L.append('| %s | %.5f | %.5f | %.1f / %.1f | %.4f | %.1f | %.4f | %.6f | %.5f | %+.3f %% |' % (
            tag(r), r['vref_a'], r['veb_a'], -r['iq'] * 1e6, -r['ir'] * 1e6, r['T_ref'] * 1e6, 1e-3 / r['T_ref'],
            r['T_eb'] * 1e6, r['mu'], r['mu_dc'], (r['mu'] / r['mu_dc'] - 1) * 100))
    L += ['', '| netlist | point | threshold | stage 2 at VDD/2 (ns) | t_d (ns) | t_logic (ns) | switch on (ns) | tau (ns) | rst width (ns) | vthr at the crossing - resting threshold (mV) | vcap min (mV) |',
          '|---|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        for ph in ('REF', 'EB'):
            x = r[ph]
            base = r['vref_a'] if ph == 'REF' else r['veb_a']
            L.append('| %s | %s | %.2f | %.2f | %.2f | %.2f | %.2f | %.2f | %+.3f | %.2f |' % (
                tag(r), ph, x.get("tx", float("nan")) * 1e9, x['td'] * 1e9, x['tlog'] * 1e9, x['ton'] * 1e9, x['tau'] * 1e9, x['wrst'] * 1e9,
                (x['vth'] - base) * 1e3, x['vmin'] * 1e3))
    L += ['', '| netlist | point | bg_ok at the start (V) | rst pulses / uo_out[0] edges | uo_out[0] lag (ns) | tie-offs max (mV) | ua[0] / ua[1] off, max (mV) | V_REF running - rest (uV) | V_REF ripple p-p (mV) | nb ripple p-p (mV) |',
          '|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        lag = r['uo0_lag']
        L.append('| %s | %.3f | %d / %d | %.2f - %.2f | %.3f | %.3f / %.3f | %+.1f | %.2f | %.1f |' % (
            tag(r), r['uo40'], r['n_rst'], r['n_uo0'], min(lag) * 1e9, max(lag) * 1e9,
            max(r['uo5_m'], r['uo7_m'], r['uio0_m'], r['uie0_m']) * 1e3, r['ua0_m'] * 1e3, r['ua1_m'] * 1e3,
            r['dvref'] * 1e6, (r['vref_hi'] - r['vref_lo']) * 1e3, (r['nb_hi'] - r['nb_lo']) * 1e3))
    L += ['', '## Settling (period vs the settled value, ppm)', '']
    for r in rows:
        L.append('- %s: REF ' % tag(r).replace(' | ', ' ') + ' '.join('%.0f' % x for x in r['ref_ppm'])
                 + ' | EB ' + ' '.join('%.0f' % x for x in r['eb_ppm']))
    if len(which) == 2:
        L += ['', '## Extracted against schematic', '',
              '| point | mu sch | mu pex | delta mu | as K (1.443e-3/K) | T_REF pex / sch - 1 | tau REF sch -> pex (ns) | tau EB sch -> pex (ns) |', '|---|---|---|---|---|---|---|---|']
        for c, t, v, s in pts:
            a, b = by[(which[0], c, t, v, s)], by[(which[1], c, t, v, s)]
            L.append('| %s %g C %g V %s | %.6f | %.6f | %+.2e | %+.3f | %+.2f %% | %.2f -> %.2f | %.2f -> %.2f |' % (
                c, t, v, s, a['mu'], b['mu'], b['mu'] - a['mu'], (b['mu'] - a['mu']) / 1.443e-3, (b['T_ref'] / a['T_ref'] - 1) * 100,
                a['REF']['tau'] * 1e9, b['REF']['tau'] * 1e9, a['EB']['tau'] * 1e9, b['EB']['tau'] * 1e9))
        if any(p[3] == 'half' for p in pts):
            k = R_LOOP / (1 - R_LOOP)
            L += ['', '## Two-slope mu0 (r = %g), tt 1.80 V' % R_LOOP, '',
                  '| T | mu0 sch | mu0 pex | delta mu0 | as K | minus the 25 C value (K): what a one-point trim leaves |', '|---|---|---|---|---|---|']
            d = {}
            for t in (-20, 25, 100):
                m = {}
                for var in which:
                    f, h = by[(var, 'tt', t, 1.8, 'full')]['mu'], by[(var, 'tt', t, 1.8, 'half')]['mu']
                    m[var] = 1 / (1 / h - k * (1 / f - 1 / h))
                d[t] = (m[which[0]], m[which[1]])
            for t in (-20, 25, 100):
                dm = d[t][1] - d[t][0]
                L.append('| %g | %.6f | %.6f | %+.2e | %+.3f | %+.3f |' % (t, d[t][0], d[t][1], dm, dm / 1.443e-3, (dm - (d[25][1] - d[25][0])) / 1.443e-3))
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'mu.md'), 'w').write(txt + '\n')
    print(txt)


# --------------------------------------------------------------------------------------------------------------- stb
def prep_brk():
    """the M5 section 6 break (ota2s output -> oa, the gate line keeps vpg), in both netlists, ports oa and vpg added"""
    w = lambda f, s: open(os.path.join(OUT, f), 'w').write(s)
    s = sch_netlist()
    assert s.count('xota inp inn vpg ') == 1
    s = s.replace('xota inp inn vpg ', 'xota inp inn oa ')
    s, n1 = re.subn(r'(^\.subckt bgr .*\n\+ su)$', r'\1 oa vpg', s, flags=re.M)
    s, n2 = re.subn(r'^(\+ swa swb su) bgr$', r'\1 oa vpg bgr', s, flags=re.M)
    s, n3 = re.subn(r'^(\+ uo_out\[0\] .* VGND VDPWR)$', r'\1 oa vpg', s, flags=re.M)
    assert (n1, n2, n3) == (1, 1, 1), (n1, n2, n3)
    w('dut_schb.spice', s)
    ports, X, C = read_flat()
    mim_fix(C)
    C = [c for c in C if c[2] > 0 and c[0] != c[1]]
    out, ib, g3 = 'bgr_0.xota.OUT', 'bgr_0.xota.IBIAS', 'bgr_0.xota.xrz.g3'
    Xb, moved = [], collections.Counter()
    for name, nodes, model, par in X:
        p = dict(x.split('=') for x in par)
        ota = (model.endswith('cap_mim_m3_1') and out in nodes) or \
              (model.endswith('pfet_01v8') and nodes[1] == ib and out in (nodes[0], nodes[2]) and p['w'] == '20') or \
              (model.endswith('nfet_01v8') and nodes[1] == g3 and out in (nodes[0], nodes[2]))
        if ota:
            nodes = ['oa' if n == out else n for n in nodes]
            moved[model] += 1
        Xb.append((name, nodes, model, par))
    assert sorted(moved.values()) == [1, 6, 8], moved         # MN3, MP3 x 6, Cc x 8
    w('dut_pexb.spice', flat_netlist(ports + ['oa', out], Xb, C))


def stb_deck(var, corner, vdd, temps, mon):
    f = os.path.join(OUT, 'dut_%s.spice' % var)
    net = open(f).read()
    name = TOP if var == 'schb' else 'tile_flat'
    pl = re.search(r'^\.subckt %s (.*(?:\n\+.*)*)' % re.escape(name), net, flags=re.M).group(1).replace('\n+', ' ').split()
    pr = P_SCH if var == 'schb' else P_PEX
    va = 'xbgr.xcore.va' if var == 'schb' else 'bgr_0.xcore.va'
    vb = 'xbgr.xcore.vb' if var == 'schb' else 'bgr_0.xcore.vb'
    L = ['* tile15 stb: Middlebrook double injection on the tile (%s), two copies' % var, 'Vdd vdpwr 0 %g' % vdd]
    for k in range(8):
        L += ['Vui%d ui%d 0 %g' % (k, k, vdd if (k == 3 and mon) else 0), 'Vuii%d uii%d 0 0' % (k, k)]
    L += ['Vclk clk 0 0', 'Vena ena vdpwr 0', 'Vrstn rst_n vdpwr 0'] + ['Vua%d ua%d 0 0' % (k, k) for k in range(2, 8)]
    shared = {'vdpwr', '0', 'clk', 'ena', 'rst_n'} | {'ui%d' % k for k in range(8)} | {'uii%d' % k for k in range(8)} | {'ua%d' % k for k in range(2, 8)}
    for t in 'vi':
        own = lambda n: n if n in shared else {'oa': 'oa_' + t, 'vpg': 'vpg_' + t, 'bgr_0.xota.OUT': 'vpg_' + t}.get(n, n + '_' + t)
        L.append('x%s ' % t + ' '.join(own(top_node(p)) for p in pl) + ' ' + name)
        L += ['Rua0%s ua0_%s ua0p_%s 500' % (t, t, t), 'Cua0%s ua0p_%s 0 5p' % (t, t), 'Rm0%s ua0p_%s 0 1e9' % (t, t),
              'Rua1%s ua1_%s ua1p_%s 500' % (t, t, t), 'Cua1%s ua1p_%s 0 5p' % (t, t), 'Rl1%s ua1p_%s 0 100k' % (t, t)]
        L += ['Cuo%d%s uo%d_%s 0 100f' % (k, t, k, t) for k in range(8)]
    g = vdd - 1.25
    ns = ' '.join('v(vpg_%s)=%.2f v(oa_%s)=%.2f v(x%s.%s)=1.24 v(x%s.%s)=0.71' % (t, g, t, g, t, pr['vref'][5:], t, pr['veb3'][5:]) for t in 'vi')
    L += ['Vinj vpg_v oa_v dc 0 ac 1', 'Vma oa_i n_i 0', 'Vmb n_i vpg_i 0', 'Iinj 0 n_i dc 0 ac 1',
          '.lib %s %s' % (LIB, corner), '.include %s' % HD, '.include %s' % f, '.nodeset ' + ns, '.control']
    for temp in temps:
        L += ['option temp=%g' % temp, 'op',
              'let vrefv = v(xv.%s)' % pr['vref'][5:], 'let vos = (v(xv.%s)-v(xv.%s))*1e6' % (va, vb), 'let idd = -i(vdd)*1e6/2',
              'let ua1 = v(ua1p_v)',
              'echo OPCHK temp=%g vref=$&vrefv va_vb_uV=$&vos idd_uA=$&idd ua1=$&ua1' % temp,
              'ac dec 40 1 1g',
              'let tv = -v(oa_v)/v(vpg_v)', 'let ti = -i(vma)/i(vmb)', 'let t = (tv*ti - 1)/(tv + ti + 2)',
              'let tdb = db(t)', 'let tph = cph(t)*180/pi',
              'meas ac t0db find tdb at=1', 'meas ac t0ph find tph at=1', 'meas ac fu when tdb=0', 'meas ac pmraw find tph when tdb=0',
              'meas ac f180 when tph=-180', 'meas ac gmraw find tdb when tph=-180', 'let pm = pmraw + 180', 'let gm = -gmraw',
              'echo STB temp=%g T0_dB=$&t0db T0_ph=$&t0ph fu=$&fu PM=$&pm f180=$&f180 GM=$&gm' % temp,
              'destroy all']
    L += ['echo TILE15_DONE', '.endc', '.end']
    return '\n'.join(L) + '\n'


def stb_run(job):
    var, corner, vdd, temps, mon = job
    out = run_deck('stb_%s_%s_%g_mon%d' % (var, corner, vdd, mon), stb_deck(var, corner, vdd, temps, mon))
    rows = []
    for temp in temps:
        a = next((ln for ln in out.splitlines() if ln.startswith('OPCHK temp=%g ' % temp)), '')
        b = next((ln for ln in out.splitlines() if ln.startswith('STB temp=%g ' % temp)), '')
        d = dict(var=var, corner=corner, vdd=vdd, temp=temp, mon=mon)
        d.update({k: float(v) for k, v in re.findall(r'(\w+)=([-+0-9.eE]+)', a + ' ' + b) if k != 'temp'})
        rows.append(d)
    return rows


def stb_main(args):
    prep_brk()
    grid = [('tt', 1.8, [-20, 25, 100]), ('ss', 1.8, [-20, 100]), ('ff', 1.8, [-20, 100]), ('sf', 1.71, [100]), ('ff', 1.89, [100])]
    jobs = [(var, c, v, t, mon) for c, v, t in grid for mon in (0, 1) for var in (args or ['schb', 'pexb'])]
    with ThreadPoolExecutor(int(os.environ.get('TILE15_JOBS', '4'))) as ex:
        rows = [r for rr in ex.map(stb_run, jobs) for r in rr]
    json.dump(rows, open(os.path.join(OUT, 'stb.json'), 'w'), indent=1)
    by = {(r['var'], r['corner'], r['vdd'], r['temp'], r['mon']): r for r in rows}
    L = ['# tile15 stb: the bandgap loop on the tile, schematic and extracted (state A)', '',
         '| corner | VDD | T | monitor | V_REF sch / pex (V) | f_u sch / pex (kHz) | PM sch / pex (deg) | GM sch / pex (dB) | T0 sch / pex (dB) |',
         '|---|---|---|---|---|---|---|---|---|']
    for c, v, ts in grid:
        for t in ts:
            for mon in (0, 1):
                a, b = by.get(('schb', c, v, t, mon), {}), by.get(('pexb', c, v, t, mon), {})
                g = lambda d, k, s=1.0: ('%.2f' % (d[k] * s)) if k in d else '-'
                L.append('| %s | %g | %g | %d | %s / %s | %s / %s | %s / %s | %s / %s | %s / %s |' % (
                    c, v, t, mon, g(a, 'vref').replace('.', '.', 1) if 'vref' not in a else '%.5f' % a['vref'],
                    '-' if 'vref' not in b else '%.5f' % b['vref'], g(a, 'fu', 1e-3), g(b, 'fu', 1e-3),
                    g(a, 'PM'), g(b, 'PM'), g(a, 'GM'), g(b, 'GM'), g(a, 'T0_dB'), g(b, 'T0_dB')))
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'stb.md'), 'w').write(txt + '\n')
    print(txt)


# ------------------------------------------------------------------------------------------------------------- modes
PH = [('REF', 2, 44), ('EB', 44, 74), ('half slope', 74, 134), ('chop B', 134, 186), ('half current', 186, 236)]
T_VMON, T_IMON, T_RING, T_END = 236, 256, 268, 270          # us


def modes_deck(var):
    vdd, half = 1.8, 0.9
    u = lambda *pts: pwl([(t * 1e-6, v * vdd) for t, v in pts])
    ui = {0: u((0, 0), (2, 1), (T_VMON, 0)), 1: u((0, 0), (44, 1), (74, 0)), 4: u((0, 0), (74, 1), (134, 0)),
          5: u((0, 0), (134, 1), (186, 0)), 7: u((0, 0), (186, 1), (T_VMON, 0)), 2: u((0, 0), (T_VMON, 1), (T_IMON, 0)),
          3: u((0, 0), (T_IMON, 1), (T_RING, 0))}
    rings = not var.endswith('q')
    if rings:
        ui[6] = u((0, 0), (T_RING, 1))
    tstop = T_END if rings else T_RING
    p = PROBE[var]
    c = ['.control',
         'save v(%s) v(%s) v(%s) v(%s) v(%s) v(uo0) v(uo1) v(uo2) v(uo3) v(uo4) v(uo6) v(ua0p) v(ua1p) vdd#branch'
         % (p['rst'], p['vcap'], p['vthr'], p['vref'], p['veb3']),
         'tran 1n %gu 0 1n' % tstop]
    c += meas_edges('r', p['rst'], half, 75)
    c += meas_edges('u', 'uo0', half, 75, 'cross')
    for k, (name, a, b) in enumerate(PH):
        c += ['meas tran vr%d avg v(%s) from=%gu to=%gu' % (k, p['vref'], b - 4, b),
              'meas tran ve%d avg v(%s) from=%gu to=%gu' % (k, p['veb3'], b - 4, b),
              'meas tran id%d avg i(vdd) from=%gu to=%gu' % (k, b - 10, b),
              'meas tran vt%d max v(%s) from=%gu to=%gu' % (k, p['vcap'], b - 12, b - 1),
              'echo PH%d vref=$&vr%d veb3=$&ve%d idd=$&id%d vpk=$&vt%d' % (k, k, k, k, k)]
    c += ['meas tran ua0_on find v(ua0p) at=%gu' % (T_IMON - 0.1), 'meas tran vref_on find v(%s) at=%gu' % (p['vref'], T_IMON - 0.1),
          'meas tran vref_dip min v(%s) from=%gu to=%gu' % (p['vref'], T_VMON, T_IMON),
          'meas tran ua1_on find v(ua1p) at=%gu' % (T_RING - 0.1), 'meas tran ua1_before find v(ua1p) at=%gu' % (T_IMON - 0.1),
          'meas tran ua0_before find v(ua0p) at=%gu' % (T_VMON - 0.1), 'meas tran uo4_min min v(uo4) from=1u',
          'meas tran idq avg i(vdd) from=0.5u to=1.9u', 'meas tran idmon avg i(vdd) from=%gu to=%gu' % (T_RING - 4, T_RING - 0.1),
          'echo MON ua0_on=$&ua0_on vref_on=$&vref_on vref_dip=$&vref_dip ua1_on=$&ua1_on ua1_before=$&ua1_before '
          'ua0_before=$&ua0_before uo4_min=$&uo4_min idq=$&idq idmon=$&idmon']
    if rings:
        for pin in (1, 3, 6):
            c += meas_edges('g%d_' % pin, 'uo%d' % pin, half, 12, 'rise', td=T_RING * 1e-6)
        c += ['meas tran idring avg i(vdd) from=%gu to=%gu' % (T_RING + 0.5, T_END), 'echo RING idring=$&idring']
    c += ['echo TILE15_DONE', '.endc']
    return bench(var, 'tt', 25, 'dc %g' % vdd, ui) + '\n'.join(c) + '\n.end\n'


def modes_run(var):
    out = run_deck('modes_' + var, modes_deck(var))
    r, u = edges(out, 'r'), edges(out, 'u')
    v = dict(var=var, n_rst=len(r), n_uo0=len(u), phases=[])
    for k, (name, a, b) in enumerate(PH):
        e = [x for x in r if a * 1e-6 < x < b * 1e-6]
        d = kv(out, 'PH%d' % k)
        d.update(name=name, n=len(e), T=(e[-1] - e[-4]) / 3 if len(e) >= 4 else float('nan'))
        v['phases'].append(d)
    v.update(kv(out, 'MON'))
    v.update(kv(out, 'RING'))
    for pin in (1, 3, 6):
        g = edges(out, 'g%d_' % pin)
        v['f_uo%d' % pin] = 1 / (g[-1] - g[-2]) if len(g) >= 2 else float('nan')
        v['n_uo%d' % pin] = len(g)
    v['late'] = len([x for x in r if x > T_VMON * 1e-6])
    return v


def modes_main(args):
    which = args or ['schq', 'pexq']
    with ThreadPoolExecutor(2) as ex:
        rows = list(ex.map(modes_run, which))
    json.dump(rows, open(os.path.join(OUT, 'modes.json'), 'w'), indent=1)
    L = ['# tile15 modes: every input pin in turn (tt, 25 C, 1.80 V)', '']
    for r in rows:
        L += ['## ' + r['var'], '', '| phase | ui_in | periods | T (us) | V_REF (V) | V_EB3 (V) | vcap peak (V) | I_DD (uA) |', '|---|---|---|---|---|---|---|---|']
        code = ['0x01', '0x03', '0x11', '0x21', '0x81']
        for c, p in zip(code, r['phases']):
            L.append('| %s | %s | %d | %.4f | %.5f | %.5f | %.4f | %.1f |' % (p['name'], c, p['n'], p['T'] * 1e6, p['vref'], p['veb3'], p['vpk'], -p['idd'] * 1e6))
        ph = {p['name']: p for p in r['phases']}
        L += ['', '- rst pulses %d, uo_out[0] edges %d; pulses after osc_en fell: %d; bg_ok minimum %.3f V' % (r['n_rst'], r['n_uo0'], r['late'], r['uo4_min']),
              '- mu (REF, EB) = %.5f; half slope / full slope period = %.4f; chop B / A period - 1 = %+.1f ppm; half current: T = %.4f us at V_REF = %.4f V'
              % (1 - ph['EB']['T'] / ph['REF']['T'], ph['half slope']['T'] / ph['REF']['T'], (ph['chop B']['T'] / ph['REF']['T'] - 1) * 1e6,
                 ph['half current']['T'] * 1e6, ph['half current']['vref']),
              '- ua[0]: %.4f mV before, %.5f V with vref_mon_en (V_REF then %.5f V; lowest V_REF after the switch closes %.4f V)'
              % (r['ua0_before'] * 1e3, r['ua0_on'], r['vref_on'], r['vref_dip']),
              '- ua[1] into 100 kohm: %.4f mV before, %.2f mV with iptat_mon_en (%.4f uA)' % (r['ua1_before'] * 1e3, r['ua1_on'] * 1e3, r['ua1_on'] / 0.1),
              '- I_DD: %.2f uA at rest, %.2f uA with the current monitor on' % (-r['idq'] * 1e6, -r['idmon'] * 1e6)]
        if 'idring' in r:
            L.append('- rings: uo_out[1] %.2f MHz, uo_out[3] %.2f MHz, uo_out[6] %.2f MHz (1 ns step: coarse); I_DD %.0f uA'
                     % (r['f_uo1'] / 1e6, r['f_uo3'] / 1e6, r['f_uo6'] / 1e6, -r['idring'] * 1e6))
        L.append('')
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'modes.md'), 'w').write(txt + '\n')
    print(txt)


# ------------------------------------------------------------------------------------------------------------- rings
RING_PTS = [('tt', 25, 1.8), ('ff', -20, 1.89), ('ss', -20, 1.71), ('sf', -20, 1.71)]


def rings_run(job):
    var, corner, temp, vdd = job
    half = vdd / 2
    c = ['.control', 'save v(uo1) v(uo3) v(uo6) vdd#branch', 'tran 10p 560n 0 10p']
    for pin in (1, 3, 6):
        c += meas_edges('g%d_' % pin, 'uo%d' % pin, half, 8)
    c += ['meas tran idr avg i(vdd) from=100n to=560n', 'echo RING idr=$&idr', 'echo TILE15_DONE', '.endc']
    deck = bench(var, corner, temp, 'dc %g' % vdd, {6: step(1e-9, 0, vdd, 0.1e-9)}, opts='method=gear') + '\n'.join(c) + '\n.end\n'
    out = run_deck('rings_%s_%s_%g_%g' % (var, corner, temp, vdd), deck)
    v = dict(var=var, corner=corner, temp=temp, vdd=vdd)
    v.update(kv(out, 'RING'))
    for pin in (1, 3, 6):
        g = edges(out, 'g%d_' % pin)
        v['n%d' % pin] = len(g)
        v['f%d' % pin] = 1 / (g[-1] - g[-2]) if len(g) >= 2 else float('nan')
    return v


def rings_main(args):
    ref = {}
    for ln in open(os.path.join(ROOT, 'docs/ring_table.csv')).read().splitlines()[1:]:
        t = ln.split(',')
        ref[(t[0], float(t[1]), float(t[2]))] = t
    hdr = open(os.path.join(ROOT, 'docs/ring_table.csv')).readline().strip().split(',')
    jobs = [(var, c, t, v) for c, t, v in RING_PTS for var in (args or ['pex'])]
    with ThreadPoolExecutor(int(os.environ.get('TILE15_JOBS', '4'))) as ex:
        rows = list(ex.map(rings_run, jobs))
    json.dump(rows, open(os.path.join(OUT, 'rings.json'), 'w'), indent=1)
    L = ['# tile15 rings: pad frequencies with the extracted wiring', '', 'ring_table.csv columns: ' + ' '.join(hdr), '',
         '| netlist | corner | T | VDD | uo_out[1] ringn (MHz) | uo_out[3] ringp (MHz) | uo_out[6] ring (MHz) | I_DD (uA) | ring_table.csv row |', '|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        k = next((x for x in ref if x[0] == r['corner'] and abs(x[1] - r['temp']) < 0.1 and abs(x[2] - r['vdd']) < 0.001), None) or \
            next((x for x in ref if x[0] == r['corner'] and abs(x[2] - r['temp']) < 0.1 and abs(x[1] - r['vdd']) < 0.001), None)
        L.append('| %s | %s | %g | %g | %.3f | %.3f | %.3f | %.0f | %s |' % (
            r['var'], r['corner'], r['temp'], r['vdd'], r['f1'] / 1e6, r['f3'] / 1e6, r['f6'] / 1e6, -r['idr'] * 1e6,
            ' '.join(ref[k]) if k else '-'))
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'rings.md'), 'w').write(txt + '\n')
    print(txt)


# ----------------------------------------------------------------------------------------------------------- startup
SU_PTS = [('tt', 27, 1e-6), ('ss', -40, 1e-6), ('ff', 125, 1e-6), ('tt', 27, 10e-3), ('ss', -40, 10e-3), ('ff', 125, 10e-3)]


def startup_run(job):
    var, corner, temp, tr = job
    vdd = 1.62
    p = PROBE[var]
    tstop = tr + 400e-6
    tmax = 50e-9 if tr < 1e-3 else 2e-6
    c = ['.control', 'save v(%s) v(%s) v(%s) v(uo4) v(uo0) v(vdpwr) vdd#branch' % (p['vref'], p['veb3'], p['su']),
         'tran %g %g 0 %g' % (tmax, tstop, tmax),
         'meas tran vfin find v(%s) at=%g' % (p['vref'], tstop - 1e-6),
         'meas tran v100 find v(%s) at=%g' % (p['vref'], tr + 100e-6),
         'meas tran vebfin find v(%s) at=%g' % (p['veb3'], tstop - 1e-6),
         'let lo = 0.99*vfin', 'let hi = 1.01*vfin',
         'meas tran t99 when v(%s)=lo cross=last' % p['vref'],
         'meas tran vmax max v(%s)' % p['vref'],
         'meas tran tbg when v(uo4)=%g rise=last' % (vdd / 2),
         'meas tran uo4fin find v(uo4) at=%g' % (tstop - 1e-6),
         'meas tran uo0max max v(uo0)', 'meas tran ifin find i(vdd) at=%g' % (tstop - 1e-6),
         'echo SU vfin=$&vfin v100=$&v100 vebfin=$&vebfin t99=$&t99 vmax=$&vmax tbg=$&tbg uo4fin=$&uo4fin uo0max=$&uo0max ifin=$&ifin',
         'meas tran tov when v(%s)=hi cross=last' % p['vref'], 'echo SU2 tov=$&tov',
         'echo TILE15_DONE', '.endc']
    deck = bench(var, corner, temp, 'pwl(0 0 %g %g)' % (tr, vdd), {}, opts='method=gear', nodeset=False) + '\n'.join(c) + '\n.end\n'
    out = run_deck('su_%s_%s_%g_%g' % (var, corner, temp, tr), deck)
    v = dict(var=var, corner=corner, temp=temp, tr=tr)
    v.update(kv(out, 'SU'))
    v.update(kv(out, 'SU2'))
    return v


def startup_main(args):
    jobs = [(var, c, t, tr) for c, t, tr in SU_PTS for var in (args or ['sch', 'pex'])]
    with ThreadPoolExecutor(int(os.environ.get('TILE15_JOBS', '4'))) as ex:
        rows = list(ex.map(startup_run, jobs))
    json.dump(rows, open(os.path.join(OUT, 'startup.json'), 'w'), indent=1)
    L = ['# tile15 startup: supply ramps to 1.62 V, every input 0', '',
         '| netlist | corner | T | ramp | V_REF final (V) | V_REF 100 us after the ramp (V) | inside 1 % for good, after the ramp (us) | V_REF max (V) | bg_ok rises, after the ramp (us) | bg_ok final (V) | uo_out[0] max (mV) | I_DD final (uA) |',
         '|---|---|---|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        g = lambda k: r.get(k, float('nan'))
        tin = max(g('t99'), r.get('tov', 0.0)) - r['tr']
        L.append('| %s | %s | %g | %s | %.5f | %.5f | %.1f | %.4f | %.1f | %.3f | %.2f | %.2f |' % (
            r['var'], r['corner'], r['temp'], '1 us' if r['tr'] < 1e-3 else '10 ms', g('vfin'), g('v100'), tin * 1e6, g('vmax'),
            (g('tbg') - r['tr']) * 1e6, g('uo4fin'), g('uo0max') * 1e3, -g('ifin') * 1e6))
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'startup.md'), 'w').write(txt + '\n')
    print(txt)


# -------------------------------------------------------------------------------------------------------------- sens
def sens_groups():
    """wiring nets of the comparator and the one-shot in the flat netlist, found by what they connect"""
    ports, X, C = read_flat()
    vcap, vthr, ib1 = 'osc_core_0.vcap', 'osc_core_0.xmux.vthr', 'osc_core_0.ib_cmp1'
    drain = lambda g: ({n for x in X if x[2].endswith('nfet_01v8_lvt') and x[1][1] == g for n in (x[1][0], x[1][2])} - {ib1}).pop()
    n1, nd = drain(vcap), drain(vthr)
    names = {n for c in C for n in c[:2]}
    g = collections.OrderedDict()
    g['n1 (stage 1 output)'] = {n1}
    g['nd (stage 1 diode side)'] = {nd}
    g['ib_cmp2 (stage 2 output, the bias wire)'] = {'osc_core_0.ib_cmp2'}
    g['ib_cmp1 (tail, the bias wire)'] = {ib1}
    g['inverter node and cmp_raw'] = {'osc_core_0.xcmp.cmp2s_arr_0/XMIP.D', 'osc_core_0.cmp_raw'}
    g['one-shot nodes and rst'] = {n for n in names if n.startswith('osc_core_0.xos.')} | {'osc_core_0.rst'}
    g['all six'] = set().union(*g.values())
    return g


def sens_run(job):
    k, name, nets, pair = job
    var = 's%d_pexq' % k
    base = open(os.path.join(OUT, 'dut_pexq.spice')).read().splitlines()
    out, gone = [], 0.0
    for ln in base:
        t = ln.split()
        if ln[:1] == 'C' and ((pair and set(t[1:3]) == pair) or (not pair and (t[1] in nets or t[2] in nets))):
            gone += capval(t[3])
            continue
        out.append(ln)
    open(os.path.join(OUT, 'dut_%s.spice' % var), 'w').write('\n'.join(out) + '\n')
    PROBE[var], SUBCKT[var] = P_PEX, 'tile_flat'
    vref, veb3, ipt = DC[25]
    tr = 1.10 * C_OSC * vref / (ipt / 2) + 90e-9
    ten, vdd, half, p = 3e-6, 1.8, 0.9, P_PEX
    tstop, tdr = ten + 7.6 * tr, ten + 4.5 * tr
    c = ['.control', 'save v(%s) v(%s) v(%s) v(%s) v(%s) v(%s) v(%s)' % (p['rst'], p['vcap'], p['vthr'], p['cmp'], p['sw'], p['vref'], p['x']),
         'tran 0.2n %.6gu 0 0.2n' % (tstop * 1e6)] + meas_edges('r', p['rst'], half, 9)
    c += ['meas tran tc when v(%s)=v(%s) rise=1 td=%.9g' % (p['vcap'], p['vthr'], tdr),
          'meas tran tx when v(%s)=%.4f rise=1 td=$&tc' % (p['x'], half),
          'meas tran tcmp when v(%s)=%.4f rise=1 td=$&tc' % (p['cmp'], half),
          'meas tran trst when v(%s)=%.4f rise=1 td=$&tc' % (p['rst'], half),
          'meas tran trstf when v(%s)=%.4f fall=1 td=$&tc' % (p['rst'], half),
          'meas tran tswon when v(%s)=%.4f rise=1 td=$&tc' % (p['sw'], half),
          'meas tran tswoff when v(%s)=%.4f fall=1 td=$&tc' % (p['sw'], half),
          'meas tran vth find v(%s) at=$&tc' % p['vthr'],
          'let dx = tx - tc', 'let dtd = tcmp - tc', 'let dlog = tswon - tcmp', 'let don = tswoff - tswon', 'let dtau = tswoff - tc',
          'let wrst = trstf - trst', 'echo TAUREF tx=$&dx td=$&dtd tlog=$&dlog ton=$&don tau=$&dtau wrst=$&wrst vth=$&vth',
          'echo TILE15_DONE', '.endc']
    log = run_deck('sens_%d' % k, bench(var, 'tt', 25, 'dc %g' % vdd, {0: step(ten, 0, vdd)}) + '\n'.join(c) + '\n.end\n')
    r = edges(log, 'r')
    v = dict(name=name, gone=gone, T_ref=(r[-1] - r[-4]) / 3, n=len(r))
    v.update(kv(log, 'TAUREF'))
    return v


def sens_main(args):
    g = sens_groups()
    jobs = [(0, 'nothing removed', set(), None)] + [(k + 1, n, nets, None) for k, (n, nets) in enumerate(g.items())]
    jobs.append((len(jobs), 'the vcap - vref coupling alone', set(), {'osc_core_0.vcap', 'vref_decap_0.vref'}))
    with ThreadPoolExecutor(int(os.environ.get('TILE15_JOBS', '5'))) as ex:
        rows = list(ex.map(sens_run, jobs))
    json.dump(rows, open(os.path.join(OUT, 'sens.json'), 'w'), indent=1)
    b = rows[0]
    L = ['# tile15 sens: which wiring capacitance slows the comparator (extracted, tt, 25 C, 1.80 V, REF, full slope)', '',
         '| wiring capacitance removed | removed (fF) | stage 2 at VDD/2 (ns) | t_d (ns) | t_logic (ns) | switch on (ns) | tau (ns) | tau - base (ns) | T_REF - base (ns) |',
         '|---|---|---|---|---|---|---|---|---|']
    for r in rows:
        L.append('| %s | %.1f | %.2f | %.2f | %.2f | %.2f | %.2f | %+.2f | %+.2f |' % (
            r['name'], r['gone'], r['tx'] * 1e9, r['td'] * 1e9, r['tlog'] * 1e9, r['ton'] * 1e9, r['tau'] * 1e9,
            (r['tau'] - b['tau']) * 1e9, (r['T_ref'] - b['T_ref']) * 1e9))
    txt = '\n'.join(L)
    open(os.path.join(OUT, 'sens.md'), 'w').write(txt + '\n')
    print(txt)


def speed_main(args):
    for var in args or ['schq', 'pexq']:
        deck, tm = mu_deck(var, 'tt', 25, 1.8, short=True)
        t0 = time.time()
        out = run_deck('speed_' + var, deck)
        print(var, 'wall %.1f s for 8 us (40,000 steps of 0.2 ns)' % (time.time() - t0),
              kv(out, 'OP') if 'TILE15_DONE' in out else 'FAILED')


if __name__ == '__main__':
    mode = sys.argv[1] if len(sys.argv) > 1 else 'mu'
    os.makedirs(OUT, exist_ok=True)
    {'prep': lambda a: prep(), 'mu': mu_main, 'speed': speed_main, 'stb': stb_main, 'modes': modes_main, 'rings': rings_main,
     'startup': startup_main, 'sens': sens_main}[mode](sys.argv[2:])
