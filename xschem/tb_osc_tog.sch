v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_osc_tog: M6 section 10. osc_core on the frozen bgr; the bgr switch phases come from swdrv. ich_sel, i3_sel,
chop_sel and thr_sel are pwl sources that tog10.py rewrites with the toggle sequence (one control per step).
Writes tog.raw (binary: rst, vref, veb3, x1.vpg); tog10.py takes the rst edges from it at full precision.} -500 -560 0 0 0.3 0.3 {}
C {bgr.sym} 0 0 0 0 {name=x1}
C {lab_pin.sym} 150 -180 0 1 {name=l1 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 150 -160 0 1 {name=l2 sig_type=std_logic lab=ich_onb}
C {lab_pin.sym} 150 -140 0 1 {name=l3 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} 150 -120 0 1 {name=l4 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} 150 -100 0 1 {name=l5 sig_type=std_logic lab=i3_onb}
C {lab_pin.sym} 150 -80 0 1 {name=l6 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} 150 -60 0 1 {name=l7 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 -40 0 1 {name=l8 sig_type=std_logic lab=vref}
C {lab_pin.sym} 150 -20 0 1 {name=l9 sig_type=std_logic lab=vcap}
C {lab_pin.sym} 150 0 0 1 {name=l10 sig_type=std_logic lab=iptat_mon}
C {lab_pin.sym} 150 20 0 1 {name=l11 sig_type=std_logic lab=chopb}
C {lab_pin.sym} 150 40 0 1 {name=l12 sig_type=std_logic lab=chop}
C {lab_pin.sym} 150 60 0 1 {name=l13 sig_type=std_logic lab=veb3}
C {lab_pin.sym} 150 80 0 1 {name=l14 sig_type=std_logic lab=0}
C {lab_pin.sym} 150 100 0 1 {name=l15 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} 150 120 0 1 {name=l16 sig_type=std_logic lab=ib_cmp2}
C {lab_pin.sym} 150 140 0 1 {name=l17 sig_type=std_logic lab=swa}
C {lab_pin.sym} 150 160 0 1 {name=l18 sig_type=std_logic lab=swb}
C {lab_pin.sym} 150 180 0 1 {name=l19 sig_type=std_logic lab=su}
C {osc_core.sym} 700 0 0 0 {name=x2}
C {lab_pin.sym} 550 -70 0 0 {name=l20 sig_type=std_logic lab=vref}
C {lab_pin.sym} 550 -50 0 0 {name=l21 sig_type=std_logic lab=veb3}
C {lab_pin.sym} 550 -30 0 0 {name=l22 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} 550 -10 0 0 {name=l23 sig_type=std_logic lab=thr_selb}
C {lab_pin.sym} 550 10 0 0 {name=l24 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} 550 30 0 0 {name=l25 sig_type=std_logic lab=osc_enb}
C {lab_pin.sym} 550 50 0 0 {name=l26 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} 550 70 0 0 {name=l27 sig_type=std_logic lab=ib_cmp2}
C {lab_pin.sym} 850 -70 0 1 {name=l28 sig_type=std_logic lab=vcap}
C {lab_pin.sym} 850 -50 0 1 {name=l29 sig_type=std_logic lab=cmp_raw}
C {lab_pin.sym} 850 -30 0 1 {name=l30 sig_type=std_logic lab=rst}
C {lab_pin.sym} 850 30 0 1 {name=l31 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 850 50 0 1 {name=l32 sig_type=std_logic lab=0}
C {swdrv.sym} -700 400 0 0 {name=x3}
C {lab_pin.sym} -850 300 0 0 {name=l33 sig_type=std_logic lab=ich_sel}
C {lab_pin.sym} -850 320 0 0 {name=l34 sig_type=std_logic lab=i3_sel}
C {lab_pin.sym} -850 340 0 0 {name=l35 sig_type=std_logic lab=chop_sel}
C {lab_pin.sym} -550 290 0 1 {name=l36 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} -550 310 0 1 {name=l37 sig_type=std_logic lab=ich_onb}
C {lab_pin.sym} -550 330 0 1 {name=l38 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} -550 350 0 1 {name=l39 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} -550 370 0 1 {name=l40 sig_type=std_logic lab=i3_onb}
C {lab_pin.sym} -550 390 0 1 {name=l41 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} -550 410 0 1 {name=l42 sig_type=std_logic lab=swa}
C {lab_pin.sym} -550 430 0 1 {name=l43 sig_type=std_logic lab=swb}
C {lab_pin.sym} -550 450 0 1 {name=l44 sig_type=std_logic lab=chop}
C {lab_pin.sym} -550 470 0 1 {name=l45 sig_type=std_logic lab=chopb}
C {lab_pin.sym} -550 490 0 1 {name=l46 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -550 510 0 1 {name=l47 sig_type=std_logic lab=0}
C {devices/vsource.sym} -1100 330 0 0 {name=Vich value="pwl(0 0 1 0)" savecurrent=false}
C {lab_pin.sym} -1100 300 0 0 {name=l48 sig_type=std_logic lab=ich_sel}
C {devices/gnd.sym} -1100 360 0 0 {name=g49 lab=0}
C {devices/vsource.sym} -980 330 0 0 {name=Vi3 value="pwl(0 0 1 0)" savecurrent=false}
C {lab_pin.sym} -980 300 0 0 {name=l50 sig_type=std_logic lab=i3_sel}
C {devices/gnd.sym} -980 360 0 0 {name=g51 lab=0}
C {devices/vsource.sym} -860 330 0 0 {name=Vchop value="pwl(0 0 1 0)" savecurrent=false}
C {lab_pin.sym} -860 300 0 0 {name=l52 sig_type=std_logic lab=chop_sel}
C {devices/gnd.sym} -860 360 0 0 {name=g53 lab=0}
C {devices/vsource.sym} -500 -100 0 0 {name=Vdd value="pwl(0 0 1u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -500 -70 0 0 {name=g54 lab=0}
C {lab_pin.sym} -500 -130 0 0 {name=l55 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} -400 650 0 0 {name=Vmon value="0.7" savecurrent=false}
C {lab_pin.sym} -400 620 0 0 {name=l56 sig_type=std_logic lab=iptat_mon}
C {devices/gnd.sym} -400 680 0 0 {name=g57 lab=0}
C {devices/capa.sym} -250 650 0 0 {name=Cdec
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -250 620 0 0 {name=l58 sig_type=std_logic lab=vref}
C {devices/gnd.sym} -250 680 0 0 {name=g59 lab=0}
C {devices/capa.sym} -120 650 0 0 {name=Cw1
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -120 620 0 0 {name=l60 sig_type=std_logic lab=ib_cmp1}
C {devices/gnd.sym} -120 680 0 0 {name=g61 lab=0}
C {devices/capa.sym} 10 650 0 0 {name=Cw2
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 10 620 0 0 {name=l62 sig_type=std_logic lab=ib_cmp2}
C {devices/gnd.sym} 10 680 0 0 {name=g63 lab=0}
C {devices/vsource.sym} 600 330 0 0 {name=Ven value="pwl(0 0 'ten' 0 'ten+0.2n' 'vdd')" savecurrent=false}
C {devices/gnd.sym} 600 360 0 0 {name=g64 lab=0}
C {lab_pin.sym} 600 300 0 0 {name=l65 sig_type=std_logic lab=osc_en}
C {sky130_stdcells/inv_1.sym} 850 300 0 0 {name=xosc_en VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 810 300 0 0 {name=l66 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} 890 300 0 1 {name=l67 sig_type=std_logic lab=osc_enb}
C {devices/vsource.sym} 600 530 0 0 {name=Vsel value="pwl(0 0 1 0)" savecurrent=false}
C {devices/gnd.sym} 600 560 0 0 {name=g68 lab=0}
C {lab_pin.sym} 600 500 0 0 {name=l69 sig_type=std_logic lab=thr_sel}
C {sky130_stdcells/inv_1.sym} 850 500 0 0 {name=xthr_sel VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 810 500 0 0 {name=l70 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} 890 500 0 1 {name=l71 sig_type=std_logic lab=thr_selb}
C {sky130_fd_pr/corner.sym} -500 -400 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 1100 -400 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8 ten=120u
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25
.option method=gear
.control
set filetype=binary
save rst vref veb3 x1.vpg
tran 0.2n 1250u 0 0.2n
write tog.raw
echo TOGDONE
.endc"}
