#!/usr/bin/env python3
"""M5 6b/6c: Middlebrook double-injection loop gain of the real bgr loop.

Reads your netlisted bench simulation/tb_bg_k.spice and writes simulation/s6/stb_<tag>.spice:
  - bgr_brk = your bgr with the ota2s output renamed oa, and oa + vpg brought out as pins (the break);
  - copy xv gets a series voltage injection at the break   -> Tv = -v(oa_v)/v(vpg_v)
  - copy xi gets a shunt current injection at the break    -> Ti = -i(vma)/i(vmb)
  - T = (Tv*Ti - 1)/(Tv + Ti + 2), then f_u, PM, GM and T at 10 Hz ... 1 MHz.
Each copy has its own vref/ich/iptat_mon/veb3/su nets so the two never touch.

Usage (in the container):  python3 /foss/designs/tt_tsense/xschem/stb6.py [corner] [vdd] [temp] [mon] [state]
Defaults: tt 1.8 25 1 A.  Netlist tb_bg_k.sch first.
  mon   = iptat_mon_en: 1 = P7 drives the pin (parked at va, as in 3d), 0 = switch open (P7 drain at VDD, no current)
  state = chop state: A = the bench as drawn, B = swa/swb and chop/chopb swapped
The tag is <corner>_<vdd>V_<temp>C, plus _mon0 and/or _B when those are not the defaults.
stb6c.py (the 6c grid) calls deck() with several temperatures, so the models load once per deck.
"""
import os, re, sys

sim = '/foss/designs/tt_tsense/xschem/simulation'


def tag_of(corner, vdd, temp, mon='1', state='A'):
    return f'{corner}_{vdd}V_{temp}C' + ('' if mon == '1' else '_mon0') + ('' if state == 'A' else '_B')


def deck(src, corner, vdd, temps, mon='1', state='A', wr='s6'):
    """The double-injection deck as text, one op + ac block per temperature in temps;
    wrdata goes to <wr>/t_<tag>.txt, relative to where ngspice runs."""

    # the bench without its control block, at this corner and supply
    bench = re.sub(r'\.control.*?\.endc\n', '', src, flags=re.S)
    bench = bench.replace('sky130.lib.spice tt\n', f'sky130.lib.spice {corner}\n')
    bench = re.sub(r'^(V\w* \w* 0) 1\.8$', rf'\g<1> {vdd}', bench, flags=re.M)
    if state == 'B':
        for a, b in (('Vswa swa 0', 'Vswb swb 0'), ('Vchopb chopb 0', 'Vchop chop 0')):
            hi, lo = f'^({a}) {re.escape(vdd)}$', f'^({b}) 0$'
            assert len(re.findall(hi, bench, flags=re.M)) == 1 and len(re.findall(lo, bench, flags=re.M)) == 1, a
            bench = re.sub(hi, r'\g<1> 0', bench, flags=re.M)
            bench = re.sub(lo, rf'\g<1> {vdd}', bench, flags=re.M)

    # the break: a copy of bgr whose op-amp drives oa instead of vpg
    m = re.search(r'^\.subckt bgr ([^\n]*)\n(.*?)^\.ends\n', bench, flags=re.S | re.M)
    pins, body = m.group(1), m.group(2)
    assert body.count('xota inp inn vpg ') == 1, 'expected one xota line driving vpg inside bgr'
    brk = f'.subckt bgr_brk {pins} oa vpg\n' + body.replace('xota inp inn vpg ', 'xota inp inn oa ') + '.ends\n'
    top = bench.replace(m.group(0), m.group(0) + brk)

    # two copies of the bench's x1 line, each with its own output nets and its own ich/iptat_mon park
    x1 = re.search(r'^x1 (.*) bgr$', top, flags=re.M)
    nets = x1.group(1).split()
    def copy(t):
        own = {'vref', 'ich', 'iptat_mon', 'veb3', 'su'}
        n = [f'{x}_{t}' if x in own else x for x in nets]
        p7 = f'p4{t}' if mon == '1' else 'VDPWR'
        return (f'x{t} {" ".join(n)} oa_{t} vpg_{t} bgr_brk\n'
                f'E4{t} p4{t} 0 x{t}.va 0 1\nV4{t} ich_{t} p4{t} 0\nV7{t} iptat_mon_{t} {p7} 0\n')
    top = top.replace(x1.group(0) + '\n', copy('v') + copy('i'))
    top = re.sub(r'^E4 p4 0 x1\.va 0 1\nV4 ich p4 0\nV7 iptat_mon p4 0\n', '', top, flags=re.M)

    # nodesets per copy (vpg sits about 1.25 V under the supply), and the two injections
    g = f'{float(vdd) - 1.25:.2f}'
    top = re.sub(r'^\.nodeset .*$',
                 f'.nodeset v(vpg_v)={g} v(oa_v)={g} v(xv.va)=0.71 v(xv.vb)=0.71 v(vref_v)=1.25 '
                 f'v(vpg_i)={g} v(oa_i)={g} v(xi.va)=0.71 v(xi.vb)=0.71 v(vref_i)=1.25\n'
                 'Vinj vpg_v oa_v dc 0 ac 1\nVma oa_i n_i 0\nVmb n_i vpg_i 0\nIinj 0 n_i dc 0 ac 1', top, flags=re.M)
    assert 'E4 p4' not in top and 'xv ' in top and 'xi ' in top

    # I_PTAT = 2 x the P7 current (2 units of 4); with the monitor off, 2 x the ich current (P4a + P4b) instead
    vi = '7' if mon == '1' else '4'
    blocks = []
    for temp in temps:
        blocks.append(f'''option temp={temp}
op
let ipv = 2*i(v{vi}v)*1e9
let ipi = 2*i(v{vi}i)*1e9
let vos = (v(xv.va)-v(xv.vb))*1e6
echo OPCHK corner={corner} vdd={vdd} temp={temp} mon={mon} state={state} Iptat_v_nA=$&ipv Iptat_i_nA=$&ipi va_vb_uV=$&vos
ac dec 40 1 1g
let tv = -v(oa_v)/v(vpg_v)
let ti = -i(vma)/i(vmb)
let t = (tv*ti - 1)/(tv + ti + 2)
let tdb = db(t)
let tph = cph(t)*180/pi
let tvdb = db(tv)
let tidb = db(ti)
meas ac t0db find tdb at=1
meas ac t0ph find tph at=1
meas ac tv0db find tvdb at=1
meas ac ti0db find tidb at=1
meas ac fu when tdb=0
meas ac pmraw find tph when tdb=0
meas ac tvfu find tvdb when tdb=0
meas ac tifu find tidb when tdb=0
meas ac f180 when tph=-180
meas ac gmraw find tdb when tph=-180
let pm = pmraw + 180
let gm = -gmraw
echo STB T0_dB=$&t0db T0_phase_deg=$&t0ph fu_Hz=$&fu PM_deg=$&pm f180_Hz=$&f180 GM_dB=$&gm Tv0_dB=$&tv0db Ti0_dB=$&ti0db Tv_at_fu_dB=$&tvfu Ti_at_fu_dB=$&tifu
foreach f 10 100 1k 10k 100k 1meg
  meas ac a find tdb at=$f
  meas ac b find tph at=$f
  echo TF f=$f T_dB=$&a T_phase=$&b
end
wrdata {wr}/t_{tag_of(corner, vdd, temp, mon, state)}.txt tdb tph tvdb tidb
''')
    ctl = '.control\n' + 'destroy all\n'.join(blocks) + '.endc\n'
    return top.replace('\n.end\n', '\n' + ctl + '.end\n')


if __name__ == '__main__':
    corner, vdd, temp, mon, state = (sys.argv[1:] + ['tt', '1.8', '25', '1', 'A'][len(sys.argv) - 1:])[:5]
    assert mon in ('0', '1') and state in ('A', 'B'), 'mon is 0 or 1, state is A or B'
    os.makedirs(f'{sim}/s6', exist_ok=True)
    tag = tag_of(corner, vdd, temp, mon, state)
    open(f'{sim}/s6/stb_{tag}.spice', 'w').write(deck(open(f'{sim}/tb_bg_k.spice').read(), corner, vdd, [temp], mon, state))
    print(f'wrote s6/stb_{tag}.spice')
