v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {cmp_tbcopy: bench helper (not in the tile). One cmp2s with the two bgr sinks it sees on chip:
MNB3 / MNB4 = nfet_01v8 4/8 x4 (5.54 uA each with 1.386 uA into the 4/8 diode), 40 fF wire on each pin.
The bias diode is outside (pin nb), so a bench can give each copy its own diode or share one.} -380 -200 0 0 0.3 0.3 {}
N -200 -40 -150 -40 {lab=vthr}
N -200 -20 -150 -20 {lab=vcap}
N -150 20 -240 20 {lab=ib_cmp1}
N -240 20 -240 50 {lab=ib_cmp1}
N -240 50 -240 90 {lab=ib_cmp1}
N -240 50 -320 50 {lab=ib_cmp1}
N -150 40 -150 80 {lab=ib_cmp2}
N -150 80 -150 90 {lab=ib_cmp2}
N -150 80 -100 80 {lab=ib_cmp2}
N -360 180 -280 180 {lab=nb}
N -280 180 -190 180 {lab=nb}
N -280 180 -280 120 {lab=nb}
N -190 180 -190 120 {lab=nb}
N 150 -40 200 -40 {lab=VDPWR}
N 150 0 200 0 {lab=cmp_raw}
N 150 40 200 40 {lab=VGND}
C {cmp2s.sym} 0 0 0 0 {name=x1}
C {sky130_fd_pr/nfet_01v8.sym} -260 120 0 0 {name=MNB3
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
C {sky130_fd_pr/nfet_01v8.sym} -170 120 0 0 {name=MNB4
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
C {devices/capa.sym} -320 80 0 0 {name=Cw1
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {devices/capa.sym} -100 110 0 0 {name=Cw2
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {ipin.sym} -200 -40 0 0 {name=p1 lab=vthr}
C {ipin.sym} -200 -20 0 0 {name=p2 lab=vcap}
C {iopin.sym} -360 180 0 1 {name=p3 lab=nb}
C {iopin.sym} 200 -40 0 0 {name=p4 lab=VDPWR}
C {opin.sym} 200 0 0 0 {name=p5 lab=cmp_raw}
C {iopin.sym} 200 40 0 0 {name=p6 lab=VGND}
C {lab_pin.sym} -240 150 0 1 {name=p7 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -150 150 0 1 {name=p8 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -240 120 0 1 {name=p9 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -150 120 0 1 {name=p10 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -320 110 0 0 {name=p11 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -100 140 0 1 {name=p12 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -240 20 3 0 {name=p13 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} -150 80 0 0 {name=p14 sig_type=std_logic lab=ib_cmp2}
