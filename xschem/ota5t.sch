v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -100 200 -100 300 {lab=dl}
N -100 360 -100 400 {lab=VGND}
N -180 400 250 400 {lab=VGND}
N 190 360 190 400 {lab=VGND}
N 190 200 190 300 {lab=OUT}
N -60 330 150 330 {lab=dl}
N -100 250 40 250 {lab=dl}
N 40 250 40 330 {lab=dl}
N -100 100 -100 140 {lab=xxx}
N -100 100 190 100 {lab=xxx}
N 190 100 190 140 {lab=xxx}
N 10 50 10 100 {lab=xxx}
N -240 20 -30 20 {lab=IBIAS}
N -280 50 -280 80 {lab=IBIAS}
N -280 80 -180 80 {lab=IBIAS}
N -180 20 -180 80 {lab=IBIAS}
N -370 -60 150 -60 {lab=VDPWR}
N -280 -60 -280 -10 {lab=VDPWR}
N 10 -60 10 -10 {lab=VDPWR}
N -190 170 -140 170 {lab=INP}
N 190 260 370 260 {lab=OUT}
N 110 170 150 170 {lab=INN}
C {sky130_fd_pr/pfet_01v8.sym} -260 20 0 1 {name=MREF
W=20
L=4
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
C {sky130_fd_pr/pfet_01v8.sym} -10 20 0 0 {name=MTAIL
W=20
L=4
nf=1
mult=2
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -120 170 0 0 {name=MP1
W=25
L=6
nf=1
mult=24
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 170 170 0 0 {name=MP2
W=25
L=6
nf=1
mult=24
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} -80 330 0 1 {name=MN1
W=6
L=20
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
C {sky130_fd_pr/nfet_01v8.sym} 170 330 0 0 {name=MN2
W=6
L=20
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
C {ipin.sym} -190 170 0 0 {name=p1 lab=INP}
C {ipin.sym} 110 170 0 0 {name=p2 lab=INN}
C {ipin.sym} -280 80 0 0 {name=p3 lab=IBIAS}
C {opin.sym} 370 260 0 0 {name=p4 lab=OUT}
C {iopin.sym} -370 -60 0 1 {name=p5 lab=VDPWR}
C {iopin.sym} -180 400 0 1 {name=p6 lab=VGND}
C {lab_pin.sym} -100 250 0 0 {name=p7 sig_type=std_logic lab=dl}
C {lab_pin.sym} 10 100 3 0 {name=p8 sig_type=std_logic lab=tail}
C {lab_pin.sym} -280 20 0 0 {name=p9 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 10 20 0 1 {name=p10 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -100 170 0 1 {name=p11 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 190 170 0 1 {name=p12 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 190 330 0 1 {name=p13 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -100 330 0 0 {name=p14 sig_type=std_logic lab=VGND}
