#!/usr/bin/env python3
"""M5 6d: the core node poles behind beta (spec M5 step 5, "core node poles").

Reads your netlisted bench simulation/tb_bg_k.spice and writes simulation/s6/nz_<corner>_<vdd>V_<temp>C.spice with
four copies of bgr (op-amp output renamed oa, as in stb6.py). In each copy oa feeds vpg through 1 GH, so the DC
point is the real one, and for AC:
  xa, xb : vpg held at AC ground (1 F); 1 A AC injected into va (xa) or vb (xb) -> the node impedances
           Z_A = v(va)/i, Z_B = v(vb)/i and the cross terms. R and C of a node come from its admittance at 10 kHz:
           Y = 1/Z = 1/R + j*2*pi*f*C.
  xg     : vpg driven by 1 V AC -> beta measured = (v(inp) - v(inn))/v(vpg), as in 6b.
  xh     : vpg driven, va and vb held at AC ground -> the real P1 and P2 drain currents per volt on vpg.
Printed: NODE lines (R, C, the hand pole 1/(2*pi*R*C), the frequency where Z is -45 deg) and BETA lines
(lag measured; lag rebuilt from the node impedances with P2's DC gm; lag rebuilt with the real drain currents).

Usage (in the container):  python3 /foss/designs/tt_tsense/xschem/nz6.py [corner] [vdd] [temp]
Defaults: tt 1.8 25. Then: ngspice -b s6/nz_<tag>.spice
"""
import os, re, sys

corner, vdd, temp = (sys.argv[1:] + ['tt', '1.8', '25'][len(sys.argv) - 1:])[:3]
sim = '/foss/designs/tt_tsense/xschem/simulation'
src = open(f'{sim}/tb_bg_k.spice').read()
os.makedirs(f'{sim}/s6', exist_ok=True)
tag = f'{corner}_{vdd}V_{temp}C'

# the bench without its control block, at this corner and supply
bench = re.sub(r'\.control.*?\.endc\n', '', src, flags=re.S)
bench = bench.replace('sky130.lib.spice tt\n', f'sky130.lib.spice {corner}\n')
bench = re.sub(r'^(V\w* \w* 0) 1\.8$', rf'\g<1> {vdd}', bench, flags=re.M)

# a copy of bgr whose op-amp drives oa instead of vpg
m = re.search(r'^\.subckt bgr ([^\n]*)\n(.*?)^\.ends\n', bench, flags=re.S | re.M)
pins, body = m.group(1), m.group(2)
assert body.count('xota inp inn vpg ') == 1, 'expected one xota line driving vpg inside bgr'
brk = f'.subckt bgr_brk {pins} oa vpg\n' + body.replace('xota inp inn vpg ', 'xota inp inn oa ') + '.ends\n'
top = bench.replace(m.group(0), m.group(0) + brk)

# four copies of the bench's x1 line, each with its own outputs and parks, oa -> vpg through 1 GH (DC only)
x1 = re.search(r'^x1 (.*) bgr$', top, flags=re.M)
nets = x1.group(1).split()
def copy(t, ac):
    own = {'vref', 'ich', 'iptat_mon', 'veb3', 'su'}
    n = [f'{x}_{t}' if x in own else x for x in nets]
    return (f'x{t} {" ".join(n)} oa_{t} vpg_{t} bgr_brk\n'
            f'E4{t} p4{t} 0 x{t}.va 0 1\nV4{t} ich_{t} p4{t} 0\nV7{t} iptat_mon_{t} p4{t} 0\n'
            f'Lh{t} oa_{t} vpg_{t} 1e9\n' + ac)
top = top.replace(x1.group(0) + '\n',
                  copy('a', 'Cha vpg_a 0 1\nIa 0 xa.va dc 0 ac 1\n') +
                  copy('b', 'Chb vpg_b 0 1\nIb 0 xb.vb dc 0 ac 1\n') +
                  copy('g', 'Chg vpg_g acs 1\n') +
                  copy('h', 'Chh vpg_h acs 1\nVsa xh.va msa 0\nCsa msa 0 1\nVsb xh.vb msb 0\nCsb msb 0 1\n') +
                  'Vg acs 0 dc 0 ac 1\n')
top = re.sub(r'^E4 p4 0 x1\.va 0 1\nV4 ich p4 0\nV7 iptat_mon p4 0\n', '', top, flags=re.M)
g = f'{float(vdd) - 1.25:.2f}'
ns = ' '.join(f'v(vpg_{t})={g} v(oa_{t})={g} v(x{t}.va)=0.71 v(x{t}.vb)=0.71 v(vref_{t})=1.25' for t in 'abgh')
top = re.sub(r'^\.nodeset .*$', f'.nodeset {ns}', top, flags=re.M)
assert 'E4 p4' not in top

P2 = '@m.xg.xcore.x1.xmp2.msky130_fd_pr__pfet_01v8'
ctl = f'''.control
option temp={temp}
save all {P2}[gm]
op
let g2 = {P2}[gm]
set gmv = $&g2
let ip = 2*i(v7g)*1e9
let gu = g2*1e6
echo OPCHK corner={corner} vdd={vdd} temp={temp} Iptat_nA=$&ip gmP2_uS=$&gu
ac dec 40 100 100meg
let w = 2*pi*frequency
let zaa = v(xa.va)
let zba = v(xa.vb)
let zab = v(xb.va)
let zbb = v(xb.vb)
let ra = 1/real(1/zaa)/1e3
let ca = imag(1/zaa)/w*1e12
let rb = 1/real(1/zbb)/1e3
let cb = imag(1/zbb)/w*1e12
let zaph = cph(zaa)*180/pi
let zbph = cph(zbb)*180/pi
let beta = (v(xg.inp)-v(xg.inn))/v(vpg_g)
let bnod = -$gmv*((zba+zbb)-(zaa+zab))
let i1 = i(vsa)/v(vpg_h)
let i2 = i(vsb)/v(vpg_h)
let bmir = (zba*i1+zbb*i2)-(zaa*i1+zab*i2)
let lagm = 180-cph(beta)*180/pi
let lagn = 180-cph(bnod)*180/pi
let lagr = 180-cph(bmir)*180/pi
meas ac q1 find ra at=10k
meas ac q2 find ca at=10k
meas ac q3 find rb at=10k
meas ac q4 find cb at=10k
meas ac fa when zaph=-45
meas ac fb when zbph=-45
let pa = 1e3/(2*pi*q1*q2)
let pb = 1e3/(2*pi*q3*q4)
let fam = fa/1e6
let fbm = fb/1e6
echo NODE va R_kohm=$&q1 C_pF=$&q2 pole_hand_MHz=$&pa pole_at_minus45_MHz=$&fam
echo NODE vb R_kohm=$&q3 C_pF=$&q4 pole_hand_MHz=$&pb pole_at_minus45_MHz=$&fbm
foreach f 100k 230k 1meg
  meas ac x1 find lagm at=$f
  meas ac x2 find lagn at=$f
  meas ac x3 find lagr at=$f
  echo BETA f=$f lag_measured_deg=$&x1 lag_from_nodes_deg=$&x2 lag_nodes_plus_mirror_deg=$&x3
end
.endc
'''
open(f'{sim}/s6/nz_{tag}.spice', 'w').write(top.replace('\n.end\n', '\n' + ctl + '.end\n'))
print(f'wrote s6/nz_{tag}.spice')
