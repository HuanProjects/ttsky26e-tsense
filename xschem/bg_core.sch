v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -100 -20 -100 60 {lab=va}
N -100 60 160 60 {lab=va}
N -100 -80 160 -80 {lab=vb}
N -100 -140 100 -140 {lab=vref}
N 100 -140 100 -60 {lab=vref}
N 100 -60 160 -60 {lab=vref}
N 100 -40 160 -40 {lab=veb3}
N 100 -40 100 80 {lab=veb3}
N 100 80 160 80 {lab=veb3}
N 130 -0 160 -0 {lab=eb2}
N 130 -0 130 100 {lab=eb2}
N 130 100 160 100 {lab=eb2}
N -60 -40 -60 190 {lab=nb}
N -100 -40 -60 -40 {lab=nb}
N -60 160 -20 160 {lab=nb}
N -60 190 -60 560 {lab=nb}
N -100 -180 -0 -180 {lab=VDPWR}
N -0 -300 -0 -180 {lab=VDPWR}
N -0 -300 160 -300 {lab=VDPWR}
N 100 -260 100 -140 {lab=vref}
N 100 -280 100 -260 {lab=vref}
N 100 -280 160 -280 {lab=vref}
C {bg_mirror.sym} -250 -110 0 0 {name=x1}
C {bg_rrow.sym} 310 -40 0 1 {name=x2}
C {bg_pnp.sym} 310 90 0 1 {name=x3}
C {sky130_fd_pr/nfet_01v8.sym} -40 190 0 0 {name=MNB1
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
C {iopin.sym} -100 60 0 1 {name=p1 lab=va}
C {iopin.sym} 50 -80 0 1 {name=p2 lab=vb
}
C {iopin.sym} 100 -140 0 0 {name=p3 lab=vref}
C {iopin.sym} 100 -40 0 1 {name=p4 lab=veb3
}
C {lab_pin.sym} -60 160 0 0 {name=p6 sig_type=std_logic lab=nb}
C {lab_pin.sym} 130 100 0 0 {name=p5 sig_type=std_logic lab=eb2}
C {sky130_fd_pr/nfet_01v8.sym} -40 300 0 0 {name=MNB2
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
C {sky130_fd_pr/nfet_01v8.sym} -40 430 0 0 {name=MNB3
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
C {sky130_fd_pr/nfet_01v8.sym} -40 560 0 0 {name=MNB4
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
C {iopin.sym} -100 -200 0 0 {name=p8 lab=vpg}
C {iopin.sym} -100 -160 0 0 {name=p9 lab=i3b}
C {iopin.sym} 0 -180 0 0 {name=p10 lab=VDPWR}
C {iopin.sym} -100 -120 0 0 {name=p11 lab=ichb}
C {iopin.sym} -100 -100 0 0 {name=p12 lab=ich}
C {iopin.sym} -100 -60 0 0 {name=p13 lab=iptat_mon}
C {iopin.sym} -20 270 0 0 {name=p14 lab=ibias}
C {iopin.sym} -20 400 0 0 {name=p15 lab=ib_cmp1}
C {iopin.sym} -20 530 0 0 {name=p16 lab=ib_cmp2}
C {iopin.sym} 160 -20 0 1 {name=p17 lab=VGND
}
C {lab_pin.sym} 160 120 0 0 {name=p18 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -20 220 0 1 {name=p19 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -20 190 0 1 {name=p20 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -20 300 0 1 {name=p21 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -20 330 0 1 {name=p22 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -20 430 0 1 {name=p23 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -20 460 0 1 {name=p24 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -20 560 0 1 {name=p25 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -20 590 0 1 {name=p26 sig_type=std_logic lab=VGND}
C {bg_su.sym} 310 -250 0 1 {name=xsu}
C {lab_pin.sym} 160 -220 0 0 {name=p7 sig_type=std_logic lab=VGND}
C {iopin.sym} -80 680 0 1 {name=p27 lab=su}
C {lab_pin.sym} 160 -240 0 0 {name=p28 sig_type=std_logic lab=su}
C {lab_pin.sym} 160 -200 0 0 {name=p29 sig_type=std_logic lab=nb}
C {lab_pin.sym} 160 -260 0 0 {name=p30 sig_type=std_logic lab=vpg}
