v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_thrmux: M6 section 7. Runner mux7.py sets corner, T, VDD and the frozen V_REF / V_EB3 at T.} 0 -120 0 0 0.3 0.3 {}
T {(A) R_on vs common mode: standard TG (left) and lvt TG (right), 2/0.5 + 4/0.5, both fully on; dc sweep of vcm} 0 -20 0 0 0.25 0.25 {}
T {(B) lvt TG off (nfet gate 0, pfet gate VDPWR) between the V_REF and V_EB3 levels: leakage} 0 250 0 0 0.25 0.25 {}
T {(C) thrmux: vref = V_REF behind 204 kOhm with the 2 pF decap, veb3 = V_EB3 behind 9.2 kOhm, vthr into 0.5 pF;
thr_sel rises at 1 us (to V_EB3) and falls at 3 us (back to V_REF); thr_selb through an inv_1} 0 480 0 0 0.25 0.25 {}
N 40 70 40 40 {lab=a}
N 40 40 240 40 {lab=a}
N 240 40 380 40 {lab=a}
N 380 40 600 40 {lab=a}
N 600 40 740 40 {lab=a}
N 200 70 240 70 {lab=a}
N 240 70 280 70 {lab=a}
N 200 130 240 130 {lab=b1}
N 240 130 280 130 {lab=b1}
N 240 70 240 40 {lab=a}
N 240 130 240 160 {lab=b1}
N 240 160 380 160 {lab=b1}
N 380 160 380 130 {lab=b1}
N 380 70 380 40 {lab=a}
N 560 70 600 70 {lab=a}
N 600 70 640 70 {lab=a}
N 560 130 600 130 {lab=b2}
N 600 130 640 130 {lab=b2}
N 600 70 600 40 {lab=a}
N 600 130 600 160 {lab=b2}
N 600 160 740 160 {lab=b2}
N 740 160 740 130 {lab=b2}
N 740 70 740 40 {lab=a}
N 200 300 240 300 {lab=lr}
N 240 300 280 300 {lab=lr}
N 200 360 240 360 {lab=le}
N 240 360 280 360 {lab=le}
N 80 300 200 300 {lab=lr}
N 280 360 400 360 {lab=le}
N 40 650 40 670 {lab=vrefi}
N 40 590 40 560 {lab=vref}
N 40 560 160 560 {lab=vref}
N 160 560 250 560 {lab=vref}
N 200 710 200 730 {lab=vebi}
N 200 650 200 580 {lab=veb3}
N 200 580 250 580 {lab=veb3}
N 550 560 600 560 {lab=vthr}
N 600 560 640 560 {lab=vthr}
C {devices/vsource.sym} 40 100 0 0 {name=Vcm value="1.0" savecurrent=false}
C {devices/gnd.sym} 40 130 0 0 {name=g1 lab=0}
C {sky130_fd_pr/nfet_01v8.sym} 180 100 0 0 {name=MSN
W=2
L=0.5
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
C {sky130_fd_pr/pfet_01v8.sym} 300 100 0 1 {name=MSP
W=4
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {lab_pin.sym} 160 100 0 0 {name=l2 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 320 100 0 1 {name=l3 sig_type=std_logic lab=0}
C {lab_pin.sym} 200 100 0 1 {name=l4 sig_type=std_logic lab=0}
C {lab_pin.sym} 280 100 0 0 {name=l5 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} 380 100 0 0 {name=Vd1 value="0.01" savecurrent=false}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 540 100 0 0 {name=MLN
W=2
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 660 100 0 1 {name=MLP
W=4
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_pin.sym} 520 100 0 0 {name=l6 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 680 100 0 1 {name=l7 sig_type=std_logic lab=0}
C {lab_pin.sym} 560 100 0 1 {name=l8 sig_type=std_logic lab=0}
C {lab_pin.sym} 640 100 0 0 {name=l9 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} 740 100 0 0 {name=Vd2 value="0.01" savecurrent=false}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 180 330 0 0 {name=MON
W=2
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 300 330 0 1 {name=MOP
W=4
L=0.5
nf=1
mult=1
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {lab_pin.sym} 160 330 0 0 {name=l10 sig_type=std_logic lab=0}
C {lab_pin.sym} 320 330 0 1 {name=l11 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 200 330 0 1 {name=l12 sig_type=std_logic lab=0}
C {lab_pin.sym} 280 330 0 0 {name=l13 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} 80 330 0 0 {name=Vlr value="'vref'" savecurrent=false}
C {devices/gnd.sym} 80 360 0 0 {name=g14 lab=0}
C {devices/vsource.sym} 400 390 0 0 {name=Vle value="'veb3'" savecurrent=false}
C {devices/gnd.sym} 400 420 0 0 {name=g15 lab=0}
C {thrmux.sym} 400 600 0 0 {name=x1}
C {devices/vsource.sym} 40 700 0 0 {name=Vvref value="'vref'" savecurrent=false}
C {devices/gnd.sym} 40 730 0 0 {name=g16 lab=0}
C {devices/res.sym} 40 620 0 0 {name=Rvref
value=204k
footprint=1206
device=resistor
m=1}
C {devices/capa.sym} 160 590 0 0 {name=Cdec
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 160 620 0 0 {name=g17 lab=0}
C {devices/vsource.sym} 200 760 0 0 {name=Vveb value="'veb3'" savecurrent=false}
C {devices/gnd.sym} 200 790 0 0 {name=g18 lab=0}
C {devices/res.sym} 200 680 0 0 {name=Rveb
value=9.2k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 250 620 0 0 {name=l19 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} 250 640 0 0 {name=l20 sig_type=std_logic lab=thr_selb}
C {lab_pin.sym} 600 560 3 0 {name=l21 sig_type=std_logic lab=vthr}
C {devices/capa.sym} 640 590 0 0 {name=Cthr
m=1
value=0.5p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 640 620 0 0 {name=g22 lab=0}
C {lab_pin.sym} 550 620 0 1 {name=l23 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 550 640 0 0 {name=g24 lab=0}
C {sky130_stdcells/inv_1.sym} -100 860 0 0 {name=xib VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -140 860 0 0 {name=l25 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} -60 860 0 1 {name=l26 sig_type=std_logic lab=thr_selb}
C {devices/vsource.sym} -240 890 0 0 {name=Vsel value="pwl(0 0 1u 0 1.0002u 'vdd' 3u 'vdd' 3.0002u 0)" savecurrent=false}
C {devices/gnd.sym} -240 920 0 0 {name=g27 lab=0}
C {lab_pin.sym} -240 860 0 0 {name=l28 sig_type=std_logic lab=thr_sel}
C {devices/vsource.sym} -240 100 0 0 {name=Vdd value="'vdd'" savecurrent=false}
C {devices/gnd.sym} -240 130 0 0 {name=g29 lab=0}
C {lab_pin.sym} -240 70 0 0 {name=l30 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 40 40 3 0 {name=l31 sig_type=std_logic lab=a}
C {lab_pin.sym} 380 160 3 0 {name=l32 sig_type=std_logic lab=b1}
C {lab_pin.sym} 740 160 3 0 {name=l33 sig_type=std_logic lab=b2}
C {lab_pin.sym} 80 300 3 0 {name=l34 sig_type=std_logic lab=lr}
C {lab_pin.sym} 400 360 3 0 {name=l35 sig_type=std_logic lab=le}
C {lab_pin.sym} 160 560 3 0 {name=l36 sig_type=std_logic lab=vref}
C {lab_pin.sym} 200 580 3 0 {name=l37 sig_type=std_logic lab=veb3}
C {sky130_fd_pr/corner.sym} -240 -200 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 900 -200 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8 vref=1.2432 veb3=0.7096
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25
.option method=gear
.control
dc vcm 0.5 1.3 0.005
let rs = 0.01/abs(i(vd1))
let rl = 0.01/abs(i(vd2))
meas dc rsmax max rs
meas dc rlmax max rl
meas dc rs096 find rs at=0.96
meas dc rl096 find rl at=0.96
echo RON rsmax=$&rsmax rlmax=$&rlmax rs096=$&rs096 rl096=$&rl096
wrdata ron_curve.txt rs rl
op
let ilr = abs(i(vlr))*1e9
let ile = abs(i(vle))*1e9
echo LEAK ilr_nA=$&ilr ile_nA=$&ile
tran 0.05n 8u 0 0.05n
meas tran a1 when v(x1.sref)=0.9 fall=1
meas tran a2 when v(x1.srefb)=0.9 rise=1
meas tran a3 when v(x1.seb)=0.9 rise=1
meas tran a4 when v(x1.sebb)=0.9 fall=1
meas tran b1 when v(x1.seb)=0.9 fall=1
meas tran b2 when v(x1.sebb)=0.9 rise=1
meas tran b3 when v(x1.sref)=0.9 rise=1
meas tran b4 when v(x1.srefb)=0.9 fall=1
meas tran s1 when v(vthr)=0.7097 fall=1 td=1u
meas tran s2 when v(vthr)=1.2431 rise=1 td=3u
meas tran vrmin min v(vref) from=3u to=4u
echo BBM a1=$&a1 a2=$&a2 a3=$&a3 a4=$&a4 b1=$&b1 b2=$&b2 b3=$&b3 b4=$&b4 s1=$&s1 s2=$&s2 vrmin=$&vrmin
.endc"}
