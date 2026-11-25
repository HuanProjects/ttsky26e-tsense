# gen_ota2s_cc_arr.tcl -- the scripted half of ota2s_cc (M4 layout): the Miller capacitor Cc of ota2s.
# ota2s_cc is a layout-only cell; lvs.sh checks it on its own against lvs_cells/ota2s_cc.spice, and the ota2s LVS
# flattens it.
# Builds ota2s_cc_arr.mag: 8 cap_mim_m3_1 units (w 25, l 25; one generated cell placed 8 times) in 2 rows x 4 columns,
# on one met3 sheet that joins every bottom plate (C2 = OUT). The generated unit also lifts its bottom plate to a
# thin met4 strip on its right edge (via3); those strips are OUT too and stay as they are.
# Left for ota2s_cc.mag: joining the eight met4 top plates (C1 = cz: one bridge per column between the two rows,
# a riser per column and a met4 bus under the array) and the pins.
#
# Floor plan (um, this cell's frame = the parent's frame with `getcell ota2s_cc_arr child 0 0`):
#   unit (column c, row r) centred at x = 13.58 + 27.16 c, y = 12.7 + 26.0 r  (c = 0..3, r = 0..1);
#   bottom plates (met3) 27.16 x 25.4 abut in x; the met3 sheet covers x 0..108.64, y 0..51.4;
#   each unit's top plate (met4) spans x = cx - 13.185 .. cx + 11.425, y = cy +- 12.305; its OUT strip (met4) sits at
#   x = cx + 13.08 .. cx + 13.56.
#   The generator's own 2 x 4 array (nx 4 ny 2) is 118.63 um wide; this pitch keeps Cc inside the 115 um centre band.
# Run (in tt_tsense/mag, with no ota2s_cc_arr.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_ota2s_cc_arr.tcl
drc off
load ota2s_cc_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__cap_mim_m3_1 XTMP w 25 l 25
set fc [lindex [cellname list children ota2s_cc_arr] 0]
select cell XTMP
delete
puts "CELL $fc"
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc cx {c} { return [expr {13.58 + 27.16 * $c}] }
proc cy {r} { return [expr {12.7 + 26.0 * $r}] }
for {set r 0} {$r < 2} {incr r} {
  for {set c 0} {$c < 4} {incr c} {
    bx [cx $c] [cy $r] [cx $c] [cy $r]
    getcell $fc child 0 0
    identify "XCC_c${c}r${r}"
  }
}
# one met3 sheet: all bottom plates (OUT), including the 0.6 um gap between the rows
bx 0 0 108.64 51.4
paint met3
save ota2s_cc_arr
load $fc
save $fc
load ota2s_cc_arr
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT ota2s_cc_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
