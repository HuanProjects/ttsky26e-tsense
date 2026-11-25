v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -100 200 -100 300 {lab=d1}
N -100 360 -100 400 {lab=VGND}
N -180 400 250 400 {lab=VGND}
N 190 360 190 400 {lab=VGND}
N 190 200 190 300 {lab=x1}
N -60 330 150 330 {lab=d1}
N -100 250 40 250 {lab=d1}
N 40 250 40 330 {lab=d1}
N -100 100 -100 140 {lab=tail}
N -100 100 190 100 {lab=tail}
N 190 100 190 140 {lab=tail}
N 10 50 10 100 {lab=tail}
N -240 20 -30 20 {lab=IBIAS}
N -280 50 -280 80 {lab=IBIAS}
N -280 80 -180 80 {lab=IBIAS}
N -180 20 -180 80 {lab=IBIAS}
N -370 -60 150 -60 {lab=VDPWR}
N -280 -60 -280 -10 {lab=VDPWR}
N 10 -60 10 -10 {lab=VDPWR}
N -190 170 -140 170 {lab=INN}
N 110 170 150 170 {lab=INP}
N 440 0 440 250 {lab=OUT}
N 440 170 540 170 {lab=OUT}
N 150 -60 440 -60 {lab=VDPWR}
N 190 250 320 250 {lab=x1}
N 320 250 320 280 {lab=x1}
N 320 280 400 280 {lab=x1}
N 250 400 440 400 {lab=VGND}
N 440 310 440 400 {lab=VGND}
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
C {ipin.sym} -190 170 0 0 {name=p1 lab=INN}
C {ipin.sym} 110 170 0 0 {name=p2 lab=INP}
C {ipin.sym} -280 80 0 0 {name=p3 lab=IBIAS}
C {opin.sym} 540 170 0 0 {name=p4 lab=OUT}
C {iopin.sym} -370 -60 0 1 {name=p5 lab=VDPWR}
C {iopin.sym} -180 400 0 1 {name=p6 lab=VGND}
C {lab_pin.sym} -100 250 0 0 {name=p7 sig_type=std_logic lab=d1}
C {lab_pin.sym} 10 100 3 0 {name=p8 sig_type=std_logic lab=tail}
C {lab_pin.sym} -280 20 0 0 {name=p9 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 10 20 0 1 {name=p10 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -100 170 0 1 {name=p11 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 190 170 0 1 {name=p12 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 190 330 0 1 {name=p13 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -100 330 0 0 {name=p14 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 190 250 0 0 {name=p15 sig_type=std_logic lab=x1}
C {sky130_fd_pr/pfet_01v8.sym} 420 -30 0 0 {name=MP3
W=20
L=4
nf=1
mult=6
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 420 280 0 0 {name=MN3
W=7
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
C {lab_pin.sym} 440 -30 0 1 {name=p17 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 440 280 0 1 {name=p18 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 400 -30 0 0 {name=p16 sig_type=std_logic lab=IBIAS}
C {sky130_fd_pr/res_high_po_1p41.sym} 800 40 0 0 {name=RZ1
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 780 40 0 0 {name=p19 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 800 100 0 0 {name=RZ2
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 780 100 0 0 {name=p20 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 800 160 0 0 {name=RZ3
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 780 160 0 0 {name=p21 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 800 220 0 0 {name=RZ4
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 780 220 0 0 {name=p22 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 800 280 0 0 {name=RZ5
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 780 280 0 0 {name=p23 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 800 340 0 0 {name=RZ6
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 780 340 0 0 {name=p24 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 800 10 0 0 {name=p25 sig_type=std_logic lab=x1}
C {lab_pin.sym} 800 370 0 0 {name=p26 sig_type=std_logic lab=cz}
C {sky130_fd_pr/cap_mim_m3_1.sym} 1070 140 0 0 {name=CC model=cap_mim_m3_1 W=25 L=25 MF=8 spiceprefix=X}
C {lab_pin.sym} 1070 110 0 0 {name=p27 sig_type=std_logic lab=cz}
C {lab_pin.sym} 1070 170 0 0 {name=p28 sig_type=std_logic lab=OUT}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -170 540 0 0 {name=DP
W=25
L=6
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
C {lab_pin.sym} -150 540 0 1 {name=p29 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -150 510 2 0 {name=p30 sig_type=std_logic lab=tail}
C {lab_pin.sym} -150 570 2 0 {name=p31 sig_type=std_logic lab=tail}
C {lab_pin.sym} -190 540 0 0 {name=p32 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/nfet_01v8.sym} 100 540 0 0 {name=DNA
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
C {lab_pin.sym} 120 540 0 1 {name=p33 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 120 570 0 1 {name=p34 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 80 540 0 0 {name=p35 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 120 510 0 0 {name=p36 sig_type=std_logic lab=d1}
C {sky130_fd_pr/nfet_01v8.sym} 420 540 0 0 {name=DNB
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
C {lab_pin.sym} 440 540 0 1 {name=DNB1 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 440 570 0 1 {name=DNB2 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 400 540 0 0 {name=DNB3 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 440 510 0 0 {name=DNB4 sig_type=std_logic lab=x1}
C {sky130_fd_pr/pfet_01v8.sym} -180 680 0 0 {name=DB
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
C {lab_pin.sym} -160 680 0 1 {name=p37 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -160 650 0 1 {name=p38 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -160 710 0 1 {name=p39 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -200 680 0 0 {name=p40 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/res_high_po_1p41.sym} 620 540 0 0 {name=RD1
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 620 510 0 1 {name=p41 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 620 570 0 1 {name=p42 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 600 540 0 0 {name=p43 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 620 660 0 0 {name=RD2
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 620 630 0 1 {name=p44 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 620 690 0 1 {name=p45 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 600 660 0 0 {name=p46 sig_type=std_logic lab=VGND}
