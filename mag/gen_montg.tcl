# gen_montg.tcl -- montg, the analog-pin monitor switch (tile level; results_m7 section 4): a hybrid transmission gate,
# complete with wiring and pins. Netlist (lvs_cells/montg.spice):
#   XMN a en b VGND sky130_fd_pr__nfet_01v8_lvt W=0.42 L=1 ; XMP b enb a VDPWR sky130_fd_pr__pfet_01v8 W=2 L=0.5
# a = the inner net (vref or iptat_mon), b = the pad side (ua[0] / ua[1]: it lands on diffusion, as the precheck wants).
# The small long lvt NMOS carries 0.85..1.1 V where the standard PMOS is weak (V_REF' in half-current mode); its
# off-leakage stays <= 25 pA at 100 C (tb_montg2). The PMOS carries V_REF at 1.25 V.
# Layout (um, cell frame): NMOS at (1.6, 1.4), PMOS at (5.0, 2.2), each in its own guard ring (= its body: VGND / VDPWR).
#   b: met1 bar from the NMOS right strip to the PMOS left strip, pin (met2) between the rings.
#   a: NMOS left strip and PMOS right strip, joined by met2 under the cell.
#   en / enb: the gate contacts (top), widened for a via1, pins on met2.
# Run (in tt_tsense/mag, with no montg.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_montg.tcl
drc off
load montg
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc sq {x y h lay} { pt [expr {$x-$h}] [expr {$y-$h}] [expr {$x+$h}] [expr {$y+$h}] $lay }
proc v12 {x y} { sq $x $y 0.17 met1; sq $x $y 0.17 met2; sq $x $y 0.13 via1 }
proc pin {nm lay x1 y1 x2 y2} { pt $x1 $y1 $x2 $y2 $lay; label $nm c $lay; port make }
set GENCELLS {}
proc gen {name dev pars x y} {
  box 0um 0um 0um 0um
  set before [cellname list children montg]
  eval magic::gencell sky130::$dev XTMP $pars
  set fc ""
  foreach c [cellname list children montg] { if {[lsearch -exact $before $c] < 0} { set fc $c } }
  select cell XTMP
  delete
  bx $x $y $x $y
  getcell $fc child 0 0
  identify $name
  puts "CELL $name $fc"
  lappend ::GENCELLS $fc
}
gen XMN sky130_fd_pr__nfet_01v8_lvt {w 0.42 l 1 nf 1 guard 1 topc 1 botc 0} 1.6 1.4
gen XMP sky130_fd_pr__pfet_01v8 {w 2 l 0.5 nf 1 guard 1 topc 1 botc 0} 5.0 2.2
# b: NMOS right strip (x 2.245) -> PMOS left strip (x 4.605); via1 + met2 pad between the rings
pt 2.13 1.10 4.72 1.40 met1
pt 3.23 1.08 3.57 1.42 met1
v12 3.40 1.25
# a: NMOS left strip (x 0.955) and PMOS right strip (x 5.395), met2 under the cell (y 0.0..0.34)
pt 0.825 1.075 1.085 1.415 met1
sq 0.955 1.245 0.13 via1
pt 0.785 0.0 1.125 1.415 met2
pt 5.265 1.33 5.525 1.67 met1
sq 5.395 1.50 0.13 via1
pt 5.225 0.0 5.565 1.67 met2
pt 0.785 0.0 5.565 0.34 met2
# en: NMOS gate contact widened up, via1
pt 1.12 1.615 2.08 2.10 met1
sq 1.60 1.85 0.13 via1
sq 1.60 1.85 0.17 met2
# enb: PMOS gate contact widened up, via1
pt 4.77 3.225 5.23 3.80 met1
sq 5.00 3.55 0.13 via1
sq 5.00 3.55 0.17 met2
# bodies: NMOS ring (left side) -> VGND, PMOS ring (right side) -> VDPWR
sq 0.385 1.40 0.085 mcon
sq 0.385 1.40 0.17 met1
sq 5.965 2.20 0.085 mcon
sq 5.965 2.20 0.17 met1
# pins (order a b en enb VDPWR VGND)
pin a     met2 0.785 0.0  1.125 0.34
pin b     met2 3.23  1.08 3.57  1.42
pin en    met2 1.43  1.68 1.77  2.02
pin enb   met2 4.83  3.38 5.17  3.72
pin VDPWR met1 5.795 2.03 6.135 2.37
pin VGND  met1 0.215 1.23 0.555 1.57
select top cell
save montg
foreach c $GENCELLS { load $c; save $c }
load montg
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT montg [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
