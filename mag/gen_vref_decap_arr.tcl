# gen_vref_decap_arr.tcl -- the scripted half of vref_decap: the 2 pF decoupling capacitor on V_REF (spec section 3
# and M6 layout notes; every M6 bench used an ideal 2 pF here). The top-level schematic takes the same device:
#   XCdec vref VGND sky130_fd_pr__cap_mim_m3_1 W=22.17 L=22.17 MF=2
# Per unit (tt model): 2.00 fF/um2 x 22.17^2 + 0.19 fF/um x 4 x 22.17 = 999.9 fF, so 2 units = 2.000 pF.
# The MIM side is kept under the PDK's 30 um limit, so two units instead of one 31.6 um square.
# vref_decap is a layout-only cell; lvs.sh checks it on its own against lvs_cells/vref_decap.spice.
# Builds vref_decap_arr.mag: 2 cap_mim_m3_1 units (one generated cell placed twice) in 1 row x 2 columns, on one
# met3 sheet that joins both bottom plates (C2 = VGND, spec B15). The unit lifts its bottom plate to a thin met4
# strip on its right edge (via3); those strips are VGND too and stay as they are.
# Left for vref_decap.mag: joining the two met4 top plates (C1 = vref: a riser per column down to a met4 bus under
# the array) and the pins.
#
# Floor plan (um, this cell's frame = the parent's frame with `getcell vref_decap_arr child 0 0`):
#   unit c centred at x = 12.165 + 24.33 c, y = 11.285 (c = 0..1); bottom plates 24.33 x 22.57 abut in x, the met3
#   sheet covers x 0..48.66, y 0..22.57; each top plate (met4) spans x = cx - 11.77 .. cx + 10.01, y = 0.395..22.175;
#   its VGND strip (met4) sits at x = cx + 11.665 .. cx + 12.145.
# Run (in tt_tsense/mag, with no vref_decap_arr.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_vref_decap_arr.tcl
drc off
load vref_decap_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__cap_mim_m3_1 XTMP w 22.17 l 22.17
set fc [lindex [cellname list children vref_decap_arr] 0]
select cell XTMP
delete
puts "CELL $fc"
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
for {set c 0} {$c < 2} {incr c} {
  set x [expr {12.165 + 24.33 * $c}]
  bx $x 11.285 $x 11.285
  getcell $fc child 0 0
  identify "XCdec_c${c}"
}
bx 0 0 48.66 22.57
paint met3
save vref_decap_arr
load $fc
save $fc
load vref_decap_arr
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT vref_decap_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
