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
C {code_shown.sym} 10 310 0 0 {name=s1 only_toplevel=false value=".param vdd=1.71
.temp 25
.option reltol=1e-5 vntol=1e-9
Vdd vdd 0 \{vdd\}
* door 1: input CM = V_EB(T) at 2.79 uA (spec lines 140, 147)
Vcmx cm 0 0.71
* door 2: PTAT bias, 1.40 uA at 25 C, sunk from IBIAS
Bib ib 0 I = 1.40e-6*(temper+273.15)/298.15
* door 4: replica P1 carries I_PTAT -> its gate is the vpg target
Brp vpgt 0 I = 2.79e-6*(temper+273.15)/298.15
* servo: plays the bandgap loop, moves INN until out = vpgt
Esv inn cm out vpgt 1000
.control
option temp = -20
save all
save @m.x1.xmtail.msky130_fd_pr__pfet_01v8[vds] @m.x1.xmtail.msky130_fd_pr__pfet_01v8[vdsat]
save @m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[vds] @m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[vdsat]
save @m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[vds] @m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[vdsat]
dc Vcmx 0.10 1.40 0.005
let top = 9
let bot1 = 0
let bot2 = 0
let vos_uV = (v(cm) - v(inn))*1e6
let mt = abs(@m.x1.xmtail.msky130_fd_pr__pfet_01v8[vds]) - abs(@m.x1.xmtail.msky130_fd_pr__pfet_01v8[vdsat])
let m1 = abs(@m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[vdsat])
let m2 = abs(@m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[vds]) - abs(@m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[vdsat])
meas dc top when mt=0.05 fall=1
meas dc bot1 when m1=0.05 rise=1
meas dc bot2 when m2=0.05 rise=1
meas dc mt083 find mt at=0.83
meas dc m1053 find m1 at=0.53
meas dc vos053 find vos_uV at=0.53
meas dc vos071 find vos_uV at=0.71
meas dc vos083 find vos_uV at=0.83
let dlo = vos053 - vos071
let dhi = vos083 - vos071
echo ICMR top_V=$&top bot_V=$&bot1 $&bot2 tail_margin_at_083_V=$&mt083 pair_margin_at_053_V=$&m1053 dVos053_uV=$&dlo dVos083_uV=$&dhi
wrdata icmr.txt mt m1 m2 vos_uV
.endc
.endc"}
C {gnd.sym} -110 250 0 0 {name=lchop lab=0}
C {lab_pin.sym} -70 250 1 0 {name=pchopb sig_type=std_logic lab=vdd}
