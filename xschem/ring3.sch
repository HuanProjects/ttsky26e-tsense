v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ring3: the three rings on one enable (spec M7 step 1). ring_n -> uo1 (ringn_out), ring_p -> uo3 (ringp_out),
ring_d -> uo6 (ring_out). ring_en comes from readout_glue (buf_1 on ui_in[6]).} -400 -320 0 0 0.3 0.3 {}
C {ring_n.sym} 0 0 0 0 {name=xn}
C {lab_pin.sym} -150 20 0 0 {name=l1 sig_type=std_logic lab=ring_en}
C {lab_pin.sym} 150 20 0 1 {name=l2 sig_type=std_logic lab=uo1}
C {lab_pin.sym} 150 40 0 1 {name=l3 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 60 0 1 {name=l4 sig_type=std_logic lab=VGND}
C {ring_p.sym} 0 200 0 0 {name=xp}
C {lab_pin.sym} -150 220 0 0 {name=l5 sig_type=std_logic lab=ring_en}
C {lab_pin.sym} 150 220 0 1 {name=l6 sig_type=std_logic lab=uo3}
C {lab_pin.sym} 150 240 0 1 {name=l7 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 260 0 1 {name=l8 sig_type=std_logic lab=VGND}
C {ring_d.sym} 0 400 0 0 {name=xd}
C {lab_pin.sym} -150 420 0 0 {name=l9 sig_type=std_logic lab=ring_en}
C {lab_pin.sym} 150 420 0 1 {name=l10 sig_type=std_logic lab=uo6}
C {lab_pin.sym} 150 440 0 1 {name=l11 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 460 0 1 {name=l12 sig_type=std_logic lab=VGND}
C {ipin.sym} -400 -200 0 0 {name=pi_ring_en lab=ring_en}
C {opin.sym} 1400 -200 0 0 {name=po_uo1 lab=uo1}
C {opin.sym} 1400 -170 0 0 {name=po_uo3 lab=uo3}
C {opin.sym} 1400 -140 0 0 {name=po_uo6 lab=uo6}
C {iopin.sym} 1400 -110 0 0 {name=pp_VDPWR lab=VDPWR}
C {iopin.sym} 1400 -80 0 0 {name=pp_VGND lab=VGND}
