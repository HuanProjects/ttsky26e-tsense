v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {thrmux: M6 threshold mux (spec M6 step 6, R3, R17). thr_sel = 0 puts vref on vthr, thr_sel = 1 puts veb3.
Two transmission gates of lvt devices (nfet_01v8_lvt 2/0.5 + pfet_01v8_lvt 4/0.5): the standard-Vth pair has a dead zone near 1.0 V.
Break-before-make: cross-coupled NOR2 (xn1, xn2), so one gate's enable rises only after the other's has fallen; xi1, xi2 drive the PMOS gates.
The seb wire crosses the sref wire at (20, 40) without a dot: not connected.} -20 -380 0 0 0.3 0.3 {}
N -20 -80 40 -80 {lab=thr_sel}
N -20 120 40 120 {lab=thr_selb}
N 160 -60 180 -60 {lab=sref}
N 180 -60 200 -60 {lab=sref}
N 180 -60 180 20 {lab=sref}
N 180 20 20 20 {lab=sref}
N 20 20 20 80 {lab=sref}
N 20 80 40 80 {lab=sref}
N 200 -60 200 -100 {lab=sref}
N 200 -100 200 -180 {lab=sref}
N 200 -100 300 -100 {lab=sref}
N 300 -100 420 -100 {lab=sref}
N 200 -180 720 -180 {lab=sref}
N 720 -180 720 -100 {lab=sref}
N 720 -100 680 -100 {lab=sref}
N 600 -100 580 -100 {lab=srefb}
N 160 100 170 100 {lab=seb}
N 170 100 200 100 {lab=seb}
N 170 100 170 40 {lab=seb}
N 170 40 0 40 {lab=seb}
N 0 40 0 -40 {lab=seb}
N 0 -40 40 -40 {lab=seb}
N 200 100 300 100 {lab=seb}
N 300 100 420 100 {lab=seb}
N 200 100 200 200 {lab=seb}
N 200 200 720 200 {lab=seb}
N 720 200 720 100 {lab=seb}
N 720 100 680 100 {lab=seb}
N 600 100 580 100 {lab=sebb}
N 380 -130 460 -130 {lab=vref}
N 460 -130 540 -130 {lab=vref}
N 460 -70 500 -70 {lab=vthr}
N 500 -70 540 -70 {lab=vthr}
N 500 -70 500 20 {lab=vthr}
N 500 20 500 70 {lab=vthr}
N 500 20 620 20 {lab=vthr}
N 460 70 500 70 {lab=vthr}
N 500 70 540 70 {lab=vthr}
N 380 130 460 130 {lab=veb3}
N 460 130 540 130 {lab=veb3}
C {sky130_stdcells/nor2_1.sym} 100 -60 0 0 {name=xn1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/nor2_1.sym} 100 100 0 0 {name=xn2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 640 -100 2 0 {name=xi1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 640 100 2 0 {name=xi2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {sky130_fd_pr/nfet_01v8_lvt.sym} 440 -100 0 0 {name=MTN1
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
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 560 -100 0 1 {name=MTP1
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
model=pfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8_lvt.sym} 440 100 0 0 {name=MTN2
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
model=nfet_01v8_lvt
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8_lvt.sym} 560 100 0 1 {name=MTP2
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
model=pfet_01v8_lvt
spiceprefix=X
}
C {ipin.sym} -20 -80 0 0 {name=p1 lab=thr_sel}
C {ipin.sym} -20 120 0 0 {name=p2 lab=thr_selb}
C {ipin.sym} 380 -130 0 0 {name=p3 lab=vref}
C {ipin.sym} 380 130 0 0 {name=p4 lab=veb3}
C {iopin.sym} 620 20 0 0 {name=p5 lab=vthr}
C {iopin.sym} -20 -200 0 1 {name=p6 lab=VDPWR}
C {iopin.sym} -20 -240 0 1 {name=p7 lab=VGND}
C {lab_pin.sym} 460 -100 0 1 {name=l1 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 540 -100 0 0 {name=l2 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 460 100 0 1 {name=l3 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 540 100 0 0 {name=l4 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 300 -100 3 0 {name=l10 sig_type=std_logic lab=sref}
C {lab_pin.sym} 600 -100 3 0 {name=l11 sig_type=std_logic lab=srefb}
C {lab_pin.sym} 300 100 3 0 {name=l12 sig_type=std_logic lab=seb}
C {lab_pin.sym} 600 100 3 0 {name=l13 sig_type=std_logic lab=sebb}
