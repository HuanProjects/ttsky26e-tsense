# gen_oneshot.tcl -- dly5 and oneshot, the one-shot of osc_core (M6 layout), complete: devices, wiring and pins.
# Frozen netlist (../xschem/simulation/osc_core.spice):
#   subckt dly5 a y VDPWR VGND: five inverters, pfet_01v8 W1 L2.3 over nfet_01v8 W0.42 L2.3 (a -> d1 -> .. -> d4 -> y).
#   subckt oneshot cmp_raw osc_en osc_enb vcap rst VDPWR VGND:
#     xbck buf_2 (cmp_raw -> ck), xff dfrtp_1 (CLK ck, D VDPWR, RESET_B rb, Q rst), xor or2_1 (rst, osc_enb -> swp),
#     xi1 inv_1 (swp -> swn), xand and2_1 (db, osc_en -> rb), xdl dly5 (rst -> db),
#     XMDP pfet_01v8 W2 L0.15 (sw, gate swn, VDPWR), XMDN nfet_01v8 W0.42 L1.5 (sw, gate swn, VGND),
#     XMRST nfet_01v8 W6 L0.5 m2 (vcap -> VGND, gate sw).
# Layout (um, cell frame):
#   dly5 at (0, 0), 19.18 x 5.53: five columns at x = 2.13 + 3.73 j (rings shared between columns), nfet row y 1.105
#   (gate contact on top), pfet row y 4.105 (gate contact at the bottom), one met1 gate link per column. The chain runs
#   right to left: a enters column 4, y leaves column 0. Drains = left strips (via1 + met2), sources = right strips
#   (li1 to the ring). VGND met1 bus along the bottom (n-ring ties), VDPWR met1 bus along the top (p-ring ties).
#   Standard-cell row at y 8.4: tap, and2_1, buf_2, dfrtp_1, or2_1, inv_1, tap. buf_2.X -> CLK, D -> VPWR and
#   or2_1.X -> inv_1.A are li1 bridges. Q -> or2_1.A is a met1 bar. Channel between the row and dly5: met2 tracks
#   y 6.3 (rb, rst) and y 7.6 (swn).
#   Reset driver beside dly5: MDN (x 20.85, y 1.105) under MDP (y 4.6), gates linked in met1, sw on met2 at x 21.745;
#   MRST at (24.2, 3.895): middle strip = vcap (via1 column, met2 out to the right edge), outer strips = VGND straight
#   down to the VGND bus; the bus runs on to the right edge, where it meets C_osc's VGND sheet in the assembly.
#   Pins: cmp_raw, osc_en, osc_enb, rst met2 on the top edge; vcap met2 on the right edge; VDPWR, VGND met1 on the left.
# Run (in tt_tsense/mag, with no dly5.mag / oneshot.mag present):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_oneshot.tcl
drc off
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc sq {x y h lay} { pt [expr {$x-$h}] [expr {$y-$h}] [expr {$x+$h}] [expr {$y+$h}] $lay }
# via1 with 0.34 um met1 / met2 pads; li1 pin -> met2 (mcon + via1)
proc v12 {x y} { sq $x $y 0.17 met1; sq $x $y 0.17 met2; sq $x $y 0.13 via1 }
proc pinup {x y} { sq $x $y 0.085 mcon; v12 $x $y }
# met2 wires 0.34 um wide: vertical (x, y1..y2) or horizontal (y, x1..x2)
proc m2v {x y1 y2} { pt [expr {$x-0.17}] $y1 [expr {$x+0.17}] $y2 met2 }
proc m2h {y x1 x2} { pt $x1 [expr {$y-0.17}] $x2 [expr {$y+0.17}] met2 }
set GENCELLS {}
proc gen {parent name dev pars x y} {
  set key "$dev $pars"
  if {[info exists ::MADE($key)]} {
    set fc $::MADE($key)
  } else {
    box 0um 0um 0um 0um
    set before [cellname list children $parent]
    eval magic::gencell sky130::$dev XTMP $pars
    set fc ""
    foreach c [cellname list children $parent] { if {[lsearch -exact $before $c] < 0} { set fc $c } }
    select cell XTMP
    delete
    set ::MADE($key) $fc
  }
  bx $x $y $x $y
  getcell $fc child 0 0
  identify $name
  puts "CELL $name $fc"
  if {[lsearch -exact $::GENCELLS $fc] < 0} { lappend ::GENCELLS $fc }
}
proc std {name cell x y} { bx $x $y $x $y; getcell sky130_fd_sc_hd__$cell child 0 0; identify $name }
proc pin {nm lay x1 y1 x2 y2} { pt $x1 $y1 $x2 $y2 $lay; label $nm c $lay; port make }

# ===================================================================================================================
# dly5
# ===================================================================================================================
load dly5
set YN 1.105
set YP 4.105
for {set j 0} {$j < 5} {incr j} {
  set c [expr {2.13 + 3.73 * $j}]
  set k [expr {5 - $j}]
  gen dly5 XMN$k sky130_fd_pr__nfet_01v8 {w 0.42 l 2.3 nf 1 guard 1 topc 1 botc 0} $c $YN
  gen dly5 XMP$k sky130_fd_pr__pfet_01v8 {w 1 l 2.3 nf 1 guard 1 topc 0 botc 1} $c $YP
  # gate link: the nfet's top gate bar to the pfet's bottom gate bar
  pt [expr {$c+0.13}] 1.32 [expr {$c+0.45}] 3.58 met1
  # drains (left strips): via1 on each, met2 between (column 0 runs on up to its pin y)
  sq [expr {$c-1.295}] 0.85 0.13 via1
  sq [expr {$c-1.295}] 4.30 0.13 via1
  # the strips are 0.23 wide: a 0.26 x 0.32 met1 pad under each via1 (via.5a)
  pt [expr {$c-1.425}] 0.69 [expr {$c-1.165}] 1.01 met1
  pt [expr {$c-1.425}] 4.14 [expr {$c-1.165}] 4.46 met1
  if {$j == 0} { set ytop 5.50 } else { set ytop 4.47 }
  m2v [expr {$c-1.295}] 0.68 $ytop
  # sources (right strips) to the ring with li1
  pt [expr {$c+1.30}] 0.80 [expr {$c+1.86}] 1.05 li1
  pt [expr {$c+1.30}] 4.10 [expr {$c+1.86}] 4.50 li1
  # ring ties to the buses
  sq $c 0.265 0.085 mcon
  sq $c 5.26 0.085 mcon
  # output -> gate of the column on the left
  if {$j > 0} {
    set cl [expr {2.13 + 3.73 * ($j - 1)}]
    m2h 2.45 [expr {$cl+0.12}] [expr {$c-1.125}]
    sq [expr {$cl+0.29}] 2.45 0.13 via1
  }
}
# input a: column 4's gate link up to the top edge
sq 17.34 2.45 0.13 via1
m2v 17.34 2.28 5.50
# supply buses
pt 0 0.12 19.18 0.41 met1
pt 0 5.12 19.18 5.40 met1
pin a     met2 17.17 5.10 17.51 5.50
pin y     met2  0.665 5.10 1.005 5.50
pin VDPWR met1  0.0  5.12 0.40 5.40
pin VGND  met1  0.0  0.12 0.40 0.41
select top cell
save dly5
foreach c $GENCELLS { load $c; save $c }

# ===================================================================================================================
# oneshot
# ===================================================================================================================
load oneshot
set Y0 8.4
bx 0 0 0 0
getcell dly5 child 0 0
identify xdl
# --- standard-cell row, rails, well ------------------------------------------------------------------------------
std XTAP1 tapvpwrvgnd_1 0     $Y0
std xand  and2_1        0.46  $Y0
std xbck  buf_2         2.76  $Y0
std xff   dfrtp_1       4.60  $Y0
std xor   or2_1         13.80 $Y0
std xi1   inv_1         16.10 $Y0
std XTAP2 tapvpwrvgnd_1 17.48 $Y0
pt -1.2  [expr {$Y0-0.24}] 17.94 [expr {$Y0+0.24}] met1
pt -0.6  [expr {$Y0+2.48}] 17.94 [expr {$Y0+2.96}] met1
pt -0.19 [expr {$Y0+1.305}] 18.13 [expr {$Y0+2.91}] nwell
# --- li1 bridges: buf_2.X -> CLK (ck), D -> VPWR, or2_1.X -> inv_1.A (swp) --------------------------------------------
pt 3.905 [expr {$Y0+1.12}] 4.80  [expr {$Y0+1.29}] li1
pt 5.955 [expr {$Y0+2.45}] 6.28  [expr {$Y0+2.635}] li1
pt 15.90 [expr {$Y0+1.11}] 16.50 [expr {$Y0+1.28}] li1
# --- db: dly5.y -> and2_1.A ------------------------------------------------------------------------------------------
pinup 0.835 [expr {$Y0+1.2}]
m2v 0.835 5.0 [expr {$Y0+1.2}]
# --- osc_en (and2_1.B) and cmp_raw (buf_2.A) up to the top edge -----------------------------------------------------
pinup 1.625 [expr {$Y0+1.2}]
m2v 1.625 [expr {$Y0+1.2}] 12.0
pinup 3.05 [expr {$Y0+1.2}]
m2v 3.05 [expr {$Y0+1.2}] 12.0
# --- rb: and2_1.X -> RESET_B (met1 pin of the flop, widened for its via) on track y 6.3 ------------------------------
pinup 2.55 [expr {$Y0+0.75}]
m2v 2.55 6.13 [expr {$Y0+0.75}]
pt 11.645 [expr {$Y0+0.965}] 11.935 [expr {$Y0+1.45}] met1
sq 11.79 [expr {$Y0+1.2}] 0.13 via1
sq 11.79 [expr {$Y0+1.2}] 0.17 met2
m2v 11.79 6.13 [expr {$Y0+1.2}]
m2h 6.3 2.38 11.96
# --- rst: Q -> or2_1.A (met1 bar over or2_1.B), up to the top edge, down to dly5.a on track y 6.3 ---------------------
pt 13.435 [expr {$Y0+1.125}] 15.11 [expr {$Y0+1.45}] met1
sq 13.605 [expr {$Y0+1.24}] 0.085 mcon
sq 14.94  [expr {$Y0+1.24}] 0.085 mcon
sq 14.65 [expr {$Y0+1.29}] 0.13 via1
sq 14.65 [expr {$Y0+1.29}] 0.17 met2
m2v 14.65 [expr {$Y0+1.29}] [expr {$Y0+3.37}]
m2h [expr {$Y0+3.2}] 14.48 15.77
m2v 15.6 [expr {$Y0+3.03}] 12.0
m2v 14.65 6.13 [expr {$Y0+1.29}]
m2h 6.3 14.48 17.51
m2v 17.34 5.0 6.47
# --- osc_enb: or2_1.B (mcon at its bottom, met1 tab down to a via1) up to the top edge ------------------------------
sq 14.12 [expr {$Y0+0.85}] 0.085 mcon
pt 13.975 [expr {$Y0+0.40}] 14.265 [expr {$Y0+0.965}] met1
sq 14.12 [expr {$Y0+0.57}] 0.13 via1
sq 14.12 [expr {$Y0+0.57}] 0.17 met2
m2v 14.12 [expr {$Y0+0.57}] 12.0
# --- swn: inv_1.Y -> track y 7.6 -> MDP's top gate contact -------------------------------------------------------------
pinup 17.035 [expr {$Y0+1.2}]
m2v 17.035 7.43 [expr {$Y0+1.2}]
m2h 7.6 16.865 21.02
m2v 20.85 5.93 7.77

# --- reset driver --------------------------------------------------------------------------------------------------
gen oneshot XMDN  sky130_fd_pr__nfet_01v8 {w 0.42 l 1.5 nf 1 guard 1 topc 1 botc 0} 20.85 1.105
gen oneshot XMDP  sky130_fd_pr__pfet_01v8 {w 2 l 0.15 nf 1 guard 1 topc 1 botc 1} 20.85 4.6
gen oneshot XMRST sky130_fd_pr__nfet_01v8 {w 6 l 0.5 nf 2 guard 1 topc 1 botc 0} 24.2 3.895
# MDP's well joined to dly5's
pt 19.0 2.685 19.9 5.525 nwell
# swn: MDP's top gate pad widened for its via; MDP bottom gate -> MDN gate bar (met1 link)
pt 20.705 5.805 20.995 6.30 met1
sq 20.85 6.1 0.13 via1
pt 20.705 1.32 20.995 3.395 met1
# sources: MDN left strip -> ring, MDP left strip -> ring (li1); MDN ring -> VGND bus, MDP ring -> VDPWR bus
pt 19.40 0.80 19.95 1.05 li1
pt 20.00 4.40 20.60 4.80 li1
sq 20.85 0.265 0.085 mcon
pt 19.1 5.12 20.25 5.40 met1
sq 20.06 5.26 0.085 mcon
# sw: MDN drain (right strip) and MDP drain (right strip) -> met2 column x 21.745 -> MRST gate bar
sq 21.745 0.85 0.13 via1
pt 21.615 0.69 21.875 1.01 met1
m2v 21.745 0.68 7.29
sq 21.07 4.0 0.13 via1
pt 20.94 3.84 21.20 4.16 met1
m2h 4.0 20.90 21.915
m2h 7.12 21.575 24.37
pt 23.575 6.90 24.825 7.35 met1
sq 24.2 7.12 0.13 via1
# vcap: MRST middle strip, a via1 column, met2 out to the right edge
foreach y {1.2 2.2 3.2 4.2 5.2 6.2} { sq 24.2 $y 0.13 via1 }
pt 24.07 1.04 24.33 6.36 met1
pt 24.03 1.03 24.37 6.37 met2
m2h 3.2 24.03 26.5
# VGND: bus under the reset driver (dly5's bus continued), MRST outer strips down to it, ring ties
pt 19.18 0.12 26.5 0.41 met1
pt 23.295 0.12 23.525 0.74 met1
pt 24.875 0.12 25.105 0.74 met1
foreach x {23.0 24.2 25.4} { sq $x 0.265 0.085 mcon }
# --- supply straps on the left: VGND met1 (dly5 bus -> VGND rail), VDPWR met2 (dly5 bus -> VPWR rail) ---------------
pt -1.2 0.12 0.0 0.41 met1
pt -1.2 0.12 -0.8 [expr {$Y0+0.24}] met1
pt -0.6 5.0 0.05 5.52 met1
sq -0.35 5.26 0.13 via1
pt -0.52 5.09 -0.18 [expr {$Y0+2.89}] met2
sq -0.35 [expr {$Y0+2.72}] 0.13 via1

# --- pins (symbol order) --------------------------------------------------------------------------------------------
pin cmp_raw met2  2.88  11.6  3.22  12.0
pin osc_en  met2  1.455 11.6  1.795 12.0
pin osc_enb met2 13.95  11.6 14.29  12.0
pin vcap    met2 26.1    3.03 26.5   3.37
pin rst     met2 15.43  11.6 15.77  12.0
pin VDPWR   met1  0.0  [expr {$Y0+2.48}] 0.4 [expr {$Y0+2.96}]
pin VGND    met1 -1.2  [expr {$Y0-0.24}] -0.8 [expr {$Y0+0.24}]

select top cell
save oneshot
foreach c $GENCELLS { load $c; save $c }
foreach cl {dly5 oneshot} {
  load $cl
  select top cell
  puts "BBOX $cl [box values]"
  drc on
  drc style drc(full)
  drc check
  drc catchup
  puts "DRC_COUNT $cl [drc list count total]"
  foreach e [lrange [drc listall why] 0 29] { puts "DRC_WHY $e" }
}
quit -noprompt
