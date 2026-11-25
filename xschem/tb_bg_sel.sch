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
* select controls, start at sel = 0: TGs on, dumps off
Vichon ich_on 0 1.8
Vichonb ich_onb 0 0
Vichdump ich_dump 0 0
Vi3on i3_on 0 1.8
Vi3onb i3_onb 0 0
Vi3dump i3_dump 0 0
* parks: ich (the future vcap) and the P7 monitor on a 1x copy of va
E4 p4 0 x1.va 0 1
V4 ich p4 0
V7 iptat_mon p4 0
Vc1 ib_cmp1 0 0.70
Vc2 ib_cmp2 0 0.70
.nodeset v(x1.vpg)=0.55 v(x1.va)=0.71 v(x1.vb)=0.71
.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
foreach t -20 25 100
  option temp=$t
  alter vichon dc=1.8
  alter vichonb dc=0
  alter vichdump dc=0
  alter vi3on dc=1.8
  alter vi3onb dc=0
  alter vi3dump dc=0
  op
  let xvref = v(vref)
  let xveb3 = v(veb3)
  let xvpg = v(x1.vpg)
  let vos = (v(x1.vb)-v(x1.va))*1e6
  let iptat = 2*i(v7)*1e6
  echo SEL temp=$t sel=0 vref_V=$&xvref veb3_V=$&xveb3 vpg_V=$&xvpg vos_uV=$&vos Iptat_uA=$&iptat
  let ich = i(v4)*1e6
  let i4tot = (abs(@m.x1.xcore.x1.xmp4a.msky130_fd_pr__pfet_01v8[id])+abs(@m.x1.xcore.x1.xmp4b.msky130_fd_pr__pfet_01v8[id]))*1e6
  let i3dump = @m.x1.xs_i3dump.msky130_fd_pr__nfet_01v8[id]*1e6
  let iout = (abs(@m.x1.xcore.x1.xmp3a.msky130_fd_pr__pfet_01v8[id])+abs(@m.x1.xcore.x1.xmp3b.msky130_fd_pr__pfet_01v8[id]))*1e6-i3dump
  let ratio = iout/iptat
  echo CUR temp=$t sel=0 Ich_uA=$&ich I4tot_uA=$&i4tot Iout_uA=$&iout Iout_over_Iptat=$&ratio I3dump_uA=$&i3dump
  alter vichon dc=0
  alter vichonb dc=1.8
  alter vichdump dc=1.8
  alter vi3on dc=0
  alter vi3onb dc=1.8
  alter vi3dump dc=1.8
  op
  let xvref = v(vref)
  let xveb3 = v(veb3)
  let xvpg = v(x1.vpg)
  let vos = (v(x1.vb)-v(x1.va))*1e6
  let iptat = 2*i(v7)*1e6
  echo SEL temp=$t sel=1 vref_V=$&xvref veb3_V=$&xveb3 vpg_V=$&xvpg vos_uV=$&vos Iptat_uA=$&iptat
  let ich = i(v4)*1e6
  let i4tot = (abs(@m.x1.xcore.x1.xmp4a.msky130_fd_pr__pfet_01v8[id])+abs(@m.x1.xcore.x1.xmp4b.msky130_fd_pr__pfet_01v8[id]))*1e6
  let i3dump = @m.x1.xs_i3dump.msky130_fd_pr__nfet_01v8[id]*1e6
  let iout = (abs(@m.x1.xcore.x1.xmp3a.msky130_fd_pr__pfet_01v8[id])+abs(@m.x1.xcore.x1.xmp3b.msky130_fd_pr__pfet_01v8[id]))*1e6-i3dump
  let ratio = iout/iptat
  echo CUR temp=$t sel=1 Ich_uA=$&ich I4tot_uA=$&i4tot Iout_uA=$&iout Iout_over_Iptat=$&ratio I3dump_uA=$&i3dump
end
.endc"}
C {bgr.sym} -70 -60 0 0 {name=x1}
C {lab_pin.sym} 80 -230 0 1 {name=p9 sig_type=std_logic lab=ich_on}
C {lab_pin.sym} 80 -210 0 1 {name=p13 sig_type=std_logic lab=ich_onb}
C {lab_pin.sym} 80 -190 0 1 {name=p16 sig_type=std_logic lab=ich_dump}
C {lab_pin.sym} 80 -170 0 1 {name=p17 sig_type=std_logic lab=i3_dump}
C {lab_pin.sym} 80 -130 0 1 {name=p7 sig_type=std_logic lab=i3_on}
