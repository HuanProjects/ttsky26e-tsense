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
setseed 42
let nmax = 200
let v25 = vector(nmax)
let vm20 = vector(nmax)
let v100 = vector(nmax)
let v171 = vector(nmax)
let v189 = vector(nmax)
let n = 0
while n < nmax
  reset
  option reltol=1e-5 vntol=1e-9
  option temp=25
  op
  let v25[n] = v(cm)-v(inn)
  option temp=-20
  op
  let vm20[n] = v(cm)-v(inn)
  option temp=100
  op
  let v100[n] = v(cm)-v(inn)
  option temp=25
  alter vdd dc=1.71
  alter vchopb dc=1.71
  op
  let v171[n] = v(cm)-v(inn)
  alter vdd dc=1.89
  alter vchopb dc=1.89
  op
  let v189[n] = v(cm)-v(inn)
  let n = n + 1
end
setplot const
let m25 = mean(v25)*1e6
let s25 = sqrt(mean((v25-mean(v25))^2)*nmax/(nmax-1))*1e6
let up95 = 1.09*s25
let dc = vm20-v25
let dh = v100-v25
let sdc = sqrt(mean((dc-mean(dc))^2)*nmax/(nmax-1))*1e6
let sdh = sqrt(mean((dh-mean(dh))^2)*nmax/(nmax-1))*1e6
let ps = (v189-v171)/0.18*1e6
let psm = mean(ps)
let psw = vecmax(abs(ps))
echo MCRESULT corner=tt_mm seed=42 N=$&nmax mean_uV=$&m25 sigma_uV=$&s25 up95_uV=$&up95 drift_m20_sigma_uV=$&sdc drift_100_sigma_uV=$&sdh psrr_mean_uVperV=$&psm psrr_worst_uVperV=$&psw
let sample = vector(nmax)
setscale sample
wrdata mc_tt_mm_42.csv v25 vm20 v100 v171 v189
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
