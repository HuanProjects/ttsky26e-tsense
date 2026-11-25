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
C {sky130_fd_pr/corner.sym} -180 310 0 0 {name=CORNER only_toplevel=false corner=tt_mm}
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
setseed 42
let nmax = 200
let v25 = vector(nmax)
let vm20 = vector(nmax)
let v100 = vector(nmax)
let n = 0
while n < nmax
  reset
  option temp=25
  op
  let v25[n] = v(cm)-v(inn)
  option temp=-20
  op
  let vm20[n] = v(cm)-v(inn)
  option temp=100
  op
  let v100[n] = v(cm)-v(inn)
  let n = n + 1
end
setplot const
let m25 = mean(v25)
let s25 = sqrt(mean((v25-m25)^2)*nmax/(nmax-1))
let up95 = 1.09*s25
let dc = vm20-v25
let dh = v100-v25
let sdc = sqrt(mean((dc-mean(dc))^2)*nmax/(nmax-1))
let sdh = sqrt(mean((dh-mean(dh))^2)*nmax/(nmax-1))
echo MC seed 42, N = 200, all in uV
print m25*1e6 s25*1e6 up95*1e6 sdc*1e6 sdh*1e6
let sample = vector(nmax)
setscale sample
wrdata vos_mc_42.csv v25 vm20 v100
.endc"}
C {gnd.sym} -110 250 0 0 {name=lchop lab=0}
C {lab_pin.sym} -70 250 1 0 {name=pchopb sig_type=std_logic lab=vdd}
