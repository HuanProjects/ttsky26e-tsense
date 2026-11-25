v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_cmp_slopes: M6 section 2. Nine cmp2s copies (cmp_tbcopy), each with its own bias diode (cmp_tbbias), tt, 25 C, 1.80 V.
Rows: thresholds V_EB3 / V_REF' / V_REF. Columns: full, half and s/20 ramps; the full and half ramps start 0.4 V under, the slow one 15 mV under.
Then a DC sweep of each slow copy gives the static offset. Runner: slopes2.py (also runs the shared-diode variant).} 40 -460 0 0 0.3 0.3 {}
T {copy 1: V_EB3 0.7096 V, full slope 0.274 V/us} 60 -90 0 0 0.25 0.25 {}
T {copy 2: V_EB3 0.7096 V, half slope 0.137 V/us} 860 -90 0 0 0.25 0.25 {}
T {copy 3: V_EB3 0.7096 V, slow s/20 0.0137 V/us} 1660 -90 0 0 0.25 0.25 {}
T {copy 4: V_REF' 0.9605 V, full slope 0.274 V/us} 60 250 0 0 0.25 0.25 {}
T {copy 5: V_REF' 0.9605 V, half slope 0.137 V/us} 860 250 0 0 0.25 0.25 {}
T {copy 6: V_REF' 0.9605 V, slow s/20 0.0137 V/us} 1660 250 0 0 0.25 0.25 {}
T {copy 7: V_REF 1.2432 V, full slope 0.274 V/us} 60 590 0 0 0.25 0.25 {}
T {copy 8: V_REF 1.2432 V, half slope 0.137 V/us} 860 590 0 0 0.25 0.25 {}
T {copy 9: V_REF 1.2432 V, slow s/20 0.0137 V/us} 1660 590 0 0 0.25 0.25 {}
N 330 110 350 110 {lab=nb1}
N 350 110 350 30 {lab=nb1}
N 80 -30 350 -30 {lab=vthr1}
N 200 -10 350 -10 {lab=vcap1}
N 1130 110 1150 110 {lab=nb2}
N 1150 110 1150 30 {lab=nb2}
N 880 -30 1150 -30 {lab=vthr2}
N 1000 -10 1150 -10 {lab=vcap2}
N 1930 110 1950 110 {lab=nb3}
N 1950 110 1950 30 {lab=nb3}
N 1680 -30 1950 -30 {lab=vthr3}
N 1800 -10 1950 -10 {lab=vcap3}
N 330 450 350 450 {lab=nb4}
N 350 450 350 370 {lab=nb4}
N 80 310 350 310 {lab=vthr4}
N 200 330 350 330 {lab=vcap4}
N 1130 450 1150 450 {lab=nb5}
N 1150 450 1150 370 {lab=nb5}
N 880 310 1150 310 {lab=vthr5}
N 1000 330 1150 330 {lab=vcap5}
N 1930 450 1950 450 {lab=nb6}
N 1950 450 1950 370 {lab=nb6}
N 1680 310 1950 310 {lab=vthr6}
N 1800 330 1950 330 {lab=vcap6}
N 330 790 350 790 {lab=nb7}
N 350 790 350 710 {lab=nb7}
N 80 650 350 650 {lab=vthr7}
N 200 670 350 670 {lab=vcap7}
N 1130 790 1150 790 {lab=nb8}
N 1150 790 1150 710 {lab=nb8}
N 880 650 1150 650 {lab=vthr8}
N 1000 670 1150 670 {lab=vcap8}
N 1930 790 1950 790 {lab=nb9}
N 1950 790 1950 710 {lab=nb9}
N 1680 650 1950 650 {lab=vthr9}
N 1800 670 1950 670 {lab=vcap9}
C {cmp_tbcopy.sym} 500 0 0 0 {name=xc1}
C {cmp_tbbias.sym} 240 130 0 0 {name=xb1}
C {lab_pin.sym} 350 110 0 1 {name=l1 sig_type=std_logic lab=nb1}
C {lab_pin.sym} 330 130 0 1 {name=l2 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 330 150 0 0 {name=g3 lab=0}
C {devices/vsource.sym} 80 0 0 0 {name=Vthr1 value=0.7096 savecurrent=false}
C {devices/gnd.sym} 80 30 0 0 {name=g4 lab=0}
C {lab_pin.sym} 80 -30 0 0 {name=l5 sig_type=std_logic lab=vthr1}
C {devices/vsource.sym} 200 20 0 0 {name=Vcap1 value="dc 0.3096 pwl(0 0.3096 0.3u 0.3096 1.978832u 0.7696)" savecurrent=false}
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
C {devices/vsource.sym} 880 0 0 0 {name=Vthr2 value=0.7096 savecurrent=false}
C {devices/gnd.sym} 880 30 0 0 {name=g14 lab=0}
C {lab_pin.sym} 880 -30 0 0 {name=l15 sig_type=std_logic lab=vthr2}
C {devices/vsource.sym} 1000 20 0 0 {name=Vcap2 value="dc 0.3096 pwl(0 0.3096 0.3u 0.3096 3.657664u 0.7696)" savecurrent=false}
C {devices/gnd.sym} 1000 50 0 0 {name=g16 lab=0}
C {lab_pin.sym} 1000 -10 0 0 {name=l17 sig_type=std_logic lab=vcap2}
C {lab_pin.sym} 1450 -30 0 1 {name=l18 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1450 0 0 1 {name=l19 sig_type=std_logic lab=cmp_raw2}
C {devices/gnd.sym} 1450 30 0 0 {name=g20 lab=0}
C {cmp_tbcopy.sym} 2100 0 0 0 {name=xc3}
C {cmp_tbbias.sym} 1840 130 0 0 {name=xb3}
C {lab_pin.sym} 1950 110 0 1 {name=l21 sig_type=std_logic lab=nb3}
C {lab_pin.sym} 1930 130 0 1 {name=l22 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 1930 150 0 0 {name=g23 lab=0}
C {devices/vsource.sym} 1680 0 0 0 {name=Vthr3 value=0.7096 savecurrent=false}
C {devices/gnd.sym} 1680 30 0 0 {name=g24 lab=0}
C {lab_pin.sym} 1680 -30 0 0 {name=l25 sig_type=std_logic lab=vthr3}
C {devices/vsource.sym} 1800 20 0 0 {name=Vcap3 value="dc 0.6946 pwl(0 0.6946 0.3u 0.6946 2.270803u 0.7216)" savecurrent=false}
C {devices/gnd.sym} 1800 50 0 0 {name=g26 lab=0}
C {lab_pin.sym} 1800 -10 0 0 {name=l27 sig_type=std_logic lab=vcap3}
C {lab_pin.sym} 2250 -30 0 1 {name=l28 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 2250 0 0 1 {name=l29 sig_type=std_logic lab=cmp_raw3}
C {devices/gnd.sym} 2250 30 0 0 {name=g30 lab=0}
C {cmp_tbcopy.sym} 500 340 0 0 {name=xc4}
C {cmp_tbbias.sym} 240 470 0 0 {name=xb4}
C {lab_pin.sym} 350 450 0 1 {name=l31 sig_type=std_logic lab=nb4}
C {lab_pin.sym} 330 470 0 1 {name=l32 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 330 490 0 0 {name=g33 lab=0}
C {devices/vsource.sym} 80 340 0 0 {name=Vthr4 value=0.9605 savecurrent=false}
C {devices/gnd.sym} 80 370 0 0 {name=g34 lab=0}
C {lab_pin.sym} 80 310 0 0 {name=l35 sig_type=std_logic lab=vthr4}
C {devices/vsource.sym} 200 360 0 0 {name=Vcap4 value="dc 0.5605 pwl(0 0.5605 0.3u 0.5605 1.978832u 1.0205)" savecurrent=false}
C {devices/gnd.sym} 200 390 0 0 {name=g36 lab=0}
C {lab_pin.sym} 200 330 0 0 {name=l37 sig_type=std_logic lab=vcap4}
C {lab_pin.sym} 650 310 0 1 {name=l38 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 650 340 0 1 {name=l39 sig_type=std_logic lab=cmp_raw4}
C {devices/gnd.sym} 650 370 0 0 {name=g40 lab=0}
C {cmp_tbcopy.sym} 1300 340 0 0 {name=xc5}
C {cmp_tbbias.sym} 1040 470 0 0 {name=xb5}
C {lab_pin.sym} 1150 450 0 1 {name=l41 sig_type=std_logic lab=nb5}
C {lab_pin.sym} 1130 470 0 1 {name=l42 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 1130 490 0 0 {name=g43 lab=0}
C {devices/vsource.sym} 880 340 0 0 {name=Vthr5 value=0.9605 savecurrent=false}
C {devices/gnd.sym} 880 370 0 0 {name=g44 lab=0}
C {lab_pin.sym} 880 310 0 0 {name=l45 sig_type=std_logic lab=vthr5}
C {devices/vsource.sym} 1000 360 0 0 {name=Vcap5 value="dc 0.5605 pwl(0 0.5605 0.3u 0.5605 3.657664u 1.0205)" savecurrent=false}
C {devices/gnd.sym} 1000 390 0 0 {name=g46 lab=0}
C {lab_pin.sym} 1000 330 0 0 {name=l47 sig_type=std_logic lab=vcap5}
C {lab_pin.sym} 1450 310 0 1 {name=l48 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1450 340 0 1 {name=l49 sig_type=std_logic lab=cmp_raw5}
C {devices/gnd.sym} 1450 370 0 0 {name=g50 lab=0}
C {cmp_tbcopy.sym} 2100 340 0 0 {name=xc6}
C {cmp_tbbias.sym} 1840 470 0 0 {name=xb6}
C {lab_pin.sym} 1950 450 0 1 {name=l51 sig_type=std_logic lab=nb6}
C {lab_pin.sym} 1930 470 0 1 {name=l52 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 1930 490 0 0 {name=g53 lab=0}
C {devices/vsource.sym} 1680 340 0 0 {name=Vthr6 value=0.9605 savecurrent=false}
C {devices/gnd.sym} 1680 370 0 0 {name=g54 lab=0}
C {lab_pin.sym} 1680 310 0 0 {name=l55 sig_type=std_logic lab=vthr6}
C {devices/vsource.sym} 1800 360 0 0 {name=Vcap6 value="dc 0.9455 pwl(0 0.9455 0.3u 0.9455 2.270803u 0.9725)" savecurrent=false}
C {devices/gnd.sym} 1800 390 0 0 {name=g56 lab=0}
C {lab_pin.sym} 1800 330 0 0 {name=l57 sig_type=std_logic lab=vcap6}
C {lab_pin.sym} 2250 310 0 1 {name=l58 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 2250 340 0 1 {name=l59 sig_type=std_logic lab=cmp_raw6}
C {devices/gnd.sym} 2250 370 0 0 {name=g60 lab=0}
C {cmp_tbcopy.sym} 500 680 0 0 {name=xc7}
C {cmp_tbbias.sym} 240 810 0 0 {name=xb7}
C {lab_pin.sym} 350 790 0 1 {name=l61 sig_type=std_logic lab=nb7}
C {lab_pin.sym} 330 810 0 1 {name=l62 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 330 830 0 0 {name=g63 lab=0}
C {devices/vsource.sym} 80 680 0 0 {name=Vthr7 value=1.2432 savecurrent=false}
C {devices/gnd.sym} 80 710 0 0 {name=g64 lab=0}
C {lab_pin.sym} 80 650 0 0 {name=l65 sig_type=std_logic lab=vthr7}
C {devices/vsource.sym} 200 700 0 0 {name=Vcap7 value="dc 0.8432 pwl(0 0.8432 0.3u 0.8432 1.978832u 1.3032)" savecurrent=false}
C {devices/gnd.sym} 200 730 0 0 {name=g66 lab=0}
C {lab_pin.sym} 200 670 0 0 {name=l67 sig_type=std_logic lab=vcap7}
C {lab_pin.sym} 650 650 0 1 {name=l68 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 650 680 0 1 {name=l69 sig_type=std_logic lab=cmp_raw7}
C {devices/gnd.sym} 650 710 0 0 {name=g70 lab=0}
C {cmp_tbcopy.sym} 1300 680 0 0 {name=xc8}
C {cmp_tbbias.sym} 1040 810 0 0 {name=xb8}
C {lab_pin.sym} 1150 790 0 1 {name=l71 sig_type=std_logic lab=nb8}
C {lab_pin.sym} 1130 810 0 1 {name=l72 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 1130 830 0 0 {name=g73 lab=0}
C {devices/vsource.sym} 880 680 0 0 {name=Vthr8 value=1.2432 savecurrent=false}
C {devices/gnd.sym} 880 710 0 0 {name=g74 lab=0}
C {lab_pin.sym} 880 650 0 0 {name=l75 sig_type=std_logic lab=vthr8}
C {devices/vsource.sym} 1000 700 0 0 {name=Vcap8 value="dc 0.8432 pwl(0 0.8432 0.3u 0.8432 3.657664u 1.3032)" savecurrent=false}
C {devices/gnd.sym} 1000 730 0 0 {name=g76 lab=0}
C {lab_pin.sym} 1000 670 0 0 {name=l77 sig_type=std_logic lab=vcap8}
C {lab_pin.sym} 1450 650 0 1 {name=l78 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 1450 680 0 1 {name=l79 sig_type=std_logic lab=cmp_raw8}
C {devices/gnd.sym} 1450 710 0 0 {name=g80 lab=0}
C {cmp_tbcopy.sym} 2100 680 0 0 {name=xc9}
C {cmp_tbbias.sym} 1840 810 0 0 {name=xb9}
C {lab_pin.sym} 1950 790 0 1 {name=l81 sig_type=std_logic lab=nb9}
C {lab_pin.sym} 1930 810 0 1 {name=l82 sig_type=std_logic lab=VDPWR}
C {devices/gnd.sym} 1930 830 0 0 {name=g83 lab=0}
C {devices/vsource.sym} 1680 680 0 0 {name=Vthr9 value=1.2432 savecurrent=false}
C {devices/gnd.sym} 1680 710 0 0 {name=g84 lab=0}
C {lab_pin.sym} 1680 650 0 0 {name=l85 sig_type=std_logic lab=vthr9}
C {devices/vsource.sym} 1800 700 0 0 {name=Vcap9 value="dc 1.2282 pwl(0 1.2282 0.3u 1.2282 2.270803u 1.2552)" savecurrent=false}
C {devices/gnd.sym} 1800 730 0 0 {name=g86 lab=0}
C {lab_pin.sym} 1800 670 0 0 {name=l87 sig_type=std_logic lab=vcap9}
C {lab_pin.sym} 2250 650 0 1 {name=l88 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 2250 680 0 1 {name=l89 sig_type=std_logic lab=cmp_raw9}
C {devices/gnd.sym} 2250 710 0 0 {name=g90 lab=0}
C {code_shown.sym} 2520 -330 0 0 {name=s1 only_toplevel=false value=".include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.option method=gear
.temp 25
.control
tran 0.2n 3.85u 0 0.2n
meas tran to1 when v(cmp_raw1)=0.9 rise=1
meas tran to2 when v(cmp_raw2)=0.9 rise=1
meas tran to3 when v(cmp_raw3)=0.9 rise=1
meas tran to4 when v(cmp_raw4)=0.9 rise=1
meas tran to5 when v(cmp_raw5)=0.9 rise=1
meas tran to6 when v(cmp_raw6)=0.9 rise=1
meas tran to7 when v(cmp_raw7)=0.9 rise=1
meas tran to8 when v(cmp_raw8)=0.9 rise=1
meas tran to9 when v(cmp_raw9)=0.9 rise=1
meas tran nb0 find v(nb1) at=0.9u
meas tran nbmax max v(nb1) from=1u to=3.85u
meas tran nbmin min v(nb1) from=1u to=3.85u
echo RESULT to1=$&to1 to2=$&to2 to3=$&to3 to4=$&to4 to5=$&to5 to6=$&to6 to7=$&to7 to8=$&to8 to9=$&to9 nb0=$&nb0 nbmax=$&nbmax nbmin=$&nbmin
* static offset: DC sweep of each slow copy's vcap across its threshold (5 uV steps)
dc vcap3 0.7046 0.7146 5u
meas dc trip3 when v(cmp_raw3)=0.9 rise=1
echo RESULT trip3=$&trip3
dc vcap6 0.9555 0.9655 5u
meas dc trip6 when v(cmp_raw6)=0.9 rise=1
echo RESULT trip6=$&trip6
dc vcap9 1.2382 1.2482 5u
meas dc trip9 when v(cmp_raw9)=0.9 rise=1
echo RESULT trip9=$&trip9
.endc"}
C {devices/vsource.sym} 60 -280 0 0 {name=Vdd value=1.8 savecurrent=false}
C {devices/gnd.sym} 60 -250 0 0 {name=g91 lab=0}
C {lab_pin.sym} 60 -310 0 0 {name=l92 sig_type=std_logic lab=VDPWR}
C {sky130_fd_pr/corner.sym} 200 -330 0 0 {name=CORNER only_toplevel=false corner=tt}
