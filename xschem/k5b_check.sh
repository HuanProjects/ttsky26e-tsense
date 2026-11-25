#!/bin/bash
# M5 5b: is an OFF-DESIGN operating point real? Power up the same corner/supply/temperature two ways and see
# where the core ends: (1) from the zero state (.ic), (2) VDD ramp 0 -> vdd in 1 us. 1 ms each.
# Usage (after k5b.sh):  bash /foss/designs/tt_tsense/xschem/k5b_check.sh fs_ll 1.71 -20
c=$1; v=$2; t=$3
[ -n "$t" ] || { echo "usage: k5b_check.sh <corner> <vdd> <temp>"; exit 1; }
cd /foss/designs/tt_tsense/xschem/simulation/k5b || exit 1
src=k_${c}_${v}.spice
[ -f $src ] || { echo "no $src: run k5b.sh first"; exit 1; }
ctl() {
cat <<EOF
.control
option reltol=1e-4
option temp=$t
tran 20n 1m 0 50n
let ip = 2*i(v7)*1e9
meas tran ip10 find ip at=10u
meas tran ip100 find ip at=100u
meas tran ipend find ip at=1m
meas tran vrend find v(vref) at=1m
meas tran vamb find v(x1.va) at=1m
meas tran vbmb find v(x1.vb) at=1m
let dab = (vamb - vbmb)*1e6
echo CHECK $1 corner=$c vdd=$v temp=$t Iptat_10us_nA=\$&ip10 Iptat_100us_nA=\$&ip100 Iptat_1ms_nA=\$&ipend vref_1ms_V=\$&vrend va_vb_1ms_uV=\$&dab
.endc
.end
EOF
}
# the netlist without its control block and final .end (the subcircuits follow the control block)
body=$(sed -e '/^\.control/,/^\.endc/d' -e '/^\.end$/d' $src)
# (1) zero state: replace the nodeset with the 4b .ic
{ echo "$body" | sed "s/^\.nodeset .*/.ic v(x1.vpg)=$v v(x1.va)=0 v(x1.vb)=0 v(vref)=0/"; ctl zero_state; } > chk_zero.spice
# (2) 1 us ramp: every source at vdd becomes PWL(0 0 1u vdd); no nodeset
{ echo "$body" | sed -e '/^\.nodeset /d' -e "s/^\(V\w* \w* 0\) $v\$/\1 PWL(0 0 1u $v)/"; ctl ramp_1us; } > chk_ramp.spice
for f in chk_zero chk_ramp; do ngspice -b $f.spice > $f.log 2>&1 & p="$p $!"; done
wait $p
grep -h '^CHECK' chk_zero.log chk_ramp.log
