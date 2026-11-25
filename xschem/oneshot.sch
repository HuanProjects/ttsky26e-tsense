v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {oneshot: M6 self-timed one-shot (spec M6 step 5) and reset switch (step 4).
The cmp_raw rising edge (through buf_2) clocks the flop with D = 1, so rst = Q goes high. dly5 makes db = NOT rst, about 10 ns late;
rb = osc_en AND db clears the flop, so the rst width is the delay line's, whatever the cmp_raw width.
swp = rst OR osc_enb (osc disabled -> switch held on). Last driver MDP 2/0.15 (fast rise) / MDN 0.42/1.5 (slow fall) drives sw,
the gate of MRST (nfet_01v8 6/0.5 x2 = 12/0.5 in two fingers), which empties C_osc on vcap.} -80 -380 0 0 0.3 0.3 {}
N -80 0 -40 0 {lab=cmp_raw}
N 40 0 75 0 {lab=ck}
N 75 0 110 0 {lab=ck}
N 290 0 330 0 {lab=rst}
N 330 -160 330 -120 {lab=rst}
N 330 -120 330 0 {lab=rst}
N 330 0 330 160 {lab=rst}
N 330 -120 420 -120 {lab=rst}
N 400 -80 420 -80 {lab=osc_enb}
N 540 -100 560 -100 {lab=swp}
N 560 -100 580 -100 {lab=swp}
N 660 -100 690 -100 {lab=swn}
N 690 -100 720 -100 {lab=swn}
N 720 -150 720 -100 {lab=swn}
N 720 -100 720 -50 {lab=swn}
N 720 -150 740 -150 {lab=swn}
N 720 -50 740 -50 {lab=swn}
N 780 -120 780 -100 {lab=sw}
N 780 -100 780 -80 {lab=sw}
N 780 -100 820 -100 {lab=sw}
N 820 -100 860 -100 {lab=sw}
N 900 -130 900 -160 {lab=vcap}
N 330 160 410 160 {lab=rst}
N 590 160 625 160 {lab=db}
N 625 160 660 160 {lab=db}
N 620 240 640 240 {lab=osc_en}
N 640 240 640 200 {lab=osc_en}
N 640 200 660 200 {lab=osc_en}
N 780 180 800 180 {lab=rb}
N 800 180 800 280 {lab=rb}
N 800 280 80 280 {lab=rb}
N 80 280 80 40 {lab=rb}
N 80 40 110 40 {lab=rb}
C {sky130_stdcells/buf_2.sym} 0 0 0 0 {name=xbck VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/dfrtp_1.sym} 200 20 0 0 {name=xff VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/or2_1.sym} 480 -100 0 0 {name=xor VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/inv_1.sym} 620 -100 0 0 {name=xi1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {sky130_stdcells/and2_1.sym} 720 180 0 0 {name=xand VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {dly5.sym} 500 160 0 0 {name=xdl}
C {sky130_fd_pr/pfet_01v8.sym} 760 -150 0 0 {name=MDP
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
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 760 -50 0 0 {name=MDN
W=0.42
L=1.5
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
C {sky130_fd_pr/nfet_01v8.sym} 880 -100 0 0 {name=MRST
W=6
L=0.5
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
C {ipin.sym} -80 0 0 0 {name=p1 lab=cmp_raw}
C {ipin.sym} 400 -80 0 0 {name=p2 lab=osc_enb}
C {ipin.sym} 620 240 0 0 {name=p3 lab=osc_en}
C {iopin.sym} 900 -160 3 0 {name=p4 lab=vcap}
C {opin.sym} 330 -160 3 0 {name=p5 lab=rst}
C {iopin.sym} -80 -200 0 1 {name=p6 lab=VDPWR}
C {iopin.sym} -80 -240 0 1 {name=p7 lab=VGND}
C {lab_pin.sym} 110 20 0 0 {name=l1 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 780 -180 0 1 {name=l2 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 780 -150 0 1 {name=l3 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 780 -50 0 1 {name=l4 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 780 -20 0 1 {name=l5 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 900 -70 0 1 {name=l6 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 900 -100 0 1 {name=l7 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 500 100 3 0 {name=l8 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 500 220 1 0 {name=l9 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 75 0 3 0 {name=l10 sig_type=std_logic lab=ck}
C {lab_pin.sym} 560 -100 3 0 {name=l11 sig_type=std_logic lab=swp}
C {lab_pin.sym} 690 -100 3 0 {name=l12 sig_type=std_logic lab=swn}
C {lab_pin.sym} 820 -100 3 0 {name=l13 sig_type=std_logic lab=sw}
C {lab_pin.sym} 625 160 3 0 {name=l14 sig_type=std_logic lab=db}
C {lab_pin.sym} 800 280 0 1 {name=l15 sig_type=std_logic lab=rb}
