# mk_bgr.tcl -- one-time: create bgr.mag (M5 layout) with its five sub-cells placed; the wiring between them and the
# 19 pins go in this cell. bgr frame = tile frame shifted by (94, 8): bgr sits in the tile at (94, 8).
#   ota2s     (  0.0,   4.0)  the op-amp (tile 94, 12); the middle stripe pair goes at tile x 90 / 93
#   bg_core   (125.5,   0.0)  the bandgap core, unchanged position in the tile (219.5, 8)
#   bgr_chop  ( 99.5, 109.0)  the input chopper, in the op-amp's empty strip right under its INN / INP lines
#   xtg_ich   (150.0,  85.0)  bgr_tg for ich (a = ich, b = ichb), in bg_core's empty corner above the PNP array
#   xtg_i3    (188.5,  75.0)  bgr_tg for i3 (a = vref, b = i3b), in bg_core's empty area left of the nb wire
load bgr
proc place {cell x y nm} {
  box [format %.3fum $x] [format %.3fum $y] [format %.3fum $x] [format %.3fum $y]
  getcell $cell child 0 0
  identify $nm
}
place ota2s    0.0   4.0  xota
place bg_core  125.5 0.0  xcore
place bgr_chop 99.5  109.0 xchop
place bgr_tg   150.0 85.0 xtg_ich
place bgr_tg   188.5 75.0 xtg_i3
save bgr
quit -noprompt
