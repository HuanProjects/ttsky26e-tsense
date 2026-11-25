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
C {sky130_fd_pr/corner.sym} -180 310 0 0 {name=CORNER only_toplevel=false corner=tt_mm}
C {code_shown.sym} 10 310 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8 rs=1
Vdd vdd 0 \{vdd\}
* door 1: input CM = real diode PNP at I_PTAT(T) (rs = R1 corner, denominator = R1 tempco)
Bcm vdd cm I = 2.79e-6*rs*(temper+273.15)/298.15/(1+4.89e-4*(temper-27)+1.2e-6*(temper-27)**2)
* door 2: PTAT bias, I_PTAT/2, sunk from IBIAS
Bib ib 0 I = 1.40e-6*rs*(temper+273.15)/298.15/(1+4.89e-4*(temper-27)+1.2e-6*(temper-27)**2)
* door 4: replica P1 -> vpg target
Brp vpgt 0 I = 2.79e-6*rs*(temper+273.15)/298.15/(1+4.89e-4*(temper-27)+1.2e-6*(temper-27)**2)
* chop state A
Vchop chop 0 0
Vchopb chopb 0 \{vdd\}
* AC test signal on INP, through the core's node-B impedance
Vac sa cm dc 0 ac 1
RsB sa inp 28.7k
* servo: closed at DC (Lsv shorts), open at AC (Lsv opens, Csv grounds s)
Lsv out s 1T
Csv s 0 1T
Bsv sn cm V = 0.5*tanh(2000*(v(s)-v(vpgt)))
RsA sn inn 9.2k
* the PMOS gate line the op-amp drives in the bandgap
CL out 0 16p
.control
setseed 44
let nmax = 200
let a0v = vector(nmax)
let f44v = vector(nmax)
let pm44v = vector(nmax)
let n = 0
while n < nmax
  reset
  option temp=25
  alter cl = 25p
  ac dec 10 0.01 100meg
  let gdb = vdb(out)
  let phd = cph(v(out))*180/pi
  meas ac a0 find gdb at=0.1
  meas ac f44 when gdb=7.131
  meas ac ph44 find phd at=$&f44
  let a0v[n] = a0
  let f44v[n] = f44/1000
  let pm44v[n] = 180+ph44
  let n = n + 1
end
setplot const
let a0m = mean(a0v)
let a0s = sqrt(mean((a0v-a0m)^2)*nmax/(nmax-1))
let a0min = vecmin(a0v)
let pmm = mean(pm44v)
let pms = sqrt(mean((pm44v-pmm)^2)*nmax/(nmax-1))
let pmmin = vecmin(pm44v)
let fmin = vecmin(f44v)
let fmax = vecmax(f44v)
echo OLMC corner=tt_mm seed=44 N=$&nmax a0_mean_dB=$&a0m a0_sigma_dB=$&a0s a0_min_dB=$&a0min pm44_mean=$&pmm pm44_sigma=$&pms pm44_min=$&pmmin f44_min_kHz=$&fmin f44_max_kHz=$&fmax
let sample = vector(nmax)
setscale sample
wrdata olmc_tt_mm_44.csv a0v f44v pm44v
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
