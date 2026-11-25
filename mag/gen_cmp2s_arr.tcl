# gen_cmp2s_arr.tcl -- the scripted half of cmp2s (M6 layout): the comparator's devices with their own wiring.
# Frozen netlist (../xschem/simulation/osc_core.spice, subckt cmp2s): XM1a nd vthr ib_cmp1 / XM1b n1 vcap ib_cmp1
# (nfet_01v8_lvt W10 L1.75 m6 each), XM2a nd nd VDPWR / XM2b n1 nd VDPWR (pfet_01v8_lvt W4 L4 m8 each), XM3 ib_cmp2 n1
# VDPWR (pfet_01v8_lvt W4 L1 m3), XMIP x ib_cmp2 VDPWR (pfet_01v8 W0.42 L1), XMIN x ib_cmp2 VGND (nfet_01v8 W2 L0.15),
# xinv x -> cmp_raw (sky130_fd_sc_hd__inv_1).
# Builds cmp2s_arr.mag (lvs.sh checks the finished cmp2s against the frozen subckt):
#   pair row  : one nfet_01v8_lvt w10 l1.75 nf12 (guard ring = p-tap), centred (36.0, 7.6). Fingers in the order
#               A B B A A B B A A B B A (A = M1a, gate vthr; B = M1b, gate vcap): both devices have their centroid on
#               the row centre. Strips k = 0..12 at x = 23.76 + 2.04 k: k = 0, 4, 8, 12 -> nd; 2, 6, 10 -> n1; odd -> tail.
#               met2 tracks over the row: nd y 10.1, tail y 7.6, n1 y 5.1 (0.8 wide, x 23.36..48.64), 2x2 via1 per strip.
#               vthr strap (met2) y 14.0..14.8 above the row with a met1 stub from each A finger's top gate contact;
#               vcap strap (met2) y 0.4..1.2 below the row from each B finger's bottom gate contact: the two comparator
#               inputs sit on opposite sides of the pair. The unused gate contacts stay as they are.
#   load row  : one pfet_01v8_lvt w4 l4 nf16 (guard = n-tap + n-well), centred (36.0, 18.4), the same A B B A order
#               (A = M2a, the diode; B = M2b). Strips at x = 1.68 + 4.29 k: k = 0, 4, 8, 12, 16 -> nd; 2, 6, 10, 14 -> n1;
#               odd -> VDPWR. met2 tracks (0.6 wide, x 1.28..70.72): nd y 19.6, n1 y 18.3, VDPWR y 17.0. Gate strap
#               (met2, all 16 gates) y 21.9..22.7 with a met1 stub from every gate contact. The gate strap is NOT yet
#               joined to nd: that is the diode, left for the routing.
#   M3        : pfet_01v8_lvt w4 l1 nf3, centred (56.5, 7.6). Strips 54.565 / 57.145 -> ib_cmp2, 55.855 / 58.435 -> VDPWR.
#               met2 tracks: ib_cmp2 y 8.6, VDPWR y 6.2 (0.6 wide, x 54.165..58.835); gate strap (n1) y 11.0..11.6.
#   MIN, MIP  : the skewed inverter: nfet_01v8 w2 l0.15 at (62.5, 3.6), pfet_01v8 w0.42 l1 at (62.5, 11.0); gates joined
#               by met1 x 62.1..62.9 (ib_cmp2); drains out to the left and joined by met1 x 60.4..60.8 (x); MIN source
#               out to the right -> VGND, MIP source -> VDPWR.
#   inv_1     : sky130_fd_sc_hd__inv_1 at (65.0, 6.0); its n-well merges with MIP's, so MIP's n-tap ring taps it.
#               x reaches its input A on met2 (y 7.2); its VGND / VPWR rails are fed from MIN's / MIP's source exits.
#   ring ties : pair, MIN rings -> VGND; load, M3, MIP rings -> VDPWR (mcon + met1 to the source wiring).
# Left for cmp2s.mag: the buses between the rows (met3: nd, n1, tail, ib_cmp2), the diode link, the supply rails and the pins.
# Run (in tt_tsense/mag, with no cmp2s_arr.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_cmp2s_arr.tcl
drc off
load cmp2s_arr
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc sq {x y h lay} { pt [expr {$x-$h}] [expr {$y-$h}] [expr {$x+$h}] [expr {$y+$h}] $lay }
# 2x2 via1 with 0.8 um met1 and met2 landings
proc via12 {x y} { sq $x $y 0.4 met1; sq $x $y 0.4 met2; sq $x $y 0.3 via1 }
proc gen {name dev pars x y} {
  box 0um 0um 0um 0um
  set before [cellname list children cmp2s_arr]
  eval magic::gencell sky130::$dev XTMP $pars
  set fc ""
  foreach c [cellname list children cmp2s_arr] { if {[lsearch -exact $before $c] < 0} { set fc $c } }
  select cell XTMP
  delete
  bx $x $y $x $y
  getcell $fc child 0 0
  identify $name
  puts "CELL $name $fc"
  lappend ::GENCELLS $fc
}
set GENCELLS {}
# --- devices -------------------------------------------------------------------------------------------------------
gen XPAIR sky130_fd_pr__nfet_01v8_lvt {w 10 l 1.75 nf 12 guard 1 topc 1 botc 1} 36.0 7.6
gen XLOAD sky130_fd_pr__pfet_01v8_lvt {w 4 l 4 nf 16 guard 1 topc 1 botc 0} 36.0 18.4
gen XM3   sky130_fd_pr__pfet_01v8_lvt {w 4 l 1 nf 3 guard 1 topc 1 botc 0} 56.5 7.6
gen XMIN  sky130_fd_pr__nfet_01v8 {w 2 l 0.15 nf 1 guard 1} 62.5 3.6
gen XMIP  sky130_fd_pr__pfet_01v8 {w 0.42 l 1 nf 1 guard 1} 62.5 11.0
bx 65.0 6.0 65.0 6.0
getcell sky130_fd_sc_hd__inv_1 child 0 0
identify XINV

# --- pair: tracks, vias, gate straps -------------------------------------------------------------------------------
array set PTRK {nd 10.1 tail 7.6 n1 5.1}
foreach {n y} [array get PTRK] { pt 23.36 [expr {$y-0.4}] 48.64 [expr {$y+0.4}] met2 }
for {set k 0} {$k <= 12} {incr k} {
  set x [expr {23.76 + 2.04 * $k}]
  if {$k % 2} { set n tail } elseif {$k % 4 == 0} { set n nd } else { set n n1 }
  via12 $x $PTRK($n)
}
pt 24.38 14.0 47.62 14.8 met2
pt 26.42 0.4 46.0 1.2 met2
foreach f {0 3 4 7 8 11} {
  set x [expr {24.78 + 2.04 * $f}]
  pt [expr {$x-0.4}] 12.76 [expr {$x+0.4}] 14.8 met1
  sq $x 14.4 0.3 via1
}
foreach f {1 2 5 6 9 10} {
  set x [expr {24.78 + 2.04 * $f}]
  pt [expr {$x-0.4}] 0.4 [expr {$x+0.4}] 2.44 met1
  sq $x 0.8 0.3 via1
}
# --- load: tracks, vias, gate strap ------------------------------------------------------------------------------
array set LTRK {nd 19.6 n1 18.3 VDPWR 17.0}
foreach {n y} [array get LTRK] { pt 1.28 [expr {$y-0.3}] 70.72 [expr {$y+0.3}] met2 }
for {set k 0} {$k <= 16} {incr k} {
  set x [expr {1.68 + 4.29 * $k}]
  if {$k % 2} { set n VDPWR } elseif {$k % 4 == 0} { set n nd } else { set n n1 }
  via12 $x $LTRK($n)
}
pt 1.28 21.9 70.72 22.7 met2
for {set f 0} {$f < 16} {incr f} {
  set x [expr {3.825 + 4.29 * $f}]
  pt [expr {$x-0.4}] 20.425 [expr {$x+0.4}] 22.7 met1
  sq $x 22.3 0.3 via1
}
# --- M3: tracks, vias, gate strap --------------------------------------------------------------------------------
pt 54.165 8.3 58.835 8.9 met2
pt 54.165 5.9 58.835 6.5 met2
foreach {x y} {54.565 8.6 57.145 8.6 55.855 6.2 58.435 6.2} { via12 $x $y }
pt 54.81 11.0 58.19 11.6 met2
foreach x {55.21 56.5 57.79} {
  pt [expr {$x-0.4}] 9.625 [expr {$x+0.4}] 11.6 met1
  sq $x 11.3 0.3 via1
}
# --- MIN / MIP / inv_1 -------------------------------------------------------------------------------------------
pt 62.1 4.76 62.9 10.585 met1
pt 60.4 3.4 62.395 3.8 met1
pt 60.4 10.8 61.97 11.2 met1
pt 60.4 3.4 60.8 11.2 met1
pt 62.605 3.4 64.6 3.8 met1
pt 64.2 3.4 64.6 6.24 met1
pt 64.2 5.76 65.0 6.24 met1
pt 63.03 10.8 64.6 11.2 met1
pt 64.2 8.48 64.6 11.2 met1
pt 64.2 8.48 65.0 8.96 met1
via12 60.6 7.2
pt 60.2 6.8 65.9 7.6 met2
sq 65.485 7.195 0.085 mcon
sq 65.485 7.195 0.3 met1
sq 65.485 7.195 0.3 met2
sq 65.485 7.195 0.13 via1
# n-well bridge: inv_1's n-well joins MIP's, whose n-tap ring taps both; MIN's unused bottom gate pad to minimum area
pt 63.0 7.305 65.2 12.305 nwell
pt 62.355 2.0 62.645 2.44 met1
# inv_1 output Y (li1) -> met1, out to the cell's right side (the cmp_raw pin goes on its end)
sq 65.885 7.9 0.085 mcon
pt 65.685 7.7 67.2 8.1 met1
# --- supply ties ----------------------------------------------------------------------------------------------------
# VGND: a met1 rail under the cell; the pair's p-tap ring (left side) and MIN's source + ring reach it
pt 22.99 -1.2 64.6 -0.4 met1
pt 22.99 -1.2 23.39 4.2 met1
sq 23.19 4.0 0.085 mcon
pt 64.2 -1.2 64.6 3.8 met1
sq 63.29 3.6 0.085 mcon
# VDPWR: MIP's ring (under its source exit), M3's ring (bottom side, one via1 up to its VDPWR track), the load ring
# (bottom side at fingers 0 and 15, up to the load's VDPWR track), and MIP's source + inv_1's VPWR up to that track
sq 63.715 11.0 0.085 mcon
sq 56.5 4.945 0.085 mcon
pt 56.25 4.745 56.75 6.45 met1
sq 56.5 6.2 0.13 via1
foreach x {3.825 68.175} {
  sq $x 15.745 0.085 mcon
  pt [expr {$x-0.25}] 15.545 [expr {$x+0.25}] 17.25 met1
  sq $x 17.0 0.13 via1
}
via12 64.4 11.0
pt 64.1 10.6 64.7 17.3 met2

select top cell
save cmp2s_arr
foreach c $GENCELLS { load $c; save $c }
load cmp2s_arr
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT cmp2s_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 29] { puts "DRC_WHY $e" }
quit -noprompt
