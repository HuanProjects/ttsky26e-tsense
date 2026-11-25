v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {dly5: delay line of the M6 one-shot. Five inverters, nfet_01v8 0.42/2.3 + pfet_01v8 1/2.3 (mobility-limited,
like the reset switch's R_on). Odd count: y = NOT a, delayed about 10 ns at tt.} 20 -220 0 0 0.3 0.3 {}
N 20 -15 60 -15 {lab=a}
N 80 -60 60 -60 {lab=a}
N 60 -60 60 -15 {lab=a}
N 60 -15 60 30 {lab=a}
N 60 30 80 30 {lab=a}
N 120 -30 120 -15 {lab=d1}
N 120 -15 120 0 {lab=d1}
N 120 -90 120 -110 {lab=VDPWR}
N 120 60 120 90 {lab=VGND}
N 120 -15 220 -15 {lab=d1}
N 240 -60 220 -60 {lab=d1}
N 220 -60 220 -15 {lab=d1}
N 220 -15 220 30 {lab=d1}
N 220 30 240 30 {lab=d1}
N 280 -30 280 -15 {lab=d2}
N 280 -15 280 0 {lab=d2}
N 280 -90 280 -110 {lab=VDPWR}
N 280 60 280 90 {lab=VGND}
N 280 -15 380 -15 {lab=d2}
N 400 -60 380 -60 {lab=d2}
N 380 -60 380 -15 {lab=d2}
N 380 -15 380 30 {lab=d2}
N 380 30 400 30 {lab=d2}
N 440 -30 440 -15 {lab=d3}
N 440 -15 440 0 {lab=d3}
N 440 -90 440 -110 {lab=VDPWR}
N 440 60 440 90 {lab=VGND}
N 440 -15 540 -15 {lab=d3}
N 560 -60 540 -60 {lab=d3}
N 540 -60 540 -15 {lab=d3}
N 540 -15 540 30 {lab=d3}
N 540 30 560 30 {lab=d3}
N 600 -30 600 -15 {lab=d4}
N 600 -15 600 0 {lab=d4}
N 600 -90 600 -110 {lab=VDPWR}
N 600 60 600 90 {lab=VGND}
N 600 -15 700 -15 {lab=d4}
N 720 -60 700 -60 {lab=d4}
N 700 -60 700 -15 {lab=d4}
N 700 -15 700 30 {lab=d4}
N 700 30 720 30 {lab=d4}
N 760 -30 760 -15 {lab=y}
N 760 -15 760 0 {lab=y}
N 760 -90 760 -110 {lab=VDPWR}
N 760 60 760 90 {lab=VGND}
N 760 -15 820 -15 {lab=y}
N 40 -110 120 -110 {lab=VDPWR}
N 40 90 120 90 {lab=VGND}
N 120 -110 280 -110 {lab=VDPWR}
N 120 90 280 90 {lab=VGND}
N 280 -110 440 -110 {lab=VDPWR}
N 280 90 440 90 {lab=VGND}
N 440 -110 600 -110 {lab=VDPWR}
N 440 90 600 90 {lab=VGND}
N 600 -110 760 -110 {lab=VDPWR}
N 600 90 760 90 {lab=VGND}
C {sky130_fd_pr/pfet_01v8.sym} 100 -60 0 0 {name=MP1
W=1
L=2.3
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
C {sky130_fd_pr/nfet_01v8.sym} 100 30 0 0 {name=MN1
W=0.42
L=2.3
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
C {lab_pin.sym} 120 -60 0 1 {name=l1 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 120 30 0 1 {name=l2 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/pfet_01v8.sym} 260 -60 0 0 {name=MP2
W=1
L=2.3
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
C {sky130_fd_pr/nfet_01v8.sym} 260 30 0 0 {name=MN2
W=0.42
L=2.3
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
C {lab_pin.sym} 280 -60 0 1 {name=l3 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 280 30 0 1 {name=l4 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/pfet_01v8.sym} 420 -60 0 0 {name=MP3
W=1
L=2.3
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
C {sky130_fd_pr/nfet_01v8.sym} 420 30 0 0 {name=MN3
W=0.42
L=2.3
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
C {lab_pin.sym} 440 -60 0 1 {name=l5 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 440 30 0 1 {name=l6 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/pfet_01v8.sym} 580 -60 0 0 {name=MP4
W=1
L=2.3
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
C {sky130_fd_pr/nfet_01v8.sym} 580 30 0 0 {name=MN4
W=0.42
L=2.3
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
C {lab_pin.sym} 600 -60 0 1 {name=l7 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 600 30 0 1 {name=l8 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/pfet_01v8.sym} 740 -60 0 0 {name=MP5
W=1
L=2.3
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
C {sky130_fd_pr/nfet_01v8.sym} 740 30 0 0 {name=MN5
W=0.42
L=2.3
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
C {lab_pin.sym} 760 -60 0 1 {name=l9 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 760 30 0 1 {name=l10 sig_type=std_logic lab=VGND}
C {iopin.sym} 40 -110 0 1 {name=p1 lab=VDPWR}
C {iopin.sym} 40 90 0 1 {name=p2 lab=VGND}
C {ipin.sym} 20 -15 0 0 {name=p3 lab=a}
C {opin.sym} 820 -15 0 0 {name=p4 lab=y}
C {lab_pin.sym} 160 -15 3 0 {name=l11 sig_type=std_logic lab=d1}
C {lab_pin.sym} 320 -15 3 0 {name=l12 sig_type=std_logic lab=d2}
C {lab_pin.sym} 480 -15 3 0 {name=l13 sig_type=std_logic lab=d3}
C {lab_pin.sym} 640 -15 3 0 {name=l14 sig_type=std_logic lab=d4}
