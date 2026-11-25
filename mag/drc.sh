#!/bin/bash
# drc.sh <cell>  -- full Magic DRC of a cell (with its subcells); prints the error count and the first errors.
# Run in tt_tsense/mag inside the container.
cell=$1
cat > /tmp/drc_$cell.tcl <<EOF
load $cell
select top cell
drc on
drc style drc(full)
drc check
drc catchup
set n [drc list count total]
puts "DRC_COUNT $cell \$n"
if {\$n > 0} { foreach e [drc listall why] { puts "DRC_WHY \$e" } }
quit -noprompt
EOF
magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc /tmp/drc_$cell.tcl 2>&1 | grep "^DRC_" | head -20
