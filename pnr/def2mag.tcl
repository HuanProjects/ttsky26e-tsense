# def2mag.tcl -- import an OpenROAD block into Magic: ../pnr/<DESIGN>.def -> <DESIGN>.mag in the current directory
# (tt_tsense/mag). Usage, in tt_tsense/mag:
#   DESIGN=swdrv magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc ../pnr/def2mag.tcl
# The hd cells come from the PDK's .mag library (Magic's search path); only the tech LEF is read, for the via rules.
# The DEF pins arrive as port labels. VDPWR and VGND get port labels on their leftmost vertical met2 shape (the ring's
# left side, or the strap), taken from the DEF's SPECIALNETS.
drc off
set D $::env(DESIGN)
set H $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd
lef read $H/techlef/sky130_fd_sc_hd__nom.tlef
def read ../pnr/$D.def
load $D

# left met2 side of each ring: the RING segment on met2 with the smallest x
set f [open ../pnr/$D.def]
set def [read $f]
close $f
set sn [string range $def [string first "SPECIALNETS" $def] end]
foreach net {VDPWR VGND} {
  set i [string first "- $net " $sn]
  set seg [string range $sn $i [expr {[string first ";" $sn $i] - 1}]]
  set best {}
  foreach {all w x1 y1 x2 y2} [regexp -all -inline {met2 (\d+) \+ SHAPE (?:RING|STRIPE) \( (\d+) (\d+) \) \( (\d+) (\d+) \)} $seg] {
    if {$x1 == $x2 && ($best eq {} || $x1 < [lindex $best 0])} { set best [list $x1 $y1 $y2 $w] }
  }
  lassign $best x y1 y2 w
  set ym [expr {($y1 + $y2) / 2000.0}]
  set xl [expr {($x - $w / 2) / 1000.0}]
  set xh [expr {($x + $w / 2) / 1000.0}]
  box [format %.3fum $xl] [format %.3fum [expr {$ym - 0.4}]] [format %.3fum $xh] [format %.3fum [expr {$ym + 0.4}]]
  label $net c met2
  port make
  port use [expr {$net eq "VGND" ? "ground" : "power"}]
  puts "SUPPLY $net met2 $xl..$xh y [expr {$ym - 0.4}]..[expr {$ym + 0.4}]"
}
select top cell
puts "BBOX $D [box values]"
save $D
quit -noprompt
