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
C {code_shown.sym} 290 -460 0 0 {name=s1 only_toplevel=false value="Vdd VDPWR 0 1.8
Vswa swa 0 1.8
Vswb swb 0 0
Vchop chop 0 0
Vchopb chopb 0 1.8
Vichon ich_on 0 1.8
Vichonb ich_onb 0 0
Vichdump ich_dump 0 0
Vi3on i3_on 0 1.8
Vi3onb i3_onb 0 0
Vi3dump i3_dump 0 0
* parks as in 3d
E4 p4 0 x1.va 0 1
V4 ich p4 0
V7 iptat_mon p4 0
Vc1 ib_cmp1 0 0.70
Vc2 ib_cmp2 0 0.70
* the zero state: gate line at the top rail, the core nodes at ground
.ic v(x1.vpg)=1.8 v(x1.va)=0 v(x1.vb)=0 v(vref)=0
.control
option reltol=1e-4
foreach t -40 25 125
  option temp=$t
  alter @m.x1.xcore.xsu.xmsu2.msky130_fd_pr__nfet_01v8[delvto]=2
  tran 20n 1m 0 50n
  let ip = 2*i(v7)*1e9
  meas tran ipmax max ip from=100u to=1m
  meas tran vrmax max v(vref) from=100u to=1m
  meas tran sumin min v(su) from=100u to=1m
  echo OFF temp=$t Iptat_max_nA=$&ipmax vref_max_V=$&vrmax su_min_V=$&sumin
  alter @m.x1.xcore.xsu.xmsu2.msky130_fd_pr__nfet_01v8[delvto]=0
  tran 20n 1m 0 50n
  let ip = 2*i(v7)*1e9
  foreach tp 1u 2u 5u 10u 20u 50u 100u 200u 500u 1m
    meas tran vr find v(vref) at=$tp
    meas tran vs find v(su) at=$tp
    meas tran vg find v(x1.vpg) at=$tp
    meas tran g3 find v(x1.xota.g3) at=$tp
    echo ON temp=$t t=$tp vref=$&vr su=$&vs vpg=$&vg g3=$&g3
  end
  meas tran ipavg avg ip from=500u to=1m
  meas tran vrmin min v(vref) from=500u to=1m
  meas tran vrmax max v(vref) from=500u to=1m
  echo LAST temp=$t Iptat_avg_nA=$&ipavg vref_min=$&vrmin vref_max=$&vrmax
end
.endc"}
C {bgr.sym} -70 -50 0 0 {name=x1}
C {lab_pin.sym} 80 -230 0 1 {name=p9 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 80 -210 0 1 {name=p13 sig_type=std_logic lab=ich_onb}
C {lab_pin.sym} 80 -190 0 1 {name=p16 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} 80 -170 0 1 {name=p17 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} 80 -130 0 1 {name=p7 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} 80 130 0 1 {name=p18 sig_type=std_logic lab=su}
