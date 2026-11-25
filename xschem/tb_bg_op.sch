v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 80 30 150 30 {lab=0}
C {bgr.sym} -70 -20 0 0 {name=x1}
C {lab_pin.sym} 80 -110 0 1 {name=p1 sig_type=std_logic lab=vref}
C {lab_pin.sym} 80 -150 0 1 {name=p2 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 80 -130 0 1 {name=p3 sig_type=std_logic lab=i3b}
C {lab_pin.sym} 80 -30 0 1 {name=p4 sig_type=std_logic lab=chop}
C {lab_pin.sym} 80 -90 0 1 {name=p7 sig_type=std_logic lab=ichb}
C {lab_pin.sym} 80 -70 0 1 {name=p8 sig_type=std_logic lab=ich}
C {lab_pin.sym} 80 -10 0 1 {name=p10 sig_type=std_logic lab=iptat_mon}
C {lab_pin.sym} 80 10 0 1 {name=p11 sig_type=std_logic lab=veb3}
C {lab_pin.sym} 80 90 0 1 {name=p12 sig_type=std_logic lab=swa}
C {lab_pin.sym} 80 50 0 1 {name=p14 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} 80 70 0 1 {name=p15 sig_type=std_logic lab=ib_cmp2}
C {gnd.sym} 150 30 0 0 {name=l1 lab=0}
C {sky130_fd_pr/corner.sym} -620 -90 0 0 {name=CORNER only_toplevel=false corner=tt}
C {lab_pin.sym} 80 -50 0 1 {name=p5 sig_type=std_logic lab=chopb}
C {lab_pin.sym} 80 110 0 1 {name=p6 sig_type=std_logic lab=swb}
C {code_shown.sym} 290 -460 0 0 {name=s1 only_toplevel=false value="Vdd VDPWR 0 1.8
* state A: S1 (va->INN) and S2 (vb->INP) on, S3/S4 off; ota2s CHOP = 0, CHOPB = 1
Vswa swa 0 1.8
Vswb swb 0 0
Vchop chop 0 0
Vchopb chopb 0 1.8
* same parks as 3a; x1.va = the net va inside instance x1
Vm3b i3b vref 0
E4 p4 0 x1.va 0 1
V4a ich p4 0
V4b ichb p4 0
V7 iptat_mon p4 0
Vc1 ib_cmp1 0 0.70
Vc2 ib_cmp2 0 0.70
.nodeset v(x1.vpg)=0.55 v(x1.va)=0.71 v(x1.vb)=0.71 v(vref)=1.25
.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
foreach t -20 25 100
  option temp=$t
  op
  let xva = v(x1.va)
  let xvb = v(x1.vb)
  let xvref = v(vref)
  let xveb3 = v(veb3)
  let xvpg = v(x1.vpg)
  echo CORE temp=$t va_V=$&xva vb_V=$&xvb vref_V=$&xvref veb3_V=$&xveb3 vpg_V=$&xvpg
  let iptat = 2*(i(v4a)+i(v4b))*1e6
  let c3b = i(vm3b)*1e6
  echo COPIES temp=$t Iptat_uA=$&iptat I3b_uA=$&c3b
  let vos = (v(x1.vb)-v(x1.va))*1e6
  let dinp = (v(x1.inp)-v(x1.vb))*1e6
  let dinn = (v(x1.inn)-v(x1.va))*1e6
  echo VOS temp=$t vos_uV=$&vos inp_minus_vb_uV=$&dinp inn_minus_va_uV=$&dinn
  let ib = @m.x1.xcore.xmnb2.msky130_fd_pr__nfet_01v8[id]*1e6
  let ratio = ib/iptat
  let xib = v(x1.ibias)
  let tail = abs(@m.x1.xota.xmtail.msky130_fd_pr__pfet_01v8[vds])-abs(@m.x1.xota.xmtail.msky130_fd_pr__pfet_01v8[vdsat])
  echo BIAS temp=$t IB_uA=$&ib IB_over_Iptat=$&ratio ibias_V=$&xib tail_margin_V=$&tail
end
.endc"}
