# one-time: create bg_core.mag with the five routed cells placed (the bg_core wiring goes in this cell).
# Placement (um, bg_core's frame; cell origin -> point, orientation):
#   bg_rrow   ( 6.00,   4.0)  0    resistor row at the bottom: eb2/vb on its top, veb3/vref on its bottom
#   bg_pnp    ( 4.27,  68.0)  90   turned clockwise: eb2 points down onto bg_rrow's eb2, va up, veb3 left
#   bg_bias   (39.50,  38.0)  0    bias column: outputs at its bottom, nb at its top
#   bg_su     (59.50,  52.0)  v    flipped top to bottom: vpg and nb at its top, vref and VDPWR at its bottom
#   bg_mirror ( 3.25, 115.5)  0    mirror on top: drain pins face down
# In the tile, bg_core sits at x = 219.5 um so that its VGND edge (x 111.2..111.8) lies under the VGND stripe.
load bg_core
proc place {cell x y o nm} {
  box [format %.3fum $x] [format %.3fum $y] [format %.3fum $x] [format %.3fum $y]
  if {$o eq "0"} { getcell $cell child 0 0 } else { getcell $cell $o child 0 0 }
  identify $nm
}
place bg_rrow 6 4 0 xrrow
place bg_pnp 4.27 68 90 xpnp
place bg_bias 39.5 38 0 xbias
place bg_su 59.5 52 v xsu
place bg_mirror 3.25 115.5 0 xmirror
save bg_core
quit -noprompt
