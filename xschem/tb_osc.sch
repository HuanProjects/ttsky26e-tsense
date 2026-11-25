v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_osc: M6 section 9. osc_core on the frozen bgr, state A (ich_sel 0, i3_sel 0, chop A). Supply ramp 0 -> vdd in 1 us,
osc_en at ten, thr_sel REF -> EB at tsw. 2 pF decap on vref, 40 fF wire on each comparator sink. Runner osc9.py sets
corner, T, VDD and the times; it can add 30 fF on bgr's ichb (spec R4).} -500 -560 0 0 0.3 0.3 {}
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
C {devices/vsource.sym} -500 -100 0 0 {name=Vdd value="pwl(0 0 1u 'vdd')" savecurrent=false}
C {devices/gnd.sym} -500 -70 0 0 {name=g33 lab=0}
C {lab_pin.sym} -500 -130 0 0 {name=l34 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} -400 300 0 0 {name=Vichon value="0" savecurrent=false}
C {lab_pin.sym} -400 270 0 0 {name=l35 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} -400 330 0 0 {name=l36 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} -310 300 0 0 {name=Vichonb value="0" savecurrent=false}
C {lab_pin.sym} -310 270 0 0 {name=l37 sig_type=std_logic lab=ich_onb}
C {devices/gnd.sym} -310 330 0 0 {name=g38 lab=0}
C {devices/vsource.sym} -220 300 0 0 {name=Vichdump value="0" savecurrent=false}
C {lab_pin.sym} -220 270 0 0 {name=l39 sig_type=std_logic lab=ich_dump}
C {devices/gnd.sym} -220 330 0 0 {name=g40 lab=0}
C {devices/vsource.sym} -130 300 0 0 {name=Vi3on value="0" savecurrent=false}
C {lab_pin.sym} -130 270 0 0 {name=l41 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} -130 330 0 0 {name=l42 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} -40 300 0 0 {name=Vi3onb value="0" savecurrent=false}
C {lab_pin.sym} -40 270 0 0 {name=l43 sig_type=std_logic lab=i3_onb}
C {devices/gnd.sym} -40 330 0 0 {name=g44 lab=0}
C {devices/vsource.sym} 50 300 0 0 {name=Vi3dump value="0" savecurrent=false}
C {lab_pin.sym} 50 270 0 0 {name=l45 sig_type=std_logic lab=i3_dump}
C {devices/gnd.sym} 50 330 0 0 {name=g46 lab=0}
C {devices/vsource.sym} 140 300 0 0 {name=Vswa value="0" savecurrent=false}
C {lab_pin.sym} 140 270 0 0 {name=l47 sig_type=std_logic lab=swa}
C {lab_pin.sym} 140 330 0 0 {name=l48 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} 230 300 0 0 {name=Vswb value="0" savecurrent=false}
C {lab_pin.sym} 230 270 0 0 {name=l49 sig_type=std_logic lab=swb}
C {devices/gnd.sym} 230 330 0 0 {name=g50 lab=0}
C {devices/vsource.sym} 320 300 0 0 {name=Vchop value="0" savecurrent=false}
C {lab_pin.sym} 320 270 0 0 {name=l51 sig_type=std_logic lab=chop}
C {devices/gnd.sym} 320 330 0 0 {name=g52 lab=0}
C {devices/vsource.sym} 410 300 0 0 {name=Vchopb value="0" savecurrent=false}
C {lab_pin.sym} 410 270 0 0 {name=l53 sig_type=std_logic lab=chopb}
C {lab_pin.sym} 410 330 0 0 {name=l54 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} -400 500 0 0 {name=Vmon value="0.7" savecurrent=false}
C {lab_pin.sym} -400 470 0 0 {name=l55 sig_type=std_logic lab=iptat_mon}
C {devices/gnd.sym} -400 530 0 0 {name=g56 lab=0}
C {devices/capa.sym} -250 500 0 0 {name=Cdec
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -250 470 0 0 {name=l57 sig_type=std_logic lab=vref}
C {devices/gnd.sym} -250 530 0 0 {name=g58 lab=0}
C {devices/capa.sym} -120 500 0 0 {name=Cw1
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -120 470 0 0 {name=l59 sig_type=std_logic lab=ib_cmp1}
C {devices/gnd.sym} -120 530 0 0 {name=g60 lab=0}
C {devices/capa.sym} 10 500 0 0 {name=Cw2
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 10 470 0 0 {name=l61 sig_type=std_logic lab=ib_cmp2}
C {devices/gnd.sym} 10 530 0 0 {name=g62 lab=0}
C {devices/vsource.sym} 600 330 0 0 {name=Ven value="pwl(0 0 'ten' 0 'ten+0.2n' 'vdd')" savecurrent=false}
C {devices/gnd.sym} 600 360 0 0 {name=g63 lab=0}
C {lab_pin.sym} 600 300 0 0 {name=l64 sig_type=std_logic lab=osc_en}
C {sky130_stdcells/inv_1.sym} 850 300 0 0 {name=xosc_en VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 810 300 0 0 {name=l65 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} 890 300 0 1 {name=l66 sig_type=std_logic lab=osc_enb}
C {devices/vsource.sym} 600 530 0 0 {name=Vsel value="pwl(0 0 'tsw' 0 'tsw+0.2n' 'vdd')" savecurrent=false}
C {devices/gnd.sym} 600 560 0 0 {name=g67 lab=0}
C {lab_pin.sym} 600 500 0 0 {name=l68 sig_type=std_logic lab=thr_sel}
C {sky130_stdcells/inv_1.sym} 850 500 0 0 {name=xthr_sel VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 810 500 0 0 {name=l69 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} 890 500 0 1 {name=l70 sig_type=std_logic lab=thr_selb}
C {sky130_fd_pr/corner.sym} -500 -400 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 1100 -400 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8 ten=120u tsw=180.6u
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25
.option method=gear
.control
save vcap x2.vthr rst cmp_raw x2.xos.sw vref veb3 x1.xcore.nb vdd#branch
tran 0.2n 225u 0 0.2n
let ten = 120u
let tq0 = 100u
let tr0 = 135u
let tw0 = 175u
let tsw = 180.6u
let te0 = 205u
let tend = 225u
let tdr = 168u
let tde = 210u
meas tran r1 when v(rst)=0.9 rise=1
print r1
meas tran r2 when v(rst)=0.9 rise=2
print r2
meas tran r3 when v(rst)=0.9 rise=3
print r3
meas tran r4 when v(rst)=0.9 rise=4
print r4
meas tran r5 when v(rst)=0.9 rise=5
print r5
meas tran r6 when v(rst)=0.9 rise=6
print r6
meas tran r7 when v(rst)=0.9 rise=7
print r7
meas tran r8 when v(rst)=0.9 rise=8
print r8
meas tran r9 when v(rst)=0.9 rise=9
print r9
meas tran r10 when v(rst)=0.9 rise=10
print r10
meas tran r11 when v(rst)=0.9 rise=11
print r11
meas tran r12 when v(rst)=0.9 rise=12
print r12
meas tran r13 when v(rst)=0.9 rise=13
print r13
meas tran r14 when v(rst)=0.9 rise=14
print r14
meas tran r15 when v(rst)=0.9 rise=15
print r15
meas tran r16 when v(rst)=0.9 rise=16
print r16
meas tran r17 when v(rst)=0.9 rise=17
print r17
meas tran r18 when v(rst)=0.9 rise=18
print r18
meas tran r19 when v(rst)=0.9 rise=19
print r19
meas tran r20 when v(rst)=0.9 rise=20
print r20
meas tran r21 when v(rst)=0.9 rise=21
print r21
meas tran r22 when v(rst)=0.9 rise=22
print r22
meas tran r23 when v(rst)=0.9 rise=23
print r23
meas tran r24 when v(rst)=0.9 rise=24
print r24
meas tran r25 when v(rst)=0.9 rise=25
print r25
meas tran r26 when v(rst)=0.9 rise=26
print r26
meas tran r27 when v(rst)=0.9 rise=27
print r27
meas tran r28 when v(rst)=0.9 rise=28
print r28
meas tran r29 when v(rst)=0.9 rise=29
print r29
meas tran r30 when v(rst)=0.9 rise=30
print r30
meas tran r31 when v(rst)=0.9 rise=31
print r31
meas tran r32 when v(rst)=0.9 rise=32
print r32
meas tran tc when v(vcap)=v(x2.vthr) rise=1 td=$&tdr
meas tran tcmp when v(cmp_raw)=0.9 rise=1 td=$&tc
meas tran tswon when v(x2.xos.sw)=0.9 rise=1 td=$&tc
meas tran tswoff when v(x2.xos.sw)=0.9 fall=1 td=$&tc
meas tran vth find v(x2.vthr) at=$&tc
meas tran vrc find v(vref) at=$&tc
let tto = tswoff + 300n
meas tran vmin min v(vcap) from=$&tswoff to=$&tto
let dtd = tcmp - tc
let dlog = tswon - tcmp
let don = tswoff - tswon
let dtau = tswoff - tc
echo TAU ph=REF td=$&dtd tlog=$&dlog ton=$&don tau=$&dtau vth=$&vth vrc=$&vrc vmin=$&vmin
meas tran tc when v(vcap)=v(x2.vthr) rise=1 td=$&tde
meas tran tcmp when v(cmp_raw)=0.9 rise=1 td=$&tc
meas tran tswon when v(x2.xos.sw)=0.9 rise=1 td=$&tc
meas tran tswoff when v(x2.xos.sw)=0.9 fall=1 td=$&tc
meas tran vth find v(x2.vthr) at=$&tc
meas tran vrc find v(vref) at=$&tc
let tto = tswoff + 300n
meas tran vmin min v(vcap) from=$&tswoff to=$&tto
let dtd = tcmp - tc
let dlog = tswon - tcmp
let don = tswoff - tswon
let dtau = tswoff - tc
echo TAU ph=EB td=$&dtd tlog=$&dlog ton=$&don tau=$&dtau vth=$&vth vrc=$&vrc vmin=$&vmin
meas tran vref_a avg v(vref) from=$&tq0 to=$&ten
meas tran veb_a avg v(veb3) from=$&tq0 to=$&ten
meas tran nb_a avg v(x1.xcore.nb) from=$&tq0 to=$&ten
meas tran iq avg i(vdd) from=$&tq0 to=$&ten
meas tran vref_r avg v(vref) from=$&tr0 to=$&tsw
meas tran veb_r avg v(veb3) from=$&tr0 to=$&tsw
meas tran nb_r avg v(x1.xcore.nb) from=$&tr0 to=$&tsw
meas tran ir avg i(vdd) from=$&tr0 to=$&tsw
meas tran vref_hi max v(vref) from=$&tw0 to=$&tsw
meas tran vref_lo min v(vref) from=$&tw0 to=$&tsw
meas tran nb_hi max v(x1.xcore.nb) from=$&tw0 to=$&tsw
meas tran nb_lo min v(x1.xcore.nb) from=$&tw0 to=$&tsw
meas tran veb_e avg v(veb3) from=$&te0 to=$&tend
echo DC vref_a=$&vref_a veb_a=$&veb_a nb_a=$&nb_a iq=$&iq vref_r=$&vref_r veb_r=$&veb_r nb_r=$&nb_r ir=$&ir vref_hi=$&vref_hi vref_lo=$&vref_lo nb_hi=$&nb_hi nb_lo=$&nb_lo veb_e=$&veb_e
let dvref = vref_r - vref_a
let dveb = veb_e - veb_a
let dnb = nb_r - nb_a
let dir = ir - iq
echo DC2 dvref=$&dvref dveb=$&dveb dnb=$&dnb dir=$&dir
.endc"}
