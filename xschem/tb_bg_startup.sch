v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 80 30 150 30 {lab=0}
C {lab_pin.sym} 80 -90 0 1 {name=p1 sig_type=std_logic lab=vref}
C {lab_pin.sym} 80 -110 0 1 {name=p2 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 80 -150 0 1 {name=p3 sig_type=std_logic lab=i3_onb}
C {lab_pin.sym} 80 -10 0 1 {name=p4 sig_type=std_logic lab=chop}
C {lab_pin.sym} 80 -70 0 1 {name=p8 sig_type=std_logic lab=ich}
C {lab_pin.sym} 80 -50 0 1 {name=p10 sig_type=std_logic lab=iptat_mon}
C {lab_pin.sym} 80 10 0 1 {name=p11 sig_type=std_logic lab=veb3}
C {lab_pin.sym} 80 90 0 1 {name=p12 sig_type=std_logic lab=swa}
C {lab_pin.sym} 80 50 0 1 {name=p14 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} 80 70 0 1 {name=p15 sig_type=std_logic lab=ib_cmp2}
C {gnd.sym} 150 30 0 0 {name=l1 lab=0}
C {sky130_fd_pr/corner.sym} -620 -90 0 0 {name=CORNER only_toplevel=false corner=tt}
C {lab_pin.sym} 80 -30 0 1 {name=p5 sig_type=std_logic lab=chopb}
C {lab_pin.sym} 80 110 0 1 {name=p6 sig_type=std_logic lab=swb}
C {code_shown.sym} 290 -460 0 0 {name=s1 only_toplevel=false value=".param vdd=1.62 tr=1u
Vdd VDPWR 0 dc \{vdd\} pwl(0 0 \{tr\} \{vdd\})
Vswa swa 0 dc \{vdd\} pwl(0 0 \{tr\} \{vdd\})
Vswb swb 0 0
Vchop chop 0 0
Vchopb chopb 0 dc \{vdd\} pwl(0 0 \{tr\} \{vdd\})
Vichon ich_on 0 dc \{vdd\} pwl(0 0 \{tr\} \{vdd\})
Vichonb ich_onb 0 0
Vichdump ich_dump 0 0
Vi3on i3_on 0 dc \{vdd\} pwl(0 0 \{tr\} \{vdd\})
Vi3onb i3_onb 0 0
Vi3dump i3_dump 0 0
* parks as in 3d (the comparator bias parks ramp too)
E4 p4 0 x1.va 0 1
V4 ich p4 0
V7 iptat_mon p4 0
Vc1 ib_cmp1 0 dc 0.70 pwl(0 0 \{tr\} 0.70)
Vc2 ib_cmp2 0 dc 0.70 pwl(0 0 \{tr\} 0.70)
* the design nodeset (for the op that gives the target)
.nodeset v(x1.vpg)=0.37 v(x1.va)=0.71 v(x1.vb)=0.71 v(vref)=1.25
.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
option temp=27
* 1) the target: the operating point at the final supply
op
let vop = v(vref)
let dab = (v(x1.va)-v(x1.vb))*1e6
set vops = $&vop
set dabs = $&dab
option reltol=1e-4 vntol=1e-6 abstol=1e-12
* 2) the power-up
tran 5n 150u 0 50n
let ip = 2*i(v7)*1e9
let tr = 1u
meas tran v0 find v(vref) at=0
meas tran vend find v(vref) at=150u
let err = abs(v(vref)-vend)/vend
meas tran tlast when err=0.01 cross=last
let tset = (tlast-tr)*1e6
let dend = (vend-$vops)*1e3
meas tran supk max v(su)
meas tran vrmin min v(vref)
meas tran ipend find ip at=150u
let kick = v(su) gt 0.9
let nk = length(kick)
let dk = kick[1,nk-1] - kick[0,nk-2]
let kicks = mean(dk gt 0)*(nk-1)
echo RAMP vref_t0=$&v0 vref_op=$vops va_vb_op_uV=$dabs vref_end=$&vend dend_mV=$&dend Iptat_end_nA=$&ipend settle_us=$&tset kicks=$&kicks su_peak=$&supk vref_min=$&vrmin
.endc"}
C {bgr.sym} -70 -50 0 0 {name=x1}
C {lab_pin.sym} 80 -230 0 1 {name=p9 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 80 -210 0 1 {name=p13 sig_type=std_logic lab=ich_onb}
C {lab_pin.sym} 80 -190 0 1 {name=p16 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} 80 -170 0 1 {name=p17 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} 80 -130 0 1 {name=p7 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} 80 130 0 1 {name=p18 sig_type=std_logic lab=su}
