# gen_osc_cosc_arr.tcl -- the scripted half of osc_cosc (M6 layout): the oscillator capacitor C_osc of osc_core
# (frozen netlist: XCosc vcap VGND sky130_fd_pr__cap_mim_m3_1 W=25 L=25 MF=4).
# osc_cosc is a layout-only cell; lvs.sh checks it on its own against lvs_cells/osc_cosc.spice, and the osc_core LVS
# flattens it.
# Builds osc_cosc_arr.mag: 4 cap_mim_m3_1 units (w 25, l 25: the same generated unit cell as Cc,
# sky130_fd_pr__cap_mim_m3_1_R3YF9Y) in 2 rows x 2 columns, on one met3 sheet that joins every bottom plate
# (C2 = VGND, spec B15). The unit also lifts its bottom plate to a thin met4 strip on its right edge (via3); those
# strips are VGND too and stay as they are.
# Left for osc_cosc.mag: joining the four met4 top plates (C1 = vcap: one bridge per column between the two rows,
# a riser per column and a met4 bus ABOVE the array, where the comparator sits) and the pins.
#
# Floor plan (um, this cell's frame = the parent's frame with `getcell osc_cosc_arr child 0 0`):
#   unit (column c, row r) centred at x = 13.58 + 27.16 c, y = 12.7 + 26.0 r  (c = 0..1, r = 0..1), as in ota2s_cc;
#   the met3 sheet covers x 0..54.32, y 0..51.4;
#   each unit's top plate (met4) spans x = cx - 13.185 .. cx + 11.425, y = cy +- 12.305; its VGND strip (met4) sits
#   at x = cx + 13.08 .. cx + 13.56.
# Run (in tt_tsense/mag, with no osc_cosc_arr.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_osc_cosc_arr.tcl
drc off
load osc_cosc_arr
set fc sky130_fd_pr__cap_mim_m3_1_R3YF9Y
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc cx {c} { return [expr {13.58 + 27.16 * $c}] }
proc cy {r} { return [expr {12.7 + 26.0 * $r}] }
for {set r 0} {$r < 2} {incr r} {
  for {set c 0} {$c < 2} {incr c} {
    bx [cx $c] [cy $r] [cx $c] [cy $r]
    getcell $fc child 0 0
    identify "XCosc_c${c}r${r}"
  }
}
# one met3 sheet: all bottom plates (VGND), including the 0.6 um gap between the rows
bx 0 0 54.32 51.4
paint met3
save osc_cosc_arr
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT osc_cosc_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
