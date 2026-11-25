# gen_thrmux.tcl -- thrmux, the threshold mux of osc_core (M6 layout), complete: devices, wiring and pins.
# Frozen netlist (../xschem/simulation/osc_core.spice, subckt thrmux vref veb3 thr_sel thr_selb vthr VDPWR VGND):
#   xn1 nor2_1 (A thr_sel, B seb -> sref), xn2 nor2_1 (A sref, B thr_selb -> seb): cross-coupled, break-before-make;
#   xi1 inv_1 (sref -> srefb), xi2 inv_1 (seb -> sebb);
#   XMTN1 nfet_01v8_lvt W2 L0.5 vref-vthr (gate sref), XMTP1 pfet_01v8_lvt W4 L0.5 vthr-vref (gate srefb),
#   XMTN2 nfet_01v8_lvt W2 L0.5 vthr-veb3 (gate seb),  XMTP2 pfet_01v8_lvt W4 L0.5 veb3-vthr (gate sebb).
# Layout (um, cell frame):
#   standard-cell row at y 0 (rails VGND y -0.24..0.24, VPWR 2.48..2.96): tapvpwrvgnd_1 at x 0, xn1 0.92, xn2 3.22,
#   xi1 5.52, xi2 7.82 (0.92 um gaps on the 0.46 grid, for the pin wiring); one n-well across the row.
#   switches at y 7.0, gate contacts at the bottom: MTN1 x 1.2, MTN2 4.2, MTP1 7.3, MTP2 10.4 (each with its guard ring;
#   the two p-switch wells joined, and joined to the row's well).
#   Gate drives go up from the cell outputs (xn1.Y sref -> MTN1, xn2.Y seb -> MTN2, xi1.Y srefb -> MTP1,
#   xi2.Y sebb -> MTP2); the cell inputs go down to met3 lines under the row (sref y -1.2, seb y -2.2) that close the
#   cross-coupling (sref joined up the left side at x -0.6, seb up the right side at x 12.0 and across at y 4.6).
#   Switch outputs: met3 lines above the switches, vthr y 10.6, vref y 11.6, veb3 y 12.6, met2 risers from every strip.
#   Pins: vref, vthr, veb3 met3 at the left ends of their lines; thr_sel, thr_selb met2 at the bottom; VDPWR, VGND met1
#   on the rails' left ends.
# Run (in tt_tsense/mag, with no thrmux.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_thrmux.tcl
drc off
load thrmux
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc sq {x y h lay} { pt [expr {$x-$h}] [expr {$y-$h}] [expr {$x+$h}] [expr {$y+$h}] $lay }
# li1 pin -> met2: mcon, 0.5 um met1 and met2 pads, one via1
proc pinup {x y} { sq $x $y 0.085 mcon; sq $x $y 0.25 met1; sq $x $y 0.25 met2; sq $x $y 0.13 via1 }
proc v12 {x y} { sq $x $y 0.25 met1; sq $x $y 0.25 met2; sq $x $y 0.13 via1 }
proc v23 {x y} { sq $x $y 0.25 met2; sq $x $y 0.25 met3; sq $x $y 0.14 via2 }
# met2 / met3 wires 0.5 um wide, as vertical (x, y1..y2) or horizontal (y, x1..x2) runs
proc m2v {x y1 y2} { pt [expr {$x-0.25}] $y1 [expr {$x+0.25}] $y2 met2 }
proc m2h {y x1 x2} { pt $x1 [expr {$y-0.25}] $x2 [expr {$y+0.25}] met2 }
proc m3v {x y1 y2} { pt [expr {$x-0.25}] $y1 [expr {$x+0.25}] $y2 met3 }
proc m3h {y x1 x2} { pt $x1 [expr {$y-0.25}] $x2 [expr {$y+0.25}] met3 }
set GENCELLS {}
proc gen {name dev pars x y} {
  set key "$dev $pars"
  if {[info exists ::MADE($key)]} {
    set fc $::MADE($key)
  } else {
    box 0um 0um 0um 0um
    set before [cellname list children thrmux]
    eval magic::gencell sky130::$dev XTMP $pars
    set fc ""
    foreach c [cellname list children thrmux] { if {[lsearch -exact $before $c] < 0} { set fc $c } }
    select cell XTMP
    delete
    set ::MADE($key) $fc
  }
  bx $x $y $x $y
  getcell $fc child 0 0
  identify $name
  puts "CELL $name $fc"
  if {[lsearch -exact $::GENCELLS $fc] < 0} { lappend ::GENCELLS $fc }
}
proc std {name cell x y} { bx $x $y $x $y; getcell sky130_fd_sc_hd__$cell child 0 0; identify $name }

# --- standard cells, rails, well ------------------------------------------------------------------------------------
std XTAP tapvpwrvgnd_1 0 0
std xn1 nor2_1 0.92 0
std xn2 nor2_1 3.22 0
std xi1 inv_1 5.52 0
std xi2 inv_1 7.82 0
pt 0 -0.24 9.2 0.24 met1
pt 0 2.48 11.6 2.96 met1
pt -0.19 1.305 9.39 2.91 nwell
# --- switches --------------------------------------------------------------------------------------------------------
gen XMTN1 sky130_fd_pr__nfet_01v8_lvt {w 2 l 0.5 nf 1 guard 1 topc 0 botc 1} 1.2 7.0
gen XMTN2 sky130_fd_pr__nfet_01v8_lvt {w 2 l 0.5 nf 1 guard 1 topc 0 botc 1} 4.2 7.0
gen XMTP1 sky130_fd_pr__pfet_01v8_lvt {w 4 l 0.5 nf 1 guard 1 topc 0 botc 1} 7.3 7.0
gen XMTP2 sky130_fd_pr__pfet_01v8_lvt {w 4 l 0.5 nf 1 guard 1 topc 0 botc 1} 10.4 7.0
# p-switch wells joined to each other and to the row's well
pt 8.4 4.08 9.3 9.92 nwell
pt 6.0 2.8 11.63 4.2 nwell

# --- cell pins ------------------------------------------------------------------------------------------------------
foreach {x y} {2.04 1.2  1.18 1.2  1.18 2.05  4.34 1.2  3.48 1.2  3.48 2.05  6.005 1.195  6.405 2.0  8.305 1.195  8.705 2.0} {
  pinup $x $y
}
# --- gate drives (up) ---------------------------------------------------------------------------------------------
# sref: xn1.Y -> MTN1 gate
m2v 1.2 2.05 5.95
# seb: xn2.Y -> MTN2 gate
m2v 3.48 2.05 3.85
m2h 3.6 3.23 4.45
m2v 4.2 3.35 5.95
# srefb: xi1.Y -> MTP1 gate
m2v 6.405 2.0 3.85
m2h 3.6 6.155 7.55
m2v 7.3 3.35 4.99
# sebb: xi2.Y -> MTP2 gate
m2v 8.705 2.0 3.85
m2h 3.6 8.455 10.65
m2v 10.4 3.35 4.99
# gate contacts: met1 down from the generated pad, one via1
foreach {x y0 y1 yv} {1.2 5.5 5.995 5.75  4.2 5.5 5.995 5.75  7.3 4.5 4.975 4.74  10.4 4.5 4.975 4.74} {
  pt [expr {$x-0.23}] $y0 [expr {$x+0.23}] $y1 met1
  sq $x $yv 0.13 via1
}
# --- cell inputs (down) and the cross-coupling ----------------------------------------------------------------------
# sref line y -1.2: xn2.A, xi1.A; joined to MTN1's gate drive up the left side
m2v 4.34 -1.45 1.2
m2v 6.005 -1.45 1.195
v23 4.34 -1.2
v23 6.005 -1.2
m3h -1.2 -0.85 6.255
m3v -0.6 -1.45 3.25
m3h 3.0 -0.85 1.45
v23 1.2 3.0
# seb line y -2.2: xn1.B, xi2.A; joined to MTN2's gate drive up the right side and across at y 4.6
m2v 1.18 -2.45 1.2
m2v 8.305 -2.45 1.195
v23 1.18 -2.2
v23 8.305 -2.2
m3h -2.2 0.93 12.25
m3v 12.0 -2.45 4.85
m3h 4.6 3.95 12.25
v23 4.2 4.6
# thr_sel (xn1.A) and thr_selb (xn2.B) down to their pins
m2v 2.04 -3.45 1.2
m2v 3.48 -3.45 1.2

# --- switch outputs ---------------------------------------------------------------------------------------------------
# strip x = switch x -+ 0.395; via1 pads at the strip tops (n: y 7.905, p: y 8.93), met2 risers to the met3 lines
array set LINE {vthr 10.6 vref 11.6 veb3 12.6}
foreach {x yv net} {0.805 7.905 vref  1.595 7.905 vthr  3.805 7.905 vthr  4.595 7.905 veb3
                    6.905 8.93 vref  7.695 8.93 vthr  10.005 8.93 vthr  10.795 8.93 veb3} {
  pt [expr {$x-0.25}] [expr {$yv-0.25}] [expr {$x+0.25}] [expr {$yv+0.25}] met1
  sq $x $yv 0.13 via1
  m2v $x [expr {$yv-0.25}] [expr {$LINE($net)+0.25}]
  v23 $x $LINE($net)
}
m3h 10.6 -0.85 10.255
m3h 11.6 -0.85 7.155
m3h 12.6 -0.85 11.045

# --- supply ties ------------------------------------------------------------------------------------------------------
# n-switch rings (p-tap) -> VGND rail: MTN1 left side x 0.235, MTN2 right side x 5.165
foreach x {0.235 5.165} {
  sq $x 7.0 0.085 mcon
  pt [expr {$x-0.2}] 6.8 [expr {$x+0.2}] 7.2 met1
  sq $x 7.0 0.13 via1
  m2v $x -0.25 7.25
  v12 $x 0.0
}
# p-switch rings (n-tap) -> VPWR rail (met1 straight down; only met2/met3 cross this strip)
foreach x {8.265 11.365} {
  sq $x 4.345 0.085 mcon
  pt [expr {$x-0.115}] 2.48 [expr {$x+0.115}] 4.5 met1
}

# --- pins (symbol order) ----------------------------------------------------------------------------------------------
foreach {nm lay x1 y1 x2 y2} {
  vref     met3 -0.85 11.35 -0.35 11.85
  veb3     met3 -0.85 12.35 -0.35 12.85
  thr_sel  met2  1.79 -3.45  2.29 -2.95
  thr_selb met2  3.23 -3.45  3.73 -2.95
  vthr     met3 -0.85 10.35 -0.35 10.85
  VDPWR    met1  0.0   2.48  0.5   2.96
  VGND     met1  0.0  -0.24  0.5   0.24
} {
  pt $x1 $y1 $x2 $y2 $lay
  label $nm c $lay
  port make
}

select top cell
save thrmux
foreach c $GENCELLS { load $c; save $c }
load thrmux
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT thrmux [drc list count total]"
foreach e [lrange [drc listall why] 0 29] { puts "DRC_WHY $e" }
quit -noprompt
