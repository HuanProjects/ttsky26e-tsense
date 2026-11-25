v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 20 -80 20 -30 {lab=va}
N 190 -80 190 -30 {lab=eb2}
N 340 -80 340 -30 {lab=veb3}
C {sky130_fd_pr/pnp_05v5.sym} 0 0 0 0 {name=Q1
model=pnp_05v5_W3p40L3p40
m=1
spiceprefix=X
}
C {sky130_fd_pr/pnp_05v5.sym} 170 0 0 0 {name=Q2
model=pnp_05v5_W3p40L3p40
m=8
spiceprefix=X
}
C {sky130_fd_pr/pnp_05v5.sym} 320 0 0 0 {name=Q3
model=pnp_05v5_W3p40L3p40
m=1
spiceprefix=X
}
C {sky130_fd_pr/pnp_05v5.sym} 480 0 0 0 {name=QD
model=pnp_05v5_W3p40L3p40
m=15
spiceprefix=X
}
C {iopin.sym} 20 -80 2 0 {name=p1 lab=va}
C {iopin.sym} 190 -80 2 0 {name=p2 lab=eb2}
C {iopin.sym} 340 -80 2 0 {name=p3 lab=veb3}
C {iopin.sym} -80 90 2 0 {name=p4 lab=VGND}
C {lab_pin.sym} -20 0 0 0 {name=p5 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 20 30 0 0 {name=p6 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 150 0 0 0 {name=p7 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 190 30 0 0 {name=p8 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 300 0 0 0 {name=p9 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 340 30 0 0 {name=p10 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 460 0 0 0 {name=p11 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 500 30 0 0 {name=p12 sig_type=std_logic lab=VGND}
C {lab_pin.sym} 500 -30 0 0 {name=p13 sig_type=std_logic lab=VGND}
