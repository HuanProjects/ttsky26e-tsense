v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_rsw: M6 section 5. Three copies of the reset switch MRST (nfet_01v8 W 6 L 0.5 x 2 = 12/0.5 in two fingers).
MRON: gate on VDPWR, drain forced to 10 mV -> R_on.  MOFF: gate at 0, drain at 1.3 V -> leakage.
MPED: on C_osc = 5.06 pF; its gate falls from VDPWR to 0 in tf -> the pedestal left on vcap (no charging current).
MCOV: on 5.06 pF; its gate steps 0.25 V -> 0 (no channel) -> the overlap capacitance C_ov.
Runner rsw5.py sets corner, T, VDD and tf.} 40 -360 0 0 0.3 0.3 {}
N 120 -60 120 -30 {lab=dron}
N 120 30 120 60 {lab=0}
N 400 -60 400 -30 {lab=droff}
N 400 30 400 60 {lab=0}
N 680 -60 680 -30 {lab=vcap}
N 680 30 680 60 {lab=0}
N 600 -60 680 -60 {lab=vcap}
N 600 -60 600 -30 {lab=vcap}
N 600 30 600 60 {lab=0}
N 1060 -60 1060 -30 {lab=vcov}
N 1060 30 1060 60 {lab=0}
N 980 -60 1060 -60 {lab=vcov}
N 980 -60 980 -30 {lab=vcov}
N 980 30 980 60 {lab=0}
C {sky130_fd_pr/nfet_01v8.sym} 100 0 0 0 {name=MRON
W=6
L=0.5
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 380 0 0 0 {name=MOFF
W=6
L=0.5
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 660 0 0 0 {name=MPED
W=6
L=0.5
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 1040 0 0 0 {name=MCOV
W=6
L=0.5
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {devices/capa.sym} 980 0 0 0 {name=Ccov
m=1
value=5.06p
footprint=1206
device="ceramic capacitor"}
C {devices/vsource.sym} 1180 30 0 0 {name=Vgo value="pwl(0 0.25 5n 0.25 6n 0)" savecurrent=false}
C {devices/gnd.sym} 1060 60 0 0 {name=g9 lab=0}
C {devices/gnd.sym} 980 60 0 0 {name=g10 lab=0}
C {devices/gnd.sym} 1180 60 0 0 {name=g11 lab=0}
C {lab_pin.sym} 1020 0 0 0 {name=l10 sig_type=std_logic lab=gcov}
C {lab_pin.sym} 1180 0 0 1 {name=l11 sig_type=std_logic lab=gcov}
C {lab_pin.sym} 1060 0 0 1 {name=l12 sig_type=std_logic lab=0}
C {lab_pin.sym} 1020 -60 0 0 {name=l13 sig_type=std_logic lab=vcov}
C {devices/capa.sym} 600 0 0 0 {name=Cosc
m=1
value=5.06p
footprint=1206
device="ceramic capacitor"}
C {devices/vsource.sym} 120 -90 2 0 {name=Vdron value=0.01 savecurrent=false}
C {devices/vsource.sym} 400 -90 2 0 {name=Vdroff value=1.3 savecurrent=false}
C {devices/vsource.sym} 820 30 0 0 {name=Vg value="pwl(0 'vdd' 20n 'vdd' '20n+tf' 0)" savecurrent=false}
C {devices/vsource.sym} 60 -280 0 0 {name=Vdd value='vdd' savecurrent=false}
C {devices/gnd.sym} 120 60 0 0 {name=g1 lab=0}
C {devices/gnd.sym} 400 60 0 0 {name=g2 lab=0}
C {devices/gnd.sym} 680 60 0 0 {name=g3 lab=0}
C {devices/gnd.sym} 600 60 0 0 {name=g4 lab=0}
C {devices/gnd.sym} 120 -120 2 0 {name=g5 lab=0}
C {devices/gnd.sym} 400 -120 2 0 {name=g6 lab=0}
C {devices/gnd.sym} 820 60 0 0 {name=g7 lab=0}
C {devices/gnd.sym} 60 -250 0 0 {name=g8 lab=0}
C {lab_pin.sym} 80 0 0 0 {name=l1 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 360 0 0 0 {name=l2 sig_type=std_logic lab=0}
C {lab_pin.sym} 640 0 0 1 {name=l3 sig_type=std_logic lab=grst}
C {lab_pin.sym} 820 0 0 1 {name=l4 sig_type=std_logic lab=grst}
C {lab_pin.sym} 120 0 0 1 {name=l5 sig_type=std_logic lab=0}
C {lab_pin.sym} 400 0 0 1 {name=l6 sig_type=std_logic lab=0}
C {lab_pin.sym} 680 0 0 1 {name=l7 sig_type=std_logic lab=0}
C {lab_pin.sym} 640 -60 0 1 {name=l8 sig_type=std_logic lab=vcap}
C {lab_pin.sym} 60 -310 0 0 {name=l9 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/corner.sym} 200 -280 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 900 -280 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8 tf=2n
.temp 25
.option method=gear
.control
op
let ron = 0.01/abs(i(vdron))
let ioff = abs(i(vdroff))*1e9
let cggon = @m.xmped.msky130_fd_pr__nfet_01v8[cgg]*1e15
let vth = @m.xmped.msky130_fd_pr__nfet_01v8[vth]
echo OP ron=$&ron ioff_nA=$&ioff cgg_on_fF=$&cggon vth=$&vth
tran 0.01n 72n 0 0.01n
* overlap only: MCOV's gate falls 0.25 V -> 0, far below threshold (no channel; a 0.5 V step already catches some
* weak-inversion charge); C_ov = -step * 5.06 pF / 0.25 V
meas tran cov find v(vcov) at=18n
let cov_fF = -cov*5.06e-12/0.25*1e15
meas tran ped find v(vcap) at=62n
let ped_mV = ped*1e3
echo PED ped_mV=$&ped_mV cov_fF=$&cov_fF
.endc"}
