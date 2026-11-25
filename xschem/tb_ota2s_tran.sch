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
C {lab_pin.sym} -240 220 0 0 {name=p3 sig_type=std_logic lab=inp}
C {lab_pin.sym} 60 180 0 1 {name=p4 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 60 200 0 1 {name=p5 sig_type=std_logic lab=out}
C {gnd.sym} 60 220 0 0 {name=l1 lab=0}
C {sky130_fd_pr/pfet3_01v8.sym} -410 190 0 0 {name=MR
W=8.8
L=20
body=VDD
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {lab_pin.sym} -430 240 0 0 {name=p6 sig_type=std_logic lab=vpgt}
C {lab_pin.sym} -390 160 0 1 {name=p7 sig_type=std_logic lab=vdd}
C {sky130_fd_pr/corner.sym} -180 310 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 0 310 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8
.temp 25
Vdd vdd 0 \{vdd\}
* door 1: input CM = V_EB(T) at 2.79 uA (spec lines 140, 147)
Bcm cm 0 V = 0.710 - 1.846e-3*(temper-25)
* door 2: PTAT bias, 1.40 uA at 25 C, sunk from IBIAS
Bib ib 0 I = 1.40e-6*(temper+273.15)/298.15
* door 4: replica P1 carries I_PTAT -> its gate is the vpg target
Brp vpgt 0 I = 2.79e-6*(temper+273.15)/298.15
* AC test signal on INP, through the core's node-B impedance
Vst sa cm pwl(0 0 20u 0 20.01u 1m)
RsB sa inp 28.7k
* servo: closed at DC (Lsv shorts), open at AC (Lsv opens, Csv grounds s)
Bdn sn 0 V = v(cm) + 0.44*(v(out)-v(vpgt))
RsA sn inn 9.2k
* the PMOS gate line the op-amp drives in the bandgap
CL out 0 25p
.control
tran 10n 80u
meas tran vpre find v(out) at=19u
meas tran vfin find v(out) at=79u
let step_mV = (vfin - vpre)*1000
let lo = vfin - 0.001*(vfin - vpre)
meas tran t_in when v(out)=$&lo cross=LAST
let settle_us = (t_in - 20.01u)*1e6
meas tran vpk max v(out) from=20u to=80u
let over_pct = (vpk - vfin)/(vfin - vpre)*100
print step_mV settle_us over_pct
wrdata step.txt v(out)
.endc"}
C {gnd.sym} -110 250 0 0 {name=lchop lab=0}
C {lab_pin.sym} -70 250 1 0 {name=pchopb sig_type=std_logic lab=vdd}
