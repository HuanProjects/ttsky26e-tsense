#!/bin/bash
# lvs.sh <cell> [schematic cell name]  -- extract a Magic cell and compare it with the frozen schematic.
# Run in tt_tsense/mag inside the container. Schematic side = a whole frozen, hashed netlist: ../xschem/simulation/bgr.spice
# (M5 11), osc_core.spice (M6 freeze) for the oscillator's cells, or swdrv / readout_glue / ring3.spice (M7); the first that has the
# subckt is used, so a cell that contains other cells (bg_core, bgr, osc_core) finds its subcells. When the netlist uses
# sky130_fd_sc_hd standard cells, the library's SPICE file is included so netgen knows their insides.
# xschem writes the top level (bgr) as comments (**.subckt bgr ... **.ends); the awk below turns those lines back
# into a real subckt and changes nothing else. Writes lvs/<cell>.*; prints the verdict lines.
set -e
cell=$1; sch=${2:-$1}
mkdir -p lvs
rm -f lvs/$cell.lvs.out lvs/$cell.ext.spice
cat > lvs/$cell.ext.tcl <<EOF
load $cell
select top cell
extract path lvs
extract all
ext2spice lvs
ext2spice -p lvs -o lvs/$cell.ext.spice
quit -noprompt
EOF
magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc lvs/$cell.ext.tcl > lvs/$cell.magic.log 2>&1
conv() {
  awk '
  /^\*\*\.subckt /        { sub(/^\*\*/, ""); print; top = 1; next }
  top && /^\*\+/          { sub(/^\*/, "");  print; next }
  /^\*\*\.ends/           { sub(/^\*\*/, ""); print; top = 0; next }
                          { top = 0; print }
' "$1"
}
NETS="../xschem/simulation/bgr.spice ../xschem/simulation/osc_core.spice ../xschem/simulation/swdrv.spice"
NETS="$NETS ../xschem/simulation/readout_glue.spice ../xschem/simulation/ring3.spice"
found=""
for net in $NETS; do
  conv $net > lvs/$cell.sch.spice
  if grep -q "^\.subckt $sch " lvs/$cell.sch.spice; then found=$net; break; fi
done
# No frozen netlist has the cell (a layout-only cell whose subckt is in lvs_cells/): all five stacked (their subckt
# names are unique), so that subckt can use any of theirs.
if [ -z "$found" ]; then
  for net in $NETS; do conv $net | grep -v -i "^\.end$"; done > lvs/$cell.sch.spice
  echo ".end" >> lvs/$cell.sch.spice
fi
# Layout-only cells (no subckt of their own in the frozen netlist; e.g. bg_bias = bg_core's MNB1..MNB4): for a
# standalone check, lvs_cells/<cell>.spice supplies that subckt, built from the frozen device lines, inserted before
# ".end". It is used only when the cell is checked on its own; bg_core's LVS flattens the layout cell instead.
# A line "* uses: a b" in that file names other lvs_cells subckts it instantiates; they are inserted as well.
if ! grep -q "^\.subckt $sch " lvs/$cell.sch.spice && [ -f lvs_cells/$sch.spice ]; then
  files=lvs_cells/$sch.spice
  for u in $(sed -n 's/^\* uses: *//p' lvs_cells/$sch.spice); do files="$files lvs_cells/$u.spice"; done
  for f in $files; do
    awk -v f=$f '$1 == ".end" { while ((getline l < f) > 0) print l } { print }' lvs/$cell.sch.spice \
      > lvs/$cell.sch.tmp && mv lvs/$cell.sch.tmp lvs/$cell.sch.spice
  done
fi
# Layout-only dummies (lvs_dummies.txt, lines "<subckt> <instance line>"): devices whose every terminal sits on one
# supply net, so they add nothing to any simulated net. The frozen netlist has none; they go into this LVS copy only.
if [ -f lvs_dummies.txt ]; then
  awk 'NR == FNR { if ($0 !~ /^#/ && NF > 1) { c = $1; sub(/^[^ ]+ +/, ""); add[c] = add[c] $0 "\n" }; next }
       $1 == ".subckt" { cur = $2 }
       $1 == ".ends" && (cur in add) { printf "%s", add[cur] }
       { print }' lvs_dummies.txt lvs/$cell.sch.spice > lvs/$cell.sch.tmp && mv lvs/$cell.sch.tmp lvs/$cell.sch.spice
fi
if ! grep -q "^\.subckt $sch " lvs/$cell.sch.spice; then echo "no subckt $sch in the frozen netlists or lvs_cells/"; exit 1; fi
if grep -q "sky130_fd_sc_hd__" lvs/$cell.sch.spice; then
  sed -i "1a .include $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice" lvs/$cell.sch.spice
fi
netgen -batch lvs "lvs/$cell.ext.spice $cell" "lvs/$cell.sch.spice $sch" $PDK_ROOT/sky130A/libs.tech/netgen/sky130A_setup.tcl lvs/$cell.lvs.out > lvs/$cell.netgen.log 2>&1
echo "== $cell vs schematic $sch"
if [ ! -f lvs/$cell.lvs.out ]; then echo "no LVS report: netgen could not read the layout netlist (a cell with no pins yet?); see lvs/$cell.netgen.log"; exit 1; fi
grep -i "circuits match\|do not match\|netlists do not\|property errors\|mismatch\|failed pin\|port errors" lvs/$cell.lvs.out | sort | uniq -c
