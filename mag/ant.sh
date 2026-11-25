#!/bin/bash
# ant.sh [cell]  -- Magic antenna check of a cell (default: the tile), as the PDK check_antenna.py runs it.
# Run in tt_tsense/mag inside the container. TinyTapeout precheck has no antenna check for sky130. Prints the number of
# violations and each one (cell of the gate, layer, ratio against the limit); the full log is lvs/<cell>.ant.log.
cell=${1:-tt_um_huanprojects_tsense}
mkdir -p lvs/ant
cat > lvs/$cell.ant.tcl <<TCL
crashbackups stop
drc off
snap internal
load $cell -dereference
select top cell
expand
extract path lvs/ant
extract do local
extract no all
extract all
antennacheck debug
antennacheck
quit -noprompt
TCL
magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc lvs/$cell.ant.tcl > lvs/$cell.ant.log 2>&1
grep -q "antennacheck finished" lvs/$cell.ant.log || { echo "antenna check did not finish; see lvs/$cell.ant.log"; exit 1; }
echo "ANTENNA_COUNT $cell $(grep -c "Antenna violation detected" lvs/$cell.ant.log)"
grep -B1 -A1 "Antenna violation detected" lvs/$cell.ant.log | grep -v "^--" | paste - - - | sed "s/^/ANTENNA /"
