# mk_osc_core.tcl -- one-time: create the routing cell osc_core.mag holding its four placed cells (results_m6.md
# section 13g). Frame = tile minus (7, 12) um: the left band (tile x 7..89) is x 0..82 here.
#   XCosc osc_cosc at (26.6, 0.5): the MIM sheet ends 2.08 um short of the VDPWR stripe (tile x 90).
#   xos   oneshot  at (4.9, 55.0): above C_osc's left part; its vcap pin and MRST sit over C_osc's vcap bus.
#   xcmp  cmp2s    mirrored (h) at (72.155, 69.4): cell x 0.845..71.155 -> 71.31..1.0; cmp_raw at the left end, over
#                  the one-shot's cmp_raw pin; the vcap strap faces C_osc.
#   xmux  thrmux   at (3.0, 97.5): top left, vref / veb3 pins facing the left channel; the V_REF decap (top level)
#                  goes to its right.
# Run once in tt_tsense/mag, with no osc_core.mag present:
#   magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc mk_osc_core.tcl
drc off
load osc_core
proc place {cell x y orient nm} {
  box ${x}um ${y}um ${x}um ${y}um
  if {$orient eq ""} { getcell $cell child 0 0 } else { getcell $cell $orient child 0 0 }
  identify $nm
}
place osc_cosc 26.6   0.5  ""  XCosc
place oneshot   4.9  55.0  ""  xos
place cmp2s    72.155 69.4 h   xcmp
place thrmux    3.0  97.5  ""  xmux
save osc_core
quit -noprompt
