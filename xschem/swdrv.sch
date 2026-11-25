v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {swdrv: switch phases for bgr (spec M6 R2 / R17, M7 step 1). Each select line: inv_1 + cross-coupled nor2_1 pair
(on and dump break before make) + inv_1 for the PMOS gate. chop_sel: nor2_1 pair -> swa / swb (break before make) and
nand2_1 pair -> chop / chopb (make before break). Nets are joined by label.} -300 -300 0 0 0.3 0.3 {}
C {sky130_stdcells/inv_1.sym} 0 0 0 0 {name=xichi VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 0 0 0 {name=l1 sig_type=std_logic lab=ich_sel}
C {lab_pin.sym} 40 0 0 1 {name=l2 sig_type=std_logic lab=ich_selb}
C {sky130_stdcells/nor2_1.sym} 200 -40 0 0 {name=xichn1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 -60 0 0 {name=l3 sig_type=std_logic lab=ich_sel}
C {lab_pin.sym} 140 -20 0 0 {name=l4 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} 260 -40 0 1 {name=l5 sig_type=std_logic lab=ich_on}
C {sky130_stdcells/nor2_1.sym} 200 40 0 0 {name=xichn2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 20 0 0 {name=l6 sig_type=std_logic lab=ich_selb}
C {lab_pin.sym} 140 60 0 0 {name=l7 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 260 40 0 1 {name=l8 sig_type=std_logic lab=ich_dump}
C {sky130_stdcells/inv_1.sym} 400 -40 0 0 {name=xichib VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 360 -40 0 0 {name=l9 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 440 -40 0 1 {name=l10 sig_type=std_logic lab=ich_onb}
C {sky130_stdcells/inv_1.sym} 0 200 0 0 {name=xi3i VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 200 0 0 {name=l11 sig_type=std_logic lab=i3_sel}
C {lab_pin.sym} 40 200 0 1 {name=l12 sig_type=std_logic lab=i3_selb}
C {sky130_stdcells/nor2_1.sym} 200 160 0 0 {name=xi3n1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 140 0 0 {name=l13 sig_type=std_logic lab=i3_sel}
C {lab_pin.sym} 140 180 0 0 {name=l14 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} 260 160 0 1 {name=l15 sig_type=std_logic lab=i3_on}
C {sky130_stdcells/nor2_1.sym} 200 240 0 0 {name=xi3n2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 220 0 0 {name=l16 sig_type=std_logic lab=i3_selb}
C {lab_pin.sym} 140 260 0 0 {name=l17 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} 260 240 0 1 {name=l18 sig_type=std_logic lab=i3_dump}
C {sky130_stdcells/inv_1.sym} 400 160 0 0 {name=xi3ib VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 360 160 0 0 {name=l19 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} 440 160 0 1 {name=l20 sig_type=std_logic lab=i3_onb}
C {sky130_stdcells/inv_1.sym} 0 400 0 0 {name=xci VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 400 0 0 {name=l21 sig_type=std_logic lab=chop_sel}
C {lab_pin.sym} 40 400 0 1 {name=l22 sig_type=std_logic lab=chop_selb}
C {sky130_stdcells/nor2_1.sym} 200 360 0 0 {name=xcn1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 340 0 0 {name=l23 sig_type=std_logic lab=chop_sel}
C {lab_pin.sym} 140 380 0 0 {name=l24 sig_type=std_logic lab=swb}
C {lab_pin.sym} 260 360 0 1 {name=l25 sig_type=std_logic lab=swa}
C {sky130_stdcells/nor2_1.sym} 200 440 0 0 {name=xcn2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 420 0 0 {name=l26 sig_type=std_logic lab=chop_selb}
C {lab_pin.sym} 140 460 0 0 {name=l27 sig_type=std_logic lab=swa}
C {lab_pin.sym} 260 440 0 1 {name=l28 sig_type=std_logic lab=swb}
C {sky130_stdcells/nand2_1.sym} 200 560 0 0 {name=xca1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 540 0 0 {name=l29 sig_type=std_logic lab=chop_sel}
C {lab_pin.sym} 140 580 0 0 {name=l30 sig_type=std_logic lab=chop}
C {lab_pin.sym} 260 560 0 1 {name=l31 sig_type=std_logic lab=chopb}
C {sky130_stdcells/nand2_1.sym} 200 640 0 0 {name=xca2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 620 0 0 {name=l32 sig_type=std_logic lab=chop_selb}
C {lab_pin.sym} 140 660 0 0 {name=l33 sig_type=std_logic lab=chopb}
C {lab_pin.sym} 260 640 0 1 {name=l34 sig_type=std_logic lab=chop}
C {ipin.sym} -300 -100 0 0 {name=p1 lab=ich_sel}
C {ipin.sym} -300 -70 0 0 {name=p2 lab=i3_sel}
C {ipin.sym} -300 -40 0 0 {name=p3 lab=chop_sel}
C {opin.sym} 600 -100 0 0 {name=p10 lab=ich_on}
C {opin.sym} 600 -70 0 0 {name=p11 lab=ich_onb}
C {opin.sym} 600 -40 0 0 {name=p12 lab=ich_dump}
C {opin.sym} 600 -10 0 0 {name=p13 lab=i3_on}
C {opin.sym} 600 20 0 0 {name=p14 lab=i3_onb}
C {opin.sym} 600 50 0 0 {name=p15 lab=i3_dump}
C {opin.sym} 600 80 0 0 {name=p16 lab=swa}
C {opin.sym} 600 110 0 0 {name=p17 lab=swb}
C {opin.sym} 600 140 0 0 {name=p18 lab=chop}
C {opin.sym} 600 170 0 0 {name=p19 lab=chopb}
C {iopin.sym} 600 200 0 0 {name=p20 lab=VDPWR}
C {iopin.sym} 600 230 0 0 {name=p21 lab=VGND}
