# gen_bg_mirror_arr.tcl -- the scripted half of bg_mirror (M5 layout).
# Builds bg_mirror_arr.mag: 28 pfet_01v8 fingers (W 8.8, L 20, nf 1; one generated cell, placed 28 times), the n-well,
# the n-tap ring, the source rails (VDPWR), the gate rails and the vpg spines (met2), and one drain stub per finger
# (met1 + a 2x2 via1 onto its track position). Left for the routing in bg_mirror.mag: the drain tracks (met2),
# the three met3 buses (d1, d2, d3a) and the pins.
#
# Floor plan (um, this cell's frame = the parent's frame when placed with `getcell bg_mirror_arr child 0 0`):
#   4 columns c = 0..3 at x = 15.96 / 38.54 / 65.46 / 88.04; columns 1 and 3 are mirrored (drain on the right).
#   7 rows r = 0..6 at y = 6.5 + 10.6 r.  Row 0 = P5 (columns 1, 2) with its end dummies (columns 0, 3);
#   row 1 and row 6 = dummies; rows 2..5 = the 4 x 4 Latin square of the spec (spec row i -> column c = i,
#   spec column j -> row r = j + 2):
#        spec row 0: A  B  C  P4      A = P1, B = P2, C = P3 (P3a at (0,2)/(3,1), P3b at (1,0)/(2,3)),
#        spec row 1: C  P7 A  B       P4a at (0,3), P4b at (3,0)
#        spec row 2: B  A  P7 C
#        spec row 3: P4 C  B  A
#   Every device has its centroid at x = 52.0 (columns symmetric about it) and, for the square, at row 3.5.
#   The fingers keep L horizontal here; bg_core may place this cell rotated by 90 deg.
#   Drains face three channels: left of column 0, between columns 1 and 2, right of column 3.
#   Sources face two 2.0 um gaps (columns 0|1 and 2|3), each one met1 VDPWR rail over an n-tap strip.
#   Dummies: gate, drain and source on VDPWR (gate strip extended into the source rail, drain bridged to the gate).
# Run (in tt_tsense/mag):  magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_bg_mirror_arr.tcl
drc off
load bg_mirror_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__pfet_01v8 XTMP w 8.8 l 20 nf 1 guard 0
set fc [lindex [cellname list children bg_mirror_arr] 0]
select cell XTMP
delete

proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc via12 {x y} { pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met2
                   pt [expr {$x-0.3}] [expr {$y-0.3}] [expr {$x+0.3}] [expr {$y+0.3}] via1 }

set XC {15.96 38.54 65.46 88.04}
set MIR {0 1 0 1}
proc yr {r} { return [expr {6.5 + 10.6 * $r}] }
set W 104.2 ;  set H 76.1      ;# ring outer edge (the ring is 0.6 wide)

# device at (column, row): name and drain net
array set DEV {
  0,2 {P1 d1}  1,2 {P3B d3b} 2,2 {P2 d2}  3,2 {P4B d4b}
  0,3 {P2 d2}  1,3 {P7 d7}   2,3 {P1 d1}  3,3 {P3A d3a}
  0,4 {P3A d3a} 1,4 {P1 d1}  2,4 {P7 d7}  3,4 {P2 d2}
  0,5 {P4A d4a} 1,5 {P2 d2}  2,5 {P3B d3b} 3,5 {P1 d1}
  1,0 {P5 d5}  2,0 {P5 d5}
}
# drain track x for each net, per channel (left = column 0, centre = columns 1 and 2, right = column 3)
array set TRK {
  L,d1 4.5   L,d2 3.5   L,d3a 2.5   L,d4a 1.5
  C,d1 50.0  C,d2 51.0  C,d5 52.0   C,d7 53.0  C,d3b 54.0
  R,d1 99.5  R,d2 100.5 R,d3a 101.5 R,d4b 102.5
}

# --- the 28 fingers ---------------------------------------------------------------------------------------------
for {set c 0} {$c < 4} {incr c} {
  for {set r 0} {$r <= 6} {incr r} {
    set x [lindex $XC $c]; set y [yr $r]
    if {[info exists DEV($c,$r)]} { set nm "M[lindex $DEV($c,$r) 0]_c${c}r${r}" } else { set nm "MD_c${c}r${r}" }
    bx $x $y $x $y
    if {[lindex $MIR $c]} { getcell $fc h child 0 0 } else { getcell $fc child 0 0 }
    identify $nm
  }
}

# --- n-well, n-tap ring, source gaps -----------------------------------------------------------------------------
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
# source gaps between columns 0|1 and 2|3: n-tap strip + li1 + mcon, and the met1 VDPWR rail over it
foreach {ca cb} {0 1 2 3} {
  set xa [expr {[lindex $XC $ca] + 10.20}]; set xb [expr {[lindex $XC $cb] - 10.20}]
  set xm [expr {($xa + $xb) / 2.0}]
  pt [expr {$xm-0.25}] 0.3 [expr {$xm+0.25}] [expr {$H-0.3}] nsubdiff
  pt [expr {$xm-0.25}] 0 [expr {$xm+0.25}] $H li1
  pt [expr {$xm-0.085}] 0.215 [expr {$xm+0.085}] [expr {$H-0.215}] nsubdiffcont
  pt [expr {$xm-0.085}] 0.215 [expr {$xm+0.085}] [expr {$H-0.215}] mcon
  pt $xa 0 $xb $H met1
}
# centre drain channel: an n-tap strip on li1 only (latch-up rule LU.3: every p-diff within 15 um of an n-tap);
# li1 runs to the ring at both ends, so the met1 drain stubs cross it without touching it
pt 51.75 0.3 52.25 [expr {$H-0.3}] nsubdiff
pt 51.915 0.215 52.085 [expr {$H-0.215}] nsubdiffcont
pt 51.75 0 52.25 $H li1

# --- gates: rails between square rows, P5 rails, dummies to VDPWR ------------------------------------------------
for {set c 0} {$c < 4} {incr c} {
  set x [lindex $XC $c]
  foreach r {2 3 4} {
    set y [yr $r]
    pt [expr {$x-9.98}] [expr {$y+4.605}] [expr {$x+9.98}] [expr {$y+5.995}] met1
    via12 $x [expr {$y+5.3}]
  }
  if {$c == 1 || $c == 2} {
    set y [yr 0]
    pt [expr {$x-9.98}] [expr {$y-5.595}] [expr {$x+9.98}] [expr {$y-4.605}] met1
    via12 $x [expr {$y-5.1}]
  }
  # vpg spine over the centre of every finger (identical over all channels), up to the top bus
  pt [expr {$x-0.25}] 1.0 [expr {$x+0.25}] [expr {$H+1.7}] met2
}
pt [expr {[lindex $XC 0]-0.25}] [expr {$H+0.9}] [expr {[lindex $XC 3]+0.25}] [expr {$H+1.7}] met2
for {set c 0} {$c < 4} {incr c} {
  set x [lindex $XC $c]; set m [lindex $MIR $c]
  set sd [expr {$m ? -1 : 1}]      ;# +1: source on the right
  for {set r 0} {$r <= 6} {incr r} {
    if {[info exists DEV($c,$r)]} continue
    set y [yr $r]
    # top gate strip into the source rail
    if {$sd > 0} { pt [expr {$x+9.90}] [expr {$y+4.605}] [expr {$x+10.40}] [expr {$y+4.835}] met1 } \
    else         { pt [expr {$x-10.40}] [expr {$y+4.605}] [expr {$x-9.90}] [expr {$y+4.835}] met1 }
    # drain strip up to the top gate strip
    if {$sd > 0} { pt [expr {$x-10.26}] [expr {$y+4.30}] [expr {$x-9.90}] [expr {$y+4.835}] met1 } \
    else         { pt [expr {$x+9.90}] [expr {$y+4.30}] [expr {$x+10.26}] [expr {$y+4.835}] met1 }
  }
}

# --- drain stubs: met1 from the drain strip to the track, 2x2 via1 at the track ---------------------------------
foreach key [array names DEV] {
  lassign [split $key ,] c r
  lassign $DEV($key) dev net
  set x [lindex $XC $c]; set y [yr $r]
  switch $c { 0 {set ch L; set s 0.0} 1 {set ch C; set s 1.8} 2 {set ch C; set s -1.8} 3 {set ch R; set s 0.0} }
  set xt $TRK($ch,$net); set ys [expr {$y + $s}]
  if {[lindex $MIR $c]} {
    pt [expr {$x+10.03}] [expr {$ys-0.4}] [expr {$xt+0.4}] [expr {$ys+0.4}] met1
  } else {
    pt [expr {$xt-0.4}] [expr {$ys-0.4}] [expr {$x-10.03}] [expr {$ys+0.4}] met1
  }
  via12 $xt $ys
}

# --- shield plates: the same met1 plate over every channel (all 28 fingers), joined to the finger's own source strip
# (VDPWR), so the shuttle's floating met1 fill cannot land on the channels (it lands unevenly from row to row).
# Plate = 19.86 x 8.30 um over the 20 x 8.8 um channel: 0.43 um clear of the drain strip, 0.455 um clear of the
# gate strips; mirrored with the finger in columns 1 and 3.
for {set c 0} {$c < 4} {incr c} {
  set x [lindex $XC $c]; set m [lindex $MIR $c]
  for {set r 0} {$r <= 6} {incr r} {
    set y [yr $r]
    if {$m} { pt [expr {$x-10.26}] [expr {$y-4.15}] [expr {$x+9.60}] [expr {$y+4.15}] met1 } \
    else    { pt [expr {$x-9.60}] [expr {$y-4.15}] [expr {$x+10.26}] [expr {$y+4.15}] met1 }
  }
}

save bg_mirror_arr
load $fc
save $fc
load bg_mirror_arr
select top cell
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT bg_mirror_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
