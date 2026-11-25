# gen_bg_bias_arr.tcl -- the scripted half of bg_bias (M5 layout): the bias row MNB1..MNB4 of bg_core.
# bg_bias is a layout-only cell (in the schematic MNB1..MNB4 sit directly in bg_core); lvs.sh checks it on its own
# against lvs_cells/bg_bias.spice, and bg_core's LVS flattens it.
# Builds bg_bias_arr.mag: 12 nfet_01v8 fingers (W 4, L 8, nf 1; one generated cell placed 12 times) in one column,
# the p-tap ring, the source rail (VGND), the nb gate rails and spine (met2) with the nb bus on top, the met1 shield
# plates, and one drain stub per finger (met1 + a 2x2 via1 onto its track position). Left for bg_bias.mag: the four
# drain tracks (met2) and the pins.
#
# Floor plan (um; this cell's frame = the parent's frame with `getcell bg_bias_arr child 0 0`):
#   column centre x = 9.96, rows r = 0..11 at y = 3.5 + 5.6 r, drains on the left, sources on the right.
#   Rows: dummy, MNB3, MNB4, MNB3, MNB4, MNB1, MNB2, MNB4, MNB3, MNB4, MNB3, dummy  (MNB3 and MNB4 centred on row 5.5,
#   MNB1/MNB2 the middle pair). Tracks (left channel): nb 4.5 (up to the bus), ibias 3.5, ib_cmp1 2.5, ib_cmp2 1.5.
# Run (in tt_tsense/mag):  magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_bg_bias_arr.tcl
drc off
load bg_bias_arr
box 0um 0um 0um 0um
magic::gencell sky130::sky130_fd_pr__nfet_01v8 XTMP w 4 l 8 nf 1 guard 0
set fc [lindex [cellname list children bg_bias_arr] 0]
select cell XTMP
delete

proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc via12 {x y} { pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met2
                   pt [expr {$x-0.3}] [expr {$y-0.3}] [expr {$x+0.3}] [expr {$y+0.3}] via1 }
set X 9.96
proc yr {r} { return [expr {3.5 + 5.6 * $r}] }
set W 16.8 ; set H 68.6
set ROWS {D MNB3 MNB4 MNB3 MNB4 MNB1 MNB2 MNB4 MNB3 MNB4 MNB3 D}
array set NET {MNB1 nb MNB2 ibias MNB3 ib_cmp1 MNB4 ib_cmp2}
array set TRK {nb 4.5 ibias 3.5 ib_cmp1 2.5 ib_cmp2 1.5}

# --- fingers ---
for {set r 0} {$r < 12} {incr r} {
  set d [lindex $ROWS $r]
  bx $X [yr $r] $X [yr $r]
  getcell $fc child 0 0
  identify "M${d}_r${r}"
}

# --- p-tap ring and the source side ---
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
# source rail: p-tap strip + li1 + mcon under a met1 VGND rail from the source strips to the right ring
set xm 15.25
pt [expr {$xm-0.25}] 0.3 [expr {$xm+0.25}] [expr {$H-0.3}] psubdiff
pt [expr {$xm-0.25}] 0 [expr {$xm+0.25}] $H li1
pt [expr {$xm-0.085}] 0.215 [expr {$xm+0.085}] [expr {$H-0.215}] psubdiffcont
pt [expr {$xm-0.085}] 0.215 [expr {$xm+0.085}] [expr {$H-0.215}] mcon
pt [expr {$X+4.20}] 0 $W $H met1

# --- gates: nb rails between active rows, spine, bus; dummies to VGND ---
for {set r 1} {$r <= 9} {incr r} {
  set y [yr $r]
  pt [expr {$X-3.98}] [expr {$y+2.16}] [expr {$X+3.98}] [expr {$y+3.44}] met1
  via12 $X [expr {$y+2.8}]
}
pt [expr {$X-0.25}] 1.0 [expr {$X+0.25}] [expr {$H+1.7}] met2
pt [expr {$TRK(nb)-0.25}] [expr {$H+0.9}] [expr {$X+0.25}] [expr {$H+1.7}] met2
foreach r {0 11} {
  set y [yr $r]
  pt [expr {$X+3.90}] [expr {$y+2.16}] [expr {$X+4.40}] [expr {$y+2.39}] met1   ;# top gate strip into the source rail
  pt [expr {$X-4.26}] [expr {$y+1.90}] [expr {$X-3.90}] [expr {$y+2.39}] met1   ;# drain strip up to the gate strip
}

# --- shield plates over every channel, joined to the source strip (VGND) ---
for {set r 0} {$r < 12} {incr r} {
  set y [yr $r]
  pt [expr {$X-3.60}] [expr {$y-1.70}] [expr {$X+4.26}] [expr {$y+1.70}] met1
}

# --- drain stubs ---
for {set r 1} {$r <= 10} {incr r} {
  set y [yr $r]; set xt $TRK($NET([lindex $ROWS $r]))
  pt [expr {$xt-0.4}] [expr {$y-0.4}] [expr {$X-4.03}] [expr {$y+0.4}] met1
  via12 $xt $y
}

save bg_bias_arr
load $fc
save $fc
load bg_bias_arr
select top cell
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT bg_bias_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 9] { puts "DRC_WHY $e" }
quit -noprompt
