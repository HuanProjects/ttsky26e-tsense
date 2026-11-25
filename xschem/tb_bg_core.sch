v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 150 50 220 50 {lab=0}
C {bg_core.sym} 0 -10 0 0 {name=x1}
C {lab_pin.sym} 150 -70 0 1 {name=p1 sig_type=std_logic lab=vref}
C {lab_pin.sym} 150 -110 0 1 {name=p2 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 -90 0 1 {name=p3 sig_type=std_logic lab=i3b}
C {lab_pin.sym} 150 -130 0 1 {name=p4 sig_type=std_logic lab=vpg}
C {lab_pin.sym} 150 -50 0 1 {name=p7 sig_type=std_logic lab=ichb}
C {lab_pin.sym} 150 -30 0 1 {name=p8 sig_type=std_logic lab=ich}
C {lab_pin.sym} 150 -10 0 1 {name=p9 sig_type=std_logic lab=vb}
C {lab_pin.sym} 150 10 0 1 {name=p10 sig_type=std_logic lab=iptat_mon}
C {lab_pin.sym} 150 30 0 1 {name=p11 sig_type=std_logic lab=veb3}
C {lab_pin.sym} 150 70 0 1 {name=p12 sig_type=std_logic lab=va}
C {lab_pin.sym} 150 90 0 1 {name=p13 sig_type=std_logic lab=ibias}
C {lab_pin.sym} 150 110 0 1 {name=p14 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} 150 130 0 1 {name=p15 sig_type=std_logic lab=ib_cmp2}
C {gnd.sym} 220 50 0 0 {name=l1 lab=0}
C {sky130_fd_pr/corner.sym} -390 -70 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 420 -210 0 0 {name=s1 only_toplevel=false value="Vdd VDPWR 0 1.8
* 0 V ammeter: P3b's drain -> vref (the i3 TG replaces it in M5 3d)
Vm3b i3b vref 0
* copies parked at a 1x copy of va, so they see P1's own V_SD: 2*(I4a+I4b) = I_PTAT at every temperature
E4 p4 0 va 0 1
V4a ich p4 0
V4b ichb p4 0
V7 iptat_mon p4 0
* bias sinks parked where their real loads sit: ota2s IBIAS (its XMREF diode) and the comparator (M6)
Vib ibias 0 0.70
Vc1 ib_cmp1 0 0.70
Vc2 ib_cmp2 0 0.70
* The 2b stand-in op-amp (+ on vb), output straight onto vpg (no kick this time)
Bgm 0 x I = 1e-4*(v(vb)-v(va))
Rx x 0 1e10
Cx x 0 159p
Bout vpg 0 V = min(1.8, 0.9 + v(x))
.nodeset v(vpg)=0.55 v(va)=0.71 v(vb)=0.71 v(vref)=1.25 v(x)=-0.37 v(x1.nb)=0.68
.control
option reltol=1e-6 vntol=1e-9 abstol=1e-15
foreach t -20 25 100
  option temp=$t
  op
  let xva = v(va)
  let xvb = v(vb)
  let xvref = v(vref)
  let xveb3 = v(veb3)
  let xvpg = v(vpg)
  echo CORE temp=$t va_V=$&xva vb_V=$&xvb vref_V=$&xvref veb3_V=$&xveb3 vpg_V=$&xvpg
  let iptat = 2*(i(v4a)+i(v4b))*1e6
  let c3b = i(vm3b)*1e6
  let c7 = i(v7)*1e6
  echo COPIES temp=$t Iptat_uA=$&iptat I3b_uA=$&c3b I7_uA=$&c7
  let ib = -i(vib)*1e6
  let ic1 = -i(vc1)*1e6
  let ic2 = -i(vc2)*1e6
  let ratio = ib/iptat
  let xnb = v(x1.nb)
  echo BIAS temp=$t IB_uA=$&ib Icmp1_uA=$&ic1 Icmp2_uA=$&ic2 IB_over_Iptat=$&ratio nb_V=$&xnb
end
.endc"}
