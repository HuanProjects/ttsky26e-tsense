v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ring_d: delay-gate ring (spec D5, R7). nand2_1 (A = en, B = the loop) -> 15 x dlygate4sd3_1 -> back to B.
Divide by 16 (4 x dfrtp_1) -> buf_2 -> out. Nets joined by label.} -400 -320 0 0 0.3 0.3 {}
C {sky130_stdcells/nand2_1.sym} 0 0 0 0 {name=xg0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -60 -20 0 0 {name=l1 sig_type=std_logic lab=en}
C {lab_pin.sym} -60 20 0 0 {name=l2 sig_type=std_logic lab=r15}
C {lab_pin.sym} 60 0 0 1 {name=l3 sig_type=std_logic lab=r0}
C {sky130_stdcells/dlygate4sd3_1.sym} 200 120 0 0 {name=xd1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 160 120 0 0 {name=l4 sig_type=std_logic lab=r0}
C {lab_pin.sym} 240 120 0 1 {name=l5 sig_type=std_logic lab=r1}
C {sky130_stdcells/dlygate4sd3_1.sym} 400 120 0 0 {name=xd2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 360 120 0 0 {name=l6 sig_type=std_logic lab=r1}
C {lab_pin.sym} 440 120 0 1 {name=l7 sig_type=std_logic lab=r2}
C {sky130_stdcells/dlygate4sd3_1.sym} 600 120 0 0 {name=xd3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 560 120 0 0 {name=l8 sig_type=std_logic lab=r2}
C {lab_pin.sym} 640 120 0 1 {name=l9 sig_type=std_logic lab=r3}
C {sky130_stdcells/dlygate4sd3_1.sym} 800 120 0 0 {name=xd4 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 760 120 0 0 {name=l10 sig_type=std_logic lab=r3}
C {lab_pin.sym} 840 120 0 1 {name=l11 sig_type=std_logic lab=r4}
C {sky130_stdcells/dlygate4sd3_1.sym} 1000 120 0 0 {name=xd5 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 960 120 0 0 {name=l12 sig_type=std_logic lab=r4}
C {lab_pin.sym} 1040 120 0 1 {name=l13 sig_type=std_logic lab=r5}
C {sky130_stdcells/dlygate4sd3_1.sym} 1200 120 0 0 {name=xd6 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1160 120 0 0 {name=l14 sig_type=std_logic lab=r5}
C {lab_pin.sym} 1240 120 0 1 {name=l15 sig_type=std_logic lab=r6}
C {sky130_stdcells/dlygate4sd3_1.sym} 1400 120 0 0 {name=xd7 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1360 120 0 0 {name=l16 sig_type=std_logic lab=r6}
C {lab_pin.sym} 1440 120 0 1 {name=l17 sig_type=std_logic lab=r7}
C {sky130_stdcells/dlygate4sd3_1.sym} 0 240 0 0 {name=xd8 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 240 0 0 {name=l18 sig_type=std_logic lab=r7}
C {lab_pin.sym} 40 240 0 1 {name=l19 sig_type=std_logic lab=r8}
C {sky130_stdcells/dlygate4sd3_1.sym} 200 240 0 0 {name=xd9 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 160 240 0 0 {name=l20 sig_type=std_logic lab=r8}
C {lab_pin.sym} 240 240 0 1 {name=l21 sig_type=std_logic lab=r9}
C {sky130_stdcells/dlygate4sd3_1.sym} 400 240 0 0 {name=xd10 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 360 240 0 0 {name=l22 sig_type=std_logic lab=r9}
C {lab_pin.sym} 440 240 0 1 {name=l23 sig_type=std_logic lab=r10}
C {sky130_stdcells/dlygate4sd3_1.sym} 600 240 0 0 {name=xd11 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 560 240 0 0 {name=l24 sig_type=std_logic lab=r10}
C {lab_pin.sym} 640 240 0 1 {name=l25 sig_type=std_logic lab=r11}
C {sky130_stdcells/dlygate4sd3_1.sym} 800 240 0 0 {name=xd12 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 760 240 0 0 {name=l26 sig_type=std_logic lab=r11}
C {lab_pin.sym} 840 240 0 1 {name=l27 sig_type=std_logic lab=r12}
C {sky130_stdcells/dlygate4sd3_1.sym} 1000 240 0 0 {name=xd13 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 960 240 0 0 {name=l28 sig_type=std_logic lab=r12}
C {lab_pin.sym} 1040 240 0 1 {name=l29 sig_type=std_logic lab=r13}
C {sky130_stdcells/dlygate4sd3_1.sym} 1200 240 0 0 {name=xd14 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1160 240 0 0 {name=l30 sig_type=std_logic lab=r13}
C {lab_pin.sym} 1240 240 0 1 {name=l31 sig_type=std_logic lab=r14}
C {sky130_stdcells/dlygate4sd3_1.sym} 1400 240 0 0 {name=xd15 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1360 240 0 0 {name=l32 sig_type=std_logic lab=r14}
C {lab_pin.sym} 1440 240 0 1 {name=l33 sig_type=std_logic lab=r15}
C {sky130_stdcells/dfrtp_1.sym} 0 600 0 0 {name=xf0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -90 580 0 0 {name=l34 sig_type=std_logic lab=r0}
C {lab_pin.sym} -90 600 0 0 {name=l35 sig_type=std_logic lab=qb0}
C {lab_pin.sym} -90 620 0 0 {name=l36 sig_type=std_logic lab=en}
C {lab_pin.sym} 90 580 0 1 {name=l37 sig_type=std_logic lab=q0}
C {sky130_stdcells/inv_1.sym} 150 660 0 0 {name=xqi0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 110 660 0 0 {name=l38 sig_type=std_logic lab=q0}
C {lab_pin.sym} 190 660 0 1 {name=l39 sig_type=std_logic lab=qb0}
C {sky130_stdcells/dfrtp_1.sym} 300 600 0 0 {name=xf1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 210 580 0 0 {name=l40 sig_type=std_logic lab=q0}
C {lab_pin.sym} 210 600 0 0 {name=l41 sig_type=std_logic lab=qb1}
C {lab_pin.sym} 210 620 0 0 {name=l42 sig_type=std_logic lab=en}
C {lab_pin.sym} 390 580 0 1 {name=l43 sig_type=std_logic lab=q1}
C {sky130_stdcells/inv_1.sym} 450 660 0 0 {name=xqi1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 410 660 0 0 {name=l44 sig_type=std_logic lab=q1}
C {lab_pin.sym} 490 660 0 1 {name=l45 sig_type=std_logic lab=qb1}
C {sky130_stdcells/dfrtp_1.sym} 600 600 0 0 {name=xf2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 510 580 0 0 {name=l46 sig_type=std_logic lab=q1}
C {lab_pin.sym} 510 600 0 0 {name=l47 sig_type=std_logic lab=qb2}
C {lab_pin.sym} 510 620 0 0 {name=l48 sig_type=std_logic lab=en}
C {lab_pin.sym} 690 580 0 1 {name=l49 sig_type=std_logic lab=q2}
C {sky130_stdcells/inv_1.sym} 750 660 0 0 {name=xqi2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 710 660 0 0 {name=l50 sig_type=std_logic lab=q2}
C {lab_pin.sym} 790 660 0 1 {name=l51 sig_type=std_logic lab=qb2}
C {sky130_stdcells/dfrtp_1.sym} 900 600 0 0 {name=xf3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 810 580 0 0 {name=l52 sig_type=std_logic lab=q2}
C {lab_pin.sym} 810 600 0 0 {name=l53 sig_type=std_logic lab=qb3}
C {lab_pin.sym} 810 620 0 0 {name=l54 sig_type=std_logic lab=en}
C {lab_pin.sym} 990 580 0 1 {name=l55 sig_type=std_logic lab=q3}
C {sky130_stdcells/inv_1.sym} 1050 660 0 0 {name=xqi3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1010 660 0 0 {name=l56 sig_type=std_logic lab=q3}
C {lab_pin.sym} 1090 660 0 1 {name=l57 sig_type=std_logic lab=qb3}
C {sky130_stdcells/buf_2.sym} 1200 600 0 0 {name=xbo VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1160 600 0 0 {name=l58 sig_type=std_logic lab=q3}
C {lab_pin.sym} 1240 600 0 1 {name=l59 sig_type=std_logic lab=out}
C {ipin.sym} -400 -200 0 0 {name=pi_en lab=en}
C {opin.sym} 1400 -200 0 0 {name=po_out lab=out}
C {iopin.sym} 1400 -170 0 0 {name=pp_VDPWR lab=VDPWR}
C {iopin.sym} 1400 -140 0 0 {name=pp_VGND lab=VGND}
