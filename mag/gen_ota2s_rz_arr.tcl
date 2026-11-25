# gen_ota2s_rz_arr.tcl -- the scripted half of ota2s_rz (M4 layout): the zero-nulling resistor Rz of ota2s.
# ota2s_rz is a layout-only cell; lvs.sh checks it on its own against lvs_cells/ota2s_rz.spice, and the ota2s LVS
# flattens it.
# Builds ota2s_rz_arr.mag: one 8-unit res_high_po_1p41 row (L = 20 um, guard ring = body = VGND; the same device and
# unit geometry as bg_rrow), with
#   - the two dummies (units k = 0 and 7, XRD1 / XRD2) with both ends tied to the guard ring on li1
#   - a 2 x 2 via1 pad on the top pad of unit 1 (g3 end) and of unit 6 (cz end)
#   - one grounded met1 shield sheet over all 8 bodies (tied to the guard ring by mcon), as on bg_rrow
# Left for ota2s_rz.mag: the series chain of units 1..6 (five met1 bridges, alternating bottom / top) and the pins.
# Geometry (um): unit k centre x = 1.27 + 1.89 k; pads 1.31 wide; top pad y 22.59..24.695; bottom pad 0.595..2.70;
# guard ring contacts left x -0.085..0.085, right 15.685..15.855.
# Run (in tt_tsense/mag, with no ota2s_rz_arr.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_ota2s_rz_arr.tcl
drc off
load ota2s_rz_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__res_high_po_1p41 XR l 20 nx 8 guard 1
puts "CELL [cellname list children ota2s_rz_arr]"
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc xc {k} { return [expr {1.27 + 1.89 * $k}] }
proc via12 {x y} { bx [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}]; paint met1; paint met2
                   bx [expr {$x-0.3}] [expr {$y-0.3}] [expr {$x+0.3}] [expr {$y+0.3}]; paint via1 }
# dummies: both ends to the guard ring on li1
foreach k {0 7} {
  set x [xc $k]
  bx [expr {$x - 0.3}] 24.50 [expr {$x + 0.3}] 25.00; paint li1
  bx [expr {$x - 0.3}] 0.20  [expr {$x + 0.3}] 0.80;  paint li1
}
# the guard ring (top and bottom) at each dummy: one solid li1 band (the ring's contacts are separate li1 islands)
bx 0.40 0.00 [expr {[xc 0] + 0.88}] 0.39; paint li1
bx [expr {[xc 7] - 0.81}] 0.00 15.30 0.39; paint li1
bx 0.40 24.95 [expr {[xc 0] + 0.88}] 25.30; paint li1
bx [expr {[xc 7] - 0.81}] 24.95 15.30 25.30; paint li1
# the two ends of the chain: g3 on unit 1's top pad, cz on unit 6's top pad
via12 [xc 1] 23.65
via12 [xc 6] 23.65
# shield: one grounded met1 sheet over all 8 bodies, 0.4 um clear of the pad metal, tied to the ring by mcon
bx -0.20 3.10 15.97 22.19; paint met1
bx -0.085 3.30 0.085 22.00; paint mcon
bx 15.685 3.30 15.855 22.00; paint mcon
writeall force
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT ota2s_rz_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
