v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {readout_glue: tile glue (spec M7 step 1, R2, R17). ui_in[0..7] buf_1 each; complements of osc_en, thr_sel,
vref_mon_en, iptat_mon_en (inv_1); osc_out toggle: buf_2 on rst -> dfrtp_1 (D = ~Q, RESET_B = osc_en) -> buf_2 -> uo0;
cmp_raw buf_2 -> uo2; bg_ok = inv_1(su) -> buf_2 -> uo4; 18 conb_1 LO tie-offs, one per pin. Nets joined by label.} -300 -420 0 0 0.3 0.3 {}
C {sky130_stdcells/buf_1.sym} 0 0 0 0 {name=xbi0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 0 0 0 {name=l1 sig_type=std_logic lab=ui0}
C {lab_pin.sym} 40 0 0 1 {name=l2 sig_type=std_logic lab=osc_en}
C {sky130_stdcells/buf_1.sym} 0 60 0 0 {name=xbi1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 60 0 0 {name=l3 sig_type=std_logic lab=ui1}
C {lab_pin.sym} 40 60 0 1 {name=l4 sig_type=std_logic lab=thr_sel}
C {sky130_stdcells/buf_1.sym} 0 120 0 0 {name=xbi2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 120 0 0 {name=l5 sig_type=std_logic lab=ui2}
C {lab_pin.sym} 40 120 0 1 {name=l6 sig_type=std_logic lab=vref_mon_en}
C {sky130_stdcells/buf_1.sym} 0 180 0 0 {name=xbi3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 180 0 0 {name=l7 sig_type=std_logic lab=ui3}
C {lab_pin.sym} 40 180 0 1 {name=l8 sig_type=std_logic lab=iptat_mon_en}
C {sky130_stdcells/buf_1.sym} 0 240 0 0 {name=xbi4 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 240 0 0 {name=l9 sig_type=std_logic lab=ui4}
C {lab_pin.sym} 40 240 0 1 {name=l10 sig_type=std_logic lab=ich_sel}
C {sky130_stdcells/buf_1.sym} 0 300 0 0 {name=xbi5 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 300 0 0 {name=l11 sig_type=std_logic lab=ui5}
C {lab_pin.sym} 40 300 0 1 {name=l12 sig_type=std_logic lab=chop_sel}
C {sky130_stdcells/buf_1.sym} 0 360 0 0 {name=xbi6 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 360 0 0 {name=l13 sig_type=std_logic lab=ui6}
C {lab_pin.sym} 40 360 0 1 {name=l14 sig_type=std_logic lab=ring_en}
C {sky130_stdcells/buf_1.sym} 0 420 0 0 {name=xbi7 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 420 0 0 {name=l15 sig_type=std_logic lab=ui7}
C {lab_pin.sym} 40 420 0 1 {name=l16 sig_type=std_logic lab=i3_sel}
C {sky130_stdcells/inv_1.sym} 250 0 0 0 {name=xci0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 210 0 0 0 {name=l17 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} 290 0 0 1 {name=l18 sig_type=std_logic lab=osc_enb}
C {sky130_stdcells/inv_1.sym} 250 60 0 0 {name=xci1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 210 60 0 0 {name=l19 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} 290 60 0 1 {name=l20 sig_type=std_logic lab=thr_selb}
C {sky130_stdcells/inv_1.sym} 250 120 0 0 {name=xci2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 210 120 0 0 {name=l21 sig_type=std_logic lab=vref_mon_en}
C {lab_pin.sym} 290 120 0 1 {name=l22 sig_type=std_logic lab=vref_mon_enb}
C {sky130_stdcells/inv_1.sym} 250 180 0 0 {name=xci3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 210 180 0 0 {name=l23 sig_type=std_logic lab=iptat_mon_en}
C {lab_pin.sym} 290 180 0 1 {name=l24 sig_type=std_logic lab=iptat_mon_enb}
C {sky130_stdcells/buf_2.sym} 0 560 0 0 {name=xtk VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 560 0 0 {name=l25 sig_type=std_logic lab=rst}
C {lab_pin.sym} 40 560 0 1 {name=l26 sig_type=std_logic lab=rst_k}
C {sky130_stdcells/dfrtp_1.sym} 250 580 0 0 {name=xtff VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 160 560 0 0 {name=l27 sig_type=std_logic lab=rst_k}
C {lab_pin.sym} 160 580 0 0 {name=l28 sig_type=std_logic lab=tqb}
C {lab_pin.sym} 160 600 0 0 {name=l29 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} 340 560 0 1 {name=l30 sig_type=std_logic lab=tq}
C {sky130_stdcells/inv_1.sym} 500 640 0 0 {name=xti VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 460 640 0 0 {name=l31 sig_type=std_logic lab=tq}
C {lab_pin.sym} 540 640 0 1 {name=l32 sig_type=std_logic lab=tqb}
C {sky130_stdcells/buf_2.sym} 500 560 0 0 {name=xto VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 460 560 0 0 {name=l33 sig_type=std_logic lab=tq}
C {lab_pin.sym} 540 560 0 1 {name=l34 sig_type=std_logic lab=uo0}
C {sky130_stdcells/buf_2.sym} 0 760 0 0 {name=xcb VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 760 0 0 {name=l35 sig_type=std_logic lab=cmp_raw}
C {lab_pin.sym} 40 760 0 1 {name=l36 sig_type=std_logic lab=uo2}
C {sky130_stdcells/inv_1.sym} 0 840 0 0 {name=xbgi VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -40 840 0 0 {name=l37 sig_type=std_logic lab=su}
C {lab_pin.sym} 40 840 0 1 {name=l38 sig_type=std_logic lab=bg_ok}
C {sky130_stdcells/buf_2.sym} 250 840 0 0 {name=xbgb VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 210 840 0 0 {name=l39 sig_type=std_logic lab=bg_ok}
C {lab_pin.sym} 290 840 0 1 {name=l40 sig_type=std_logic lab=uo4}
C {sky130_stdcells/conb_1.sym} 800 0 0 0 {name=xtie0 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 -20 0 1 {name=l41 sig_type=std_logic lab=tie_hi0}
C {lab_pin.sym} 860 20 0 1 {name=l42 sig_type=std_logic lab=uo5}
C {sky130_stdcells/conb_1.sym} 800 80 0 0 {name=xtie1 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 60 0 1 {name=l43 sig_type=std_logic lab=tie_hi1}
C {lab_pin.sym} 860 100 0 1 {name=l44 sig_type=std_logic lab=uo7}
C {sky130_stdcells/conb_1.sym} 800 160 0 0 {name=xtie2 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 140 0 1 {name=l45 sig_type=std_logic lab=tie_hi2}
C {lab_pin.sym} 860 180 0 1 {name=l46 sig_type=std_logic lab=uio_out0}
C {sky130_stdcells/conb_1.sym} 800 240 0 0 {name=xtie3 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 220 0 1 {name=l47 sig_type=std_logic lab=tie_hi3}
C {lab_pin.sym} 860 260 0 1 {name=l48 sig_type=std_logic lab=uio_out1}
C {sky130_stdcells/conb_1.sym} 800 320 0 0 {name=xtie4 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 300 0 1 {name=l49 sig_type=std_logic lab=tie_hi4}
C {lab_pin.sym} 860 340 0 1 {name=l50 sig_type=std_logic lab=uio_out2}
C {sky130_stdcells/conb_1.sym} 800 400 0 0 {name=xtie5 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 380 0 1 {name=l51 sig_type=std_logic lab=tie_hi5}
C {lab_pin.sym} 860 420 0 1 {name=l52 sig_type=std_logic lab=uio_out3}
C {sky130_stdcells/conb_1.sym} 800 480 0 0 {name=xtie6 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 460 0 1 {name=l53 sig_type=std_logic lab=tie_hi6}
C {lab_pin.sym} 860 500 0 1 {name=l54 sig_type=std_logic lab=uio_out4}
C {sky130_stdcells/conb_1.sym} 800 560 0 0 {name=xtie7 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 540 0 1 {name=l55 sig_type=std_logic lab=tie_hi7}
C {lab_pin.sym} 860 580 0 1 {name=l56 sig_type=std_logic lab=uio_out5}
C {sky130_stdcells/conb_1.sym} 800 640 0 0 {name=xtie8 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 860 620 0 1 {name=l57 sig_type=std_logic lab=tie_hi8}
C {lab_pin.sym} 860 660 0 1 {name=l58 sig_type=std_logic lab=uio_out6}
C {sky130_stdcells/conb_1.sym} 1050 0 0 0 {name=xtie9 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 -20 0 1 {name=l59 sig_type=std_logic lab=tie_hi9}
C {lab_pin.sym} 1110 20 0 1 {name=l60 sig_type=std_logic lab=uio_out7}
C {sky130_stdcells/conb_1.sym} 1050 80 0 0 {name=xtie10 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 60 0 1 {name=l61 sig_type=std_logic lab=tie_hi10}
C {lab_pin.sym} 1110 100 0 1 {name=l62 sig_type=std_logic lab=uio_oe0}
C {sky130_stdcells/conb_1.sym} 1050 160 0 0 {name=xtie11 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 140 0 1 {name=l63 sig_type=std_logic lab=tie_hi11}
C {lab_pin.sym} 1110 180 0 1 {name=l64 sig_type=std_logic lab=uio_oe1}
C {sky130_stdcells/conb_1.sym} 1050 240 0 0 {name=xtie12 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 220 0 1 {name=l65 sig_type=std_logic lab=tie_hi12}
C {lab_pin.sym} 1110 260 0 1 {name=l66 sig_type=std_logic lab=uio_oe2}
C {sky130_stdcells/conb_1.sym} 1050 320 0 0 {name=xtie13 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 300 0 1 {name=l67 sig_type=std_logic lab=tie_hi13}
C {lab_pin.sym} 1110 340 0 1 {name=l68 sig_type=std_logic lab=uio_oe3}
C {sky130_stdcells/conb_1.sym} 1050 400 0 0 {name=xtie14 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 380 0 1 {name=l69 sig_type=std_logic lab=tie_hi14}
C {lab_pin.sym} 1110 420 0 1 {name=l70 sig_type=std_logic lab=uio_oe4}
C {sky130_stdcells/conb_1.sym} 1050 480 0 0 {name=xtie15 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 460 0 1 {name=l71 sig_type=std_logic lab=tie_hi15}
C {lab_pin.sym} 1110 500 0 1 {name=l72 sig_type=std_logic lab=uio_oe5}
C {sky130_stdcells/conb_1.sym} 1050 560 0 0 {name=xtie16 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 540 0 1 {name=l73 sig_type=std_logic lab=tie_hi16}
C {lab_pin.sym} 1110 580 0 1 {name=l74 sig_type=std_logic lab=uio_oe6}
C {sky130_stdcells/conb_1.sym} 1050 640 0 0 {name=xtie17 VGND=VGND VNB=VGND VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 1110 620 0 1 {name=l75 sig_type=std_logic lab=tie_hi17}
C {lab_pin.sym} 1110 660 0 1 {name=l76 sig_type=std_logic lab=uio_oe7}
C {ipin.sym} -300 1000 0 0 {name=pi_ui0 lab=ui0}
C {ipin.sym} -300 1030 0 0 {name=pi_ui1 lab=ui1}
C {ipin.sym} -300 1060 0 0 {name=pi_ui2 lab=ui2}
C {ipin.sym} -300 1090 0 0 {name=pi_ui3 lab=ui3}
C {ipin.sym} -300 1120 0 0 {name=pi_ui4 lab=ui4}
C {ipin.sym} -300 1150 0 0 {name=pi_ui5 lab=ui5}
C {ipin.sym} -300 1180 0 0 {name=pi_ui6 lab=ui6}
C {ipin.sym} -300 1210 0 0 {name=pi_ui7 lab=ui7}
C {ipin.sym} -300 1240 0 0 {name=pi_rst lab=rst}
C {ipin.sym} -300 1270 0 0 {name=pi_cmp_raw lab=cmp_raw}
C {ipin.sym} -300 1300 0 0 {name=pi_su lab=su}
C {opin.sym} 1500 1000 0 0 {name=po_osc_en lab=osc_en}
C {opin.sym} 1500 1030 0 0 {name=po_osc_enb lab=osc_enb}
C {opin.sym} 1500 1060 0 0 {name=po_thr_sel lab=thr_sel}
C {opin.sym} 1500 1090 0 0 {name=po_thr_selb lab=thr_selb}
C {opin.sym} 1500 1120 0 0 {name=po_vref_mon_en lab=vref_mon_en}
C {opin.sym} 1500 1150 0 0 {name=po_vref_mon_enb lab=vref_mon_enb}
C {opin.sym} 1500 1180 0 0 {name=po_iptat_mon_en lab=iptat_mon_en}
C {opin.sym} 1500 1210 0 0 {name=po_iptat_mon_enb lab=iptat_mon_enb}
C {opin.sym} 1500 1240 0 0 {name=po_ich_sel lab=ich_sel}
C {opin.sym} 1500 1270 0 0 {name=po_chop_sel lab=chop_sel}
C {opin.sym} 1500 1300 0 0 {name=po_ring_en lab=ring_en}
C {opin.sym} 1500 1330 0 0 {name=po_i3_sel lab=i3_sel}
C {opin.sym} 1500 1360 0 0 {name=po_uo0 lab=uo0}
C {opin.sym} 1500 1390 0 0 {name=po_uo2 lab=uo2}
C {opin.sym} 1500 1420 0 0 {name=po_uo4 lab=uo4}
C {opin.sym} 1500 1450 0 0 {name=po_uo5 lab=uo5}
C {opin.sym} 1500 1480 0 0 {name=po_uo7 lab=uo7}
C {opin.sym} 1500 1510 0 0 {name=po_uio_out0 lab=uio_out0}
C {opin.sym} 1500 1540 0 0 {name=po_uio_out1 lab=uio_out1}
C {opin.sym} 1500 1570 0 0 {name=po_uio_out2 lab=uio_out2}
C {opin.sym} 1500 1600 0 0 {name=po_uio_out3 lab=uio_out3}
C {opin.sym} 1500 1630 0 0 {name=po_uio_out4 lab=uio_out4}
C {opin.sym} 1500 1660 0 0 {name=po_uio_out5 lab=uio_out5}
C {opin.sym} 1500 1690 0 0 {name=po_uio_out6 lab=uio_out6}
C {opin.sym} 1500 1720 0 0 {name=po_uio_out7 lab=uio_out7}
C {opin.sym} 1500 1750 0 0 {name=po_uio_oe0 lab=uio_oe0}
C {opin.sym} 1500 1780 0 0 {name=po_uio_oe1 lab=uio_oe1}
C {opin.sym} 1500 1810 0 0 {name=po_uio_oe2 lab=uio_oe2}
C {opin.sym} 1500 1840 0 0 {name=po_uio_oe3 lab=uio_oe3}
C {opin.sym} 1500 1870 0 0 {name=po_uio_oe4 lab=uio_oe4}
C {opin.sym} 1500 1900 0 0 {name=po_uio_oe5 lab=uio_oe5}
C {opin.sym} 1500 1930 0 0 {name=po_uio_oe6 lab=uio_oe6}
C {opin.sym} 1500 1960 0 0 {name=po_uio_oe7 lab=uio_oe7}
C {iopin.sym} 1500 1990 0 0 {name=pp_VDPWR lab=VDPWR}
C {iopin.sym} 1500 2020 0 0 {name=pp_VGND lab=VGND}
