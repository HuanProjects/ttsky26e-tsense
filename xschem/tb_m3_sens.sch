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
C {code_shown.sym} 10 310 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8 rs=1
.temp 25
Vdd vdd 0 \{vdd\}
* door 1: input CM = a real diode PNP carrying I_PTAT(T)
* rs = R1 corner (1 nominal, 1.17 ll, 0.88 hh); the denominator is R1's own tempco
Bcm vdd cm I = 2.79e-6*rs*(temper+273.15)/298.15/(1+4.89e-4*(temper-27)+1.2e-6*(temper-27)**2)
* door 2: PTAT bias, I_PTAT/2, sunk from IBIAS
Bib ib 0 I = 1.40e-6*rs*(temper+273.15)/298.15/(1+4.89e-4*(temper-27)+1.2e-6*(temper-27)**2)
* door 4: replica P1 carries I_PTAT -> its gate is the vpg target
Brp vpgt 0 I = 2.79e-6*rs*(temper+273.15)/298.15/(1+4.89e-4*(temper-27)+1.2e-6*(temper-27)**2)
* chop state A (swap the two values for state B)
Vchop chop 0 0
Vchopb chopb 0 \{vdd\}
* servo: plays the bandgap loop, moves INN until out = vpgt
Bsv inn cm V = 0.5*tanh(2000*(v(out)-v(vpgt)))
.control
option reltol=1e-5 vntol=1e-9
option temp=25
let s = vector(9)
op
let s[0] = (v(cm)-v(inn))*1e6
alter @m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[delvto] = 1e-3
op
let s[1] = ((v(cm)-v(inn))*1e6 - s[0])/1000
alter @m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[delvto] = 0
alter @m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[delvto] = 1e-3
op
let s[2] = ((v(cm)-v(inn))*1e6 - s[0])/1000
alter @m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[delvto] = 0
alter @m.x1.xmn1.msky130_fd_pr__nfet_01v8[delvto] = 1e-3
op
let s[3] = ((v(cm)-v(inn))*1e6 - s[0])/1000
alter @m.x1.xmn1.msky130_fd_pr__nfet_01v8[delvto] = 0
alter @m.x1.xmn2.msky130_fd_pr__nfet_01v8[delvto] = 1e-3
op
let s[4] = ((v(cm)-v(inn))*1e6 - s[0])/1000
alter @m.x1.xmn2.msky130_fd_pr__nfet_01v8[delvto] = 0
alter @m.x1.xmn3.msky130_fd_pr__nfet_01v8[delvto] = 1e-3
op
let s[5] = ((v(cm)-v(inn))*1e6 - s[0])/1000
alter @m.x1.xmn3.msky130_fd_pr__nfet_01v8[delvto] = 0
alter @m.x1.xmtail.msky130_fd_pr__pfet_01v8[delvto] = 1e-3
op
let s[6] = ((v(cm)-v(inn))*1e6 - s[0])/1000
alter @m.x1.xmtail.msky130_fd_pr__pfet_01v8[delvto] = 0
alter @m.x1.xmp3.msky130_fd_pr__pfet_01v8[delvto] = 1e-3
op
let s[7] = ((v(cm)-v(inn))*1e6 - s[0])/1000
alter @m.x1.xmp3.msky130_fd_pr__pfet_01v8[delvto] = 0
alter @m.x1.xmref.msky130_fd_pr__pfet_01v8[delvto] = 1e-3
op
let s[8] = ((v(cm)-v(inn))*1e6 - s[0])/1000
alter @m.x1.xmref.msky130_fd_pr__pfet_01v8[delvto] = 0
let vos0 = s[0]
let smp1 = s[1]
let smp2 = s[2]
let smn1 = s[3]
let smn2 = s[4]
let smn3 = s[5]
let smtail = s[6]
let smp3 = s[7]
let smref = s[8]
echo SENS vos0_uV=$&vos0 mp1=$&smp1 mp2=$&smp2 mn1=$&smn1 mn2=$&smn2 mn3=$&smn3 mtail=$&smtail mp3=$&smp3 mref=$&smref
.endc
.endc"}
C {lab_pin.sym} -70 250 2 0 {name=pchopb sig_type=std_logic lab=chopb}
C {lab_pin.sym} -110 250 0 0 {name=pchopb1 sig_type=std_logic lab=chop}
C {sky130_fd_pr/pnp_05v5.sym} -440 360 0 0 {name=Q1
model=pnp_05v5_W3p40L3p40
m=1
spiceprefix=X
}
C {lab_pin.sym} -420 330 0 0 {name=p8 sig_type=std_logic lab=cm}
C {gnd.sym} -420 390 0 0 {name=l2 lab=0}
C {gnd.sym} -460 360 0 0 {name=l3 lab=0}
