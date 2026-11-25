v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_cmp_noise: M6 section 11. cmp2s (cmp_tbcopy) on its own bias diode; vthr fixed, vcap at the trip point
(1 uV .dc sweep), .noise at n1 (first stage) from 1 kHz to 1 GHz. Runner noise11.py sets T, the threshold and Iref.} -600 -460 0 0 0.3 0.3 {}
C {cmp_tbcopy.sym} 0 0 0 0 {name=x1}
C {lab_pin.sym} -150 -30 0 0 {name=l1 sig_type=std_logic lab=vthr}
C {lab_pin.sym} -150 -10 0 0 {name=l2 sig_type=std_logic lab=vcap}
C {lab_pin.sym} -150 30 0 0 {name=l3 sig_type=std_logic lab=nb}
C {lab_pin.sym} 150 -30 0 1 {name=l4 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 0 0 1 {name=l5 sig_type=std_logic lab=cmp_raw}
C {lab_pin.sym} 150 30 0 1 {name=l6 sig_type=std_logic lab=0}
C {cmp_tbbias.sym} -500 200 0 0 {name=xb}
C {lab_pin.sym} -410 180 0 1 {name=l7 sig_type=std_logic lab=nb}
C {lab_pin.sym} -410 200 0 1 {name=l8 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -410 220 0 1 {name=l9 sig_type=std_logic lab=0}
C {devices/vsource.sym} -300 30 0 0 {name=Vthr value="'vthr'" savecurrent=false}
C {devices/gnd.sym} -300 60 0 0 {name=g10 lab=0}
C {lab_pin.sym} -300 0 0 0 {name=l11 sig_type=std_logic lab=vthr}
C {devices/vsource.sym} -400 30 0 0 {name=Vcap value="dc 'vcapdc' ac 1" savecurrent=false}
C {devices/gnd.sym} -400 60 0 0 {name=g12 lab=0}
C {lab_pin.sym} -400 0 0 0 {name=l13 sig_type=std_logic lab=vcap}
C {devices/vsource.sym} -600 30 0 0 {name=Vdd value="'vdd'" savecurrent=false}
C {devices/gnd.sym} -600 60 0 0 {name=g14 lab=0}
C {lab_pin.sym} -600 0 0 0 {name=l15 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/corner.sym} -600 -300 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 300 -300 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8 vthr=1.2432 vcapdc=1.2432
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25
.control
let lo = 1.2392
let hi = 1.2472
dc vcap $&lo $&hi 1u
meas dc trip when v(cmp_raw)=0.9 cross=1
print trip
alter vcap dc = $&trip
op
print v(x1.x1.n1) v(x1.x1.ib_cmp2) v(cmp_raw)
noise v(x1.x1.n1) vcap dec 200 1k 1g
setplot noise1
wrdata noise.txt onoise_spectrum inoise_spectrum
setplot noise2
print onoise_total inoise_total
.endc"}
