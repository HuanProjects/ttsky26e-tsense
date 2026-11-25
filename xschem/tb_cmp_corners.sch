v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_cmp_corners: M6 section 3. Six cmp2s copies (cmp_tbcopy), each on its own bias diode (cmp_tbbias).
Rows: thresholds veb3 / vrefp / vref (.param). Columns: full slope sl and sl/2, both starting 0.4 V under.
Then per threshold: DC trip and every device's V_DS - V_dsat at the trip. Runner corner3.py sets corner, T, VDD, params, I_PTAT/2.} 40 -460 0 0 0.3 0.3 {}
T {copy 1: V_EB3 (veb3), full slope} 60 -90 0 0 0.25 0.25 {}
T {copy 2: V_EB3 (veb3), half slope} 860 -90 0 0 0.25 0.25 {}
T {copy 3: V_REF' (vrefp), full slope} 60 250 0 0 0.25 0.25 {}
T {copy 4: V_REF' (vrefp), half slope} 860 250 0 0 0.25 0.25 {}
T {copy 5: V_REF (vref), full slope} 60 590 0 0 0.25 0.25 {}
T {copy 6: V_REF (vref), half slope} 860 590 0 0 0.25 0.25 {}
N 330 110 350 110 {lab=nb1}
N 350 110 350 30 {lab=nb1}
N 80 -30 350 -30 {lab=vthr1}
N 200 -10 350 -10 {lab=vcap1}
N 1130 110 1150 110 {lab=nb2}
N 1150 110 1150 30 {lab=nb2}
N 880 -30 1150 -30 {lab=vthr2}
N 1000 -10 1150 -10 {lab=vcap2}
N 330 450 350 450 {lab=nb3}
N 350 450 350 370 {lab=nb3}
N 80 310 350 310 {lab=vthr3}
N 200 330 350 330 {lab=vcap3}
N 1130 450 1150 450 {lab=nb4}
N 1150 450 1150 370 {lab=nb4}
N 880 310 1150 310 {lab=vthr4}
N 1000 330 1150 330 {lab=vcap4}
N 330 790 350 790 {lab=nb5}
N 350 790 350 710 {lab=nb5}
N 80 650 350 650 {lab=vthr5}
N 200 670 350 670 {lab=vcap5}
N 1130 790 1150 790 {lab=nb6}
N 1150 790 1150 710 {lab=nb6}
N 880 650 1150 650 {lab=vthr6}
N 1000 670 1150 670 {lab=vcap6}
C {cmp_tbcopy.sym} 500 0 0 0 {name=xc1}
C {cmp_tbbias.sym} 240 130 0 0 {name=xb1}
C {lab_pin.sym} 350 110 0 1 {name=l1 sig_type=std_logic lab=nb1}
C {lab_pin.sym} 330 130 0 1 {name=l2 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 330 150 0 0 {name=g3 lab=0}
C {devices/vsource.sym} 80 0 0 0 {name=Vthr1 value="'veb3'" savecurrent=false}
C {devices/gnd.sym} 80 30 0 0 {name=g4 lab=0}
C {lab_pin.sym} 80 -30 0 0 {name=l5 sig_type=std_logic lab=vthr1}
C {devices/vsource.sym} 200 20 0 0 {name=Vcap1 value="dc 'veb3-0.4' pwl(0 'veb3-0.4' 0.3u 'veb3-0.4' '0.3e-6+0.46/sl' 'veb3+0.06')" savecurrent=false}
C {devices/gnd.sym} 200 50 0 0 {name=g6 lab=0}
C {lab_pin.sym} 200 -10 0 0 {name=l7 sig_type=std_logic lab=vcap1}
C {lab_pin.sym} 650 -30 0 1 {name=l8 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 650 0 0 1 {name=l9 sig_type=std_logic lab=cmp_raw1}
C {devices/gnd.sym} 650 30 0 0 {name=g10 lab=0}
C {cmp_tbcopy.sym} 1300 0 0 0 {name=xc2}
C {cmp_tbbias.sym} 1040 130 0 0 {name=xb2}
C {lab_pin.sym} 1150 110 0 1 {name=l11 sig_type=std_logic lab=nb2}
C {lab_pin.sym} 1130 130 0 1 {name=l12 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 1130 150 0 0 {name=g13 lab=0}
C {devices/vsource.sym} 880 0 0 0 {name=Vthr2 value="'veb3'" savecurrent=false}
C {devices/gnd.sym} 880 30 0 0 {name=g14 lab=0}
C {lab_pin.sym} 880 -30 0 0 {name=l15 sig_type=std_logic lab=vthr2}
C {devices/vsource.sym} 1000 20 0 0 {name=Vcap2 value="dc 'veb3-0.4' pwl(0 'veb3-0.4' 0.3u 'veb3-0.4' '0.3e-6+0.92/sl' 'veb3+0.06')" savecurrent=false}
C {devices/gnd.sym} 1000 50 0 0 {name=g16 lab=0}
C {lab_pin.sym} 1000 -10 0 0 {name=l17 sig_type=std_logic lab=vcap2}
C {lab_pin.sym} 1450 -30 0 1 {name=l18 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1450 0 0 1 {name=l19 sig_type=std_logic lab=cmp_raw2}
C {devices/gnd.sym} 1450 30 0 0 {name=g20 lab=0}
C {cmp_tbcopy.sym} 500 340 0 0 {name=xc3}
C {cmp_tbbias.sym} 240 470 0 0 {name=xb3}
C {lab_pin.sym} 350 450 0 1 {name=l21 sig_type=std_logic lab=nb3}
C {lab_pin.sym} 330 470 0 1 {name=l22 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 330 490 0 0 {name=g23 lab=0}
C {devices/vsource.sym} 80 340 0 0 {name=Vthr3 value="'vrefp'" savecurrent=false}
C {devices/gnd.sym} 80 370 0 0 {name=g24 lab=0}
C {lab_pin.sym} 80 310 0 0 {name=l25 sig_type=std_logic lab=vthr3}
C {devices/vsource.sym} 200 360 0 0 {name=Vcap3 value="dc 'vrefp-0.4' pwl(0 'vrefp-0.4' 0.3u 'vrefp-0.4' '0.3e-6+0.46/sl' 'vrefp+0.06')" savecurrent=false}
C {devices/gnd.sym} 200 390 0 0 {name=g26 lab=0}
C {lab_pin.sym} 200 330 0 0 {name=l27 sig_type=std_logic lab=vcap3}
C {lab_pin.sym} 650 310 0 1 {name=l28 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 650 340 0 1 {name=l29 sig_type=std_logic lab=cmp_raw3}
C {devices/gnd.sym} 650 370 0 0 {name=g30 lab=0}
C {cmp_tbcopy.sym} 1300 340 0 0 {name=xc4}
C {cmp_tbbias.sym} 1040 470 0 0 {name=xb4}
C {lab_pin.sym} 1150 450 0 1 {name=l31 sig_type=std_logic lab=nb4}
C {lab_pin.sym} 1130 470 0 1 {name=l32 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 1130 490 0 0 {name=g33 lab=0}
C {devices/vsource.sym} 880 340 0 0 {name=Vthr4 value="'vrefp'" savecurrent=false}
C {devices/gnd.sym} 880 370 0 0 {name=g34 lab=0}
C {lab_pin.sym} 880 310 0 0 {name=l35 sig_type=std_logic lab=vthr4}
C {devices/vsource.sym} 1000 360 0 0 {name=Vcap4 value="dc 'vrefp-0.4' pwl(0 'vrefp-0.4' 0.3u 'vrefp-0.4' '0.3e-6+0.92/sl' 'vrefp+0.06')" savecurrent=false}
C {devices/gnd.sym} 1000 390 0 0 {name=g36 lab=0}
C {lab_pin.sym} 1000 330 0 0 {name=l37 sig_type=std_logic lab=vcap4}
C {lab_pin.sym} 1450 310 0 1 {name=l38 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1450 340 0 1 {name=l39 sig_type=std_logic lab=cmp_raw4}
C {devices/gnd.sym} 1450 370 0 0 {name=g40 lab=0}
C {cmp_tbcopy.sym} 500 680 0 0 {name=xc5}
C {cmp_tbbias.sym} 240 810 0 0 {name=xb5}
C {lab_pin.sym} 350 790 0 1 {name=l41 sig_type=std_logic lab=nb5}
C {lab_pin.sym} 330 810 0 1 {name=l42 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 330 830 0 0 {name=g43 lab=0}
C {devices/vsource.sym} 80 680 0 0 {name=Vthr5 value="'vref'" savecurrent=false}
C {devices/gnd.sym} 80 710 0 0 {name=g44 lab=0}
C {lab_pin.sym} 80 650 0 0 {name=l45 sig_type=std_logic lab=vthr5}
C {devices/vsource.sym} 200 700 0 0 {name=Vcap5 value="dc 'vref-0.4' pwl(0 'vref-0.4' 0.3u 'vref-0.4' '0.3e-6+0.46/sl' 'vref+0.06')" savecurrent=false}
C {devices/gnd.sym} 200 730 0 0 {name=g46 lab=0}
C {lab_pin.sym} 200 670 0 0 {name=l47 sig_type=std_logic lab=vcap5}
C {lab_pin.sym} 650 650 0 1 {name=l48 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 650 680 0 1 {name=l49 sig_type=std_logic lab=cmp_raw5}
C {devices/gnd.sym} 650 710 0 0 {name=g50 lab=0}
C {cmp_tbcopy.sym} 1300 680 0 0 {name=xc6}
C {cmp_tbbias.sym} 1040 810 0 0 {name=xb6}
C {lab_pin.sym} 1150 790 0 1 {name=l51 sig_type=std_logic lab=nb6}
C {lab_pin.sym} 1130 810 0 1 {name=l52 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 1130 830 0 0 {name=g53 lab=0}
C {devices/vsource.sym} 880 680 0 0 {name=Vthr6 value="'vref'" savecurrent=false}
C {devices/gnd.sym} 880 710 0 0 {name=g54 lab=0}
C {lab_pin.sym} 880 650 0 0 {name=l55 sig_type=std_logic lab=vthr6}
C {devices/vsource.sym} 1000 700 0 0 {name=Vcap6 value="dc 'vref-0.4' pwl(0 'vref-0.4' 0.3u 'vref-0.4' '0.3e-6+0.92/sl' 'vref+0.06')" savecurrent=false}
C {devices/gnd.sym} 1000 730 0 0 {name=g56 lab=0}
C {lab_pin.sym} 1000 670 0 0 {name=l57 sig_type=std_logic lab=vcap6}
C {lab_pin.sym} 1450 650 0 1 {name=l58 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1450 680 0 1 {name=l59 sig_type=std_logic lab=cmp_raw6}
C {devices/gnd.sym} 1450 710 0 0 {name=g60 lab=0}
C {code_shown.sym} 1720 -330 0 0 {name=s1 only_toplevel=false value=".param vref=1.2432 veb3=0.7096 vrefp=0.9605 sl=0.274e6
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.option method=gear
.temp 25
.control
save all @m.xc1.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc1.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc1.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc1.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc1.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc1.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc1.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc1.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc1.xmnb3.msky130_fd_pr__nfet_01v8[vds] @m.xc1.xmnb3.msky130_fd_pr__nfet_01v8[vdsat] @m.xc2.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc2.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc2.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc2.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc2.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc2.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc2.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc2.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc2.xmnb3.msky130_fd_pr__nfet_01v8[vds] @m.xc2.xmnb3.msky130_fd_pr__nfet_01v8[vdsat] @m.xc3.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc3.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc3.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc3.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc3.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc3.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc3.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc3.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc3.xmnb3.msky130_fd_pr__nfet_01v8[vds] @m.xc3.xmnb3.msky130_fd_pr__nfet_01v8[vdsat] @m.xc4.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc4.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc4.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc4.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc4.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc4.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc4.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc4.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc4.xmnb3.msky130_fd_pr__nfet_01v8[vds] @m.xc4.xmnb3.msky130_fd_pr__nfet_01v8[vdsat] @m.xc5.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc5.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc5.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc5.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc5.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc5.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc5.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc5.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc5.xmnb3.msky130_fd_pr__nfet_01v8[vds] @m.xc5.xmnb3.msky130_fd_pr__nfet_01v8[vdsat] @m.xc6.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc6.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc6.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds] @m.xc6.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat] @m.xc6.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc6.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc6.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds] @m.xc6.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.xc6.xmnb3.msky130_fd_pr__nfet_01v8[vds] @m.xc6.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]
tran 0.2n 3.85u 0 0.2n
meas tran to1 when v(cmp_raw1)=0.9 rise=1
meas tran to2 when v(cmp_raw2)=0.9 rise=1
meas tran to3 when v(cmp_raw3)=0.9 rise=1
meas tran to4 when v(cmp_raw4)=0.9 rise=1
meas tran to5 when v(cmp_raw5)=0.9 rise=1
meas tran to6 when v(cmp_raw6)=0.9 rise=1
echo RESULT to1=$&to1 to2=$&to2 to3=$&to3 to4=$&to4 to5=$&to5 to6=$&to6
* V_DS - V_dsat (mV) of the key devices at the moment n2 crosses 0.9 V on the ramp
meas tran tf1 when v(xc1.ib_cmp2)=0.9 rise=1
let gm1a_1 = (abs(@m.xc1.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1a_1 find gm1a_1 at=$&tf1
let gm1b_1 = (abs(@m.xc1.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1b_1 find gm1b_1 at=$&tf1
let gm2b_1 = (abs(@m.xc1.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm2b_1 find gm2b_1 at=$&tf1
let gm3_1 = (abs(@m.xc1.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm3_1 find gm3_1 at=$&tf1
let gmnb3_1 = (abs(@m.xc1.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc1.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
meas tran fmnb3_1 find gmnb3_1 at=$&tf1
meas tran fn1_1 find v(xc1.x1.n1) at=$&tf1
meas tran ftl_1 find v(xc1.ib_cmp1) at=$&tf1
echo FLIP k=1 m1a=$&fm1a_1 m1b=$&fm1b_1 m2b=$&fm2b_1 m3=$&fm3_1 mnb3=$&fmnb3_1 n1=$&fn1_1 tail=$&ftl_1
meas tran tf2 when v(xc2.ib_cmp2)=0.9 rise=1
let gm1a_2 = (abs(@m.xc2.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc2.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1a_2 find gm1a_2 at=$&tf2
let gm1b_2 = (abs(@m.xc2.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc2.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1b_2 find gm1b_2 at=$&tf2
let gm2b_2 = (abs(@m.xc2.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc2.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm2b_2 find gm2b_2 at=$&tf2
let gm3_2 = (abs(@m.xc2.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc2.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm3_2 find gm3_2 at=$&tf2
let gmnb3_2 = (abs(@m.xc2.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc2.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
meas tran fmnb3_2 find gmnb3_2 at=$&tf2
meas tran fn1_2 find v(xc2.x1.n1) at=$&tf2
meas tran ftl_2 find v(xc2.ib_cmp1) at=$&tf2
echo FLIP k=2 m1a=$&fm1a_2 m1b=$&fm1b_2 m2b=$&fm2b_2 m3=$&fm3_2 mnb3=$&fmnb3_2 n1=$&fn1_2 tail=$&ftl_2
meas tran tf3 when v(xc3.ib_cmp2)=0.9 rise=1
let gm1a_3 = (abs(@m.xc3.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1a_3 find gm1a_3 at=$&tf3
let gm1b_3 = (abs(@m.xc3.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1b_3 find gm1b_3 at=$&tf3
let gm2b_3 = (abs(@m.xc3.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm2b_3 find gm2b_3 at=$&tf3
let gm3_3 = (abs(@m.xc3.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm3_3 find gm3_3 at=$&tf3
let gmnb3_3 = (abs(@m.xc3.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc3.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
meas tran fmnb3_3 find gmnb3_3 at=$&tf3
meas tran fn1_3 find v(xc3.x1.n1) at=$&tf3
meas tran ftl_3 find v(xc3.ib_cmp1) at=$&tf3
echo FLIP k=3 m1a=$&fm1a_3 m1b=$&fm1b_3 m2b=$&fm2b_3 m3=$&fm3_3 mnb3=$&fmnb3_3 n1=$&fn1_3 tail=$&ftl_3
meas tran tf4 when v(xc4.ib_cmp2)=0.9 rise=1
let gm1a_4 = (abs(@m.xc4.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc4.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1a_4 find gm1a_4 at=$&tf4
let gm1b_4 = (abs(@m.xc4.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc4.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1b_4 find gm1b_4 at=$&tf4
let gm2b_4 = (abs(@m.xc4.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc4.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm2b_4 find gm2b_4 at=$&tf4
let gm3_4 = (abs(@m.xc4.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc4.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm3_4 find gm3_4 at=$&tf4
let gmnb3_4 = (abs(@m.xc4.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc4.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
meas tran fmnb3_4 find gmnb3_4 at=$&tf4
meas tran fn1_4 find v(xc4.x1.n1) at=$&tf4
meas tran ftl_4 find v(xc4.ib_cmp1) at=$&tf4
echo FLIP k=4 m1a=$&fm1a_4 m1b=$&fm1b_4 m2b=$&fm2b_4 m3=$&fm3_4 mnb3=$&fmnb3_4 n1=$&fn1_4 tail=$&ftl_4
meas tran tf5 when v(xc5.ib_cmp2)=0.9 rise=1
let gm1a_5 = (abs(@m.xc5.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1a_5 find gm1a_5 at=$&tf5
let gm1b_5 = (abs(@m.xc5.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1b_5 find gm1b_5 at=$&tf5
let gm2b_5 = (abs(@m.xc5.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm2b_5 find gm2b_5 at=$&tf5
let gm3_5 = (abs(@m.xc5.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm3_5 find gm3_5 at=$&tf5
let gmnb3_5 = (abs(@m.xc5.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc5.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
meas tran fmnb3_5 find gmnb3_5 at=$&tf5
meas tran fn1_5 find v(xc5.x1.n1) at=$&tf5
meas tran ftl_5 find v(xc5.ib_cmp1) at=$&tf5
echo FLIP k=5 m1a=$&fm1a_5 m1b=$&fm1b_5 m2b=$&fm2b_5 m3=$&fm3_5 mnb3=$&fmnb3_5 n1=$&fn1_5 tail=$&ftl_5
meas tran tf6 when v(xc6.ib_cmp2)=0.9 rise=1
let gm1a_6 = (abs(@m.xc6.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc6.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1a_6 find gm1a_6 at=$&tf6
let gm1b_6 = (abs(@m.xc6.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc6.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
meas tran fm1b_6 find gm1b_6 at=$&tf6
let gm2b_6 = (abs(@m.xc6.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc6.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm2b_6 find gm2b_6 at=$&tf6
let gm3_6 = (abs(@m.xc6.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc6.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
meas tran fm3_6 find gm3_6 at=$&tf6
let gmnb3_6 = (abs(@m.xc6.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc6.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
meas tran fmnb3_6 find gmnb3_6 at=$&tf6
meas tran fn1_6 find v(xc6.x1.n1) at=$&tf6
meas tran ftl_6 find v(xc6.ib_cmp1) at=$&tf6
echo FLIP k=6 m1a=$&fm1a_6 m1b=$&fm1b_6 m2b=$&fm2b_6 m3=$&fm3_6 mnb3=$&fmnb3_6 n1=$&fn1_6 tail=$&ftl_6
* per threshold: static trip (DC sweep, 5 uV steps), then V_DS - V_dsat (mV) of every device at that trip
dc vcap1 0.7046 0.7146 5u
meas dc trip1 when v(cmp_raw1)=0.9 rise=1
echo RESULT trip1=$&trip1
alter @vcap1[dc] = $&trip1
op
let m1a_1 = (abs(@m.xc1.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
let m1b_1 = (abs(@m.xc1.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
let m2a_1 = (abs(@m.xc1.x1.xm2a.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm2a.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let m2b_1 = (abs(@m.xc1.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let m3_1 = (abs(@m.xc1.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc1.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let mnb3_1 = (abs(@m.xc1.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc1.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
let mnb4_1 = (abs(@m.xc1.xmnb4.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc1.xmnb4.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
let n1_1 = v(xc1.x1.n1)
let tl_1 = v(xc1.ib_cmp1)
let nd_1 = v(xc1.x1.nd)
echo MARGIN k=1 m1a=$&m1a_1 m1b=$&m1b_1 m2a=$&m2a_1 m2b=$&m2b_1 m3=$&m3_1 mnb3=$&mnb3_1 mnb4=$&mnb4_1 n1=$&n1_1 tail=$&tl_1 nd=$&nd_1
dc vcap3 0.9555 0.9655 5u
meas dc trip3 when v(cmp_raw3)=0.9 rise=1
echo RESULT trip3=$&trip3
alter @vcap3[dc] = $&trip3
op
let m1a_3 = (abs(@m.xc3.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
let m1b_3 = (abs(@m.xc3.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
let m2a_3 = (abs(@m.xc3.x1.xm2a.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm2a.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let m2b_3 = (abs(@m.xc3.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let m3_3 = (abs(@m.xc3.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc3.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let mnb3_3 = (abs(@m.xc3.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc3.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
let mnb4_3 = (abs(@m.xc3.xmnb4.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc3.xmnb4.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
let n1_3 = v(xc3.x1.n1)
let tl_3 = v(xc3.ib_cmp1)
let nd_3 = v(xc3.x1.nd)
echo MARGIN k=3 m1a=$&m1a_3 m1b=$&m1b_3 m2a=$&m2a_3 m2b=$&m2b_3 m3=$&m3_3 mnb3=$&mnb3_3 mnb4=$&mnb4_3 n1=$&n1_3 tail=$&tl_3 nd=$&nd_3
dc vcap5 1.2382 1.2482 5u
meas dc trip5 when v(cmp_raw5)=0.9 rise=1
echo RESULT trip5=$&trip5
alter @vcap5[dc] = $&trip5
op
let m1a_5 = (abs(@m.xc5.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm1a.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
let m1b_5 = (abs(@m.xc5.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm1b.msky130_fd_pr__nfet_01v8_lvt[vdsat]))*1e3
let m2a_5 = (abs(@m.xc5.x1.xm2a.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm2a.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let m2b_5 = (abs(@m.xc5.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm2b.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let m3_5 = (abs(@m.xc5.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.xc5.x1.xm3.msky130_fd_pr__pfet_01v8_lvt[vdsat]))*1e3
let mnb3_5 = (abs(@m.xc5.xmnb3.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc5.xmnb3.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
let mnb4_5 = (abs(@m.xc5.xmnb4.msky130_fd_pr__nfet_01v8[vds]) - abs(@m.xc5.xmnb4.msky130_fd_pr__nfet_01v8[vdsat]))*1e3
let n1_5 = v(xc5.x1.n1)
let tl_5 = v(xc5.ib_cmp1)
let nd_5 = v(xc5.x1.nd)
echo MARGIN k=5 m1a=$&m1a_5 m1b=$&m1b_5 m2a=$&m2a_5 m2b=$&m2b_5 m3=$&m3_5 mnb3=$&mnb3_5 mnb4=$&mnb4_5 n1=$&n1_5 tail=$&tl_5 nd=$&nd_5
.endc"}
C {devices/vsource.sym} 60 -280 0 0 {name=Vdd value=1.8 savecurrent=false}
C {devices/gnd.sym} 60 -250 0 0 {name=g61 lab=0}
C {lab_pin.sym} 60 -310 0 0 {name=l62 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/corner.sym} 200 -330 0 0 {name=CORNER only_toplevel=false corner=tt}
