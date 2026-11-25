# helpers.tcl -- small commands for routing by hand in the Magic GUI.
# Load once per Magic session, in tkcon (Magic started in tt_tsense/mag):   source helpers.tcl
#
# stack x y : a via stack from metal1 up to metal3, centred on (x, y) in um, with 2 x 2 cuts on both levels:
#             a metal2 landing (0.8 um), a metal3 pad (0.9 um), via1 (0.6 um) and via2 (0.7 um).
# via12 x y : metal1 up to metal2 only, 2 x 2 cuts: a metal2 landing (0.8 um) and via1 (0.6 um).
# via23 x y : metal2 up to metal3 only, 2 x 2 cuts: a metal2 landing (0.8 um), a metal3 pad (0.9 um), via2 (0.7 um).
# via34 x y : metal3 up to metal4 only, 2 x 2 cuts: metal3 and metal4 pads (1.0 um), via3 (0.8 um).
# stack24 x y : metal2 up to metal4, 2 x 2 cuts: a metal2 landing (0.8 um), metal3 and metal4 pads (1.0 um),
#             via2 (0.7 um) and via3 (0.8 um).
# stack14 x y : metal1 up to metal4, 2 x 2 cuts: metal1 and metal2 pads (0.8 um), metal3 and metal4 pads (1.0 um),
#             via1 (0.6 um), via2 (0.7 um) and via3 (0.8 um).
# The metals are painted first: a via painted without its metal margin gives DRC errors.
# Why these sizes: the tech file places cuts on a grid (via1: 0.055 border, 0.15 cut, 0.17 space;
# via2: 0.04 border, 0.20 cut, 0.20 space), so a 0.5 um via area holds ONE cut and 0.6 / 0.7 um hold 2 x 2.
# One cut is 4.5 ohm (via1) or 3.41 ohm (via2); 2 x 2 is a quarter of that and survives one bad cut.
proc sqpaint {x y h lay} {
  box [format %.3fum [expr {$x-$h}]] [format %.3fum [expr {$y-$h}]] [format %.3fum [expr {$x+$h}]] [format %.3fum [expr {$y+$h}]]
  paint $lay
}
proc stack {x y} {
  foreach {h lay} {0.4 met2 0.45 met3 0.3 via1 0.35 via2} { sqpaint $x $y $h $lay }
}
proc via12 {x y} {
  foreach {h lay} {0.4 met2 0.3 via1} { sqpaint $x $y $h $lay }
}
proc via23 {x y} {
  foreach {h lay} {0.4 met2 0.45 met3 0.35 via2} { sqpaint $x $y $h $lay }
}
proc via34 {x y} {
  foreach {h lay} {0.5 met3 0.5 met4 0.4 via3} { sqpaint $x $y $h $lay }
}
proc stack24 {x y} {
  foreach {h lay} {0.4 met2 0.5 met3 0.5 met4 0.35 via2 0.4 via3} { sqpaint $x $y $h $lay }
}
proc stack14 {x y} {
  foreach {h lay} {0.4 met1 0.4 met2 0.5 met3 0.5 met4 0.3 via1 0.35 via2 0.4 via3} { sqpaint $x $y $h $lay }
}
puts "helpers loaded: stack x y (met1-met3), via12 (met1-met2), via23 (met2-met3), via34 (met3-met4),"
puts "                stack24 (met2-met4), stack14 (met1-met4); all 2x2 cuts"
