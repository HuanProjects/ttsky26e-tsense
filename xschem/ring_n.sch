v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {ring_n: NMOS-weighted corner ring (spec E3, R6). 31 x nand2_1; stage 1 A = en, stages 2-31 A = HI from one conb_1;
B = the loop. Divide by 32 (5 x dfrtp_1, D = not Q, RESET_B = en) -> buf_2 -> out. Nets joined by label.} -400 -320 0 0 0.3 0.3 {}
C {sky130_stdcells/conb_1.sym} -300 0 0 0 {name=xtie VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -240 -20 0 1 {name=l1 sig_type=std_logic lab=hi}
C {lab_pin.sym} -240 20 0 1 {name=l2 sig_type=std_logic lab=tie_lo}
C {sky130_stdcells/nand2_1.sym} 0 0 0 0 {name=xg0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -60 -20 0 0 {name=l3 sig_type=std_logic lab=en}
C {lab_pin.sym} -60 20 0 0 {name=l4 sig_type=std_logic lab=r30}
C {lab_pin.sym} 60 0 0 1 {name=l5 sig_type=std_logic lab=r0}
C {sky130_stdcells/nand2_1.sym} 200 0 0 0 {name=xg1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 -20 0 0 {name=l6 sig_type=std_logic lab=hi}
C {lab_pin.sym} 140 20 0 0 {name=l7 sig_type=std_logic lab=r0}
C {lab_pin.sym} 260 0 0 1 {name=l8 sig_type=std_logic lab=r1}
C {sky130_stdcells/nand2_1.sym} 400 0 0 0 {name=xg2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 340 -20 0 0 {name=l9 sig_type=std_logic lab=hi}
C {lab_pin.sym} 340 20 0 0 {name=l10 sig_type=std_logic lab=r1}
C {lab_pin.sym} 460 0 0 1 {name=l11 sig_type=std_logic lab=r2}
C {sky130_stdcells/nand2_1.sym} 600 0 0 0 {name=xg3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 540 -20 0 0 {name=l12 sig_type=std_logic lab=hi}
C {lab_pin.sym} 540 20 0 0 {name=l13 sig_type=std_logic lab=r2}
C {lab_pin.sym} 660 0 0 1 {name=l14 sig_type=std_logic lab=r3}
C {sky130_stdcells/nand2_1.sym} 800 0 0 0 {name=xg4 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 740 -20 0 0 {name=l15 sig_type=std_logic lab=hi}
C {lab_pin.sym} 740 20 0 0 {name=l16 sig_type=std_logic lab=r3}
C {lab_pin.sym} 860 0 0 1 {name=l17 sig_type=std_logic lab=r4}
C {sky130_stdcells/nand2_1.sym} 1000 0 0 0 {name=xg5 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 940 -20 0 0 {name=l18 sig_type=std_logic lab=hi}
C {lab_pin.sym} 940 20 0 0 {name=l19 sig_type=std_logic lab=r4}
C {lab_pin.sym} 1060 0 0 1 {name=l20 sig_type=std_logic lab=r5}
C {sky130_stdcells/nand2_1.sym} 1200 0 0 0 {name=xg6 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1140 -20 0 0 {name=l21 sig_type=std_logic lab=hi}
C {lab_pin.sym} 1140 20 0 0 {name=l22 sig_type=std_logic lab=r5}
C {lab_pin.sym} 1260 0 0 1 {name=l23 sig_type=std_logic lab=r6}
C {sky130_stdcells/nand2_1.sym} 1400 0 0 0 {name=xg7 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1340 -20 0 0 {name=l24 sig_type=std_logic lab=hi}
C {lab_pin.sym} 1340 20 0 0 {name=l25 sig_type=std_logic lab=r6}
C {lab_pin.sym} 1460 0 0 1 {name=l26 sig_type=std_logic lab=r7}
C {sky130_stdcells/nand2_1.sym} 0 120 0 0 {name=xg8 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -60 100 0 0 {name=l27 sig_type=std_logic lab=hi}
C {lab_pin.sym} -60 140 0 0 {name=l28 sig_type=std_logic lab=r7}
C {lab_pin.sym} 60 120 0 1 {name=l29 sig_type=std_logic lab=r8}
C {sky130_stdcells/nand2_1.sym} 200 120 0 0 {name=xg9 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 100 0 0 {name=l30 sig_type=std_logic lab=hi}
C {lab_pin.sym} 140 140 0 0 {name=l31 sig_type=std_logic lab=r8}
C {lab_pin.sym} 260 120 0 1 {name=l32 sig_type=std_logic lab=r9}
C {sky130_stdcells/nand2_1.sym} 400 120 0 0 {name=xg10 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 340 100 0 0 {name=l33 sig_type=std_logic lab=hi}
C {lab_pin.sym} 340 140 0 0 {name=l34 sig_type=std_logic lab=r9}
C {lab_pin.sym} 460 120 0 1 {name=l35 sig_type=std_logic lab=r10}
C {sky130_stdcells/nand2_1.sym} 600 120 0 0 {name=xg11 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 540 100 0 0 {name=l36 sig_type=std_logic lab=hi}
C {lab_pin.sym} 540 140 0 0 {name=l37 sig_type=std_logic lab=r10}
C {lab_pin.sym} 660 120 0 1 {name=l38 sig_type=std_logic lab=r11}
C {sky130_stdcells/nand2_1.sym} 800 120 0 0 {name=xg12 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 740 100 0 0 {name=l39 sig_type=std_logic lab=hi}
C {lab_pin.sym} 740 140 0 0 {name=l40 sig_type=std_logic lab=r11}
C {lab_pin.sym} 860 120 0 1 {name=l41 sig_type=std_logic lab=r12}
C {sky130_stdcells/nand2_1.sym} 1000 120 0 0 {name=xg13 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 940 100 0 0 {name=l42 sig_type=std_logic lab=hi}
C {lab_pin.sym} 940 140 0 0 {name=l43 sig_type=std_logic lab=r12}
C {lab_pin.sym} 1060 120 0 1 {name=l44 sig_type=std_logic lab=r13}
C {sky130_stdcells/nand2_1.sym} 1200 120 0 0 {name=xg14 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1140 100 0 0 {name=l45 sig_type=std_logic lab=hi}
C {lab_pin.sym} 1140 140 0 0 {name=l46 sig_type=std_logic lab=r13}
C {lab_pin.sym} 1260 120 0 1 {name=l47 sig_type=std_logic lab=r14}
C {sky130_stdcells/nand2_1.sym} 1400 120 0 0 {name=xg15 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1340 100 0 0 {name=l48 sig_type=std_logic lab=hi}
C {lab_pin.sym} 1340 140 0 0 {name=l49 sig_type=std_logic lab=r14}
C {lab_pin.sym} 1460 120 0 1 {name=l50 sig_type=std_logic lab=r15}
C {sky130_stdcells/nand2_1.sym} 0 240 0 0 {name=xg16 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -60 220 0 0 {name=l51 sig_type=std_logic lab=hi}
C {lab_pin.sym} -60 260 0 0 {name=l52 sig_type=std_logic lab=r15}
C {lab_pin.sym} 60 240 0 1 {name=l53 sig_type=std_logic lab=r16}
C {sky130_stdcells/nand2_1.sym} 200 240 0 0 {name=xg17 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 220 0 0 {name=l54 sig_type=std_logic lab=hi}
C {lab_pin.sym} 140 260 0 0 {name=l55 sig_type=std_logic lab=r16}
C {lab_pin.sym} 260 240 0 1 {name=l56 sig_type=std_logic lab=r17}
C {sky130_stdcells/nand2_1.sym} 400 240 0 0 {name=xg18 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 340 220 0 0 {name=l57 sig_type=std_logic lab=hi}
C {lab_pin.sym} 340 260 0 0 {name=l58 sig_type=std_logic lab=r17}
C {lab_pin.sym} 460 240 0 1 {name=l59 sig_type=std_logic lab=r18}
C {sky130_stdcells/nand2_1.sym} 600 240 0 0 {name=xg19 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 540 220 0 0 {name=l60 sig_type=std_logic lab=hi}
C {lab_pin.sym} 540 260 0 0 {name=l61 sig_type=std_logic lab=r18}
C {lab_pin.sym} 660 240 0 1 {name=l62 sig_type=std_logic lab=r19}
C {sky130_stdcells/nand2_1.sym} 800 240 0 0 {name=xg20 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 740 220 0 0 {name=l63 sig_type=std_logic lab=hi}
C {lab_pin.sym} 740 260 0 0 {name=l64 sig_type=std_logic lab=r19}
C {lab_pin.sym} 860 240 0 1 {name=l65 sig_type=std_logic lab=r20}
C {sky130_stdcells/nand2_1.sym} 1000 240 0 0 {name=xg21 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 940 220 0 0 {name=l66 sig_type=std_logic lab=hi}
C {lab_pin.sym} 940 260 0 0 {name=l67 sig_type=std_logic lab=r20}
C {lab_pin.sym} 1060 240 0 1 {name=l68 sig_type=std_logic lab=r21}
C {sky130_stdcells/nand2_1.sym} 1200 240 0 0 {name=xg22 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1140 220 0 0 {name=l69 sig_type=std_logic lab=hi}
C {lab_pin.sym} 1140 260 0 0 {name=l70 sig_type=std_logic lab=r21}
C {lab_pin.sym} 1260 240 0 1 {name=l71 sig_type=std_logic lab=r22}
C {sky130_stdcells/nand2_1.sym} 1400 240 0 0 {name=xg23 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1340 220 0 0 {name=l72 sig_type=std_logic lab=hi}
C {lab_pin.sym} 1340 260 0 0 {name=l73 sig_type=std_logic lab=r22}
C {lab_pin.sym} 1460 240 0 1 {name=l74 sig_type=std_logic lab=r23}
C {sky130_stdcells/nand2_1.sym} 0 360 0 0 {name=xg24 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -60 340 0 0 {name=l75 sig_type=std_logic lab=hi}
C {lab_pin.sym} -60 380 0 0 {name=l76 sig_type=std_logic lab=r23}
C {lab_pin.sym} 60 360 0 1 {name=l77 sig_type=std_logic lab=r24}
C {sky130_stdcells/nand2_1.sym} 200 360 0 0 {name=xg25 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 140 340 0 0 {name=l78 sig_type=std_logic lab=hi}
C {lab_pin.sym} 140 380 0 0 {name=l79 sig_type=std_logic lab=r24}
C {lab_pin.sym} 260 360 0 1 {name=l80 sig_type=std_logic lab=r25}
C {sky130_stdcells/nand2_1.sym} 400 360 0 0 {name=xg26 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 340 340 0 0 {name=l81 sig_type=std_logic lab=hi}
C {lab_pin.sym} 340 380 0 0 {name=l82 sig_type=std_logic lab=r25}
C {lab_pin.sym} 460 360 0 1 {name=l83 sig_type=std_logic lab=r26}
C {sky130_stdcells/nand2_1.sym} 600 360 0 0 {name=xg27 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 540 340 0 0 {name=l84 sig_type=std_logic lab=hi}
C {lab_pin.sym} 540 380 0 0 {name=l85 sig_type=std_logic lab=r26}
C {lab_pin.sym} 660 360 0 1 {name=l86 sig_type=std_logic lab=r27}
C {sky130_stdcells/nand2_1.sym} 800 360 0 0 {name=xg28 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 740 340 0 0 {name=l87 sig_type=std_logic lab=hi}
C {lab_pin.sym} 740 380 0 0 {name=l88 sig_type=std_logic lab=r27}
C {lab_pin.sym} 860 360 0 1 {name=l89 sig_type=std_logic lab=r28}
C {sky130_stdcells/nand2_1.sym} 1000 360 0 0 {name=xg29 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 940 340 0 0 {name=l90 sig_type=std_logic lab=hi}
C {lab_pin.sym} 940 380 0 0 {name=l91 sig_type=std_logic lab=r28}
C {lab_pin.sym} 1060 360 0 1 {name=l92 sig_type=std_logic lab=r29}
C {sky130_stdcells/nand2_1.sym} 1200 360 0 0 {name=xg30 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1140 340 0 0 {name=l93 sig_type=std_logic lab=hi}
C {lab_pin.sym} 1140 380 0 0 {name=l94 sig_type=std_logic lab=r29}
C {lab_pin.sym} 1260 360 0 1 {name=l95 sig_type=std_logic lab=r30}
C {sky130_stdcells/dfrtp_1.sym} 0 600 0 0 {name=xf0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -90 580 0 0 {name=l96 sig_type=std_logic lab=r0}
C {lab_pin.sym} -90 600 0 0 {name=l97 sig_type=std_logic lab=qb0}
C {lab_pin.sym} -90 620 0 0 {name=l98 sig_type=std_logic lab=en}
C {lab_pin.sym} 90 580 0 1 {name=l99 sig_type=std_logic lab=q0}
C {sky130_stdcells/inv_1.sym} 150 660 0 0 {name=xqi0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 110 660 0 0 {name=l100 sig_type=std_logic lab=q0}
C {lab_pin.sym} 190 660 0 1 {name=l101 sig_type=std_logic lab=qb0}
C {sky130_stdcells/dfrtp_1.sym} 300 600 0 0 {name=xf1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 210 580 0 0 {name=l102 sig_type=std_logic lab=q0}
C {lab_pin.sym} 210 600 0 0 {name=l103 sig_type=std_logic lab=qb1}
C {lab_pin.sym} 210 620 0 0 {name=l104 sig_type=std_logic lab=en}
C {lab_pin.sym} 390 580 0 1 {name=l105 sig_type=std_logic lab=q1}
C {sky130_stdcells/inv_1.sym} 450 660 0 0 {name=xqi1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 410 660 0 0 {name=l106 sig_type=std_logic lab=q1}
C {lab_pin.sym} 490 660 0 1 {name=l107 sig_type=std_logic lab=qb1}
C {sky130_stdcells/dfrtp_1.sym} 600 600 0 0 {name=xf2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 510 580 0 0 {name=l108 sig_type=std_logic lab=q1}
C {lab_pin.sym} 510 600 0 0 {name=l109 sig_type=std_logic lab=qb2}
C {lab_pin.sym} 510 620 0 0 {name=l110 sig_type=std_logic lab=en}
C {lab_pin.sym} 690 580 0 1 {name=l111 sig_type=std_logic lab=q2}
C {sky130_stdcells/inv_1.sym} 750 660 0 0 {name=xqi2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 710 660 0 0 {name=l112 sig_type=std_logic lab=q2}
C {lab_pin.sym} 790 660 0 1 {name=l113 sig_type=std_logic lab=qb2}
C {sky130_stdcells/dfrtp_1.sym} 900 600 0 0 {name=xf3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 810 580 0 0 {name=l114 sig_type=std_logic lab=q2}
C {lab_pin.sym} 810 600 0 0 {name=l115 sig_type=std_logic lab=qb3}
C {lab_pin.sym} 810 620 0 0 {name=l116 sig_type=std_logic lab=en}
C {lab_pin.sym} 990 580 0 1 {name=l117 sig_type=std_logic lab=q3}
C {sky130_stdcells/inv_1.sym} 1050 660 0 0 {name=xqi3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1010 660 0 0 {name=l118 sig_type=std_logic lab=q3}
C {lab_pin.sym} 1090 660 0 1 {name=l119 sig_type=std_logic lab=qb3}
C {sky130_stdcells/dfrtp_1.sym} 1200 600 0 0 {name=xf4 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 580 0 0 {name=l120 sig_type=std_logic lab=q3}
C {lab_pin.sym} 1110 600 0 0 {name=l121 sig_type=std_logic lab=qb4}
C {lab_pin.sym} 1110 620 0 0 {name=l122 sig_type=std_logic lab=en}
C {lab_pin.sym} 1290 580 0 1 {name=l123 sig_type=std_logic lab=q4}
C {sky130_stdcells/inv_1.sym} 1350 660 0 0 {name=xqi4 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1310 660 0 0 {name=l124 sig_type=std_logic lab=q4}
C {lab_pin.sym} 1390 660 0 1 {name=l125 sig_type=std_logic lab=qb4}
C {sky130_stdcells/buf_2.sym} 1500 600 0 0 {name=xbo VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1460 600 0 0 {name=l126 sig_type=std_logic lab=q4}
C {lab_pin.sym} 1540 600 0 1 {name=l127 sig_type=std_logic lab=out}
C {ipin.sym} -400 -200 0 0 {name=pi_en lab=en}
C {opin.sym} 1400 -200 0 0 {name=po_out lab=out}
C {iopin.sym} 1400 -170 0 0 {name=pp_VDPWR lab=VDPWR}
C {iopin.sym} 1400 -140 0 0 {name=pp_VGND lab=VGND}
