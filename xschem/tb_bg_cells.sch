v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 150 -10 250 -10 {lab=veb3}
N 250 -10 250 -0 {lab=veb3}
N 250 -0 340 -0 {lab=veb3}
N 150 10 220 10 {lab=eb2}
N 220 10 220 40 {lab=eb2}
N 220 40 340 40 {lab=eb2}
C {bg_pnp.sym} 0 0 0 0 {name=xp}
C {bg_rrow.sym} 490 0 0 1 {name=xr}
C {lab_pin.sym} 150 -30 0 1 {name=p1 sig_type=std_logic lab=va}
C {lab_pin.sym} 340 -40 0 0 {name=p2 sig_type=std_logic lab=vb}
C {lab_pin.sym} 340 -20 0 0 {name=p3 sig_type=std_logic lab=vref}
C {lab_pin.sym} 250 -10 0 1 {name=p4 sig_type=std_logic lab=veb3}
C {lab_pin.sym} 220 20 0 1 {name=p5 sig_type=std_logic lab=eb2}
C {lab_pin.sym} 340 20 0 0 {name=p6 sig_type=std_logic lab=GND}
C {gnd.sym} 150 30 0 0 {name=l1 lab=0}
C {code_shown.sym} 510 150 0 0 {name=s1 only_toplevel=false value="*my cells + the same ideal op-amp and mirrors as M3 k_extract.cir
Bnull g 0 V = max(1e7*(v(va)-v(vb)), 0.5)
.nodeset v(g)=2.8 v(va)=0.71 v(vb)=0.71
Gp1 0 va g 0 1e-6
Gp2 0 vb g 0 1e-6
Gp3 0 vref g 0 1e-6
.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
foreach t -20 25 100
  option temp=$t
  op
  let i_uA = v(g)
  let x_veb3 = v(veb3)
  let x_dveb = (v(vb)-v(eb2))*1000
  let x_vref = v(vref)
  let x_form = v(veb3)+10*(v(vb)-v(eb2))
  let x_diff = (v(vref)-x_form)*1e6
  echo CELLS temp=$t I_uA=$&i_uA VEB3_V=$&x_veb3 dVEB_mV=$&x_dveb VREF_V=$&x_vref formula_V=$&x_form vref_minus_formula_uV=$&x_diff
end
.endc"}
C {sky130_fd_pr/corner.sym} 240 130 0 0 {name=CORNER only_toplevel=false corner=tt}
