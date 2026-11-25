#!/bin/bash
# precheck.sh [path to a tt-support-tools checkout]  -- TinyTapeout's precheck, run locally the way the gds workflow
# runs it: gds/<top>.gds, lef/<top>.lef and src/project.v are copied side by side into ../tt_submission (ignored by
# git, removed afterwards) and precheck.py runs on that copy. Run in tt_tsense/mag inside the container.
# The checkout (git clone --depth 1 https://github.com/TinyTapeout/tt-support-tools) defaults to
# /foss/designs/tt_setup/tt_template/tools. The CI uses its own Magic, KLayout and PDK versions, so a local pass is
# a strong hint, not a guarantee. Prints the result table; the full log is /tmp/tt_precheck.log.
T=${1:-/foss/designs/tt_setup/tt_template/tools}
R=$(cd .. && pwd)
TOP=$(grep -E '^\s*top_module:' $R/info.yaml | sed -E 's/.*"(.*)".*/\1/')
S=$R/tt_submission
rm -rf $S && mkdir -p $S
cp $R/gds/$TOP.gds $R/lef/$TOP.lef $S/ && cp $R/src/project.v $S/$TOP.v || exit 1
cd $T/precheck && rm -rf reports/*
PDK=sky130A python3 precheck.py --gds $S/$TOP.gds --tech sky130A > /tmp/tt_precheck.log 2>&1
echo "precheck exit code $? (0 = all checks passed)"
grep -a "^ERROR" /tmp/tt_precheck.log | head -20
cat reports/results.md
rm -rf $S
