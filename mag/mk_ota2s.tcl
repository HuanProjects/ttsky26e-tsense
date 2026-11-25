# mk_ota2s.tcl -- one-time: create ota2s.mag with the five routed sub-cells placed (the wiring between them and the
# eight pins go in this cell, drawn in the Magic GUI). Placement (um, ota2s frame; cell origin -> point):
#   ota2s_pair  ( 0.00,   0.00)  the input pair, 4 rows (ring 0..90.91 x 0..116.6)
#   ota2s_prow  (90.91,   0.00)  the bias column; its ring abuts the pair's right ring, the n-wells overlap and the two
#                                tail exits overlap (y 13.6..14.6), so tail and VDPWR join without a wire
#   ota2s_nrows ( 3.53, 119.30)  the NMOS block; its d1 / x1 buses (x 43.455 / 47.455) start on the pair's d1 / x1 pins
#   ota2s_rz    (89.50, 120.85)  Rz, right of the NMOS block; its g3 pad (y 144.5) faces the NMOS block's g3 pin
#   ota2s_cc    ( 3.00, 149.30)  Cc on top; its cz bus runs under it at y 147.7..148.7
# Footprint ≈ 115.3 x 200.7 um (pins on the right at x 115.31, CHOP / CHOPB on the left at x 2.53).
load ota2s
proc place {cell x y nm} {
  box [format %.3fum $x] [format %.3fum $y] [format %.3fum $x] [format %.3fum $y]
  getcell $cell child 0 0
  identify $nm
}
place ota2s_pair  0.00   0.00  xpair
place ota2s_prow  90.91  0.00  xprow
place ota2s_nrows 3.53   119.30 xnrows
place ota2s_rz    89.50  120.85 xrz
place ota2s_cc    3.00   149.30 xcc
save ota2s
quit -noprompt
