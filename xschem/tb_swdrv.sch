v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_swdrv: M6 section 10. swdrv with 50 fF on each output; ich_sel, i3_sel, chop_sel go 0 -> 1 at 5 ns and back at 25 ns
through buf_1 each. Gaps (break before make) must be > 0; chop overlaps (make before break) must be > 0. Runner sw10.py.} -650 -460 0 0 0.3 0.3 {}
C {swdrv.sym} 0 0 0 0 {name=x1}
C {lab_pin.sym} -150 -100 0 0 {name=l1 sig_type=std_logic lab=s_ich}
C {lab_pin.sym} -150 -80 0 0 {name=l2 sig_type=std_logic lab=s_i3}
C {lab_pin.sym} -150 -60 0 0 {name=l3 sig_type=std_logic lab=s_chop}
C {lab_pin.sym} 150 -110 0 1 {name=l4 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 150 -90 0 1 {name=l5 sig_type=std_logic lab=ich_onb}
C {lab_pin.sym} 150 -70 0 1 {name=l6 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} 150 -50 0 1 {name=l7 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} 150 -30 0 1 {name=l8 sig_type=std_logic lab=i3_onb}
C {lab_pin.sym} 150 -10 0 1 {name=l9 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} 150 10 0 1 {name=l10 sig_type=std_logic lab=swa}
C {lab_pin.sym} 150 30 0 1 {name=l11 sig_type=std_logic lab=swb}
C {lab_pin.sym} 150 50 0 1 {name=l12 sig_type=std_logic lab=chop}
C {lab_pin.sym} 150 70 0 1 {name=l13 sig_type=std_logic lab=chopb}
C {lab_pin.sym} 150 90 0 1 {name=l14 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 110 0 1 {name=l15 sig_type=std_logic lab=0}
C {devices/capa.sym} 300 230 0 0 {name=Cichon
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 300 200 0 0 {name=l16 sig_type=std_logic lab=ich_on}
C {devices/gnd.sym} 300 260 0 0 {name=g17 lab=0}
C {devices/capa.sym} 370 230 0 0 {name=Cichonb
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 370 200 0 0 {name=l18 sig_type=std_logic lab=ich_onb}
C {devices/gnd.sym} 370 260 0 0 {name=g19 lab=0}
C {devices/capa.sym} 440 230 0 0 {name=Cichdump
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 440 200 0 0 {name=l20 sig_type=std_logic lab=ich_dump}
C {devices/gnd.sym} 440 260 0 0 {name=g21 lab=0}
C {devices/capa.sym} 510 230 0 0 {name=Ci3on
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 510 200 0 0 {name=l22 sig_type=std_logic lab=i3_on}
C {devices/gnd.sym} 510 260 0 0 {name=g23 lab=0}
C {devices/capa.sym} 580 230 0 0 {name=Ci3onb
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 580 200 0 0 {name=l24 sig_type=std_logic lab=i3_onb}
C {devices/gnd.sym} 580 260 0 0 {name=g25 lab=0}
C {devices/capa.sym} 650 230 0 0 {name=Ci3dump
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 650 200 0 0 {name=l26 sig_type=std_logic lab=i3_dump}
C {devices/gnd.sym} 650 260 0 0 {name=g27 lab=0}
C {devices/capa.sym} 720 230 0 0 {name=Cswa
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 720 200 0 0 {name=l28 sig_type=std_logic lab=swa}
C {devices/gnd.sym} 720 260 0 0 {name=g29 lab=0}
C {devices/capa.sym} 790 230 0 0 {name=Cswb
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 790 200 0 0 {name=l30 sig_type=std_logic lab=swb}
C {devices/gnd.sym} 790 260 0 0 {name=g31 lab=0}
C {devices/capa.sym} 860 230 0 0 {name=Cchop
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 860 200 0 0 {name=l32 sig_type=std_logic lab=chop}
C {devices/gnd.sym} 860 260 0 0 {name=g33 lab=0}
C {devices/capa.sym} 930 230 0 0 {name=Cchopb
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 930 200 0 0 {name=l34 sig_type=std_logic lab=chopb}
C {devices/gnd.sym} 930 260 0 0 {name=g35 lab=0}
C {devices/vsource.sym} -500 130 0 0 {name=Vs value="pwl(0 0 5n 0 5.1n 'vdd' 25n 'vdd' 25.1n 0)" savecurrent=false}
C {devices/gnd.sym} -500 160 0 0 {name=g36 lab=0}
C {lab_pin.sym} -500 100 0 0 {name=l37 sig_type=std_logic lab=sel}
C {sky130_stdcells/buf_1.sym} -350 250 0 0 {name=xbi VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -390 250 0 0 {name=l38 sig_type=std_logic lab=sel}
C {lab_pin.sym} -310 250 0 1 {name=l39 sig_type=std_logic lab=s_ich}
C {sky130_stdcells/buf_1.sym} -350 310 0 0 {name=xb3 VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -390 310 0 0 {name=l40 sig_type=std_logic lab=sel}
C {lab_pin.sym} -310 310 0 1 {name=l41 sig_type=std_logic lab=s_i3}
C {sky130_stdcells/buf_1.sym} -350 370 0 0 {name=xbc VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -390 370 0 0 {name=l42 sig_type=std_logic lab=sel}
C {lab_pin.sym} -310 370 0 1 {name=l43 sig_type=std_logic lab=s_chop}
C {devices/vsource.sym} -650 130 0 0 {name=Vdd value="'vdd'" savecurrent=false}
C {devices/gnd.sym} -650 160 0 0 {name=g44 lab=0}
C {lab_pin.sym} -650 100 0 0 {name=l45 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/corner.sym} -650 -300 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 900 -300 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25
.control
tran 2p 45n
meas tran on_f when v(ich_on)=0.9 fall=1
meas tran onb_r when v(ich_onb)=0.9 rise=1
meas tran dump_r when v(ich_dump)=0.9 rise=1
meas tran dump_f when v(ich_dump)=0.9 fall=1
meas tran on_r when v(ich_on)=0.9 rise=1
meas tran onb_f when v(ich_onb)=0.9 fall=1
meas tran i3on_f when v(i3_on)=0.9 fall=1
meas tran i3onb_r when v(i3_onb)=0.9 rise=1
meas tran i3dump_r when v(i3_dump)=0.9 rise=1
meas tran i3dump_f when v(i3_dump)=0.9 fall=1
meas tran i3on_r when v(i3_on)=0.9 rise=1
meas tran i3onb_f when v(i3_onb)=0.9 fall=1
meas tran swa_f when v(swa)=0.9 fall=1
meas tran swb_r when v(swb)=0.9 rise=1
meas tran swb_f when v(swb)=0.9 fall=1
meas tran swa_r when v(swa)=0.9 rise=1
meas tran chop_r when v(chop)=0.9 rise=1
meas tran chopb_f when v(chopb)=0.9 fall=1
meas tran chopb_r when v(chopb)=0.9 rise=1
meas tran chop_f when v(chop)=0.9 fall=1
let g_ich_01 = (dump_r - on_f) * 1e9
let g_ich_01_full = (dump_r - onb_r) * 1e9
let g_ich_10 = (on_r - dump_f) * 1e9
let g_ich_10_full = (onb_f - dump_f) * 1e9
let g_i3_01 = (i3dump_r - i3on_f) * 1e9
let g_i3_01_full = (i3dump_r - i3onb_r) * 1e9
let g_i3_10 = (i3on_r - i3dump_f) * 1e9
let g_i3_10_full = (i3onb_f - i3dump_f) * 1e9
let g_sw_ab = (swb_r - swa_f) * 1e9
let g_sw_ba = (swa_r - swb_f) * 1e9
let o_chop_ab = (chopb_f - chop_r) * 1e9
let o_chop_ba = (chop_f - chopb_r) * 1e9
let t_last = (dump_r - 5.05n) * 1e9
echo GAPS g_ich_01=$&g_ich_01 g_ich_01_full=$&g_ich_01_full g_ich_10=$&g_ich_10 g_ich_10_full=$&g_ich_10_full g_i3_01=$&g_i3_01 g_i3_01_full=$&g_i3_01_full g_i3_10=$&g_i3_10 g_i3_10_full=$&g_i3_10_full g_sw_ab=$&g_sw_ab g_sw_ba=$&g_sw_ba o_chop_ab=$&o_chop_ab o_chop_ba=$&o_chop_ba t_last=$&t_last
.endc"}
