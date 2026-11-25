v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_reset: M6 section 6. Two oneshot copies, each on its own C_osc = 5.06 pF. osc_en rises at 50 ns (the switch opens: first pedestal
with the real driver edge); Ipre puts 100 uA for 62.6 ns into vcap (about 1.24 V); cmp_raw rises at 400 ns, 5 ns wide (copy 1)
or 40 ns wide (copy 2). Measured: rst and sw widths, the sw fall time, vcap at the sw fall, and the pedestal. Runner reset6.py.} -560 -520 0 0 0.3 0.3 {}
N -300 -40 -150 -40 {lab=cmp_raw1}
N 150 -40 300 -40 {lab=vcap1}
N 300 -40 380 -40 {lab=vcap1}
N 300 -40 300 -10 {lab=vcap1}
N -300 280 -150 280 {lab=cmp_raw2}
N 150 280 300 280 {lab=vcap2}
N 300 280 380 280 {lab=vcap2}
N 300 280 300 310 {lab=vcap2}
C {oneshot.sym} 0 0 0 0 {name=x1}
C {devices/vsource.sym} -300 -10 0 0 {name=Vck1 value="pwl(0 0 400n 0 400.2n 'vdd' 405n 'vdd' 405.2n 0)" savecurrent=false}
C {devices/gnd.sym} -300 20 0 0 {name=g1 lab=0}
C {lab_pin.sym} -300 -40 0 0 {name=l2 sig_type=std_logic lab=cmp_raw1}
C {lab_pin.sym} -150 -20 0 0 {name=l3 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} -150 0 0 0 {name=l4 sig_type=std_logic lab=osc_enb}
C {devices/capa.sym} 300 20 0 0 {name=Cosc1
m=1
value=5.06p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 300 50 0 0 {name=g5 lab=0}
C {devices/isource.sym} 380 -10 2 0 {name=Ipre1 value="pwl(0 0 150n 0 150.1n 100u 212.6n 100u 212.7n 0)"}
C {devices/gnd.sym} 380 20 0 0 {name=g6 lab=0}
C {lab_pin.sym} 340 -40 3 0 {name=l7 sig_type=std_logic lab=vcap1}
C {lab_pin.sym} 150 -20 0 1 {name=l8 sig_type=std_logic lab=rst1}
C {lab_pin.sym} 150 20 0 1 {name=l9 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 150 40 0 0 {name=g10 lab=0}
T {copy 1: cmp_raw 5 ns wide} -320 -100 0 0 0.25 0.25 {}
C {oneshot.sym} 0 320 0 0 {name=x2}
C {devices/vsource.sym} -300 310 0 0 {name=Vck2 value="pwl(0 0 400n 0 400.2n 'vdd' 440n 'vdd' 440.2n 0)" savecurrent=false}
C {devices/gnd.sym} -300 340 0 0 {name=g11 lab=0}
C {lab_pin.sym} -300 280 0 0 {name=l12 sig_type=std_logic lab=cmp_raw2}
C {lab_pin.sym} -150 300 0 0 {name=l13 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} -150 320 0 0 {name=l14 sig_type=std_logic lab=osc_enb}
C {devices/capa.sym} 300 340 0 0 {name=Cosc2
m=1
value=5.06p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 300 370 0 0 {name=g15 lab=0}
C {devices/isource.sym} 380 310 2 0 {name=Ipre2 value="pwl(0 0 150n 0 150.1n 100u 212.6n 100u 212.7n 0)"}
C {devices/gnd.sym} 380 340 0 0 {name=g16 lab=0}
C {lab_pin.sym} 340 280 3 0 {name=l17 sig_type=std_logic lab=vcap2}
C {lab_pin.sym} 150 300 0 1 {name=l18 sig_type=std_logic lab=rst2}
C {lab_pin.sym} 150 340 0 1 {name=l19 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 150 360 0 0 {name=g20 lab=0}
T {copy 2: cmp_raw 40 ns wide} -320 220 0 0 0.25 0.25 {}
C {devices/vsource.sym} -560 -200 0 0 {name=Ven value="pwl(0 0 50n 0 50.2n 'vdd')" savecurrent=false}
C {devices/gnd.sym} -560 -170 0 0 {name=g21 lab=0}
C {lab_pin.sym} -560 -230 0 0 {name=l22 sig_type=std_logic lab=osc_en}
C {devices/vsource.sym} -460 -200 0 0 {name=Venb value="pwl(0 'vdd' 50n 'vdd' 50.2n 0)" savecurrent=false}
C {devices/gnd.sym} -460 -170 0 0 {name=g23 lab=0}
C {lab_pin.sym} -460 -230 0 0 {name=l24 sig_type=std_logic lab=osc_enb}
C {devices/vsource.sym} -360 -200 0 0 {name=Vdd value="'vdd'" savecurrent=false}
C {devices/gnd.sym} -360 -170 0 0 {name=g25 lab=0}
C {lab_pin.sym} -360 -230 0 0 {name=l26 sig_type=std_logic lab=VDPWR}
C {code_shown.sym} 520 -360 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25
.option method=gear
.control
tran 0.01n 700n 0 0.02n
meas tran trr1 when v(rst1)=0.9 rise=1 td=300n
meas tran trf1 when v(rst1)=0.9 fall=1 td=300n
meas tran tsr1 when v(x1.sw)=0.9 rise=1 td=300n
meas tran tsf1 when v(x1.sw)=0.9 fall=1 td=300n
meas tran t901 when v(x1.sw)=1.62 fall=1 td=300n
meas tran t101 when v(x1.sw)=0.18 fall=1 td=300n
meas tran vpre1 find v(vcap1) at=390n
meas tran vres1 find v(vcap1) when v(x1.sw)=0.9 fall=1 td=300n
meas tran ped01 find v(vcap1) at=140n
meas tran ped1 find v(vcap1) at=650n
meas tran again1 max v(rst1) from=480n to=690n
echo R k=1 trr=$&trr1 trf=$&trf1 tsr=$&tsr1 tsf=$&tsf1 t90=$&t901 t10=$&t101 vpre=$&vpre1 vres=$&vres1 ped0=$&ped01 ped=$&ped1 again=$&again1
meas tran trr2 when v(rst2)=0.9 rise=1 td=300n
meas tran trf2 when v(rst2)=0.9 fall=1 td=300n
meas tran tsr2 when v(x2.sw)=0.9 rise=1 td=300n
meas tran tsf2 when v(x2.sw)=0.9 fall=1 td=300n
meas tran t902 when v(x2.sw)=1.62 fall=1 td=300n
meas tran t102 when v(x2.sw)=0.18 fall=1 td=300n
meas tran vpre2 find v(vcap2) at=390n
meas tran vres2 find v(vcap2) when v(x2.sw)=0.9 fall=1 td=300n
meas tran ped02 find v(vcap2) at=140n
meas tran ped2 find v(vcap2) at=650n
meas tran again2 max v(rst2) from=480n to=690n
echo R k=2 trr=$&trr2 trf=$&trf2 tsr=$&tsr2 tsf=$&tsf2 t90=$&t902 t10=$&t102 vpre=$&vpre2 vres=$&vres2 ped0=$&ped02 ped=$&ped2 again=$&again2
.endc"}
C {sky130_fd_pr/corner.sym} -240 -400 0 0 {name=CORNER only_toplevel=false corner=tt}
