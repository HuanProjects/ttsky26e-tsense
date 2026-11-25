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
C {code_shown.sym} 10 310 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8
.temp 25
Vdd vdd 0 \{vdd\}
* door 1: input CM = V_EB(T) at 2.79 uA (spec lines 140, 147)
Bcm cm 0 V = 0.710 - 1.846e-3*(temper-25)
* door 2: PTAT bias, 1.40 uA at 25 C, sunk from IBIAS
Bib ib 0 I = 1.40e-6*(temper+273.15)/298.15
* door 4: replica P1 carries I_PTAT -> its gate is the vpg target
Brp vpgt 0 I = 2.79e-6*(temper+273.15)/298.15
* servo: plays the bandgap loop, moves INN until out = vpgt
Esv inn cm out vpgt 1000
.control
op
let vid_mV = (v(cm) - v(inn))*1000
print v(cm) v(vpgt) v(out) v(x1.d1) v(x1.x1) v(x1.tail) vid_mV
print @m.x1.xmtail.msky130_fd_pr__pfet_01v8[vds] @m.x1.xmtail.msky130_fd_pr__pfet_01v8[vdsat] @m.x1.xmtail.msky130_fd_pr__pfet_01v8[id]
print @m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[vds] @m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.x1.xmp1.msky130_fd_pr__pfet_01v8_lvt[id]
print @m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[vds] @m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[vdsat] @m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[id]
print @m.x1.xmn1.msky130_fd_pr__nfet_01v8[vds] @m.x1.xmn1.msky130_fd_pr__nfet_01v8[vdsat] @m.x1.xmn1.msky130_fd_pr__nfet_01v8[id]
print @m.x1.xmn2.msky130_fd_pr__nfet_01v8[vds] @m.x1.xmn2.msky130_fd_pr__nfet_01v8[vdsat] @m.x1.xmn2.msky130_fd_pr__nfet_01v8[id]
print @m.x1.xmp3.msky130_fd_pr__pfet_01v8[vds] @m.x1.xmp3.msky130_fd_pr__pfet_01v8[vdsat] @m.x1.xmp3.msky130_fd_pr__pfet_01v8[id]
print @m.x1.xmn3.msky130_fd_pr__nfet_01v8[vds] @m.x1.xmn3.msky130_fd_pr__nfet_01v8[vdsat] @m.x1.xmn3.msky130_fd_pr__nfet_01v8[id]

* --- the two high-impedance nodes: R, gain, pole ---
let gm1  = @m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[gm]
let r_x1 = 1/(@m.x1.xmp2.msky130_fd_pr__pfet_01v8_lvt[gds] + @m.x1.xmn2.msky130_fd_pr__nfet_01v8[gds])
let gm6  = @m.x1.xmn3.msky130_fd_pr__nfet_01v8[gm]
let r_out = 1/(@m.x1.xmn3.msky130_fd_pr__nfet_01v8[gds] + @m.x1.xmp3.msky130_fd_pr__pfet_01v8[gds])
let a1 = gm1*r_x1
let a2 = gm6*r_out
let c_x1 = 1p
let c_out = 16p
let f_x1 = 1/(2*pi*r_x1*c_x1)
let f_out = 1/(2*pi*r_out*c_out)
let loop0 = 0.44*a1*a2
print gm1 r_x1 a1 gm6 r_out a2 loop0 f_x1 f_out
.endc"}
C {gnd.sym} -110 250 0 0 {name=lchop lab=0}
C {lab_pin.sym} -70 250 1 0 {name=pchopb sig_type=std_logic lab=vdd}
