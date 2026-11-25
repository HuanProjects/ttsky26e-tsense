# gen_ota2s_prow_arr.tcl -- the scripted half of ota2s_prow (M4 layout): the bias column of ota2s.
# ota2s_prow is a layout-only cell; lvs.sh checks it on its own against lvs_cells/ota2s_prow.spice, and the ota2s LVS
# flattens it.
# Builds ota2s_prow_arr.mag: 11 pfet_01v8 fingers (w 20, l 4, nf 1; one generated cell placed 11 times, each turned
# 90 deg clockwise so W runs along x and the drain strip is on top, the source strip at the bottom) stacked in one
# column, bottom to top:  XDB  XMP3 XMP3 XMP3  XMTAIL  XMREF  XMTAIL  XMP3 XMP3 XMP3  XDB
# (XMP3, XMTAIL and XMREF all centred on the middle finger). Also: the n-well and an n-tap ring, a met1 shield plate
# over every channel (joined to the finger's source strip, VDPWR), the IBIAS gate rail (met1, right-hand gate
# contacts of the 9 active fingers) with a 2x2 via1 pad, the two dummies' gates tied into the left ring, and a 2x2
# via1 pad on every strip at its track position: sources and the dummies' drains at x = 8.8 (VDPWR), XMTAIL's drains
# at x = 3.8 (tail), XMP3's at 13.8 (OUT), XMREF's at 18.8 (IBIAS); two VDPWR pads on the bottom and top ring.
# Left for ota2s_prow.mag: the four met2 tracks, the tail exit, the IBIAS link (gate rail -> XMREF's drain, which
# makes XMREF the diode) with the IBIAS exit, and the pins.
#
# Floor plan (um, this cell's frame = the parent's frame with `getcell ota2s_prow_arr child 0 0`):
#   ring 0..23.4 x 0..58.8 (0.6 wide); finger k (k = 0..10) centred at x = 11.3, y = 3.4 + 5.2 k; strips span
#   x = 1.3 .. 21.3; drain strip at y_k + 2.145, source strip at y_k - 2.145; gate contacts at x = 0.865..1.095
#   (left) and 21.505..21.735 (right).
#   Placed in ota2s with its origin at the pair's right edge (pair x = 90.91, same y): the two rings abut, the n-wells
#   overlap, and the tail exit (y = 13.6..14.6) overlaps the pair's tail exit (tested: DRC 0, tail and VDPWR joined).
#   Overlapping the two rings instead fails: ring contacts may not partially overlap between subcells.
# Run (in tt_tsense/mag, with no ota2s_prow_arr.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_ota2s_prow_arr.tcl
drc off
load ota2s_prow_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__pfet_01v8 XTMP w 20 l 4 nf 1 guard 0
set fc [lindex [cellname list children ota2s_prow_arr] 0]
select cell XTMP
delete
puts "CELL $fc"

proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc via12 {x y} { pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met1
                   pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met2
                   pt [expr {$x-0.3}] [expr {$y-0.3}] [expr {$x+0.3}] [expr {$y+0.3}] via1 }

set XB 11.3 ; set W 23.4 ; set H 58.8
proc yk {k} { return [expr {3.4 + 5.2 * $k}] }
set ORDER {D P P P T R T P P P D}
array set NAME {D XDB P XMP3 T XMTAIL R XMREF}
array set TRK {tail 3.8 VDPWR 8.8 OUT 13.8 IBIAS 18.8}
array set DNET {D VDPWR P OUT T tail R IBIAS}

# --- fingers ------------------------------------------------------------------------------------------------------
for {set k 0} {$k <= 10} {incr k} {
  bx $XB [yk $k] $XB [yk $k]
  getcell $fc 90 child 0 0
  identify "$NAME([lindex $ORDER $k])_$k"
}

# --- n-well, n-tap ring ---------------------------------------------------------------------------------------------
pt -0.25 -0.25 [expr {$W+0.25}] [expr {$H+0.25}] nwell
foreach {x1 y1 x2 y2} [list 0 0 $W 0.6  0 [expr {$H-0.6}] $W $H  0 0 0.6 $H  [expr {$W-0.6}] 0 $W $H] {
  pt $x1 $y1 $x2 $y2 nsubdiff
  pt $x1 $y1 $x2 $y2 li1
  pt $x1 $y1 $x2 $y2 met1
}
foreach {x1 y1 x2 y2} [list 0.215 0.215 [expr {$W-0.215}] 0.385  0.215 [expr {$H-0.385}] [expr {$W-0.215}] [expr {$H-0.215}] \
                            0.215 0.215 0.385 [expr {$H-0.215}]  [expr {$W-0.385}] 0.215 [expr {$W-0.215}] [expr {$H-0.215}]] {
  pt $x1 $y1 $x2 $y2 nsubdiffcont
  pt $x1 $y1 $x2 $y2 mcon
}

# --- shield plates: 19.7 x 3.71 um over every channel, joined to the source strip (VDPWR); wide metal keeps
# 0.28 um from other met1 (0.295 from the drain pads, 0.355 from the gate contacts) -------------------------------
for {set k 0} {$k <= 10} {incr k} {
  set y [yk $k]
  pt [expr {$XB-9.85}] [expr {$y-2.26}] [expr {$XB+9.85}] [expr {$y+1.45}] met1
}

# --- strip pads at the track positions ----------------------------------------------------------------------------
for {set k 0} {$k <= 10} {incr k} {
  set y [yk $k]
  via12 $TRK(VDPWR) [expr {$y-2.145}]
  via12 $TRK($DNET([lindex $ORDER $k])) [expr {$y+2.145}]
}
via12 $TRK(VDPWR) 0.3
via12 $TRK(VDPWR) [expr {$H-0.3}]
# the bottom dummy's drain pad and finger 1's source pad are both VDPWR on the same track, 0.11 um apart: join them
pt [expr {$TRK(VDPWR)-0.4}] [expr {[yk 0]+2.5}] [expr {$TRK(VDPWR)+0.4}] [expr {[yk 1]-2.5}] met1
pt [expr {$TRK(VDPWR)-0.4}] [expr {[yk 0]+2.5}] [expr {$TRK(VDPWR)+0.4}] [expr {[yk 1]-2.5}] met2

# --- gates: IBIAS rail on the right-hand contacts of fingers 1..9, its pad at y_5; dummies into the left ring ------
# the rail starts 0.3 um past the strip ends (x 21.3): a source strip is part of a wide plate (rule met1.3b, 0.28 um)
pt [expr {$XB+10.3}] [expr {[yk 1]-1.98}] [expr {$XB+10.75}] [expr {[yk 9]+1.98}] met1
via12 [expr {$XB+10.85}] [yk 5]
foreach k {0 10} {
  pt 0.3 [expr {[yk $k]-1.98}] [expr {$XB-10.205}] [expr {[yk $k]+1.98}] met1
}

# --- report: centroids per device (finger centres) ------------------------------------------------------------------
foreach d {D P T R} {
  set n 0; set s 0.0
  for {set k 0} {$k <= 10} {incr k} { if {[lindex $ORDER $k] eq $d} { incr n; set s [expr {$s + [yk $k]}] } }
  puts [format "CENTROID %s n=%d y=%.4f" $NAME($d) $n [expr {$s/$n}]]
}

save ota2s_prow_arr
load $fc
save $fc
load ota2s_prow_arr
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT ota2s_prow_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
