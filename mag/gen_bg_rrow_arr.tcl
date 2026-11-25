# gen_bg_rrow_arr.tcl -- the scripted half of bg_rrow (M5 layout).
# Builds bg_rrow_arr.mag: the 48-unit res_high_po_1p41 row (L = 20 um, guard ring = body = VGND), plus
#   - the 4 dummies (units 1, 2, 47, 48; k = 0, 1, 46, 47) with both ends tied to the guard ring (li1)
#   - R3: the 40 units k = 2..45 except the R1 units, chained in series: adjacent units by met1 bridges
#     (alternating top / bottom), and the 4 hops over an R1 unit (6->8, 17->19, 28->30, 39->41, all on top)
#     by via1 (2 cuts side by side on each pad) + met2 in the lower part of the top pads.
# Left for the routing in bg_rrow.mag: R1 (units 8/19/30/41, k = 7, 18, 29, 40) in series, and the pins.
# Geometry (um): unit k centre x = 1.27 + 1.89 k; pads 1.31 wide; top pad y 22.59..24.695; bottom pad 0.595..2.70;
# guard ring li1 bottom y -0.085..0.395, top 24.895..25.375, left x -0.085..0.395.
# In bg_rrow.mag this cell sits at +0.265 um in x and y (its bounding box starts at -0.265).
# Run (in tt_tsense/mag):  magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_bg_rrow_arr.tcl
drc off
load bg_rrow_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__res_high_po_1p41 XR l 20 nx 48 guard 1
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc xc {k} { return [expr {1.27 + 1.89 * $k}] }
# dummies: both ends to the guard ring on li1
foreach k {0 1 46 47} {
  set x [xc $k]
  bx [expr {$x - 0.3}] 24.50 [expr {$x + 0.3}] 25.00; paint li1
  bx [expr {$x - 0.3}] 0.20  [expr {$x + 0.3}] 0.80;  paint li1
}
# the guard ring (top and bottom) at each dummy pair: one solid li1 band (its contacts are separate li1 islands,
# and a narrow strap between them leaves li1 notches < 0.17 um)
bx 0.40 0.00 3.90 0.39; paint li1
bx 87.40 0.00 90.90 0.39; paint li1
bx 0.40 24.95 3.90 25.30; paint li1
bx 87.40 24.95 90.90 25.30; paint li1
# R3 chain
set L {}
for {set k 2} {$k <= 45} {incr k} { if {[lsearch {7 18 29 40} $k] < 0} { lappend L $k } }
for {set i 0} {$i < [expr {[llength $L] - 1}]} {incr i} {
  set a [lindex $L $i]; set b [lindex $L [expr {$i + 1}]]
  set xa [xc $a]; set xb [xc $b]
  set top [expr {$i % 2 == 0}]
  if {$b == $a + 1} {
    if {$top} { bx $xa 23.10 $xb 24.20 } else { bx $xa 1.10 $xb 2.20 }
    paint met1
  } else {
    # hop over an R1 unit: met2 across (painted first), then via1 on both pads (lower part of the top pad).
    # via1 0.82 um wide = 2 cuts side by side; the met2 keeps its 0.7 um height so it stays clear of the
    # R1 via stack that the routing cell puts higher on the pad in between.
    bx [expr {$xa - 0.50}] 22.65 [expr {$xb + 0.50}] 23.35; paint met2
    bx [expr {$xa - 0.41}] 22.75 [expr {$xa + 0.41}] 23.25; paint via1
    bx [expr {$xb - 0.41}] 22.75 [expr {$xb + 0.41}] 23.25; paint via1
  }
}
# shield: one grounded met1 sheet over all 48 resistor bodies, so every unit has the same metal above it and the
# shuttle's floating met1 fill cannot land on the bodies (it lands unevenly, on a grid that ignores the unit pitch).
# 0.4 um clear of the pad metal (pads end at y 2.70 / start at 22.59); tied to the guard ring (VGND) by mcon on the
# left and right ring sides (ring contacts at x -0.085..0.085 and 91.285..91.455).
bx -0.20 3.10 91.57 22.19; paint met1
bx -0.085 3.30 0.085 22.00; paint mcon
bx 91.285 3.30 91.455 22.00; paint mcon
writeall force
select top cell
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT [drc list count total]"
puts "R3_ORDER $L"
quit -noprompt
