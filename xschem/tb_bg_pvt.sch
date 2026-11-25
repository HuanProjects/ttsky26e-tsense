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
C {code_shown.sym} 300 -460 0 0 {name=s1 only_toplevel=false value="*   S0 = normal, S1 = i3_sel 1 (half-current output branch), S2 = ich_sel 1 (half slope)
Vdd VDPWR 0 1.8
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
* parks as in 3d; 2 pF on vref as the spec bench
E4 p4 0 x1.va 0 1
V4 ich p4 0
V7 iptat_mon p4 0
Vc1 ib_cmp1 0 0.70
Vc2 ib_cmp2 0 0.70
Cref vref 0 2p
* the design nodeset
.nodeset v(x1.vpg)=0.55 v(x1.va)=0.71 v(x1.vb)=0.71 v(vref)=1.25
.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
let vd = 1.8
foreach t -40 -20 0 25 50 75 100 125
  option temp=$t
  * S0: normal
  op
  let ip = 2*i(v7)*1e9
  let ib = abs(@m.x1.xcore.xmnb2.msky130_fd_pr__nfet_01v8[id])*1e9
  let ibr = ib/ip
  let xvref = v(vref)
  let xveb3 = v(veb3)
  let mu = 1 - xveb3/xvref
  let vos = (v(x1.vb)-v(x1.va))*1e6
  let xvpg = v(x1.vpg)
  let tailm = (abs(@m.x1.xota.xmtail.msky130_fd_pr__pfet_01v8[vds]) - abs(@m.x1.xota.xmtail.msky130_fd_pr__pfet_01v8[vdsat]))*1e3
  let p3m = (abs(@m.x1.xcore.x1.xmp3a.msky130_fd_pr__pfet_01v8[vds]) - abs(@m.x1.xcore.x1.xmp3a.msky130_fd_pr__pfet_01v8[vdsat]))*1e3
  let xsu = v(su)*1e3
  let imsu1 = abs(@m.x1.xcore.xsu.xmsu1.msky130_fd_pr__pfet_01v8[id])*1e9
  let imsu2 = abs(@m.x1.xcore.xsu.xmsu2.msky130_fd_pr__nfet_01v8[id])*1e12
  let ich = i(v4)*1e9
  set s0vref = $&xvref
  set s0veb3 = $&xveb3
  set s0ich = $&ich
  let i3s0 = abs(@m.x1.xcore.x1.xmp3a.msky130_fd_pr__pfet_01v8[id]) + abs(@m.x1.xcore.x1.xmp3b.msky130_fd_pr__pfet_01v8[id])
  set s0i3 = $&i3s0
  echo PVT temp=$t Iptat_nA=$&ip IB_ratio=$&ibr vref_V=$&xvref veb3_V=$&xveb3 mu=$&mu vos_uV=$&vos vpg_V=$&xvpg tail_margin_mV=$&tailm p3_margin_mV=$&p3m su_mV=$&xsu Imsu1_nA=$&imsu1 Imsu2_pA=$&imsu2 Ich_nA=$&ich
  * 8c: input-switch leakage, state A (S1/S2 on, S3/S4 off): everything hanging on va and vb
  let lva = (abs(@m.x1.xs1.msky130_fd_pr__nfet_01v8_lvt[id]) + abs(@m.x1.xs1.msky130_fd_pr__nfet_01v8_lvt[ibd]) + abs(@m.x1.xs3.msky130_fd_pr__nfet_01v8_lvt[id]) + abs(@m.x1.xs3.msky130_fd_pr__nfet_01v8_lvt[ibd]))*1e12
  let lvb = (abs(@m.x1.xs2.msky130_fd_pr__nfet_01v8_lvt[id]) + abs(@m.x1.xs2.msky130_fd_pr__nfet_01v8_lvt[ibd]) + abs(@m.x1.xs4.msky130_fd_pr__nfet_01v8_lvt[id]) + abs(@m.x1.xs4.msky130_fd_pr__nfet_01v8_lvt[ibd]))*1e12
  let loff = abs(@m.x1.xs3.msky130_fd_pr__nfet_01v8_lvt[id])*1e12
  echo LEAK temp=$t Ileak_va_pA=$&lva Ileak_vb_pA=$&lvb Ioff_channel_S3_pA=$&loff
  * S1: i3_sel = 1 (P3b to ground)
  alter vi3on = 0
  alter vi3onb = $&vd
  alter vi3dump = $&vd
  op
  let i3a = abs(@m.x1.xcore.x1.xmp3a.msky130_fd_pr__pfet_01v8[id])
  let rho = i3a/$s0i3
  let xvref = v(vref)
  let xveb3 = v(veb3)
  let mu = 1 - xveb3/xvref
  let xsu = v(su)*1e3
  let chi = 10*$s0veb3/($s0vref - $s0veb3) - 5*xveb3/(xvref - xveb3) - 1/3
  echo HALF temp=$t rho=$&rho vref_V=$&xvref veb3_V=$&xveb3 mu=$&mu su_mV=$&xsu chi_nom=$&chi
  alter vi3on = $&vd
  alter vi3onb = 0
  alter vi3dump = 0
  * S2: ich_sel = 1 (P4b to ground)
  alter vichon = 0
  alter vichonb = $&vd
  alter vichdump = $&vd
  op
  let ich = i(v4)*1e9
  let ichr = ich/$s0ich
  echo SLOPE temp=$t Ich_nA=$&ich Ich_ratio=$&ichr
  alter vichon = $&vd
  alter vichonb = 0
  alter vichdump = 0
end
.endc"}
C {bgr.sym} -70 -50 0 0 {name=x1}
C {lab_pin.sym} 80 -230 0 1 {name=p9 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 80 -210 0 1 {name=p13 sig_type=std_logic lab=ich_onb}
C {lab_pin.sym} 80 -190 0 1 {name=p16 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} 80 -170 0 1 {name=p17 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} 80 -130 0 1 {name=p7 sig_type=std_logic lab=i3_on}
C {lab_pin.sym} 80 130 0 1 {name=p18 sig_type=std_logic lab=su}
