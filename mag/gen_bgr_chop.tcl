# gen_bgr_chop.tcl -- bgr_chop (M5 layout, bgr): the op-amp's input chopper S1..S4, fully scripted (devices, ring,
# wiring and pins). Layout-only cell: lvs.sh checks it against lvs_cells/bgr_chop.spice; the bgr LVS flattens it.
# Two nfet_01v8_lvt pairs (w 4, l 0.5, nf 2, shared middle strip; one generated cell placed twice):
#   pair VA at x = 3.0: strips inn | va | inp, finger 0 = XS1 (va-inn, gate swa), finger 1 = XS3 (va-inp, gate swb)
#   pair VB at x = 7.0: strips inn | vb | inp, finger 0 = XS4 (vb-inn, gate swb), finger 1 = XS2 (vb-inp, gate swa)
# so each pair is mirror-symmetric between inn and inp, and swa / swb each drive one finger of each pair.
# met2 tracks: inn at y 4.6, inp at y 2.2 (both pairs); the middle strips (va, vb) get a via1 + via2 pad at y 3.4.
# Gate stubs (met1) + 2x2 via1 onto two met2 straps: swa at y 6.7, swb at y 7.8, out through the left ring.
# Pins: va, vb (met3 on the middle-strip via2 pads), inn (met3 on a via2 at the inn track's right end x 8.8),
# inp (met3 on a via2 at the inp track's left end x 1.2), swa / swb (met2, left strap ends), VGND (ring).
# p-tap ring 0..10.0 x 0..9.2 (0.6 wide).
# Run (in tt_tsense/mag, with no bgr_chop.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_bgr_chop.tcl
drc off
load bgr_chop
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__nfet_01v8_lvt XTMP w 4 l 0.5 nf 2 guard 0
set fc [lindex [cellname list children bgr_chop] 0]
select cell XTMP
delete
puts "CELL $fc"
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc via12 {x y} { pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met1
                   pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met2
                   pt [expr {$x-0.3}] [expr {$y-0.3}] [expr {$x+0.3}] [expr {$y+0.3}] via1 }
proc via23 {x y} { pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met2
                   pt [expr {$x-0.45}] [expr {$y-0.45}] [expr {$x+0.45}] [expr {$y+0.45}] met3
                   pt [expr {$x-0.35}] [expr {$y-0.35}] [expr {$x+0.35}] [expr {$y+0.35}] via2 }
proc place {cell x y nm} { bx $x $y $x $y; getcell $cell child 0 0; identify $nm }
set W 10.0 ; set H 9.2 ; set YC 3.4
set XA 3.0 ; set XB 7.0
place $fc $XA $YC XVA
place $fc $XB $YC XVB
# p-tap ring
foreach {x1 y1 x2 y2} [list 0 0 $W 0.6  0 [expr {$H-0.6}] $W $H  0 0 0.6 $H  [expr {$W-0.6}] 0 $W $H] {
  pt $x1 $y1 $x2 $y2 psubdiff; pt $x1 $y1 $x2 $y2 li1; pt $x1 $y1 $x2 $y2 met1
}
foreach {x1 y1 x2 y2} [list 0.215 0.215 [expr {$W-0.215}] 0.385  0.215 [expr {$H-0.385}] [expr {$W-0.215}] [expr {$H-0.215}] \
                            0.215 0.215 0.385 [expr {$H-0.215}]  [expr {$W-0.385}] 0.215 [expr {$W-0.215}] [expr {$H-0.215}]] {
  pt $x1 $y1 $x2 $y2 psubdiffcont; pt $x1 $y1 $x2 $y2 mcon
}
# tracks and strip pads
pt 0.8 [expr {$YC+0.8}] 9.2 [expr {$YC+1.6}] met2
pt 0.8 [expr {$YC-1.6}] 9.2 [expr {$YC-0.8}] met2
foreach xp [list $XA $XB] {
  via12 [expr {$xp-0.79}] [expr {$YC+1.2}]
  via12 [expr {$xp+0.79}] [expr {$YC-1.2}]
  via12 $xp $YC
  via23 $xp $YC
}
via23 8.8 [expr {$YC+1.2}]
via23 1.2 [expr {$YC-1.2}]
# gate stubs and straps (swa lower at YC+3.3, swb upper at YC+4.4)
foreach {xp f net} [list $XA 0 swa $XA 1 swb $XB 0 swb $XB 1 swa] {
  set xf [expr {$xp - 0.395 + 0.79 * $f}]
  set ys [expr {$net eq "swa" ? $YC+3.3 : $YC+4.4}]
  pt [expr {$xf-0.23}] [expr {$YC+2.16}] [expr {$xf+0.23}] $ys met1
  via12 $xf $ys
}
pt -1.0 [expr {$YC+2.9}] [expr {$XB+0.795}] [expr {$YC+3.7}] met2
pt -1.0 [expr {$YC+4.0}] [expr {$XB+0.795}] [expr {$YC+4.8}] met2
# pins (all on this cell's own paint)
proc pin {nm lay x1 y1 x2 y2} { pt $x1 $y1 $x2 $y2 $lay; label $nm c $lay; port make }
pin va    met3 [expr {$XA-0.45}] [expr {$YC-0.45}] [expr {$XA+0.45}] [expr {$YC+0.45}]
pin vb    met3 [expr {$XB-0.45}] [expr {$YC-0.45}] [expr {$XB+0.45}] [expr {$YC+0.45}]
pin inn   met3 8.35 [expr {$YC+0.75}] 9.25 [expr {$YC+1.65}]
pin inp   met3 0.75 [expr {$YC-1.65}] 1.65 [expr {$YC-0.75}]
pin swa   met2 -1.0 [expr {$YC+2.9}] -0.2 [expr {$YC+3.7}]
pin swb   met2 -1.0 [expr {$YC+4.0}] -0.2 [expr {$YC+4.8}]
pin VGND  met1 4.5 0 5.5 0.6
save bgr_chop
load $fc
save $fc
load bgr_chop
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT bgr_chop [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
