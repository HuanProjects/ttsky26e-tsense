v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -20 -80 -20 0 {lab=vpg}
N 120 -80 120 0 {lab=vpg}
N 260 -80 260 -0 {lab=vpg}
N 400 -80 400 -0 {lab=vpg}
N 540 -80 540 0 {lab=vpg}
N 680 -80 680 0 {lab=vpg}
N 820 -80 820 -0 {lab=vpg}
N -80 -80 820 -80 {lab=vpg}
N 970 -80 970 0 {lab=vpg}
N 820 -80 970 -80 {lab=vpg}
N 20 30 20 100 {lab=d1}
N 160 30 160 100 {lab=d2}
N 300 30 300 100 {lab=d3a}
N 440 30 440 100 {lab=d3b}
N 580 30 580 100 {lab=d4a}
N 720 30 720 100 {lab=d4b}
N 860 30 860 100 {lab=d7}
N 1010 30 1010 100 {lab=xxx}
C {sky130_fd_pr/pfet_01v8.sym} 0 0 0 0 {name=MP1
W=8.8
L=20
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 140 0 0 0 {name=MP2
W=8.8
L=20
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 280 0 0 0 {name=MP3A
W=8.8
L=20
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
C {sky130_fd_pr/pfet_01v8.sym} 420 0 0 0 {name=MP3B
W=8.8
L=20
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
C {sky130_fd_pr/pfet_01v8.sym} 560 0 0 0 {name=MP4A
W=8.8
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
C {sky130_fd_pr/pfet_01v8.sym} 700 0 0 0 {name=MP4B
W=8.8
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
C {sky130_fd_pr/pfet_01v8.sym} 840 0 0 0 {name=MP7
W=8.8
L=20
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
C {sky130_fd_pr/pfet_01v8.sym} 990 0 0 0 {name=MP5
W=8.8
L=20
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
C {iopin.sym} -80 -80 0 1 {name=p1 lab=vpg}
C {lab_pin.sym} 20 -30 0 1 {name=p2 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 20 0 0 1 {name=p3 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 160 -30 0 1 {name=p4 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 160 0 0 1 {name=p5 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 300 -30 0 1 {name=p6 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 300 0 0 1 {name=p7 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 440 -30 0 1 {name=p8 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 440 0 0 1 {name=p9 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 580 -30 0 1 {name=p10 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 580 0 0 1 {name=p11 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 720 -30 0 1 {name=p12 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 720 0 0 1 {name=p13 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 860 -30 0 1 {name=p14 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 860 0 0 1 {name=p15 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1010 -30 0 1 {name=p16 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1010 0 0 1 {name=p17 sig_type=std_logic lab=VDPWR}
C {iopin.sym} -270 -80 0 1 {name=p18 lab=VDPWR}
C {iopin.sym} 20 100 0 0 {name=p19 lab=d1}
C {iopin.sym} 160 100 0 0 {name=p20 lab=d2}
C {iopin.sym} 300 100 0 0 {name=p21 lab=d3a}
C {iopin.sym} 440 100 0 0 {name=p22 lab=d3b}
C {iopin.sym} 580 100 0 0 {name=p23 lab=d4a}
C {iopin.sym} 720 100 0 0 {name=p24 lab=d4b}
C {iopin.sym} 860 100 0 0 {name=p25 lab=d7}
C {iopin.sym} 1010 100 0 0 {name=p26 lab=d5}
