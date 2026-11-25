v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 790 -40 830 -40 {lab=VDPWR}
N 140 -90 830 -90 {lab=VDPWR}
N 830 -90 830 -40 {lab=VDPWR}
N 790 0 790 60 {lab=VGND}
N 140 90 360 90 {lab=va}
N 360 90 360 260 {lab=va}
N 440 -20 490 -20 {lab=inn}
N 440 -20 440 340 {lab=inn}
N 360 340 440 340 {lab=inn}
N 360 320 360 340 {lab=inn}
N 140 10 240 10 {lab=vb}
N 240 10 240 390 {lab=vb}
N 240 390 360 390 {lab=vb}
N 360 450 490 450 {lab=inp}
N 490 0 490 450 {lab=inp}
N 220 520 370 520 {lab=va}
N 220 90 220 520 {lab=va}
N 240 390 240 660 {lab=vb}
N 240 660 370 660 {lab=vb}
N 370 580 490 580 {lab=inp}
N 490 450 490 580 {lab=inp}
N 440 340 440 680 {lab=inn}
N 440 680 440 720 {lab=inn}
N 370 720 440 720 {lab=inn}
N 140 70 790 70 {lab=VGND}
N 790 60 790 70 {lab=VGND}
N 140 -30 230 -30 {lab=ichb}
N 230 -350 230 -30 {lab=ichb}
N 210 -350 230 -350 {lab=ichb}
N 210 -350 210 -330 {lab=ichb}
N 210 -270 210 -10 {lab=ich}
N 140 -10 210 -10 {lab=ich}
N 460 -270 460 -240 {lab=ichb}
N 230 -240 460 -240 {lab=ichb}
N 210 -220 320 -220 {lab=ich}
N 320 -340 320 -220 {lab=ich}
N 320 -340 460 -340 {lab=ich}
N 460 -340 460 -330 {lab=ich}
N 700 -340 700 -330 {lab=ichb}
N 580 -340 700 -340 {lab=ichb}
N 270 -160 270 -70 {lab=i3b}
N 140 -70 270 -70 {lab=i3b}
N 270 -190 270 -160 {lab=i3b}
N 270 -190 410 -190 {lab=i3b}
N 140 -50 340 -50 {lab=vref}
N 340 -130 340 -50 {lab=vref}
N 340 -130 410 -130 {lab=vref}
N 520 -130 630 -130 {lab=i3b}
N 410 -130 500 -130 {lab=vref}
N 500 -200 500 -130 {lab=vref}
N 500 -200 630 -200 {lab=vref}
N 630 -200 630 -190 {lab=vref}
N 780 -240 890 -240 {lab=i3b}
N 460 -240 540 -240 {lab=ichb}
N 540 -340 540 -240 {lab=ichb}
N 540 -340 580 -340 {lab=ichb}
N 410 -190 510 -190 {lab=i3b}
N 510 -190 510 -130 {lab=i3b}
N 510 -130 520 -130 {lab=i3b}
N 720 -240 780 -240 {lab=i3b}
N 720 -240 720 -130 {lab=i3b}
N 630 -130 720 -130 {lab=i3b}
C {bg_core.sym} -10 30 0 0 {name=xcore}
C {ota2s.sym} 640 -20 0 0 {name=xota}
C {lab_pin.sym} 490 -40 0 0 {name=p1 sig_type=std_logic lab=ibias}
C {lab_pin.sym} 490 -20 0 0 {name=p2 sig_type=std_logic lab=inn}
C {lab_pin.sym} 490 0 0 0 {name=p3 sig_type=std_logic lab=inp}
C {lab_pin.sym} 790 -20 0 1 {name=p5 sig_type=std_logic lab=vpg}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 340 290 0 0 {name=S1
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
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_pin.sym} 360 290 0 1 {name=p7 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 340 420 0 0 {name=S2
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
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_pin.sym} 360 420 0 1 {name=p8 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 370 550 0 1 {name=p11 sig_type=std_logic lab=VGND}
C {iopin.sym} 330 550 0 1 {name=p12 lab=swb}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 350 550 0 0 {name=S3
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
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_pin.sym} 370 690 0 1 {name=p13 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 330 690 0 0 {name=p14 sig_type=std_logic lab=swb}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 350 690 0 0 {name=S4
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
model=nfet_01v8_lvt
spiceprefix=X
}
C {lab_pin.sym} 140 -110 0 1 {name=p15 sig_type=std_logic lab=vpg}
C {iopin.sym} 830 -90 0 0 {name=p16 lab=VDPWR}
C {iopin.sym} 790 70 0 0 {name=p17 lab=VGND}
C {iopin.sym} 340 -50 0 0 {name=p18 lab=vref}
C {iopin.sym} 140 50 0 0 {name=p19 lab=veb3}
C {iopin.sym} 210 -10 0 0 {name=p21 lab=ich}
C {iopin.sym} 140 30 0 0 {name=p23 lab=iptat_mon}
C {iopin.sym} 140 130 0 0 {name=p24 lab=ib_cmp1}
C {iopin.sym} 140 150 0 0 {name=p25 lab=ib_cmp2}
C {iopin.sym} 320 290 0 1 {name=p26 lab=swa}
C {lab_pin.sym} 320 420 0 0 {name=p10 sig_type=std_logic lab=swa}
C {iopin.sym} 620 30 0 1 {name=p9 lab=chop}
C {iopin.sym} 660 30 0 0 {name=p4 lab=chopb}
C {lab_pin.sym} 140 110 0 1 {name=p6 sig_type=std_logic lab=ibias}
C {lab_pin.sym} 140 90 0 1 {name=p27 sig_type=std_logic lab=va}
C {lab_pin.sym} 140 10 0 1 {name=p28 sig_type=std_logic lab=vb}
C {lab_pin.sym} 270 -70 0 1 {name=p29 sig_type=std_logic lab=i3b}
C {lab_pin.sym} 230 -30 0 1 {name=p20 sig_type=std_logic lab=ichb}
C {sky130_fd_pr/nfet_01v8.sym} 190 -300 0 0 {name=S_ichon_n
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
C {lab_pin.sym} 210 -330 0 1 {name=p22 sig_type=std_logic lab=ichb}
C {lab_pin.sym} 210 -300 0 1 {name=p30 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 210 -270 0 1 {name=p31 sig_type=std_logic lab=ich}
C {sky130_fd_pr/pfet_01v8.sym} 440 -300 0 0 {name=S_ichon_p
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
C {lab_pin.sym} 460 -270 0 1 {name=p33 sig_type=std_logic lab=ichb}
C {lab_pin.sym} 460 -330 0 1 {name=p35 sig_type=std_logic lab=ich}
C {lab_pin.sym} 460 -300 0 1 {name=p36 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/nfet_01v8.sym} 680 -300 0 0 {name=S_ichdump
W=1
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
C {lab_pin.sym} 700 -300 0 1 {name=p37 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 700 -270 0 1 {name=p38 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/nfet_01v8.sym} 390 -160 0 0 {name=S_i3on_n
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
C {lab_pin.sym} 410 -160 0 1 {name=p41 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/pfet_01v8.sym} 610 -160 0 0 {name=S_i3on_p
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
C {lab_pin.sym} 630 -160 0 1 {name=p43 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 890 -210 0 1 {name=p45 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/nfet_01v8.sym} 870 -210 0 0 {name=S_i3dump
W=1
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
C {lab_pin.sym} 890 -180 0 1 {name=p46 sig_type=std_logic lab=VGND}
C {iopin.sym} 170 -300 0 1 {name=p47 lab=ich_on}
C {iopin.sym} 420 -300 0 1 {name=p32 lab=ich_onb}
C {iopin.sym} 660 -300 0 1 {name=p34 lab=ich_dump}
C {iopin.sym} 370 -160 0 1 {name=p39 lab=i3_on}
C {iopin.sym} 590 -160 0 1 {name=p40 lab=i3_onb}
C {iopin.sym} 850 -210 0 1 {name=p42 lab=i3_dump}
C {lab_pin.sym} 140 170 0 1 {name=p44 sig_type=std_logic lab=su}
C {iopin.sym} 320 840 0 1 {name=p48 lab=su}
