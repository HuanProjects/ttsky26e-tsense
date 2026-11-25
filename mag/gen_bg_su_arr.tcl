# gen_bg_su_arr.tcl -- the scripted half of bg_su (M5 layout): the startup devices MSU1..MSU3.
# Builds bg_su_arr.mag: MSU1 (pfet_01v8 W 0.42 L 20) in an n-well with an n-tap ring (VDPWR), MSU2 (nfet_01v8
# W 0.42 L 10) and MSU3 (nfet_01v8 W 0.42 L 1, mirrored) in a p-tap ring (VGND) with a VGND rail over a p-tap strip
# between them; each source tied to its rail/ring; every drain and gate terminal brought to a met1 pad with a 2x2 via1
# up to a met2 landing. Left for bg_su.mag: the met2 wires of su, vpg, vref, nb and the pins.
#
# Pads (um, this cell's frame = the parent's frame with `getcell bg_su_arr child 0 0`):
#   MSU1  D (su)   1.80, 8.10      G (vref)  12.86, 9.145   (top gate strip)
#   MSU2  D (vpg)  1.80, 2.60      G (su)     7.90, 3.645   (top gate strip)
#   MSU3  D (su)  17.80, 2.60      G (nb)    15.98, 1.555   (bottom gate strip)
# Run (in tt_tsense/mag):  magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc gen_bg_su_arr.tcl
drc off
load bg_su_arr
proc um {v} { return [format "%.3fum" $v] }
proc bx {x1 y1 x2 y2} { box [um $x1] [um $y1] [um $x2] [um $y2] }
proc pt {x1 y1 x2 y2 lay} { bx $x1 $y1 $x2 $y2; paint $lay }
proc pad {x y} { pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met1
                 pt [expr {$x-0.4}] [expr {$y-0.4}] [expr {$x+0.4}] [expr {$y+0.4}] met2
                 pt [expr {$x-0.3}] [expr {$y-0.3}] [expr {$x+0.3}] [expr {$y+0.3}] via1 }
proc ring {x1 y1 x2 y2 tap cont} {
  foreach {a b c d} [list $x1 $y1 $x2 [expr {$y1+0.6}]  $x1 [expr {$y2-0.6}] $x2 $y2  $x1 $y1 [expr {$x1+0.6}] $y2  [expr {$x2-0.6}] $y1 $x2 $y2] {
    pt $a $b $c $d $tap; pt $a $b $c $d li1; pt $a $b $c $d met1
  }
  foreach {a b c d} [list [expr {$x1+0.215}] [expr {$y1+0.215}] [expr {$x2-0.215}] [expr {$y1+0.385}] \
                          [expr {$x1+0.215}] [expr {$y2-0.385}] [expr {$x2-0.215}] [expr {$y2-0.215}] \
                          [expr {$x1+0.215}] [expr {$y1+0.215}] [expr {$x1+0.385}] [expr {$y2-0.215}] \
                          [expr {$x2-0.385}] [expr {$y1+0.215}] [expr {$x2-0.215}] [expr {$y2-0.215}]] {
    pt $a $b $c $d $cont; pt $a $b $c $d mcon
  }
}
# the three devices (generated cells; centres)
set xa 7.90 ; set xb 15.98 ; set xp 12.86 ; set Yn 2.60 ; set Yp 8.10
foreach {nm dev w l x y o} [list MSU1 pfet 0.42 20 $xp $Yp 0  MSU2 nfet 0.42 10 $xa $Yn 0  MSU3 nfet 0.42 1 $xb $Yn 1] {
  box 0um 0um 0um 0um
  magic::gencell sky130::sky130_fd_pr__${dev}_01v8 XTMP w $w l $l nf 1 guard 0
  set fc [lindex [cellname list children bg_su_arr] end]
  foreach c [cellname list children bg_su_arr] { if {[string match "*${dev}*" $c] && ![info exists done($c)]} { set fc $c } }
  set done($fc) 1
  select cell XTMP
  delete
  bx $x $y $x $y
  if {$o} { getcell $fc h child 0 0 } else { getcell $fc child 0 0 }
  identify $nm
  set cellof($nm) $fc
}
# n-well + n-tap ring (MSU1, VDPWR); p-tap ring (MSU2, MSU3, VGND)
pt -0.2 6.2 25.1 10.9 nwell
ring 0 6.4 24.9 10.7 nsubdiff nsubdiffcont
ring 0 0 24.9 5.2 psubdiff psubdiffcont
# VGND rail between MSU2 (source right) and MSU3 (mirrored, source left), over a p-tap strip
pt 13.94 0.3 14.44 4.9 psubdiff
pt 14.105 0.215 14.275 4.985 psubdiffcont
pt 13.94 0 14.44 5.2 li1
pt 14.105 0.215 14.275 4.985 mcon
pt 13.10 0 15.30 5.2 met1
# MSU1 source to the right side of the n-tap ring
pt [expr {$xp+10.03}] [expr {$Yp-0.15}] 24.4 [expr {$Yp+0.15}] met1
# drain pads (met1 bar from the drain strip to the pad)
pad 1.80 $Yp ; pt 2.20 [expr {$Yp-0.15}] [expr {$xp-10.03}] [expr {$Yp+0.15}] met1
pad 1.80 $Yn ; pt 2.20 [expr {$Yn-0.15}] [expr {$xa-5.03}] [expr {$Yn+0.15}] met1
pad 17.80 $Yn ; pt [expr {$xb+0.53}] [expr {$Yn-0.15}] 17.40 [expr {$Yn+0.15}] met1
# gate pads on the gate strips (top for MSU1 and MSU2, bottom for MSU3)
pt [expr {$xp-0.4}] [expr {$Yp+0.415}] [expr {$xp+0.4}] [expr {$Yp+1.445}] met1 ; pad $xp [expr {$Yp+1.045}]
pt [expr {$xa-0.4}] [expr {$Yn+0.415}] [expr {$xa+0.4}] [expr {$Yn+1.445}] met1 ; pad $xa [expr {$Yn+1.045}]
pt [expr {$xb-0.4}] [expr {$Yn-1.445}] [expr {$xb+0.4}] [expr {$Yn-0.415}] met1 ; pad $xb [expr {$Yn-1.045}]

save bg_su_arr
foreach nm {MSU1 MSU2 MSU3} { load $cellof($nm); save $cellof($nm); puts "CELL $nm $cellof($nm)" }
load bg_su_arr
select top cell
drc on
drc style drc(full)
drc check
drc catchup
puts "DRC_COUNT bg_su_arr [drc list count total]"
foreach e [lrange [drc listall why] 0 19] { puts "DRC_WHY $e" }
quit -noprompt
