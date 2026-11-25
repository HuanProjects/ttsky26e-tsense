v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {tb_osc_si: M6 section 8. osc_core on stand-in sources: vref = V_REF behind 204 kOhm with the 2 pF decap, veb3 = V_EB3 behind 9.2 kOhm,
I_ch ideal (I_PTAT/2, or I_PTAT/4 for the half slope), comparator sinks MNB3 / MNB4 4/8 x4 on their own diode (I_PTAT/2 in), 40 fF wire each.
osc_en rises at ten, thr_sel at tsw (REF -> EB). Runner osc8.py sets T, I_ch, ten, tsw and the stop time.} -900 -560 0 0 0.3 0.3 {}
N -700 340 -700 370 {lab=vrs}
N -700 280 -600 280 {lab=vref}
N -400 340 -400 370 {lab=ves}
C {osc_core.sym} 0 0 0 0 {name=x1}
C {lab_pin.sym} -150 -70 0 0 {name=l1 sig_type=std_logic lab=vref}
C {lab_pin.sym} -150 -50 0 0 {name=l2 sig_type=std_logic lab=veb3}
C {lab_pin.sym} -150 -30 0 0 {name=l3 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} -150 -10 0 0 {name=l4 sig_type=std_logic lab=thr_selb}
C {lab_pin.sym} -150 10 0 0 {name=l5 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} -150 30 0 0 {name=l6 sig_type=std_logic lab=osc_enb}
C {lab_pin.sym} -150 50 0 0 {name=l7 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} -150 70 0 0 {name=l8 sig_type=std_logic lab=ib_cmp2}
C {lab_pin.sym} 150 -70 0 1 {name=l9 sig_type=std_logic lab=vcap}
C {lab_pin.sym} 150 -50 0 1 {name=l10 sig_type=std_logic lab=cmp_raw}
C {lab_pin.sym} 150 -30 0 1 {name=l11 sig_type=std_logic lab=rst}
C {lab_pin.sym} 150 30 0 1 {name=l12 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 150 50 0 1 {name=l13 sig_type=std_logic lab=0}
C {devices/isource.sym} 350 -100 0 0 {name=Ich value='ich'}
C {lab_pin.sym} 350 -130 0 1 {name=l14 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} 350 -70 0 1 {name=l15 sig_type=std_logic lab=vcap}
C {devices/vsource.sym} -900 -100 0 0 {name=Vdd value="'vdd'" savecurrent=false}
C {devices/gnd.sym} -900 -70 0 0 {name=g16 lab=0}
C {lab_pin.sym} -900 -130 0 0 {name=l17 sig_type=std_logic lab=VDPWR}
C {devices/vsource.sym} -700 400 0 0 {name=Vvref value="'vref'" savecurrent=false}
C {devices/gnd.sym} -700 430 0 0 {name=g18 lab=0}
C {devices/res.sym} -700 310 0 0 {name=Rvref
value=204k
footprint=1206
device=resistor
m=1}
C {devices/capa.sym} -600 310 0 0 {name=Cdec
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} -600 340 0 0 {name=g19 lab=0}
C {lab_pin.sym} -700 280 3 0 {name=l20 sig_type=std_logic lab=vref}
C {devices/vsource.sym} -400 400 0 0 {name=Vveb value="'veb3'" savecurrent=false}
C {devices/gnd.sym} -400 430 0 0 {name=g21 lab=0}
C {devices/res.sym} -400 310 0 0 {name=Rveb
value=9.2k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} -400 280 3 0 {name=l22 sig_type=std_logic lab=veb3}
C {cmp_tbbias.sym} -800 700 0 0 {name=xb}
C {lab_pin.sym} -710 680 0 1 {name=l23 sig_type=std_logic lab=nb}
C {lab_pin.sym} -710 700 0 1 {name=l24 sig_type=std_logic lab=VDPWR}
C {lab_pin.sym} -710 720 0 1 {name=l25 sig_type=std_logic lab=0}
C {sky130_fd_pr/nfet_01v8.sym} -400 700 0 0 {name=MNB3
W=4
L=8
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_pin.sym} -380 670 0 1 {name=l26 sig_type=std_logic lab=ib_cmp1}
C {lab_pin.sym} -420 700 0 0 {name=l27 sig_type=std_logic lab=nb}
C {lab_pin.sym} -380 730 0 1 {name=l28 sig_type=std_logic lab=0}
C {lab_pin.sym} -380 700 0 1 {name=l29 sig_type=std_logic lab=0}
C {devices/capa.sym} -300 700 0 0 {name=Cw3
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -300 670 0 1 {name=l30 sig_type=std_logic lab=ib_cmp1}
C {devices/gnd.sym} -300 730 0 0 {name=g31 lab=0}
C {sky130_fd_pr/nfet_01v8.sym} -150 700 0 0 {name=MNB4
W=4
L=8
nf=1
mult=4
ad="expr('int((@nf + 1)/2) * @W / @nf * 0.29')"
pd="expr('2*int((@nf + 1)/2) * (@W / @nf + 0.29)')"
as="expr('int((@nf + 2)/2) * @W / @nf * 0.29')"
ps="expr('2*int((@nf + 2)/2) * (@W / @nf + 0.29)')"
nrd="expr('0.29 / @W ')" nrs="expr('0.29 / @W ')"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_pin.sym} -130 670 0 1 {name=l32 sig_type=std_logic lab=ib_cmp2}
C {lab_pin.sym} -170 700 0 0 {name=l33 sig_type=std_logic lab=nb}
C {lab_pin.sym} -130 730 0 1 {name=l34 sig_type=std_logic lab=0}
C {lab_pin.sym} -130 700 0 1 {name=l35 sig_type=std_logic lab=0}
C {devices/capa.sym} -50 700 0 0 {name=Cw4
m=1
value=40f
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} -50 670 0 1 {name=l36 sig_type=std_logic lab=ib_cmp2}
C {devices/gnd.sym} -50 730 0 0 {name=g37 lab=0}
C {devices/vsource.sym} 300 430 0 0 {name=Ven value="pwl(0 0 'ten' 0 'ten+0.2n' 'vdd')" savecurrent=false}
C {devices/gnd.sym} 300 460 0 0 {name=g38 lab=0}
C {lab_pin.sym} 300 400 0 0 {name=l39 sig_type=std_logic lab=osc_en}
C {sky130_stdcells/inv_1.sym} 600 400 0 0 {name=xosc_en VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 560 400 0 0 {name=l40 sig_type=std_logic lab=osc_en}
C {lab_pin.sym} 640 400 0 1 {name=l41 sig_type=std_logic lab=osc_enb}
C {devices/vsource.sym} 300 630 0 0 {name=Vsel value="pwl(0 0 'tsw' 0 'tsw+0.2n' 'vdd')" savecurrent=false}
C {devices/gnd.sym} 300 660 0 0 {name=g42 lab=0}
C {lab_pin.sym} 300 600 0 0 {name=l43 sig_type=std_logic lab=thr_sel}
C {sky130_stdcells/inv_1.sym} 600 600 0 0 {name=xthr_sel VGND=0 VNB=0 VPB=VDPWR VPWR=VDPWR prefix=sky130_fd_sc_hd__ }
C {lab_pin.sym} 560 600 0 0 {name=l44 sig_type=std_logic lab=thr_sel}
C {lab_pin.sym} 640 600 0 1 {name=l45 sig_type=std_logic lab=thr_selb}
C {sky130_fd_pr/corner.sym} -900 -400 0 0 {name=CORNER only_toplevel=false corner=tt}
C {code_shown.sym} 900 -400 0 0 {name=s1 only_toplevel=false value=".param vdd=1.8 vref=1.24324 veb3=0.709608 ich=1.385555u ten=2u tsw=65.3u
.include /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice
.temp 25
.option method=gear
.control
save vcap x1.vthr rst cmp_raw x1.xos.sw
tran 0.2n 140u 0 0.2n
let tdr = 48u
let tde = 98u
meas tran r1 when v(rst)=0.9 rise=1
print r1
meas tran r2 when v(rst)=0.9 rise=2
print r2
meas tran r3 when v(rst)=0.9 rise=3
print r3
meas tran r4 when v(rst)=0.9 rise=4
print r4
meas tran r5 when v(rst)=0.9 rise=5
print r5
meas tran r6 when v(rst)=0.9 rise=6
print r6
meas tran r7 when v(rst)=0.9 rise=7
print r7
meas tran r8 when v(rst)=0.9 rise=8
print r8
meas tran r9 when v(rst)=0.9 rise=9
print r9
meas tran r10 when v(rst)=0.9 rise=10
print r10
meas tran r11 when v(rst)=0.9 rise=11
print r11
meas tran r12 when v(rst)=0.9 rise=12
print r12
meas tran r13 when v(rst)=0.9 rise=13
print r13
meas tran r14 when v(rst)=0.9 rise=14
print r14
meas tran r15 when v(rst)=0.9 rise=15
print r15
meas tran r16 when v(rst)=0.9 rise=16
print r16
meas tran r17 when v(rst)=0.9 rise=17
print r17
meas tran r18 when v(rst)=0.9 rise=18
print r18
meas tran r19 when v(rst)=0.9 rise=19
print r19
meas tran r20 when v(rst)=0.9 rise=20
print r20
meas tran r21 when v(rst)=0.9 rise=21
print r21
meas tran r22 when v(rst)=0.9 rise=22
print r22
meas tran r23 when v(rst)=0.9 rise=23
print r23
meas tran r24 when v(rst)=0.9 rise=24
print r24
meas tran r25 when v(rst)=0.9 rise=25
print r25
meas tran r26 when v(rst)=0.9 rise=26
print r26
meas tran r27 when v(rst)=0.9 rise=27
print r27
meas tran r28 when v(rst)=0.9 rise=28
print r28
meas tran r29 when v(rst)=0.9 rise=29
print r29
meas tran r30 when v(rst)=0.9 rise=30
print r30
meas tran r31 when v(rst)=0.9 rise=31
print r31
meas tran r32 when v(rst)=0.9 rise=32
print r32
meas tran tc when v(vcap)=v(x1.vthr) rise=1 td=$&tdr
meas tran tcmp when v(cmp_raw)=0.9 rise=1 td=$&tc
meas tran tswon when v(x1.xos.sw)=0.9 rise=1 td=$&tc
meas tran tswoff when v(x1.xos.sw)=0.9 fall=1 td=$&tc
meas tran vth find v(x1.vthr) at=$&tc
let tto = tswoff + 300n
meas tran vmin min v(vcap) from=$&tswoff to=$&tto
let dtd = tcmp - tc
let dlog = tswon - tcmp
let don = tswoff - tswon
let dtau = tswoff - tc
echo TAU ph=REF td=$&dtd tlog=$&dlog ton=$&don tau=$&dtau vth=$&vth vmin=$&vmin
meas tran tc when v(vcap)=v(x1.vthr) rise=1 td=$&tde
meas tran tcmp when v(cmp_raw)=0.9 rise=1 td=$&tc
meas tran tswon when v(x1.xos.sw)=0.9 rise=1 td=$&tc
meas tran tswoff when v(x1.xos.sw)=0.9 fall=1 td=$&tc
meas tran vth find v(x1.vthr) at=$&tc
let tto = tswoff + 300n
meas tran vmin min v(vcap) from=$&tswoff to=$&tto
let dtd = tcmp - tc
let dlog = tswon - tcmp
let don = tswoff - tswon
let dtau = tswoff - tc
echo TAU ph=EB td=$&dtd tlog=$&dlog ton=$&don tau=$&dtau vth=$&vth vmin=$&vmin
.endc"}
