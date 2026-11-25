v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -430 190 -430 240 {lab=vpgt}
N -430 240 -390 240 {lab=vpgt}
N -390 220 -390 240 {lab=vpgt}
C {ota2s.sym} -90 200 0 0 {name=x1}
C {lab_pin.sym} -240 180 0 0 {name=p1 sig_type=std_logic lab=ib}
C {lab_pin.sym} -240 200 0 0 {name=p2 sig_type=std_logic lab=inn}
C {lab_pin.sym} -240 220 0 0 {name=p3 sig_type=std_logic lab=cm}
C {lab_pin.sym} 60 180 0 1 {name=p4 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 60 200 0 1 {name=p5 sig_type=std_logic lab=out}
C {gnd.sym} 60 220 0 0 {name=l1 lab=0}
C {lab_pin.sym} -430 240 0 0 {name=p6 sig_type=std_logic lab=vpgt}
C {lab_pin.sym} -390 160 0 1 {name=p7 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/corner.sym} -180 310 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 10 310 0 0 {name=s1 only_toplevel=false value=".param vdd=1.71
.temp 25
.option reltol=1e-6 vntol=1e-10
Vdd vdd 0 \{vdd\}
* door 1: input CM = V_EB(T) at 2.79 uA (spec lines 140, 147)
Bcm cm 0 V = 0.710 - 1.846e-3*(temper-25)
* door 2: PTAT bias, 1.40 uA at 25 C, sunk from IBIAS
Bib ib 0 I = 1.40e-6*(temper+273.15)/298.15
Vtgt vpgt 0 0.55
* servo: plays the bandgap loop, moves INN until out = vpgt
Esv inn cm out vpgt 1000
.control
option temp = -20
dc Vtgt 0.05 1.40 0.005
let lo70 = 0
let hi70 = 9
let vos = v(cm) - v(inn)
let dv = abs(deriv(vos))
let gdb = -20*log10(dv + 1e-12)
meas dc gmid find gdb at=0.55
meas dc lo70 when gdb=70 rise=1
meas dc hi70 when gdb=70 fall=last
meas dc g019 find gdb at=0.19
meas dc g095 find gdb at=0.95
meas dc vos028 find vos at=0.28
meas dc vos091 find vos at=0.91
let dfin_uV = (vos028 - vos091)*1e6
echo SWING A_at_055_dB=$&gmid lo70_V=$&lo70 hi70_V=$&hi70 A_at_019_dB=$&g019 A_at_095_dB=$&g095 dVos_028_to_091_uV=$&dfin_uV
wrdata swing.txt gdb vos
.endc
.endc"}
C {gnd.sym} -110 250 0 0 {name=lchop lab=0}
C {lab_pin.sym} -70 250 1 0 {name=pchopb sig_type=std_logic lab=vdd}
