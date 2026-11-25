v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -100 200 -100 300 {lab=d1}
N -100 460 -100 500 {lab=VGND}
N -180 500 250 500 {lab=VGND}
N 350 460 350 500 {lab=VGND}
N 350 200 350 300 {lab=x1}
N -60 430 150 430 {lab=g12}
N -100 350 40 350 {lab=d1}
N -100 100 -100 140 {lab=tail}
N -100 100 190 100 {lab=tail}
N 350 100 350 140 {lab=tail}
N 10 50 10 100 {lab=tail}
N -240 20 -30 20 {lab=IBIAS}
N -280 50 -280 80 {lab=IBIAS}
N -280 80 -180 80 {lab=IBIAS}
N -180 20 -180 80 {lab=IBIAS}
N -370 -60 150 -60 {lab=VDPWR}
N -280 -60 -280 -10 {lab=VDPWR}
N 10 -60 10 -10 {lab=VDPWR}
N -190 170 -140 170 {lab=INN}
N 270 170 310 170 {lab=INP}
N 600 0 600 250 {lab=OUT}
N 600 170 700 170 {lab=OUT}
N 310 -60 600 -60 {lab=VDPWR}
N 410 500 600 500 {lab=VGND}
N 600 410 600 500 {lab=VGND}
N 150 -60 310 -60 {lab=VDPWR}
N 190 100 350 100 {lab=tail}
N 150 430 310 430 {lab=g12}
N 250 500 410 500 {lab=VGND}
N 50 350 50 370 {lab=d1}
N 40 350 50 350 {lab=d1}
N -100 300 -100 400 {lab=d1}
N 350 300 350 400 {lab=x1}
N 600 250 600 350 {lab=OUT}
N 50 280 490 280 {lab=d1}
N 50 280 50 350 {lab=d1}
N 490 220 560 220 {lab=g3}
N 560 220 560 380 {lab=g3}
N 560 380 560 480 {lab=g3}
N 490 480 560 480 {lab=g3}
N 490 350 490 420 {lab=x1}
N 350 350 490 350 {lab=x1}
N 250 350 250 370 {lab=x1}
N 250 350 350 350 {lab=x1}
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
C {sky130_fd_pr/pfet_01v8_lvt.sym} 330 170 0 0 {name=MP2
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
C {sky130_fd_pr/nfet_01v8.sym} -80 430 0 1 {name=MN1
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
C {sky130_fd_pr/nfet_01v8.sym} 330 430 0 0 {name=MN2
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
C {ipin.sym} 270 170 0 0 {name=p2 lab=INP}
C {ipin.sym} -280 80 0 0 {name=p3 lab=IBIAS}
C {opin.sym} 700 170 0 0 {name=p4 lab=OUT}
C {iopin.sym} -370 -60 0 1 {name=p5 lab=VDPWR}
C {iopin.sym} -180 500 0 1 {name=p6 lab=VGND}
C {lab_pin.sym} -100 350 0 0 {name=p7 sig_type=std_logic lab=d1}
C {lab_pin.sym} 10 100 3 0 {name=p8 sig_type=std_logic lab=tail}
C {lab_pin.sym} -280 20 0 0 {name=p9 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 10 20 0 1 {name=p10 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -100 170 0 1 {name=p11 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 350 170 0 1 {name=p12 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 350 430 0 1 {name=p13 sig_type=std_logic lab=VGND}
C {lab_pin.sym} -100 430 0 0 {name=p14 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 350 350 0 0 {name=p15 sig_type=std_logic lab=x1}
C {sky130_fd_pr/pfet_01v8.sym} 580 -30 0 0 {name=MP3
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
C {sky130_fd_pr/nfet_01v8.sym} 580 380 0 0 {name=MN3
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
C {lab_pin.sym} 600 -30 0 1 {name=p17 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 600 380 0 1 {name=p18 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 560 -30 0 0 {name=p16 sig_type=std_logic lab=IBIAS}
C {sky130_fd_pr/res_high_po_1p41.sym} 910 40 0 0 {name=RZ1
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 890 40 0 0 {name=p19 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 910 100 0 0 {name=RZ2
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 890 100 0 0 {name=p20 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 910 160 0 0 {name=RZ3
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 890 160 0 0 {name=p21 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 910 220 0 0 {name=RZ4
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 890 220 0 0 {name=p22 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 910 280 0 0 {name=RZ5
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 890 280 0 0 {name=p23 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 910 340 0 0 {name=RZ6
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 890 340 0 0 {name=p24 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 910 10 0 0 {name=p25 sig_type=std_logic lab=g3
}
C {lab_pin.sym} 910 370 0 0 {name=p26 sig_type=std_logic lab=cz}
C {sky130_fd_pr/cap_mim_m3_1.sym} 1180 140 0 0 {name=CC model=cap_mim_m3_1 W=25 L=25 MF=8 spiceprefix=X}
C {lab_pin.sym} 1180 110 0 0 {name=p27 sig_type=std_logic lab=cz}
C {lab_pin.sym} 1180 170 0 0 {name=p28 sig_type=std_logic lab=OUT}
C {sky130_fd_pr/pfet_01v8_lvt.sym} -190 730 0 0 {name=DP
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
C {lab_pin.sym} -170 730 0 1 {name=p29 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -170 700 2 0 {name=p30 sig_type=std_logic lab=tail}
C {lab_pin.sym} -170 760 2 0 {name=p31 sig_type=std_logic lab=tail}
C {lab_pin.sym} -210 730 0 0 {name=p32 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/nfet_01v8.sym} 80 730 0 0 {name=DNA
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
C {lab_pin.sym} 100 730 0 1 {name=p33 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 100 760 0 1 {name=p34 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 60 730 0 0 {name=p35 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 100 700 0 0 {name=p36 sig_type=std_logic lab=d1}
C {sky130_fd_pr/nfet_01v8.sym} 400 730 0 0 {name=DNB
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
C {lab_pin.sym} 420 730 0 1 {name=DNB1 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 420 760 0 1 {name=DNB2 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 380 730 0 0 {name=DNB3 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 420 700 0 0 {name=DNB4 sig_type=std_logic lab=x1}
C {sky130_fd_pr/pfet_01v8.sym} -200 870 0 0 {name=DB
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
C {lab_pin.sym} -180 870 0 1 {name=p37 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -180 840 0 1 {name=p38 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -180 900 0 1 {name=p39 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -220 870 0 0 {name=p40 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/res_high_po_1p41.sym} 600 730 0 0 {name=RD1
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 600 700 0 1 {name=p41 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 600 760 0 1 {name=p42 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 580 730 0 0 {name=p43 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/res_high_po_1p41.sym} 600 850 0 0 {name=RD2
L=20
model=res_high_po_1p41
spiceprefix=X
mult=1}
C {lab_pin.sym} 600 820 0 1 {name=p44 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 600 880 0 1 {name=p45 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 580 850 0 0 {name=p46 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 560 380 0 0 {name=p48 sig_type=std_logic lab=g3}
C {sky130_fd_pr/nfet_01v8.sym} 30 400 0 0 {name=SD1
W=6
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
C {sky130_fd_pr/nfet_01v8.sym} 230 400 0 0 {name=SD2
W=6
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
C {sky130_fd_pr/nfet_01v8.sym} 470 250 0 0 {name=SG2
W=6
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
C {lab_pin.sym} 250 400 0 1 {name=p47 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 50 400 0 1 {name=p49 sig_type=std_logic lab=VGND}
C {sky130_fd_pr/nfet_01v8.sym} 470 450 0 0 {name=SG1
W=6
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
C {lab_pin.sym} 490 250 0 1 {name=p50 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 490 450 0 1 {name=p51 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 450 250 0 0 {name=p55 sig_type=std_logic lab=CHOP}
C {lab_pin.sym} 450 450 0 0 {name=p56 sig_type=std_logic lab=CHOPB}
C {lab_pin.sym} 50 430 3 0 {name=p57 sig_type=std_logic lab=g12}
C {ipin.sym} 10 400 0 0 {name=p58 lab=CHOPB}
C {ipin.sym} 210 400 0 0 {name=p54 lab=CHOP}
