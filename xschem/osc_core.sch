v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {osc_core: M6 relaxation oscillator core (spec M6, section 8 of results_m6).
I_ch from bgr's ich pin charges C_osc on vcap; cmp2s fires when vcap crosses vthr; oneshot closes the reset switch for about 11 ns.
thrmux puts vref (thr_sel = 0) or veb3 (thr_sel = 1) on vthr. ib_cmp1 / ib_cmp2 are bgr's MNB3 / MNB4 sinks (bias option A).
C_osc = 4 x cap_mim_m3_1 25 x 25 um (5.06 pF); top plate (capm / met4) on vcap, bottom plate (met3) on VGND.} -250 -380 0 0 0.3 0.3 {}
N -250 -40 -150 -40 {lab=vref}
N -250 -20 -150 -20 {lab=veb3}
N -250 20 -150 20 {lab=thr_sel}
N -250 40 -150 40 {lab=thr_selb}
N 150 -40 250 -40 {lab=vthr}
N 250 -40 250 0 {lab=vthr}
N 250 0 350 0 {lab=vthr}
N 250 60 350 60 {lab=ib_cmp1}
N 250 80 350 80 {lab=ib_cmp2}
N 650 40 750 40 {lab=cmp_raw}
N 750 40 850 40 {lab=cmp_raw}
N 750 40 750 -20 {lab=cmp_raw}
N 750 60 850 60 {lab=osc_en}
N 750 80 850 80 {lab=osc_enb}
N 1150 40 1200 40 {lab=vcap}
N 1200 40 1200 -150 {lab=vcap}
N 1200 -150 1350 -150 {lab=vcap}
N 1350 -150 1450 -150 {lab=vcap}
N 1200 -150 300 -150 {lab=vcap}
N 300 -150 300 20 {lab=vcap}
N 300 20 350 20 {lab=vcap}
N 1150 60 1250 60 {lab=rst}
C {thrmux.sym} 0 0 0 0 {name=xmux}
C {cmp2s.sym} 500 40 0 0 {name=xcmp}
C {oneshot.sym} 1000 80 0 0 {name=xos}
C {sky130_fd_pr/cap_mim_m3_1.sym} 1350 -120 0 0 {name=Cosc model=cap_mim_m3_1 W=25 L=25 MF=4 spiceprefix=X}
C {ipin.sym} -250 -40 0 0 {name=p1 lab=vref}
C {ipin.sym} -250 -20 0 0 {name=p2 lab=veb3}
C {ipin.sym} -250 20 0 0 {name=p3 lab=thr_sel}
C {ipin.sym} -250 40 0 0 {name=p4 lab=thr_selb}
C {lab_pin.sym} 250 -40 0 0 {name=l5 sig_type=std_logic lab=vthr}
C {iopin.sym} 250 60 0 1 {name=p6 lab=ib_cmp1}
C {iopin.sym} 250 80 0 1 {name=p7 lab=ib_cmp2}
C {opin.sym} 750 -20 0 0 {name=p8 lab=cmp_raw}
C {ipin.sym} 750 60 0 0 {name=p9 lab=osc_en}
C {ipin.sym} 750 80 0 0 {name=p10 lab=osc_enb}
C {lab_pin.sym} 1200 -150 0 0 {name=l11 sig_type=std_logic lab=vcap}
C {iopin.sym} 1450 -150 0 0 {name=p12 lab=vcap}
C {lab_pin.sym} 1350 -90 0 0 {name=l13 sig_type=std_logic lab=VGND}
C {opin.sym} 1250 60 0 0 {name=p14 lab=rst}
C {lab_pin.sym} 150 20 0 1 {name=l15 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 40 0 1 {name=l16 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 650 0 0 1 {name=l17 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 650 80 0 1 {name=l18 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 1150 100 0 1 {name=l19 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1150 120 0 1 {name=l20 sig_type=std_logic lab=VGND}
C {iopin.sym} -250 -200 0 1 {name=p21 lab=VDPWR}
C {iopin.sym} -250 -240 0 1 {name=p22 lab=VGND}
