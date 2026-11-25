#!/bin/bash
# M5 5b: fan tb_bg_k.spice out over the 15 guaranteed corners x 1.71/1.80/1.89 V at -20/0/25/50/75/100 C,
# then summarize V_REF(N3) = veb3 + (N3/4)*ptat for N3 = 39/40/41, K_opt per corner/supply, and flag any
# operating point that is not the design point (|va - vb| > 1 mV or I_PTAT < 1 uA).
# Run from anywhere in the container after netlisting tb_bg_k.sch:  bash /foss/designs/tt_tsense/xschem/k5b.sh
S=/foss/designs/tt_tsense/xschem/simulation
cd $S || exit 1
grep -q '^foreach t ' tb_bg_k.spice || { echo "netlist tb_bg_k.sch first"; exit 1; }
mkdir -p k5b && rm -f k5b/*
# one OpenMP thread per ngspice, so twelve at once do not fight (a .spiceinit here replaces the home one)
sed 's/^set num_threads=.*/set num_threads=1/' $HOME/.spiceinit > k5b/.spiceinit
for c in tt ll hh ss ss_ll ss_hh ff ff_ll ff_hh sf sf_ll sf_hh fs fs_ll fs_hh; do
  for v in 1.71 1.8 1.89; do
    sed -e "s/sky130.lib.spice tt\$/sky130.lib.spice $c/" \
        -e "s/^foreach t .*/foreach t -20 0 25 50 75 100/" \
        -e "s/^\(V\w* \w* 0\) 1.8\$/\1 $v/" \
        -e "s/^  echo KX temp=/  echo KX corner=$c vdd=$v temp=/" tb_bg_k.spice > k5b/k_${c}_${v}.spice
    echo k_${c}_${v}.spice
  done
done > k5b/jobs.txt
cd k5b && xargs -P 12 -I{} sh -c 'ngspice -b {} > {}.log 2>&1' < jobs.txt
for f in $(cat jobs.txt); do grep '^KX ' $f.log; done > all.txt
echo "$(wc -l < all.txt) KX lines (expect 270)"
awk '
{ delete v; for (i = 2; i <= NF; i++) { split($i, kv, "="); v[kv[1]] = kv[2] }
  k = v["corner"] " " v["vdd"]; if (!(k in seen)) { seen[k] = 1; order[++n] = k }
  if (v["Iptat_nA"] < 1000 || v["va_vb_uV"] > 1000 || v["va_vb_uV"] < -1000) {
    printf "OFF-DESIGN corner=%s vdd=%s temp=%s Iptat_nA=%s vref_V=%s va_vb_uV=%s\n", v["corner"], v["vdd"], v["temp"], v["Iptat_nA"], v["vref_V"], v["va_vb_uV"]
    bad[k] = 1; next }
  if (v["temp"] == -20) { e1[k] = v["veb3_V"]; p1[k] = v["ptat_mV"] / 1000 }
  if (v["temp"] == 100) { e2[k] = v["veb3_V"]; p2[k] = v["ptat_mV"] / 1000 }
  for (m = 39; m <= 41; m++) { r = v["veb3_V"] + m / 4 * v["ptat_mV"] / 1000
    if (!((k, m) in lo) || r < lo[k, m]) { lo[k, m] = r; lot[k, m] = v["temp"] }
    if (!((k, m) in hi) || r > hi[k, m]) hi[k, m] = r } }
END {
  printf "\n%-6s %-5s %7s   %-22s %-22s %-22s\n", "corner", "vdd", "K_opt", "N3=39 min..max (Tmin)", "N3=40 min..max (Tmin)", "N3=41 min..max (Tmin)"
  for (j = 1; j <= n; j++) { k = order[j]; split(k, ck, " ")
    ko = ((k in e1) && (k in e2)) ? sprintf("%7.3f", (e1[k] - e2[k]) / (p2[k] - p1[k])) : "    n/a"
    line = sprintf("%-6s %-5s %s", ck[1], ck[2], ko)
    for (m = 39; m <= 41; m++) line = line sprintf("   %.4f..%.4f (%4s)", lo[k, m], hi[k, m], lot[k, m])
    print line (k in bad ? "   * one point off-design, left out" : "") }
  for (m = 39; m <= 41; m++) { L = 9; H = 0
    for (j = 1; j <= n; j++) { k = order[j]; if (lo[k, m] < L) { L = lo[k, m]; Lk = k " " lot[k, m] }; if (hi[k, m] > H) H = hi[k, m] }
    printf "N3=%d over all: V_REF %.4f .. %.4f V   lowest at %s C\n", m, L, H, Lk } }' all.txt
