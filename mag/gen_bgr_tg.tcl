# gen_bgr_tg.tcl -- bgr_tg (M5 layout, bgr): one transmission gate + dump switch, fully scripted. Used twice in bgr:
#   ich: a = ich,  b = ichb, on = ich_on, onb = ich_onb, dump = ich_dump
#   i3:  a = vref, b = i3b,  on = i3_on,  onb = i3_onb,  dump = i3_dump
# Layout-only cell: lvs.sh checks it against lvs_cells/bgr_tg.spice; the bgr LVS flattens it.
# Three guard-ring devices (each with its own li1 tap ring = its body), centres at y = 3.5, left to right:
#   XD dump nfet_01v8 w 1 l 0.5 (mirrored: S = VGND left, D = b right)   at x = 1.6
#   XN      nfet_01v8 w 2 l 0.5 (D = b left, S = a right)                at x = 4.4
#   XP      pfet_01v8 w 4 l 0.5 (mirrored: S = a left, D = b right)      at x = 7.6
# so facing strips share a net: one met1 bar joins XD-b and XN-b, one joins XN-a and XP-a; XP-b returns on met2.
# Gates: met1 stubs up through the ring tops to 2x2 via1 pads; pins dump, on, onb on met2.
# Rings: mcon + met1 ties at each ring's bottom: XD and XN rings and XD's source on VGND (met1 bar at y 0.0..0.5),
# XP ring on VDPWR (met1 pad + pin). Pins a (met1 bar), b (met2 line), dump, on, onb, VDPWR, VGND.
# Run (in tt_tsense/mag, with no bgr_tg.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_bgr_tg.tcl
drc off
load bgr_tg
box 0um 0um 0um 0um
set before {}
foreach {t dev pars} {XT1 sky130_fd_pr__nfet_01v8 {w 1 l 0.5 nf 1 guard 1}  XT2 sky130_fd_pr__nfet_01v8 {w 2 l 0.5 nf 1 guard 1}
                      XT3 sky130_fd_pr__pfet_01v8 {w 4 l 0.5 nf 1 guard 1}} {
  eval magic::gencell sky130::$dev $t $pars
  set now [cellname list children bgr_tg]
  foreach c $now { if {[lsearch -exact $before $c] < 0} { set CELL($t) $c } }
  set before $now
}
foreach t {XT1 XT2 XT3} { select cell $t; delete }
puts "CELLS $CELL(XT1) $CELL(XT2) $CELL(XT3)"
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc via12 {x y} { pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met1
                   pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met2
                   pt [expr {$x-0.3}] [expr {$y-0.3}] [expr {$x+0.3}] [expr {$y+0.3}] via1 }
proc tie {x y} { pt [expr {$x-0.2}] [expr {$y-0.2}] [expr {$x+0.2}] [expr {$y+0.2}] met1
                 pt [expr {$x-0.085}] [expr {$y-0.085}] [expr {$x+0.085}] [expr {$y+0.085}] mcon }
proc pin {nm lay x1 y1 x2 y2} { pt $x1 $y1 $x2 $y2 $lay; label $nm c $lay; port make }
set Y0 3.5
set XD 1.6 ; set XN 4.4 ; set XP 7.6
bx $XD $Y0 $XD $Y0; getcell $CELL(XT1) h child 0 0; identify XD
bx $XN $Y0 $XN $Y0; getcell $CELL(XT2) child 0 0; identify XN
bx $XP $Y0 $XP $Y0; getcell $CELL(XT3) h child 0 0; identify XP
# strip bars at mid-height (met1, 0.3 tall)
pt [expr {$XD+0.28}] [expr {$Y0-0.15}] [expr {$XN-0.28}] [expr {$Y0+0.15}] met1   ;# b: XD drain -> XN drain
pt [expr {$XN+0.28}] [expr {$Y0-0.15}] [expr {$XP-0.28}] [expr {$Y0+0.15}] met1   ;# a: XN source -> XP source
pt [expr {$XP+0.28}] [expr {$Y0-0.15}] [expr {$XP+1.55}] [expr {$Y0+0.15}] met1   ;# b: XP drain -> right
via12 [expr {$XP+1.75}] $Y0
via12 3.0 $Y0
pt 3.0 [expr {$Y0-0.4}] [expr {$XP+1.75}] [expr {$Y0+0.4}] met2                     ;# b returns on met2
pt -0.6 [expr {$Y0-0.15}] [expr {$XD-0.28}] [expr {$Y0+0.15}] met1                 ;# XD source (VGND) -> left
# gates: stubs from the top gate contacts up through the ring tops to via pads
foreach {x yg ys} [list $XD [expr {$Y0+0.66}] [expr {$Y0+2.2}]  $XN [expr {$Y0+1.16}] [expr {$Y0+3.0}] \
                        $XP [expr {$Y0+2.205}] [expr {$Y0+3.95}]] {
  pt [expr {$x-0.23}] $yg [expr {$x+0.23}] $ys met1
  via12 $x $ys
}
# ring ties (mcon on the li1 rings): XD and XN at their ring bottoms -> VGND bar; XP on its ring's right side
# (x = XP + 0.965) -> a met1 riser to the VDPWR pin at the top
tie $XD [expr {$Y0-1.285}]
tie $XN [expr {$Y0-1.785}]
tie [expr {$XP+0.965}] [expr {$Y0+2.1}]
pt -0.6 0.0 [expr {$XN+0.2}] 0.5 met1                                                ;# VGND bar
pt [expr {$XD-0.2}] 0.3 [expr {$XD+0.2}] [expr {$Y0-1.285}] met1
pt [expr {$XN-0.2}] 0.3 [expr {$XN+0.2}] [expr {$Y0-1.785}] met1
pt -0.6 0.0 -0.2 [expr {$Y0+0.15}] met1                                              ;# XD source down to the bar
pt [expr {$XP+0.765}] [expr {$Y0+1.9}] [expr {$XP+1.165}] [expr {$Y0+4.35}] met1    ;# XP ring -> VDPWR pin
# a: met1 riser from the a bar up through the gap between the XN and XP rings to a via1 pad at the top
pt 5.8 [expr {$Y0+0.15}] 6.2 [expr {$Y0+4.1}] met1
via12 6.0 [expr {$Y0+4.1}]
# pins
pin dump  met2 [expr {$XD-0.4}] [expr {$Y0+1.8}] [expr {$XD+0.4}] [expr {$Y0+2.6}]
pin on    met2 [expr {$XN-0.4}] [expr {$Y0+2.6}] [expr {$XN+0.4}] [expr {$Y0+3.4}]
pin onb   met2 [expr {$XP-0.4}] [expr {$Y0+3.55}] [expr {$XP+0.4}] [expr {$Y0+4.35}]
pin a     met2 5.6 [expr {$Y0+3.7}] 6.4 [expr {$Y0+4.5}]
pin b     met2 [expr {$XP+1.35}] [expr {$Y0-0.4}] [expr {$XP+2.15}] [expr {$Y0+0.4}]
pin VGND  met1 -0.6 0.0 0.2 0.5
pin VDPWR met1 [expr {$XP+0.765}] [expr {$Y0+3.95}] [expr {$XP+1.165}] [expr {$Y0+4.35}]
save bgr_tg
foreach t {XT1 XT2 XT3} { load $CELL($t); save $CELL($t) }
load bgr_tg
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT bgr_tg [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
