v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {cmp_tbbias: bench helper (not in the tile). Stand-in for bgr's comparator bias diode:
I_PTAT/2 (1.386 uA at 25 C) into nfet_01v8 4/8.} -160 -200 0 0 0.3 0.3 {}
N 0 -110 0 -90 {lab=VDPWR}
N 0 -30 0 0 {lab=nb}
N -40 30 -40 0 {lab=nb}
N -40 0 0 0 {lab=nb}
N 0 0 60 0 {lab=nb}
N 0 60 0 90 {lab=VGND}
C {devices/isource.sym} 0 -60 0 0 {name=Iref value=1.386u}
C {sky130_fd_pr/nfet_01v8.sym} -20 30 0 0 {name=MNB1
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
C {iopin.sym} 0 -110 3 0 {name=p1 lab=VDPWR}
C {iopin.sym} 60 0 0 0 {name=p2 lab=nb}
C {iopin.sym} 0 90 1 0 {name=p3 lab=VGND}
C {lab_pin.sym} 0 30 0 1 {name=p4 sig_type=std_logic lab=VGND}
