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
* the zero nodeset: gate line at the top rail, the core nodes at ground
.nodeset v(x1.vpg)=1.8 v(x1.va)=0 v(x1.vb)=0 v(vref)=0
.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
foreach t -40 25 125
  option temp=$t
  alter @m.x1.xcore.xsu.xmsu2.msky130_fd_pr__nfet_01v8[delvto]=2
  op
  let iptat = 2*i(v7)*1e9
  let xvref = v(vref)
  let xvpg = v(x1.vpg)
  let xsu = v(su)
  echo SU temp=$t startup=off Iptat_nA=$&iptat vref_V=$&xvref vpg_V=$&xvpg su_V=$&xsu
  alter @m.x1.xcore.xsu.xmsu2.msky130_fd_pr__nfet_01v8[delvto]=0
  op
  let iptat = 2*i(v7)*1e9
  let xvref = v(vref)
  let xvpg = v(x1.vpg)
  let xsu = v(su)
  echo SU temp=$t startup=on Iptat_nA=$&iptat vref_V=$&xvref vpg_V=$&xvpg su_V=$&xsu
  let i1 = abs(@m.x1.xcore.xsu.xmsu1.msky130_fd_pr__pfet_01v8[id])*1e9
  let i2 = abs(@m.x1.xcore.xsu.xmsu2.msky130_fd_pr__nfet_01v8[id])*1e12
  echo LEAK temp=$t Imsu1_nA=$&i1 Imsu2_pA=$&i2
end
.endc"}
C {bgr.sym} -70 -50 0 0 {name=x1}
C {lab_pin.sym} 80 -230 0 1 {name=p9 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 80 -210 0 1 {name=p13 sig_type=std_logic lab=ich_onb}
C {lab_pin.sym} 80 -190 0 1 {name=p16 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} 80 -170 0 1 {name=p17 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} 80 -130 0 1 {name=p7 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} 80 130 0 1 {name=p18 sig_type=std_logic lab=su}
