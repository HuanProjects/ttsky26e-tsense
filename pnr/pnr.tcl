# pnr.tcl -- OpenROAD place and route of one digital block of the tile (sky130_fd_sc_hd), for import into Magic.
# Usage (in tt_tsense/pnr):  DESIGN=swdrv openroad -exit -no_init pnr.tcl
# Reads cfg_<DESIGN>.tcl: DIE_W, DIE_H (um), MX, MY (die edge to core: whole sites of 0.46, whole rows of 2.72),
# DENSITY, and PINS, a list of
# {name side layer position} with side top|bottom|left|right and position along that edge (um, from the die's
# lower-left corner).
# Supply: met1 rails on every row, joined by a ring round the core (met3 horizontal, met2 vertical sides);
# signals on met1..met3 only, so met4 stays free over the block for the tile wiring.
# Fill: fill cells only (no decap cells: they hold devices that the frozen netlists do not have).
set D $::env(DESIGN)
source cfg_$D.tcl
set H $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd
read_lef $H/techlef/sky130_fd_sc_hd__nom.tlef
read_lef $H/lef/sky130_fd_sc_hd.lef
read_liberty $H/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog $D.v
link_design $D

initialize_floorplan -die_area "0 0 $DIE_W $DIE_H" \
  -core_area "$MX $MY [expr {$DIE_W - $MX}] [expr {$DIE_H - $MY}]" -site unithd
make_tracks li1  -x_offset 0.23 -x_pitch 0.46 -y_offset 0.17 -y_pitch 0.34
make_tracks met1 -x_offset 0.17 -x_pitch 0.34 -y_offset 0.17 -y_pitch 0.34
make_tracks met2 -x_offset 0.23 -x_pitch 0.46 -y_offset 0.23 -y_pitch 0.46
make_tracks met3 -x_offset 0.34 -x_pitch 0.68 -y_offset 0.34 -y_pitch 0.68
make_tracks met4 -x_offset 0.46 -x_pitch 0.92 -y_offset 0.46 -y_pitch 0.92
make_tracks met5 -x_offset 1.70 -x_pitch 3.40 -y_offset 1.70 -y_pitch 3.40

# pins, on the die edge
foreach p $PINS {
  lassign $p name side layer pos
  switch $side {
    top    { set loc [list $pos [expr {$DIE_H - 0.4}]]; set sz {0.28 0.8} }
    bottom { set loc [list $pos 0.4];                   set sz {0.28 0.8} }
    left   { set loc [list 0.4 $pos];                   set sz {0.8 0.3} }
    right  { set loc [list [expr {$DIE_W - 0.4}] $pos]; set sz {0.8 0.3} }
  }
  place_pin -pin_name $name -layer $layer -location $loc -pin_size $sz -force_to_die_boundary
}

# PDN = ring (default): a ring round the core. PDN = straps: one met2 strap at the core's left edge (VGND) and one at
# its right edge (VDPWR), STRAP_W wide (cells may sit under them; the router reaches their pins on met1);
# the straps face the tile's left VGND stripe and middle VDPWR stripe.
if {![info exists PDN]} { set PDN ring }
tapcell -distance 13 -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1
# supply network
add_global_connection -net VDPWR -pin_pattern {^VPWR$} -power
add_global_connection -net VDPWR -pin_pattern {^VPB$} -power
add_global_connection -net VGND -pin_pattern {^VGND$} -ground
add_global_connection -net VGND -pin_pattern {^VNB$} -ground
global_connect
set_voltage_domain -power VDPWR -ground VGND
define_pdn_grid -name grid -voltage_domains CORE
if {$PDN eq "straps"} {
  set cw [expr {$DIE_W - 2 * $MX}]
  add_pdn_stripe -grid grid -layer met1 -width 0.48 -followpins
  add_pdn_stripe -grid grid -layer met2 -width $STRAP_W -pitch 1000 -offset 0.23 -nets {VGND}
  add_pdn_stripe -grid grid -layer met2 -width $STRAP_W -pitch 1000 -offset [expr {$cw - $STRAP_W - 0.23}] -nets {VDPWR}
  add_pdn_connect -grid grid -layers {met1 met2}
} else {
  add_pdn_ring -grid grid -layers {met3 met2} -widths {0.8 0.8} -spacings {0.5 0.5} -core_offsets {0.5 0.5}
  add_pdn_stripe -grid grid -layer met1 -width 0.48 -followpins -extend_to_core_ring
  add_pdn_connect -grid grid -layers {met1 met2}
  add_pdn_connect -grid grid -layers {met2 met3}
}
pdngen

# place
global_placement -density $DENSITY
detailed_placement
check_placement -verbose
filler_placement {sky130_fd_sc_hd__fill_8 sky130_fd_sc_hd__fill_4 sky130_fd_sc_hd__fill_2 sky130_fd_sc_hd__fill_1}
check_placement

# route
set_routing_layers -signal met1-met3
global_route
detailed_route -output_drc $D.route_drc.rpt -verbose 0
write_def $D.def
write_verilog $D.pnr.v
puts "PNR_DONE $D"
