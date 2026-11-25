# gen_bg_pnp_arr.tcl -- the scripted half of bg_pnp (M5 layout).
# Builds bg_pnp_arr.mag: the 5x5 sky130 PNP array (spec M5 layout notes) plus the regular ties:
#   every unit: base ring shorted to the collector ring (li1 strap, left side) -> base = collector = substrate (VGND)
#   the 15 dummies (outer ring except Q3 at column 2, row 0): emitter tied to the base ring (mcon + met1)
#   ground ring: mcon rows + a 0.5 um met1 band on the outer collector ring, open at the bottom for x 15.0..17.5 um
#     where Q3's met1 (veb3) leaves. The PDK cell's rings are li1 only (12.8 ohm/sq); without metal the 8.3 uA
#     of the three branches returns through an li1 mesh and lifts the array by about 1 mV at a single ground point.
# Units: unit (i, j) sits at (6.44 i, 6.44 j) um; i = column (x), j = row (y). Q1 = (2,2); Q2 = the 8 around it;
# Q3 = (2,0), middle of the bottom edge. The routing goes in bg_pnp.mag, which only instantiates this cell,
# so re-running this script never touches it.
# Run (in tt_tsense/mag):  magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_bg_pnp_arr.tcl
drc off
load bg_pnp_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__pnp_05v5_W3p40L3p40 XQ nx 5 ny 5
set p 6.44
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
for {set i 0} {$i < 5} {incr i} {
  for {set j 0} {$j < 5} {incr j} {
    set x [expr {$i * $p}]
    set y [expr {$j * $p}]
    # base ring -> collector ring
    box [um [expr {$x + 0.50}]] [um [expr {$y + 3.15}]] [um [expr {$x + 1.05}]] [um [expr {$y + 3.35}]]
    paint li1
    set outer [expr {$i == 0 || $i == 4 || $j == 0 || $j == 4}]
    if {$outer && !($i == 2 && $j == 0)} {
      # dummy: emitter -> base ring
      box [um [expr {$x + 0.99}]] [um [expr {$y + 3.15}]] [um [expr {$x + 1.16}]] [um [expr {$y + 3.32}]]
      paint mcon
      box [um [expr {$x + 0.93}]] [um [expr {$y + 3.09}]] [um [expr {$x + 1.90}]] [um [expr {$y + 3.38}]]
      paint met1
    }
  }
}
# ground ring on the outer collector ring (li1 at 0.13..0.625 um from each edge of the 32.46 um array)
bx 0.29 0.80 0.46 31.66;   paint mcon
bx 32.00 0.80 32.17 31.66; paint mcon
bx 0.80 32.00 31.66 32.17; paint mcon
bx 0.80 0.29 14.80 0.46;   paint mcon
bx 17.70 0.29 31.66 0.46;  paint mcon
bx 0.13 0.13 0.63 32.33;   paint met1
bx 31.83 0.13 32.33 32.33; paint met1
bx 0.13 31.83 32.33 32.33; paint met1
bx 0.13 0.13 15.00 0.63;   paint met1
bx 17.50 0.13 32.33 0.63;  paint met1
save bg_pnp_arr
select top cell
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT [drc list count total]"
quit -noprompt
