v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_readout_glue: M7 section 13. rst = 10 ns pulses (width at VDD/2) every 1 us from 0.5 us (spec: 4.55 us; the toggle is static, the gap does not matter), edges trf;
osc_en (ui0) = 0 for 0-0.8 us, so the first pulse must not toggle; 8 pulses after it -> osc_out rises 4 times.
ui1..ui7 rise at 8.8 us (checked at 9.1 us); step 0.05 ns (0.5 ns let the solver miss flop transitions). su = 0 (bandgap started). 100 fF on uo0/uo2/uo4.
Diagnostic beside the cell: a second toggle flop clocked by rst directly (no local buf_2). Runner glue13.py.} -700 -520 0 0 0.3 0.3 {}
C {readout_glue.sym} 0 0 0 0 {name=x1}
C {lab_pin.sym} -150 20 0 0 {name=l1 sig_type=std_logic lab=ui0}
C {lab_pin.sym} -150 40 0 0 {name=l2 sig_type=std_logic lab=ui1}
C {lab_pin.sym} -150 60 0 0 {name=l3 sig_type=std_logic lab=ui2}
C {lab_pin.sym} -150 80 0 0 {name=l4 sig_type=std_logic lab=ui3}
C {lab_pin.sym} -150 100 0 0 {name=l5 sig_type=std_logic lab=ui4}
C {lab_pin.sym} -150 120 0 0 {name=l6 sig_type=std_logic lab=ui5}
C {lab_pin.sym} -150 140 0 0 {name=l7 sig_type=std_logic lab=ui6}
C {lab_pin.sym} -150 160 0 0 {name=l8 sig_type=std_logic lab=ui7}
C {lab_pin.sym} -150 180 0 0 {name=l9 sig_type=std_logic lab=rst}
C {lab_pin.sym} -150 200 0 0 {name=l10 sig_type=std_logic lab=cmp_raw}
C {lab_pin.sym} -150 220 0 0 {name=l11 sig_type=std_logic lab=su}
C {lab_pin.sym} 150 20 0 1 {name=l12 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} 150 40 0 1 {name=l13 sig_type=std_logic lab=osc_enb}
C {lab_pin.sym} 150 60 0 1 {name=l14 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} 150 80 0 1 {name=l15 sig_type=std_logic lab=thr_selb}
C {lab_pin.sym} 150 100 0 1 {name=l16 sig_type=std_logic lab=vref_mon_en}
C {lab_pin.sym} 150 120 0 1 {name=l17 sig_type=std_logic lab=vref_mon_enb}
C {lab_pin.sym} 150 140 0 1 {name=l18 sig_type=std_logic lab=iptat_mon_en}
C {lab_pin.sym} 150 160 0 1 {name=l19 sig_type=std_logic lab=iptat_mon_enb}
C {lab_pin.sym} 150 180 0 1 {name=l20 sig_type=std_logic lab=ich_sel}
C {lab_pin.sym} 150 200 0 1 {name=l21 sig_type=std_logic lab=chop_sel}
C {lab_pin.sym} 150 220 0 1 {name=l22 sig_type=std_logic lab=ring_en}
C {lab_pin.sym} 150 240 0 1 {name=l23 sig_type=std_logic lab=i3_sel}
C {lab_pin.sym} 150 260 0 1 {name=l24 sig_type=std_logic lab=uo0}
C {lab_pin.sym} 150 280 0 1 {name=l25 sig_type=std_logic lab=uo2}
C {lab_pin.sym} 150 300 0 1 {name=l26 sig_type=std_logic lab=uo4}
C {lab_pin.sym} 150 320 0 1 {name=l27 sig_type=std_logic lab=uo5}
C {lab_pin.sym} 150 340 0 1 {name=l28 sig_type=std_logic lab=uo7}
C {lab_pin.sym} 150 360 0 1 {name=l29 sig_type=std_logic lab=uio_out0}
C {lab_pin.sym} 150 380 0 1 {name=l30 sig_type=std_logic lab=uio_out1}
C {lab_pin.sym} 150 400 0 1 {name=l31 sig_type=std_logic lab=uio_out2}
C {lab_pin.sym} 150 420 0 1 {name=l32 sig_type=std_logic lab=uio_out3}
C {lab_pin.sym} 150 440 0 1 {name=l33 sig_type=std_logic lab=uio_out4}
C {lab_pin.sym} 150 460 0 1 {name=l34 sig_type=std_logic lab=uio_out5}
C {lab_pin.sym} 150 480 0 1 {name=l35 sig_type=std_logic lab=uio_out6}
C {lab_pin.sym} 150 500 0 1 {name=l36 sig_type=std_logic lab=uio_out7}
C {lab_pin.sym} 150 520 0 1 {name=l37 sig_type=std_logic lab=uio_oe0}
C {lab_pin.sym} 150 540 0 1 {name=l38 sig_type=std_logic lab=uio_oe1}
C {lab_pin.sym} 150 560 0 1 {name=l39 sig_type=std_logic lab=uio_oe2}
C {lab_pin.sym} 150 580 0 1 {name=l40 sig_type=std_logic lab=uio_oe3}
C {lab_pin.sym} 150 600 0 1 {name=l41 sig_type=std_logic lab=uio_oe4}
C {lab_pin.sym} 150 620 0 1 {name=l42 sig_type=std_logic lab=uio_oe5}
C {lab_pin.sym} 150 640 0 1 {name=l43 sig_type=std_logic lab=uio_oe6}
C {lab_pin.sym} 150 660 0 1 {name=l44 sig_type=std_logic lab=uio_oe7}
C {lab_pin.sym} 150 680 0 1 {name=l45 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 700 0 1 {name=l46 sig_type=std_logic lab=0}
C {devices/vsource.sym} -700 900 0 0 {name=Vdd value="'vdd'" savecurrent=false}
C {devices/gnd.sym} -700 930 0 0 {name=gVdd lab=0}
C {lab_pin.sym} -700 870 0 0 {name=l47 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} -580 900 0 0 {name=Vui0 value="pwl(0 0 0.8u 0 0.8001u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -580 930 0 0 {name=gVui0 lab=0}
C {lab_pin.sym} -580 870 0 0 {name=l48 sig_type=std_logic lab=ui0}
C {devices/vsource.sym} -460 900 0 0 {name=Vrst value="pulse(0 'vdd' 0.5u 'trf' 'trf' '10n-trf' 1u)" savecurrent=false}
C {devices/gnd.sym} -460 930 0 0 {name=gVrst lab=0}
C {lab_pin.sym} -460 870 0 0 {name=l49 sig_type=std_logic lab=rst}
C {devices/vsource.sym} -340 900 0 0 {name=Vcmp value="pulse(0 'vdd' 0.495u 0.5n 0.5n 25n 1u)" savecurrent=false}
C {devices/gnd.sym} -340 930 0 0 {name=gVcmp lab=0}
C {lab_pin.sym} -340 870 0 0 {name=l50 sig_type=std_logic lab=cmp_raw}
C {devices/vsource.sym} -220 900 0 0 {name=Vsu value="0" savecurrent=false}
C {devices/gnd.sym} -220 930 0 0 {name=gVsu lab=0}
C {lab_pin.sym} -220 870 0 0 {name=l51 sig_type=std_logic lab=su}
C {devices/vsource.sym} -100 900 0 0 {name=Vui1 value="pwl(0 0 8.8u 0 8.8001u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -100 930 0 0 {name=gVui1 lab=0}
C {lab_pin.sym} -100 870 0 0 {name=l52 sig_type=std_logic lab=ui1}
C {devices/vsource.sym} 20 900 0 0 {name=Vui2 value="pwl(0 0 8.8u 0 8.8001u 'vdd')" savecurrent=false}
C {devices/gnd.sym} 20 930 0 0 {name=gVui2 lab=0}
C {lab_pin.sym} 20 870 0 0 {name=l53 sig_type=std_logic lab=ui2}
C {devices/vsource.sym} -700 1100 0 0 {name=Vui3 value="pwl(0 0 8.8u 0 8.8001u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -700 1130 0 0 {name=gVui3 lab=0}
C {lab_pin.sym} -700 1070 0 0 {name=l54 sig_type=std_logic lab=ui3}
C {devices/vsource.sym} -580 1100 0 0 {name=Vui4 value="pwl(0 0 8.8u 0 8.8001u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -580 1130 0 0 {name=gVui4 lab=0}
C {lab_pin.sym} -580 1070 0 0 {name=l55 sig_type=std_logic lab=ui4}
C {devices/vsource.sym} -460 1100 0 0 {name=Vui5 value="pwl(0 0 8.8u 0 8.8001u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -460 1130 0 0 {name=gVui5 lab=0}
C {lab_pin.sym} -460 1070 0 0 {name=l56 sig_type=std_logic lab=ui5}
C {devices/vsource.sym} -340 1100 0 0 {name=Vui6 value="pwl(0 0 8.8u 0 8.8001u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -340 1130 0 0 {name=gVui6 lab=0}
C {lab_pin.sym} -340 1070 0 0 {name=l57 sig_type=std_logic lab=ui6}
C {devices/vsource.sym} -220 1100 0 0 {name=Vui7 value="pwl(0 0 8.8u 0 8.8001u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -220 1130 0 0 {name=gVui7 lab=0}
C {lab_pin.sym} -220 1070 0 0 {name=l58 sig_type=std_logic lab=ui7}
C {devices/capa.sym} 400 900 0 0 {name=Cuo0
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 400 870 0 0 {name=l59 sig_type=std_logic lab=uo0}
C {devices/gnd.sym} 400 930 0 0 {name=gc0 lab=0}
C {devices/capa.sym} 470 900 0 0 {name=Cuo2
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 470 870 0 0 {name=l60 sig_type=std_logic lab=uo2}
C {devices/gnd.sym} 470 930 0 0 {name=gc1 lab=0}
C {devices/capa.sym} 540 900 0 0 {name=Cuo4
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 540 870 0 0 {name=l61 sig_type=std_logic lab=uo4}
C {devices/gnd.sym} 540 930 0 0 {name=gc2 lab=0}
C {devices/capa.sym} 610 900 0 0 {name=Cosc_en
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 610 870 0 0 {name=l62 sig_type=std_logic lab=osc_en}
C {devices/gnd.sym} 610 930 0 0 {name=gc3 lab=0}
C {devices/capa.sym} 680 900 0 0 {name=Cosc_enb
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 680 870 0 0 {name=l63 sig_type=std_logic lab=osc_enb}
C {devices/gnd.sym} 680 930 0 0 {name=gc4 lab=0}
C {devices/capa.sym} 750 900 0 0 {name=Cthr_sel
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 750 870 0 0 {name=l64 sig_type=std_logic lab=thr_sel}
C {devices/gnd.sym} 750 930 0 0 {name=gc5 lab=0}
C {devices/capa.sym} 820 900 0 0 {name=Cthr_selb
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 820 870 0 0 {name=l65 sig_type=std_logic lab=thr_selb}
C {devices/gnd.sym} 820 930 0 0 {name=gc6 lab=0}
C {devices/capa.sym} 890 900 0 0 {name=Cvref_mon_en
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 890 870 0 0 {name=l66 sig_type=std_logic lab=vref_mon_en}
C {devices/gnd.sym} 890 930 0 0 {name=gc7 lab=0}
C {devices/capa.sym} 960 900 0 0 {name=Cvref_mon_enb
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 960 870 0 0 {name=l67 sig_type=std_logic lab=vref_mon_enb}
C {devices/gnd.sym} 960 930 0 0 {name=gc8 lab=0}
C {devices/capa.sym} 1030 900 0 0 {name=Ciptat_mon_en
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1030 870 0 0 {name=l68 sig_type=std_logic lab=iptat_mon_en}
C {devices/gnd.sym} 1030 930 0 0 {name=gc9 lab=0}
C {devices/capa.sym} 1100 900 0 0 {name=Ciptat_mon_enb
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1100 870 0 0 {name=l69 sig_type=std_logic lab=iptat_mon_enb}
C {devices/gnd.sym} 1100 930 0 0 {name=gc10 lab=0}
C {devices/capa.sym} 1170 900 0 0 {name=Cich_sel
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1170 870 0 0 {name=l70 sig_type=std_logic lab=ich_sel}
C {devices/gnd.sym} 1170 930 0 0 {name=gc11 lab=0}
C {devices/capa.sym} 1240 900 0 0 {name=Cchop_sel
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1240 870 0 0 {name=l71 sig_type=std_logic lab=chop_sel}
C {devices/gnd.sym} 1240 930 0 0 {name=gc12 lab=0}
C {devices/capa.sym} 1310 900 0 0 {name=Cring_en
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1310 870 0 0 {name=l72 sig_type=std_logic lab=ring_en}
C {devices/gnd.sym} 1310 930 0 0 {name=gc13 lab=0}
C {devices/capa.sym} 1380 900 0 0 {name=Ci3_sel
m=1
value=20f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1380 870 0 0 {name=l73 sig_type=std_logic lab=i3_sel}
C {devices/gnd.sym} 1380 930 0 0 {name=gc14 lab=0}
C {sky130_stdcells/dfrtp_1.sym} -500 600 0 0 {name=xdff VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -590 580 0 0 {name=l74 sig_type=std_logic lab=rst}
C {lab_pin.sym} -590 600 0 0 {name=l75 sig_type=std_logic lab=dqb}
C {lab_pin.sym} -590 620 0 0 {name=l76 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} -410 580 0 1 {name=l77 sig_type=std_logic lab=dq}
C {sky130_stdcells/inv_1.sym} -250 660 0 0 {name=xdi VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} -290 660 0 0 {name=l78 sig_type=std_logic lab=dq}
C {lab_pin.sym} -210 660 0 1 {name=l79 sig_type=std_logic lab=dqb}
C {sky130_fd_pr/corner.sym} -700 -300 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 900 -300 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8
.param trf=3n
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 27
.control
save uo0 uo2 uo4 rst x1.rst_k dq vdd#branch osc_en osc_enb thr_sel thr_selb vref_mon_en vref_mon_enb iptat_mon_en iptat_mon_enb ich_sel chop_sel ring_en i3_sel uo5 uo7 uio_out0 uio_out1 uio_out2 uio_out3 uio_out4 uio_out5 uio_out6 uio_out7 uio_oe0 uio_oe1 uio_oe2 uio_oe3 uio_oe4 uio_oe5 uio_oe6 uio_oe7
tran 0.05n 9.3u
meas tran r1 when v(uo0)=0.9 rise=1
meas tran r2 when v(uo0)=0.9 rise=2
meas tran r3 when v(uo0)=0.9 rise=3
meas tran r4 when v(uo0)=0.9 rise=4
meas tran r5 when v(uo0)=0.9 rise=5
meas tran f4 when v(uo0)=0.9 fall=4
meas tran f5 when v(uo0)=0.9 fall=5
meas tran pre_max max v(uo0) from=0 to=0.8u
meas tran tr trig v(uo0) val=0.18 rise=1 targ v(uo0) val=1.62 rise=1
meas tran tf trig v(uo0) val=1.62 fall=1 targ v(uo0) val=0.18 fall=1
meas tran t_rst trig v(rst) val=0.9 rise=2 targ v(uo0) val=0.9 rise=1
meas tran t_rstk trig v(rst) val=0.9 rise=2 targ v(x1.rst_k) val=0.9 rise=2
meas tran tr_rstk trig v(x1.rst_k) val=0.18 rise=2 targ v(x1.rst_k) val=1.62 rise=2
meas tran d1 when v(dq)=0.9 rise=1
meas tran d4 when v(dq)=0.9 rise=4
meas tran d5 when v(dq)=0.9 rise=5
meas tran c9 when v(uo2)=0.9 rise=9
meas tran c10 when v(uo2)=0.9 rise=10
meas tran i_def avg i(Vdd) from=0.1u to=0.45u
meas tran i_run avg i(Vdd) from=0.9u to=1.45u
meas tran i_all1 avg i(Vdd) from=9.0u to=9.3u
meas tran v_def find v(uo0) at=0.7u
meas tran oe_def find v(osc_en) at=0.7u
meas tran oeb_def find v(osc_enb) at=0.7u
meas tran tsb_def find v(thr_selb) at=0.7u
meas tran vmb_def find v(vref_mon_enb) at=0.7u
meas tran imb_def find v(iptat_mon_enb) at=0.7u
meas tran bg_def find v(uo4) at=0.7u
meas tran ts_on find v(thr_sel) at=9.1u
meas tran tsb_on find v(thr_selb) at=9.1u
meas tran vm_on find v(vref_mon_en) at=9.1u
meas tran vmb_on find v(vref_mon_enb) at=9.1u
meas tran im_on find v(iptat_mon_en) at=9.1u
meas tran imb_on find v(iptat_mon_enb) at=9.1u
meas tran ich_on find v(ich_sel) at=9.1u
meas tran chop_on find v(chop_sel) at=9.1u
meas tran ring_on find v(ring_en) at=9.1u
meas tran i3_on find v(i3_sel) at=9.1u
meas tran tie_max max v(uo5) from=0 to=9.3u
meas tran tmx_uo7 max v(uo7) from=0 to=9.3u
meas tran tmx_uio_out0 max v(uio_out0) from=0 to=9.3u
meas tran tmx_uio_out1 max v(uio_out1) from=0 to=9.3u
meas tran tmx_uio_out2 max v(uio_out2) from=0 to=9.3u
meas tran tmx_uio_out3 max v(uio_out3) from=0 to=9.3u
meas tran tmx_uio_out4 max v(uio_out4) from=0 to=9.3u
meas tran tmx_uio_out5 max v(uio_out5) from=0 to=9.3u
meas tran tmx_uio_out6 max v(uio_out6) from=0 to=9.3u
meas tran tmx_uio_out7 max v(uio_out7) from=0 to=9.3u
meas tran tmx_uio_oe0 max v(uio_oe0) from=0 to=9.3u
meas tran tmx_uio_oe1 max v(uio_oe1) from=0 to=9.3u
meas tran tmx_uio_oe2 max v(uio_oe2) from=0 to=9.3u
meas tran tmx_uio_oe3 max v(uio_oe3) from=0 to=9.3u
meas tran tmx_uio_oe4 max v(uio_oe4) from=0 to=9.3u
meas tran tmx_uio_oe5 max v(uio_oe5) from=0 to=9.3u
meas tran tmx_uio_oe6 max v(uio_oe6) from=0 to=9.3u
meas tran tmx_uio_oe7 max v(uio_oe7) from=0 to=9.3u
echo GLUE_DONE
.endc"}
