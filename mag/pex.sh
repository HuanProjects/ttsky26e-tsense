#!/bin/bash
# pex.sh [cell]  -- flat C-only extraction of a cell (default: the tile) for post-layout simulation.
# Run in tt_tsense/mag inside the container. Writes pex/<cell>.pex.spice (subckt <cell>_flat, every parasitic
# capacitor), pex/<cell>.lvs.spice (the same flat cell, devices only) and compares that one with the schematic, so
# the netlist that gets simulated is known to be the right circuit.
# The cell is flattened first, so wires of one block running over another are extracted against each other.
# ext2spice: "lvs" sets the device format; "hierarchy off" must follow it. With the hierarchy left on, this Magic
# (8.3.678) leaves out the substrate capacitance of every net it does not count as connected at the top level
# (225 nets of the tile, vcap among them); the sum of the node capacitances in the .ext file is the check.
set -e
cell=${1:-tt_um_huanprojects_tsense}
mkdir -p pex
cat > pex/$cell.pex.tcl <<TCL
crashbackups stop
drc off
load $cell
select top cell
flatten ${cell}_flat
load ${cell}_flat
select top cell
extract path pex
extract all
ext2spice lvs
ext2spice -p pex -o pex/$cell.lvs.spice
ext2spice hierarchy off
ext2spice cthresh 0
ext2spice -p pex -o pex/$cell.pex.spice
quit -noprompt
TCL
magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc pex/$cell.pex.tcl > pex/$cell.magic.log 2>&1
sed -i "s/ *; \*\*FLOATING$//" pex/$cell.pex.spice
echo "== $cell: $(grep -c "^X" pex/$cell.pex.spice) devices, $(grep -c "^C" pex/$cell.pex.spice) capacitors"
