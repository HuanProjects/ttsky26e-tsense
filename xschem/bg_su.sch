v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -60 30 -60 120 {lab=su}
N -60 70 80 70 {lab=su}
N -140 -0 -100 -0 {lab=vref}
N -140 150 -100 150 {lab=nb}
N -60 180 -60 220 {lab=VGND}
N -60 220 120 220 {lab=VGND}
N 120 100 120 220 {lab=VGND}
C {sky130_fd_pr/pfet_01v8.sym} -80 0 0 0 {name=MSU1
W=0.42
L=20
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
C {sky130_fd_pr/nfet_01v8.sym} -80 150 0 0 {name=MSU3
W=0.42
L=1
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
C {sky130_fd_pr/nfet_01v8.sym} 100 70 0 0 {name=MSU2
W=0.42
L=10
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
C {iopin.sym} -140 0 0 1 {name=p2 lab=vref}
C {iopin.sym} -60 220 0 1 {name=p3 lab=VGND}
C {iopin.sym} 120 40 1 1 {name=p4 lab=vpg}
C {iopin.sym} -60 -30 1 1 {name=p5 lab=VDPWR}
C {lab_pin.sym} -60 0 0 1 {name=p6 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -60 150 0 1 {name=p7 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 120 70 0 1 {name=p8 sig_type=std_logic lab=VGND}
C {iopin.sym} -60 70 0 1 {name=p9 lab=su}
C {iopin.sym} -70 290 0 1 {name=p1 lab=nb}
C {lab_pin.sym} -140 150 0 0 {name=p10 sig_type=std_logic lab=nb}
