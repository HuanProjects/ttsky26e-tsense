# mk_tile.tcl -- builds the tile's top cell from TinyTapeout's 2x2 analog template, then writes the GDS and the LEF
# that the gds workflow reads (../gds/<top>.gds, ../lef/<top>.lef).
# Based on TinyTapeout's magic_init_project.tcl (tt-support-tools, tech/sky130A/def/analog; Apache-2.0).
# The template tt_analog_2x2.def (same folder, copied unchanged from there) gives the 334.88 x 225.76 um boundary
# and the 51 pins: digital pins on met4 along the top edge, ua[0..7] on met4 along the bottom edge.
#
# Contents: pins, power stripes, the two analog-pin stubs, the finished blocks and their supply straps. The left band
# (x 8..90: oscillator, comparator, mux, reset, digital row), the output tie-offs and the exits of bgr's control
# pins come later; edit the lists below as blocks arrive.
# Run (in tt_tsense/mag, with the top cell's .mag absent or about to be replaced):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc mk_tile.tcl
set TOP tt_um_huanprojects_tsense
set STRIPE_W 2um                        ;# TinyTapeout's minimum is 1.2 um
# power stripes on met4, y = 5 .. 220.76 um: net, x of the left edge. Left pair, middle pair (between the left band
# and bgr; ota2s's Cc starts at x 97, 2 um right of the VGND stripe), right pair (over bg_core's right edge).
set STRIPES { VDPWR 1um  VGND 4um  VDPWR 90um  VGND 93um  VDPWR 327um  VGND 330um }
# analog pins in use (info.yaml analog_pins: 2): x of the pin centre; each gets a met4 stub from the pin up to y = 3 um
set UA_STUBS { 152.26 132.94 }
# cells: name, x, y of the cell's origin (um).
#   bgr (results_m5.md section 18): its frame is the tile frame shifted by (94, 8), so ota2s sits at (94, 12) and
#   bg_core at (219.5, 8): bg_core's VGND edge column (bg_core x 111.2..111.8) lies under the VGND stripe at 330 um
#   and its mirror ring (x 106.85..107.45) next to the VDPWR stripe at 327 um.
set CELLS { bgr 94 8  osc_core 7 12  vref_decap 25.0 122.1  swdrv 25.99 146.0  dig_top 8.05 188.36
             montg 225.9 1.2  montg 233.9 1.2 }

drc off
def read tt_analog_2x2.def
cellname rename tt_um_template $TOP

proc um {v} { return [format "%.3fum" $v] }
foreach {name x} $STRIPES {
  box $x 5um $x 220.76um
  box width $STRIPE_W
  paint met4
  label $name FreeSans 0.25u -met4
  port make
  port use [expr {$name eq "VGND" ? "ground" : "power"}]
  port class bidirectional
  port connections n s e w
}
foreach x $UA_STUBS {
  box [um [expr {$x - 0.45}]] 1.0um [um [expr {$x + 0.45}]] 3.0um
  paint met4
}
foreach {cell x y} $CELLS {
  box [um $x] [um $y] [um $x] [um $y]
  getcell $cell child 0 0
}

# supply straps: via stacks with 2 x 2 cuts on every level
# (pads: met1 0.8, via1 0.6, met2 0.8, via2 0.7, met3 1.0, via3 0.8, met4 1.0 um)
proc sqpaint {x y h lay} {
  box [um [expr {$x-$h}]] [um [expr {$y-$h}]] [um [expr {$x+$h}]] [um [expr {$y+$h}]]
  paint $lay
}
proc stack14 {x y} {
  foreach {h lay} {0.4 met1 0.4 met2 0.5 met3 0.5 met4 0.3 via1 0.35 via2 0.4 via3} { sqpaint $x $y $h $lay }
}
proc stack34 {x y} {
  foreach {h lay} {0.5 met3 0.5 met4 0.4 via3} { sqpaint $x $y $h $lay }
}
proc rect {x0 y0 x1 y1 lay} {
  box [um $x0] [um $y0] [um $x1] [um $y1]
  paint $lay
}
# bg_core, to the right stripes:
# VGND: on bg_core's VGND edge column (bg_core (111.5, 46.0)), between the VDPWR line (y 43.3) and the bias/su trunk (y 49.0)
stack14 331.0 54.0
# VDPWR: met1 out of the mirror ring's right side (bg_core x 106.85 -> 108.4, y 175), stack at bg_core x 108.0,
# 0.35 um clear of the vpg riser (bg_core x 108.75)
rect 326.35 182.6 327.9 183.4 met1
stack14 327.5 183.0
# ota2s, to the middle stripes, by 2 um met4 bars landing where its supply current enters (met4 is free over ota2s
# below Cc, bgr y < 150.5), so its 12.6 uA does not take bgr's links through the mirror ring and the PNP ground:
# VDPWR: onto bgr's own stack out of ota2s_prow's ring (bgr (116, 45.5), via1/via2 + met3 already there): add via3;
# the bar starts on met3 under the VGND stripe (via3 at x 91 inside the VDPWR stripe, via3 back up at x 96.5)
stack34 91.0 53.5
rect 90.5 53.0 97.0 54.0 met3
stack34 96.5 53.5
rect 96.0 52.5 210.5 54.5 met4
stack34 210.0 53.5
# VGND: a bar from the VGND stripe with two stacks: on the nrows ring's left side (bgr (3.83, 130.5)) and on bgr's
# VGND junction, the met1 line at x 118.0..118.8 where it meets the Rz-shield bar (bgr (118.4, 130.5))
rect 94.0 137.5 212.9 139.5 met4
stack14 97.83 138.5
stack14 212.4 138.5

if {[file exists tile_wiring.tcl]} { source tile_wiring.tcl }
select top cell
save $TOP.mag
file mkdir ../gds
gds write ../gds/$TOP.gds
file mkdir ../lef
select top cell
lef write ../lef/$TOP.lef -hide -pinonly

select top cell
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT $TOP [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
