#!/bin/bash
# run.sh [design ...] -- the digital blocks of the tile, from the frozen netlists to Magic cells.
# Run in tt_tsense/pnr inside the container. Default designs: swdrv dig_top (dig_top = readout_glue + ring3).
#   1. structural Verilog from ../xschem/simulation/{swdrv,readout_glue,ring3}.spice (spice2v.py, mk_dig_top_v.py)
#   2. OpenROAD place and route per block (pnr.tcl + cfg_<design>.tcl) -> <design>.def, <design>.log
#   3. import into ../mag (def2mag.tcl) -> ../mag/<design>.mag
# Check afterwards in ../mag: ./drc.sh <design>, ./lvs.sh <design> (dig_top's subckt: lvs_cells/dig_top.spice).
set -e
S=../xschem/simulation
python3 spice2v.py $S/swdrv.spice swdrv > swdrv.v
python3 spice2v.py $S/readout_glue.spice readout_glue > readout_glue.v
python3 spice2v.py $S/ring3.spice ring3 > ring3.v
python3 mk_dig_top_v.py > dig_top.v
for d in ${@:-swdrv dig_top}; do
  if ! DESIGN=$d openroad -exit -no_init pnr.tcl > $d.log 2>&1; then echo "OpenROAD failed for $d: see $d.log"; exit 1; fi
  grep -q "PNR_DONE $d" $d.log
  [ -s $d.route_drc.rpt ] && echo "$d: router DRC report not empty ($d.route_drc.rpt)"
  (cd ../mag && DESIGN=$d magic -dnull -noconsole -rcfile $PDK_ROOT/sky130A/libs.tech/magic/sky130A.magicrc \
     ../pnr/def2mag.tcl | grep -E "^(SUPPLY|BBOX)")
done
