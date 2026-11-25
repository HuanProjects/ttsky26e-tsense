v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {cmp2s: M6 comparator (adopted set C). Stage 1 = lvt nfet pair M1a/M1b + lvt pfet mirror M2a/M2b.
Stage 2 = M3 (lvt pfet) against the MNB4 sink in bgr. Tail sink = MNB3 in bgr (pins ib_cmp1 / ib_cmp2).
Output = MIP/MIN inverter (strong nfet) + inv_1.} -200 -320 0 0 0.3 0.3 {}
N -160 -200 -120 -200 {lab=VDPWR}
N -120 -200 120 -200 {lab=VDPWR}
N 120 -200 320 -200 {lab=VDPWR}
N 320 -200 460 -200 {lab=VDPWR}
N -120 -200 -120 -180 {lab=VDPWR}
N 120 -200 120 -180 {lab=VDPWR}
N 320 -200 320 -120 {lab=VDPWR}
N 460 -200 460 -120 {lab=VDPWR}
N -80 -150 0 -150 {lab=nd}
N 0 -150 80 -150 {lab=nd}
N 0 -150 0 -100 {lab=nd}
N -120 -100 0 -100 {lab=nd}
N -120 -120 -120 -100 {lab=nd}
N -120 -100 -120 -60 {lab=nd}
N 120 -120 120 -90 {lab=n1}
N 120 -90 120 -60 {lab=n1}
N 120 -90 200 -90 {lab=n1}
N 200 -90 280 -90 {lab=n1}
N -120 0 0 0 {lab=ib_cmp1}
N 0 0 120 0 {lab=ib_cmp1}
N 0 0 0 40 {lab=ib_cmp1}
N -200 -30 -160 -30 {lab=vthr}
N 160 -30 200 -30 {lab=vcap}
N 320 -60 320 -30 {lab=ib_cmp2}
N 320 -30 320 40 {lab=ib_cmp2}
N 320 -30 400 -30 {lab=ib_cmp2}
N 400 -90 420 -90 {lab=ib_cmp2}
N 400 30 420 30 {lab=ib_cmp2}
N 400 -90 400 -30 {lab=ib_cmp2}
N 400 -30 400 30 {lab=ib_cmp2}
N 460 -60 460 -30 {lab=x}
N 460 -30 460 0 {lab=x}
N 460 -30 500 -30 {lab=x}
N 580 -30 620 -30 {lab=cmp_raw}
N 460 60 460 100 {lab=VGND}
N -160 100 460 100 {lab=VGND}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -100 -150 0 1 {name=M2a
W=4
L=4
nf=1
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 100 -150 0 0 {name=M2b
W=4
L=4
nf=1
mult=8
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} -140 -30 0 0 {name=M1a
W=10
L=1.75
nf=1
mult=6
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 140 -30 0 1 {name=M1b
W=10
L=1.75
nf=1
mult=6
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 300 -90 0 0 {name=M3
W=4
L=1
nf=1
mult=3
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 440 -90 0 0 {name=MIP
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 440 30 0 0 {name=MIN
W=2
L=0.15
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
C {sky130_stdcells/inv_1.sym} 540 -30 0 0 {name=xinv VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {iopin.sym} -160 -200 0 1 {name=p1 lab=VDPWR}
C {iopin.sym} -160 100 0 1 {name=p2 lab=VGND}
C {ipin.sym} -200 -30 0 0 {name=p3 lab=vthr}
C {ipin.sym} 200 -30 0 1 {name=p4 lab=vcap}
C {iopin.sym} 0 40 1 0 {name=p5 lab=ib_cmp1}
C {iopin.sym} 320 40 1 0 {name=p6 lab=ib_cmp2}
C {opin.sym} 620 -30 0 0 {name=p7 lab=cmp_raw}
C {lab_pin.sym} -120 -150 0 0 {name=p8 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 120 -150 0 1 {name=p9 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 320 -90 0 1 {name=p10 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 460 -90 0 1 {name=p11 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -120 -30 0 1 {name=p12 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 120 -30 0 0 {name=p13 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 460 30 0 1 {name=p14 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 0 -100 0 1 {name=p15 sig_type=std_logic lab=nd}
C {lab_pin.sym} 200 -90 3 0 {name=p16 sig_type=std_logic lab=n1}
C {lab_pin.sym} 460 -30 0 1 {name=p17 sig_type=std_logic lab=x}
