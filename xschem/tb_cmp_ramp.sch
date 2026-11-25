v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_cmp_ramp: M6 section 1. cmp2s on a full-slope ramp (0.274 V/us, 1.386 uA into 5.06 pF) crossing vthr = V_REF (1.2432 V, 25 C).
MNB1 (4/8) fed 1.386 uA stands in for bgr's bias diode; MNB3 / MNB4 (4/8 x4, 5.54 uA each) stand in for bgr's sinks; 40 fF = wire to each pin.
t_d = vcap crossing vthr -> cmp_raw at VDD/2. Results: simulation/tb_cmp_ramp.log, waveforms: simulation/tb_cmp_ramp.txt} -440 -330 0 0 0.3 0.3 {}
N -420 -40 -150 -40 {lab=vthr}
N -320 -20 -150 -20 {lab=vcap}
N -150 20 -240 20 {lab=ib_cmp1}
N -240 20 -240 100 {lab=ib_cmp1}
N -240 100 -240 190 {lab=ib_cmp1}
N -240 100 -200 100 {lab=ib_cmp1}
N -150 40 -150 100 {lab=ib_cmp2}
N -150 100 -150 190 {lab=ib_cmp2}
N -150 100 -100 100 {lab=ib_cmp2}
N -400 220 -400 190 {lab=nb}
N -400 190 -360 190 {lab=nb}
N -360 160 -360 190 {lab=nb}
N -400 220 -400 300 {lab=nb}
N -400 300 -280 300 {lab=nb}
N -280 300 -190 300 {lab=nb}
N -280 300 -280 220 {lab=nb}
N -190 300 -190 220 {lab=nb}
N 150 -40 200 -40 {lab=VDPWR}
N 200 -40 320 -40 {lab=VDPWR}
N 150 0 200 0 {lab=cmp_raw}
N 150 40 180 40 {lab=0}
C {cmp2s.sym} 0 0 0 0 {name=x1}
C {devices/vsource.sym} -420 -10 0 0 {name=Vthr value=1.2432 savecurrent=false}
C {devices/vsource.sym} -320 10 0 0 {name=Vcap value="pwl(0 0.8432 0.3u 0.8432 1.97883u 1.3032)" savecurrent=false}
C {devices/vsource.sym} 320 -10 0 0 {name=Vdd value=1.8 savecurrent=false}
C {devices/isource.sym} -360 130 0 0 {name=Iref value=1.386u}
C {devices/capa.sym} -200 130 0 0 {name=Cw1
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {devices/capa.sym} -100 130 0 0 {name=Cw2
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {sky130_fd_pr/nfet_01v8.sym} -380 220 0 0 {name=MNB1
W=4
L=8
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -260 220 0 0 {name=MNB3
W=4
L=8
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -170 220 0 0 {name=MNB4
W=4
L=8
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/gnd.sym} -420 20 0 0 {name=l1 lab=0}
C {devices/gnd.sym} -320 40 0 0 {name=l2 lab=0}
C {devices/gnd.sym} 320 20 0 0 {name=l3 lab=0}
C {devices/gnd.sym} 180 40 0 0 {name=l4 lab=0}
C {devices/gnd.sym} -200 160 0 0 {name=l5 lab=0}
C {devices/gnd.sym} -100 160 0 0 {name=l6 lab=0}
C {devices/gnd.sym} -360 250 0 0 {name=l7 lab=0}
C {devices/gnd.sym} -240 250 0 0 {name=l8 lab=0}
C {devices/gnd.sym} -150 250 0 0 {name=l9 lab=0}
C {lab_pin.sym} -360 220 0 1 {name=p1 sig_type=std_logic lab=0}
C {lab_pin.sym} -240 220 0 1 {name=p2 sig_type=std_logic lab=0}
C {lab_pin.sym} -150 220 0 1 {name=p3 sig_type=std_logic lab=0}
C {lab_pin.sym} -360 100 0 0 {name=p4 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 200 -40 3 0 {name=p5 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 200 0 0 1 {name=p6 sig_type=std_logic lab=cmp_raw}
C {lab_pin.sym} -420 -40 0 0 {name=p7 sig_type=std_logic lab=vthr}
C {lab_pin.sym} -320 -20 0 0 {name=p8 sig_type=std_logic lab=vcap}
C {lab_pin.sym} -240 20 3 0 {name=p9 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} -150 190 0 0 {name=p10 sig_type=std_logic lab=ib_cmp2}
C {lab_pin.sym} -360 190 0 1 {name=p11 sig_type=std_logic lab=nb}
C {sky130_fd_pr/corner.sym} -420 -230 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 260 80 0 0 {name=s1 only_toplevel=false value=".include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.option method=gear
.temp 25
.control
save all @m.xmnb3.msky130_fd_pr__nfet_01v8[id] @m.xmnb4.msky130_fd_pr__nfet_01v8[id]
tran 0.1n 2.2u 0 0.1n
* the crossing and the output edge
meas tran tcross when v(vcap)=1.2432 rise=1
meas tran tout when v(cmp_raw)=0.9 rise=1
let td_ns = (tout - tcross)*1e9
* idle state 0.26 us before the crossing (vcap 70 mV under vthr)
meas tran n1i find v(x1.n1) at=1.5u
meas tran ndi find v(x1.nd) at=1.5u
meas tran n2i find v(ib_cmp2) at=1.5u
meas tran taili find v(ib_cmp1) at=1.5u
meas tran ivdd avg i(vdd) from=1.2u to=1.5u
let icmp_uA = (-ivdd - 1.386e-6)*1e6
* where n1 has to get to before stage 2 flips
meas tran t128 when v(x1.n1)=1.28 fall=1
meas tran tn2 when v(ib_cmp2)=0.9 rise=1
meas tran n1flip find v(x1.n1) when v(ib_cmp2)=0.9 rise=1
let t128_ns = (t128 - tcross)*1e9
let tn2_ns = (tn2 - tcross)*1e9
echo RESULT td_ns=$&td_ns icmp_uA=$&icmp_uA n1_idle=$&n1i nd_idle=$&ndi n2_idle=$&n2i tail_idle=$&taili
echo RESULT t_n1_1p28_ns=$&t128_ns t_n2_0p9_ns=$&tn2_ns n1_at_n2flip=$&n1flip
wrdata tb_cmp_ramp.txt v(vcap) v(vthr) v(x1.n1) v(x1.nd) v(ib_cmp2) v(cmp_raw) v(ib_cmp1)
.endc"}
