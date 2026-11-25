v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_cmp_mc: M6 section 4. One cmp2s (cmp_tbcopy) on its own bias diode (cmp_tbbias), tt_mm (mismatch on).
Each chip (reset = new mismatch draw): at each temperature, a DC sweep of vcap across V_REF, then across V_EB3 -> Vos at both thresholds
on the same chip. The default control below runs 3 chips at 25 C; the runner mc4.py writes its own control (200 chips, -20 / 25 / 100 C).} 40 -460 0 0 0.3 0.3 {}
N 330 110 350 110 {lab=nb}
N 350 110 350 30 {lab=nb}
N 80 -30 350 -30 {lab=vthr}
N 200 -10 350 -10 {lab=vcap}
C {cmp_tbcopy.sym} 500 0 0 0 {name=xc1}
C {cmp_tbbias.sym} 240 130 0 0 {name=xb1}
C {devices/vsource.sym} 80 0 0 0 {name=Vthr value=1.2432 savecurrent=false}
C {devices/vsource.sym} 200 20 0 0 {name=Vcap value=1.2332 savecurrent=false}
C {devices/vsource.sym} 60 -280 0 0 {name=Vdd value=1.8 savecurrent=false}
C {devices/gnd.sym} 80 30 0 0 {name=g1 lab=0}
C {devices/gnd.sym} 200 50 0 0 {name=g2 lab=0}
C {devices/gnd.sym} 330 150 0 0 {name=g3 lab=0}
C {devices/gnd.sym} 650 30 0 0 {name=g4 lab=0}
C {devices/gnd.sym} 60 -250 0 0 {name=g5 lab=0}
C {lab_pin.sym} 350 110 0 1 {name=l1 sig_type=std_logic lab=nb}
C {lab_pin.sym} 330 130 0 1 {name=l2 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 80 -30 0 0 {name=l3 sig_type=std_logic lab=vthr}
C {lab_pin.sym} 200 -10 0 0 {name=l4 sig_type=std_logic lab=vcap}
C {lab_pin.sym} 650 -30 0 1 {name=l5 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 650 0 0 1 {name=l6 sig_type=std_logic lab=cmp_raw}
C {lab_pin.sym} 60 -310 0 0 {name=l7 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/corner.sym} 200 -330 0 0 {name=CORNER only_toplevel=false corner=tt_mm}
C {code_shown.sym} 900 -330 0 0 {name=s1 only_toplevel=false value=".include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.control
setseed 101
let n = 0
while n < 3
  reset
  option temp=25
  alter @i.xb1.iref[dc] = 1.38556e-6
  alter vthr dc = 1.24324
  dc vcap 1.23724 1.24924 20u
  meas dc tr when v(cmp_raw)=0.9 rise=1
  echo MC chip=$&n t=25 cm=ref thr=1.24324 trip=$&tr
  alter vthr dc = 0.709608
  dc vcap 0.703608 0.715608 20u
  meas dc te when v(cmp_raw)=0.9 rise=1
  echo MC chip=$&n t=25 cm=eb thr=0.709608 trip=$&te
  let n = n + 1
end
.endc"}
