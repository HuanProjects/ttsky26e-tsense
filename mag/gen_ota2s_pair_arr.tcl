# gen_ota2s_pair_arr.tcl -- the scripted half of ota2s_pair (M4 layout): the input pair XMP1/XMP2 and its 8 dummies XDP.
# ota2s_pair is a layout-only cell (in the schematic the pair sits directly in ota2s); lvs.sh checks it on its own
# against lvs_cells/ota2s_pair.spice, and the ota2s LVS flattens it.
# Builds ota2s_pair_arr.mag: 4 rows of pfet_01v8_lvt (w 25, l 6, nf 14 = 12 active + 2 end dummies, shared diffusion;
# one generated cell placed 4 times), the n-well, the n-tap ring, an n-tap strip in every gate channel, three met2
# tracks over every row (d1, tail, x1) with a 2x2 via1 on every strip, two met2 gate straps per channel with a met1
# stub + 2x2 via1 from every active gate, the dummy gates tied to the ring, and a met1 shield plate over every channel
# (joined to the finger's tail strip). Left for ota2s_pair.mag: the met3 buses (d1, x1, tail, INN, INP), the tail exit
# and the pins.
#
# Floor plan (um, this cell's frame = the parent's frame with `getcell ota2s_pair_arr child 0 0`):
#   rows r = 0..3 centred at x = 45.455, y = 14.1 + 28.7 r; strip k (k = 0..14) at x = 1.425 + 6.29 k; finger f between
#   strips f and f+1 (centre x = 4.57 + 6.29 f). Gate contacts used: the top ones.
#   Strip map (spec M4 step 4; A = XMP1, drain d1, gate INN; B = XMP2, drain x1, gate INP; D = dummy):
#     rows 0, 2:  D A A B B B B A A A A B B D        rows 1, 3:  D B B A A A A B B B B A A D
#   strips 0, 1, 3, 5, ..., 13, 14 = tail; strip 2j = the drain of fingers 2j-1 and 2j.
#   Tracks over row r (met2, full width x 1.025..89.885): d1 at y_r + 5 (0.8), tail at y_r (1.0), x1 at y_r - 5 (0.8).
#   Gate channel above row r: n-tap strip (li1 only) y_r + 13.2..13.7; straps (met2 0.8) "lo" at y_r + 14.0 and
#   "hi" at y_r + 15.1; rows 0 and 2: lo = INN, hi = INP; rows 1 and 3: lo = INP, hi = INN (each device gets 12 short
#   and 12 long gate stubs).
#   Ring: n-tap, 0.6 wide, outer edge 0..90.91 x 0..116.6.
# Run (in tt_tsense/mag, with no ota2s_pair_arr.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_ota2s_pair_arr.tcl
drc off
load ota2s_pair_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__pfet_01v8_lvt XTMP w 25 l 6 nf 14 guard 0
set fc [lindex [cellname list children ota2s_pair_arr] 0]
select cell XTMP
delete

proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc via12 {x y} { pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met1
                   pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met2
                   pt [expr {$x-0.3}] [expr {$y-0.3}] [expr {$x+0.3}] [expr {$y+0.3}] via1 }

set XC 45.455
set W 90.91 ; set H 116.6
proc yr {r} { return [expr {14.1 + 28.7 * $r}] }
proc xs {k} { return [expr {1.425 + 6.29 * $k}] }
set XL [expr {[xs 0] - 0.4}] ; set XR [expr {[xs 14] + 0.4}]      ;# track / strap span 1.025 .. 89.885
set MAP(0) {D A A B B B B A A A A B B D}
set MAP(1) {D B B A A A A B B B B A A D}
set MAP(2) $MAP(0) ; set MAP(3) $MAP(1)
array set DRN {A d1 B x1}
array set GATE {A INN B INP}
array set TOFF {d1 5.0 tail 0.0 x1 -5.0}

# --- the four rows ----------------------------------------------------------------------------------------------
for {set r 0} {$r < 4} {incr r} {
  bx $XC [yr $r] $XC [yr $r]
  getcell $fc child 0 0
  identify "XPR$r"
}

# --- n-well, n-tap ring, n-tap strips in the gate channels --------------------------------------------------------
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
# latch-up rule LU.3 (every p-diff within 15 um of an n-tap): one li1-only strip per gate channel, joined to the ring's
# li1 at both ends, so the met1 gate stubs cross it without touching it
for {set r 0} {$r < 4} {incr r} {
  set y [yr $r]
  pt 0.3 [expr {$y+13.2}] [expr {$W-0.3}] [expr {$y+13.7}] nsubdiff
  pt 0.215 [expr {$y+13.365}] [expr {$W-0.215}] [expr {$y+13.535}] nsubdiffcont
  pt 0 [expr {$y+13.2}] $W [expr {$y+13.7}] li1
}

# --- shield plates: the same met1 plate over every channel, joined to the finger's own tail strip --------------
# A plate is wide metal (> 3 um), so it keeps 0.28 um from every other met1 (rule met1.3b): active finger 5.705 x
# 24.84 um, 0.3 um clear of the drain strip's via pad, 0.285 um clear of the gate strips; dummy: across both strips.
for {set r 0} {$r < 4} {incr r} {
  set y [yr $r]
  for {set f 0} {$f < 14} {incr f} {
    set d [lindex $MAP($r) $f]
    if {$d eq "D"} {
      pt [expr {[xs $f]-0.115}] [expr {$y-12.42}] [expr {[xs [expr {$f+1}]]+0.115}] [expr {$y+12.42}] met1
    } elseif {$f % 2 == 1} {
      pt [expr {[xs $f]-0.115}] [expr {$y-12.42}] [expr {[xs [expr {$f+1}]]-0.7}] [expr {$y+12.42}] met1
    } else {
      pt [expr {[xs $f]+0.7}] [expr {$y-12.42}] [expr {[xs [expr {$f+1}]]+0.115}] [expr {$y+12.42}] met1
    }
  }
}

# --- tracks over every row and the strip vias -------------------------------------------------------------------
for {set r 0} {$r < 4} {incr r} {
  set y [yr $r]
  pt $XL [expr {$y+4.6}] $XR [expr {$y+5.4}] met2
  pt $XL [expr {$y-0.5}] $XR [expr {$y+0.5}] met2
  pt $XL [expr {$y-5.4}] $XR [expr {$y-4.6}] met2
  for {set k 0} {$k <= 14} {incr k} {
    if {$k == 0 || $k == 14 || $k % 2 == 1} { set net tail } else { set net $DRN([lindex $MAP($r) [expr {$k-1}]]) }
    via12 [xs $k] [expr {$y + $TOFF($net)}]
  }
}

# --- gate straps, active gate stubs, dummy gates to the ring ----------------------------------------------------
for {set r 0} {$r < 4} {incr r} {
  set y [yr $r]
  if {$r % 2 == 0} { set lo INN } else { set lo INP }
  pt $XL [expr {$y+13.6}] $XR [expr {$y+14.4}] met2
  pt $XL [expr {$y+14.7}] $XR [expr {$y+15.5}] met2
  for {set f 0} {$f < 14} {incr f} {
    set d [lindex $MAP($r) $f]
    set xf [expr {[xs $f] + 3.145}]
    if {$d eq "D"} {
      # top gate strip of the dummy, extended over its outer tail strip's end into the ring (VDPWR)
      if {$f == 0} { pt 0.3 [expr {$y+12.705}] [expr {[xs 1]-0.165}] [expr {$y+12.935}] met1 } \
      else         { pt [expr {[xs 13]+0.165}] [expr {$y+12.705}] [expr {$W-0.3}] [expr {$y+12.935}] met1 }
      continue
    }
    if {$GATE($d) eq $lo} { set ys [expr {$y+14.0}] } else { set ys [expr {$y+15.1}] }
    pt [expr {$xf-0.4}] [expr {$y+12.705}] [expr {$xf+0.4}] $ys met1
    via12 $xf $ys
  }
}

# --- report: centroids per device (finger centres) --------------------------------------------------------------
foreach dev {A B D} {
  set n 0; set sx 0.0; set sy 0.0
  for {set r 0} {$r < 4} {incr r} {
    for {set f 0} {$f < 14} {incr f} {
      if {[lindex $MAP($r) $f] eq $dev} { incr n; set sx [expr {$sx + [xs $f] + 3.145}]; set sy [expr {$sy + [yr $r]}] }
    }
  }
  puts [format "CENTROID %s n=%d x=%.4f y=%.4f" $dev $n [expr {$sx/$n}] [expr {$sy/$n}]]
}

save ota2s_pair_arr
load $fc
save $fc
load ota2s_pair_arr
select top cell
puts "BBOX [box values]"
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT ota2s_pair_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
