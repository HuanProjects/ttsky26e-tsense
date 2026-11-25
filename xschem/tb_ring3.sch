v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_ring3: M7 section 14. ring3 with 100 fF on each pad output; ring_en rises at 2 ns. The supply comes through rsup
(0.001 ohm by default; the pulling check sets 10 ohm). The runner ring14.py adds 1.5 fF of wire on every ring node
(as in the spec R6 quick check) and makes the solo decks.} -700 -420 0 0 0.3 0.3 {}
C {ring3.sym} 0 0 0 0 {name=x1}
C {lab_pin.sym} -150 20 0 0 {name=l1 sig_type=std_logic lab=ring_en}
C {lab_pin.sym} 150 20 0 1 {name=l2 sig_type=std_logic lab=uo1}
C {lab_pin.sym} 150 40 0 1 {name=l3 sig_type=std_logic lab=uo3}
C {lab_pin.sym} 150 60 0 1 {name=l4 sig_type=std_logic lab=uo6}
C {lab_pin.sym} 150 80 0 1 {name=l5 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 100 0 1 {name=l6 sig_type=std_logic lab=0}
C {devices/vsource.sym} -600 300 0 0 {name=Vsup value="'vdd'" savecurrent=false}
C {devices/gnd.sym} -600 330 0 0 {name=gVsup lab=0}
C {lab_pin.sym} -600 270 0 0 {name=l7 sig_type=std_logic lab=vsup}
C {devices/vsource.sym} -450 300 0 0 {name=Ven value="pwl(0 0 2n 0 2.05n 'vdd')" savecurrent=false}
C {devices/gnd.sym} -450 330 0 0 {name=gVen lab=0}
C {lab_pin.sym} -450 270 0 0 {name=l8 sig_type=std_logic lab=ring_en}
C {devices/res.sym} -300 300 0 0 {name=Rsup
value='rsup'
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} -300 270 0 0 {name=l9 sig_type=std_logic lab=vsup}
C {lab_pin.sym} -300 330 0 0 {name=l10 sig_type=std_logic lab=VDPWR}
C {devices/capa.sym} 300 300 0 0 {name=Cuo1
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 300 270 0 0 {name=l11 sig_type=std_logic lab=uo1}
C {devices/gnd.sym} 300 330 0 0 {name=gc0 lab=0}
C {devices/capa.sym} 380 300 0 0 {name=Cuo3
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 380 270 0 0 {name=l12 sig_type=std_logic lab=uo3}
C {devices/gnd.sym} 380 330 0 0 {name=gc1 lab=0}
C {devices/capa.sym} 460 300 0 0 {name=Cuo6
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 460 270 0 0 {name=l13 sig_type=std_logic lab=uo6}
C {devices/gnd.sym} 460 330 0 0 {name=gc2 lab=0}
C {sky130_fd_pr/corner.sym} -700 -300 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 900 -300 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8
.param rsup=0.001
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25
.control
save uo1 uo3 uo6 x1.xn.r0 x1.xp.r0 x1.xd.r0 x1.xn.q0 x1.xp.q0 x1.xd.q0 vsup#branch VDPWR
tran 5p 500n
meas tran n_a when v(x1.xn.r0)=0.9 rise=10
meas tran n_b when v(x1.xn.r0)=0.9 rise=50
meas tran p_a when v(x1.xp.r0)=0.9 rise=10
meas tran p_b when v(x1.xp.r0)=0.9 rise=50
meas tran d_a when v(x1.xd.r0)=0.9 rise=5
meas tran d_b when v(x1.xd.r0)=0.9 rise=25
meas tran nq_a when v(x1.xn.q0)=0.9 rise=10
meas tran nq_b when v(x1.xn.q0)=0.9 rise=30
meas tran pq_a when v(x1.xp.q0)=0.9 rise=10
meas tran pq_b when v(x1.xp.q0)=0.9 rise=30
meas tran dq_a when v(x1.xd.q0)=0.9 rise=3
meas tran dq_b when v(x1.xd.q0)=0.9 rise=10
meas tran no_a when v(uo1)=0.9 rise=1
meas tran no_b when v(uo1)=0.9 rise=2
meas tran po_a when v(uo3)=0.9 rise=1
meas tran po_b when v(uo3)=0.9 rise=2
meas tran do_a when v(uo6)=0.9 rise=1
meas tran do_b when v(uo6)=0.9 rise=2
meas tran nq_min min v(x1.xn.q0) from=150n to=500n
meas tran nq_max max v(x1.xn.q0) from=150n to=500n
meas tran i_run avg i(Vsup) from=150n to=500n
meas tran vdd_min min v(VDPWR) from=150n to=500n
echo RING_DONE
.endc"}
