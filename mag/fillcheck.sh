#!/bin/bash
# fillcheck.sh <cell> <res|mos|pnp>  -- where would the shuttle's fill land on a cell?
# Runs the PDK's own fill recipe (Magic `cif ostyle wafflefill(tiled)`, the one generate_fill.py uses) on a flattened
# copy of the cell in /tmp/fillcheck, then prints, for every matched unit, how much fill and how much of the cell's
# own metal sits above it (fill_units.py; res = resistor bodies, mos = channels, pnp = emitters).
# Writes nothing in this folder; the picture <cell>_fill.png (units, own met1, met1 fill) goes to /tmp/fillcheck.
# Run in tt_tsense/mag inside the container.
set -e
cell=$1; kind=$2
RC=$PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc
here=$(pwd); W=/tmp/fillcheck; mkdir -p $W
cat > $W/gds_$cell.tcl <<EOF
load $cell
select top cell
gds write $W/$cell.gds
quit -noprompt
EOF
magic -dnull -noconsole -rcfile $RC $W/gds_$cell.tcl > $W/gds_$cell.log 2>&1
cd $W
cat > fill_$cell.tcl <<EOF
drc off
crashbackups stop
locking disable
tech unlock *
scalegrid 1 2
snap internal
gds rescale false
gds drccheck no
gds read $cell.gds
load $cell -dereference
select top cell
expand
set bb [box values]
flatten -dobox -nolabels flat_$cell
load flat_$cell
property GDS_FILE ""
select top cell
erase comment
box values {*}\$bb
paint comment
cif ostyle wafflefill(tiled)
gds write fillpat_$cell.gds
quit -noprompt
EOF
magic -dnull -noconsole -rcfile $RC fill_$cell.tcl > fill_$cell.log 2>&1
klayout -b -r $here/fill_units.py -rd gds=$cell.gds -rd fill=fillpat_$cell.gds -rd kind=$kind -rd png=$W/${cell}_fill.png 2>&1 | grep -v Warning
