v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 150 -10 250 -10 {lab=veb3}
N 250 -10 250 -0 {lab=veb3}
N 250 -0 340 -0 {lab=veb3}
N 150 10 220 10 {lab=eb2}
N 220 10 220 40 {lab=eb2}
N 220 40 340 40 {lab=eb2}
C {bg_pnp.sym} 0 0 0 0 {name=xp}
C {bg_rrow.sym} 490 0 0 1 {name=xr}
C {lab_pin.sym} 150 -30 0 1 {name=p1 sig_type=std_logic lab=va}
C {lab_pin.sym} 340 -40 0 0 {name=p2 sig_type=std_logic lab=vb}
C {lab_pin.sym} 340 -20 0 0 {name=p3 sig_type=std_logic lab=vref}
C {lab_pin.sym} 250 -10 0 1 {name=p4 sig_type=std_logic lab=veb3}
C {lab_pin.sym} 220 20 0 1 {name=p5 sig_type=std_logic lab=eb2}
C {lab_pin.sym} 340 20 0 0 {name=p6 sig_type=std_logic lab=GND}
C {gnd.sym} 150 30 0 0 {name=l1 lab=0}
C {code_shown.sym} 860 110 0 0 {name=s1 only_toplevel=false value="Vdd VDPWR 0 1.8
* 0 V ammeters: each mirror drain -> the core node it feeds
Vm1 d1 va 0
Vm2 d2 vb 0
Vm3a d3a vref 0
Vm3b d3b vref 0
* the other copies get their real loads later; park their drains at 0.71 V
V4a d4a 0 0.71
V4b d4b 0 0.71
V7 d7 0 0.71
V5 d5 0 0.71
* stand-in op-amp: gain 1e6, GBW 100 kHz, output stops at the 1.8 V rail
* pol=1 puts + on vb (hand analysis, M5 0); 2c will use pol=-1 to swap the inputs
.param pol=1
Bgm 0 x I = pol*1e-4*(v(vb)-v(va))
Rx x 0 1e10
Cx x 0 159p
Bout oa 0 V = min(1.8, 0.9 + v(x))
Vkick vpg oa dc 0 ac 1 pwl(0 0 1u 0 1.001u 1m 2u 1m 2.001u 0)
.nodeset v(vpg)=0.55 v(va)=0.71 v(vb)=0.71 v(vref)=1.25 v(x)=-0.37
.control
* M5 2c: loop polarity. Same circuit, op-amp inputs normal (pol=1) then swapped (pol=-1)
option reltol=1e-6 vntol=1e-9 abstol=1e-15 method=gear
foreach p 1 -1
  alterparam pol=$p
  reset
  * reset puts temp back to 27, so set 25 after it
  option temp=25
  op
  let i1 = i(vm1)*1e6
  let xvpg = v(vpg)
  echo POL_OP pol=$p I1_uA=$&i1 vpg_V=$&xvpg
  * loop gain: Vkick breaks the loop between oa and vpg, so T = -v(oa)/v(vpg)
  ac dec 20 1m 10meg
  let T = -v(oa)/v(vpg)
  let Tmag = abs(T)
  let ph = 180/pi*cph(T)
  let ph0 = ph[0]
  let gdb0 = db(Tmag[0])
  meas ac fu when Tmag=1
  let fu_kHz = fu/1e3
  echo POL_AC pol=$p T_dB_at_1mHz=$&gdb0 phase_T_at_1mHz_deg=$&ph0 fu_kHz=$&fu_kHz
  * kick: +1 mV on vpg from 1 us to 2 us
  tran 10n 100u
  meas tran vpg_10 find v(vpg) at=10u
  meas tran vpg_end find v(vpg) at=100u
  meas tran i1_end find i(vm1) at=100u
  let i1e = i1_end*1e6
  echo POL_KICK pol=$p vpg_at_10us=$&vpg_10 vpg_at_100us=$&vpg_end I1_at_100us_uA=$&i1e
  plot v(vpg) title kick_pol_$p
end
.endc"}
C {sky130_fd_pr/corner.sym} 810 -140 0 0 {name=CORNER only_toplevel=false corner=tt}
C {bg_mirror.sym} -390 -250 0 0 {name=x1}
C {lab_pin.sym} -240 -340 0 1 {name=p7 sig_type=std_logic lab=vpg
}
C {lab_pin.sym} -240 -320 0 1 {name=p8 sig_type=std_logic lab=VDPWR
}
C {lab_pin.sym} -240 -300 0 1 {name=p9 sig_type=std_logic lab=d3b
}
C {lab_pin.sym} -240 -280 0 1 {name=p10 sig_type=std_logic lab=d3a
}
C {lab_pin.sym} -240 -260 0 1 {name=p11 sig_type=std_logic lab=d4b
}
C {lab_pin.sym} -240 -240 0 1 {name=p12 sig_type=std_logic lab=d4a
}
C {lab_pin.sym} -240 -220 0 1 {name=p13 sig_type=std_logic lab=d2
}
C {lab_pin.sym} -240 -200 0 1 {name=p14 sig_type=std_logic lab=d7
}
C {lab_pin.sym} -240 -180 0 1 {name=p15 sig_type=std_logic lab=d5
}
C {lab_pin.sym} -240 -160 0 1 {name=p16 sig_type=std_logic lab=d1
}
