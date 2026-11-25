# gen_ota2s_nrows_arr.tcl -- the scripted half of ota2s_nrows (M4 layout): the NMOS block of ota2s.
# ota2s_nrows is a layout-only cell; lvs.sh checks it on its own against lvs_cells/ota2s_nrows.spice, and the ota2s
# LVS flattens it.
# Builds ota2s_nrows_arr.mag inside one p-tap ring (VGND):
#   rows 0 and 1: the load, nfet_01v8 w 6 l 20 nf 4 (shared diffusion; one generated cell placed twice)
#     row 0: fingers XDNA XMN1 XMN2 XDNB, strips VGND d1 VGND x1 VGND
#     row 1: fingers XDNB XMN2 XMN1 XDNA, strips VGND x1 VGND d1 VGND   (cross-coupled over the two rows)
#   row 2: switch pair D = nfet_01v8 w 6 l 0.5 nf 2, strips d1 | g12 | x1, fingers XSD1 (CHOPB), XSD2 (CHOP);
#          switch pair G = the same cell, strips d1 | g3 | x1, fingers XSG2 (CHOP), XSG1 (CHOPB);
#          XMN3 = nfet_01v8 w 7 l 1 nf 1, D = OUT (left), S = VGND (right), G = g3
#   met2 tracks over every row (d1 at y_r + 1.9, VGND at y_r on rows 0/1, x1 at y_r - 1.9) with a 2x2 via1 on every
#   strip; the g12 "H" (the active load gates of both rows joined in the channel between rows 0 and 1, met1) with a
#   2x2 via1 pad at its centre; the dummy gates tied into the side rings; met1 shield plates over the load channels;
#   the switch gates' met1 stubs + 2x2 via1 onto two met2 straps (CHOPB lower, CHOP upper) that run out through the
#   left ring; g3 (switch pair G's middle strip -> XMN3's gate -> out through the right ring) and OUT (XMN3's drain ->
#   out through the right ring) on met2; XMN3's source to the right ring (met1).
# Left for ota2s_nrows.mag: the met3 buses d1 and x1 (rows 0, 1, 2), the g12 riser (met3, channel pad -> pair D's
# middle strip) and the pins.
#
# Floor plan (um, this cell's frame = the parent's frame with `getcell ota2s_nrows_arr child 0 0`):
#   ring 0..83.85 x 0..27.4 (0.6 wide); centre line x = 41.925; rows at y = 4.3 / 12.7 / 20.7.
#   Load strips at x = 1.345 + 20.29 k (k = 0..4). Pair D at x = 41.925, pair G at 47.925 (strips -0.79 / 0 / +0.79),
#   XMN3 at 52.425 (strips -0.645 / +0.645).
# Run (in tt_tsense/mag, with no ota2s_nrows_arr.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_ota2s_nrows_arr.tcl
drc off
load ota2s_nrows_arr
box 0um 0um 0um 0um
set before {}
foreach {t pars} {XT1 {w 6 l 20 nf 4 guard 0}  XT2 {w 6 l 0.5 nf 2 guard 0}  XT3 {w 7 l 1 nf 1 guard 0}} {
  eval magic::gencell sky130::sky130_fd_pr__nfet_01v8 $t $pars
  set now [cellname list children ota2s_nrows_arr]
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
proc place {cell x y nm} { bx $x $y $x $y; getcell $cell child 0 0; identify $nm }

set XC 41.925 ; set W 83.85 ; set H 27.4
set Y0 4.3 ; set Y1 12.7 ; set Y2 20.7
proc xl {k} { return [expr {1.345 + 20.29 * $k}] }
set XD $XC ; set XG [expr {$XC + 6.0}] ; set XM [expr {$XC + 10.5}]
# drain net of strips 1 and 3 in each load row
array set SN {0,1 d1 0,3 x1 1,1 x1 1,3 d1}
array set TOFF {d1 1.9 VGND 0.0 x1 -1.9}

# --- devices ------------------------------------------------------------------------------------------------------
place $CELL(XT1) $XC $Y0 XLOAD0
place $CELL(XT1) $XC $Y1 XLOAD1
place $CELL(XT2) $XD $Y2 XSWD
place $CELL(XT2) $XG $Y2 XSWG
place $CELL(XT3) $XM $Y2 XMN3

# --- p-tap ring ---------------------------------------------------------------------------------------------------
foreach {x1 y1 x2 y2} [list 0 0 $W 0.6  0 [expr {$H-0.6}] $W $H  0 0 0.6 $H  [expr {$W-0.6}] 0 $W $H] {
  pt $x1 $y1 $x2 $y2 psubdiff
  pt $x1 $y1 $x2 $y2 li1
  pt $x1 $y1 $x2 $y2 met1
}
foreach {x1 y1 x2 y2} [list 0.215 0.215 [expr {$W-0.215}] 0.385  0.215 [expr {$H-0.385}] [expr {$W-0.215}] [expr {$H-0.215}] \
                            0.215 0.215 0.385 [expr {$H-0.215}]  [expr {$W-0.385}] 0.215 [expr {$W-0.215}] [expr {$H-0.215}]] {
  pt $x1 $y1 $x2 $y2 psubdiffcont
  pt $x1 $y1 $x2 $y2 mcon
}

# --- load rows: shield plates (wide metal keeps 0.28 um: 0.3 from the drain pads, 0.31 from the gate strips) -----
foreach r {0 1} {
  set y [expr {$r == 0 ? $Y0 : $Y1}]
  pt [expr {[xl 0]-0.115}] [expr {$y-2.85}] [expr {[xl 1]-0.7}] [expr {$y+2.85}] met1
  pt [expr {[xl 1]+0.7}] [expr {$y-2.85}] [expr {[xl 2]+0.115}] [expr {$y+2.85}] met1
  pt [expr {[xl 2]-0.115}] [expr {$y-2.85}] [expr {[xl 3]-0.7}] [expr {$y+2.85}] met1
  pt [expr {[xl 3]+0.7}] [expr {$y-2.85}] [expr {[xl 4]+0.115}] [expr {$y+2.85}] met1
}

# --- load rows: tracks, strip vias, outer strips into the side rings ------------------------------------------------
foreach r {0 1} {
  set y [expr {$r == 0 ? $Y0 : $Y1}]
  set xa [expr {[xl 0]-0.4}] ; set xb [expr {[xl 4]+0.4}]
  foreach net {d1 VGND x1} { pt $xa [expr {$y+$TOFF($net)-0.4}] $xb [expr {$y+$TOFF($net)+0.4}] met2 }
  for {set k 0} {$k <= 4} {incr k} {
    if {$k % 2 == 0} { set net VGND } else { set net $SN($r,$k) }
    via12 [xl $k] [expr {$y + $TOFF($net)}]
  }
  pt 0.3 [expr {$y-0.4}] [xl 0] [expr {$y+0.4}] met1
  pt [xl 4] [expr {$y-0.4}] [expr {$W-0.3}] [expr {$y+0.4}] met1
}

# --- load gates: g12 H in the channel, dummy gates into the side rings ----------------------------------------------
# row 0 uses its top gate strips (y0 + 3.16..3.39), row 1 its bottom ones (y1 - 3.39..-3.16)
pt [expr {[xl 1]+0.165}] [expr {$Y0+3.16}] [expr {[xl 3]-0.165}] [expr {$Y0+3.39}] met1
pt [expr {[xl 1]+0.165}] [expr {$Y1-3.39}] [expr {[xl 3]-0.165}] [expr {$Y1-3.16}] met1
pt [expr {$XC-0.4}] [expr {$Y0+3.16}] [expr {$XC+0.4}] [expr {$Y1-3.16}] met1
via12 $XC [expr {$Y0+4.2}]
# dummies: row 0 bottom gate strips, row 1 top gate strips, extended over the outer strip's end into the side ring
pt 0.3 [expr {$Y0-3.39}] [expr {[xl 1]-0.165}] [expr {$Y0-3.16}] met1
pt [expr {[xl 3]+0.165}] [expr {$Y0-3.39}] [expr {$W-0.3}] [expr {$Y0-3.16}] met1
pt 0.3 [expr {$Y1+3.16}] [expr {[xl 1]-0.165}] [expr {$Y1+3.39}] met1
pt [expr {[xl 3]+0.165}] [expr {$Y1+3.16}] [expr {$W-0.3}] [expr {$Y1+3.39}] met1

# --- row 2: tracks d1 / x1 over the two switch pairs, strip vias ----------------------------------------------------
set xa [expr {$XC-2.4}] ; set xb [expr {$XC+7.2}]
pt $xa [expr {$Y2+1.5}] $xb [expr {$Y2+2.3}] met2
pt $xa [expr {$Y2-2.3}] $xb [expr {$Y2-1.5}] met2
foreach xp [list $XD $XG] {
  via12 [expr {$xp-0.79}] [expr {$Y2+1.9}]     ;# strip 0 = d1
  via12 [expr {$xp+0.79}] [expr {$Y2-1.9}]     ;# strip 2 = x1
  via12 $xp $Y2                                 ;# strip 1 = g12 (pair D) / g3 (pair G)
}

# --- switch gates: top gate strips -> stubs -> straps (CHOPB lower y2+4.3, CHOP upper y2+5.4) ------------------------
# pair D: finger 0 = XSD1 (CHOPB), finger 1 = XSD2 (CHOP); pair G: finger 0 = XSG2 (CHOP), finger 1 = XSG1 (CHOPB)
foreach {xp f net} [list $XD 0 CHOPB $XD 1 CHOP $XG 0 CHOP $XG 1 CHOPB] {
  set xf [expr {$xp - 0.395 + 0.79 * $f}]
  set ys [expr {$net eq "CHOPB" ? $Y2+4.3 : $Y2+5.4}]
  pt [expr {$xf-0.23}] [expr {$Y2+3.16}] [expr {$xf+0.23}] $ys met1
  via12 $xf $ys
}
pt -1.0 [expr {$Y2+3.9}] [expr {$XG+0.795}] [expr {$Y2+4.7}] met2
pt -1.0 [expr {$Y2+5.0}] [expr {$XG+0.795}] [expr {$Y2+5.8}] met2

# --- g3: pair G's middle strip -> XMN3's top gate -> out through the right ring (met2) -------------------------------
set xj [expr {$XC+7.8}]
pt [expr {$XG-0.4}] [expr {$Y2-0.4}] [expr {$xj+0.4}] [expr {$Y2+0.4}] met2
pt [expr {$xj-0.4}] [expr {$Y2-0.4}] [expr {$xj+0.4}] [expr {$Y2+4.9}] met2
pt [expr {$xj-0.4}] [expr {$Y2+4.1}] [expr {$W+1.0}] [expr {$Y2+4.9}] met2
pt [expr {$XM-0.4}] [expr {$Y2+3.66}] [expr {$XM+0.4}] [expr {$Y2+4.5}] met1
via12 $XM [expr {$Y2+4.5}]

# --- XMN3: drain -> OUT (met2, out through the right ring), source -> right ring (met1) -----------------------------
via12 [expr {$XM-0.645}] $Y2
pt [expr {$XM-1.045}] [expr {$Y2-0.4}] [expr {$W+1.0}] [expr {$Y2+0.4}] met2
pt [expr {$XM+0.53}] [expr {$Y2-0.4}] [expr {$W-0.3}] [expr {$Y2+0.4}] met1

save ota2s_nrows_arr
foreach t {XT1 XT2 XT3} { load $CELL($t); save $CELL($t) }
load ota2s_nrows_arr
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT ota2s_nrows_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
