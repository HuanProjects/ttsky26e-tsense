# M6 results — relaxation oscillator and comparator

*Cells and benches in `xschem/`, runs in `xschem/simulation/`. Comparator sizes = adopted set C (spec §12e R12): pair M1a/M1b `nfet_01v8_lvt` 60/1.75 (W 10 × 6), mirror M2a/M2b `pfet_01v8_lvt` 32/4 (W 4 × 8), stage 2 M3 `pfet_01v8_lvt` 12/1 (W 4 × 3), output MIN `nfet_01v8` 2/0.15 + MIP `pfet_01v8` 0.42/1 + `sky130_fd_sc_hd__inv_1`. Bias option A: the tail and the stage-2 sink are `bgr`'s MNB3 / MNB4 (pins `ib_cmp1` / `ib_cmp2`).*

## 1. `cmp2s` on the first ramp

**Cell.** `cmp2s.sch` / `cmp2s.sym`, pins `vthr vcap ib_cmp1 ib_cmp2 VDPWR cmp_raw VGND`. Internal nodes: `nd` (mirror), `n1` (stage-1 output = M3 gate), `x` (inverter output). `ib_cmp1` is the tail node, `ib_cmp2` is the stage-2 output node `n2`.

**Bench.** `tb_cmp_ramp.sch`: tt, 25 °C, 1.80 V. MNB1 `nfet_01v8` 4/8 fed 1.386 µA; MNB3 / MNB4 4/8 × 4 on `ib_cmp1` / `ib_cmp2` (5.54 µA each), 40 fF on each pin. `vthr` = 1.2432 V (V_REF). `vcap` holds 0.8432 V, then ramps at 0.274 V/µs from 0.3 µs; the crossing is at 1.75985 µs. `.option method=gear`, `tran 0.1n 2.2u`. Log `simulation/tb_cmp_ramp.log`, waveforms `simulation/tb_cmp_ramp.txt`.

| Quantity | Result | Expected |
|---|---|---|
| t_d (`vcap` = `vthr` → `cmp_raw` = 0.9 V) | **71.8 ns** | 65–75 ns (spec t_d ≤ 100 ns) |
| Idle current (supply minus the 1.386 µA bias feed) | 5.49 µA | ≈ 5.5 µA (tail only) |
| `n1` idle (`vcap` 70 mV under) | 1.785 V | near VDPWR |
| `nd` idle | 1.191 V | — |
| Tail node idle | 0.701 V | — |
| `n2` idle | 0 V | 0 |
| `n1` at the crossing | 1.645 V | — |
| `n1` reaches 1.28 V | +56.1 ns | — |
| `n2` reaches 0.1 V | +64.1 ns | — |
| `n1` when `n2` = 0.9 V | 1.070 V | — |
| Overdrive at the output edge (71.8 ns × 0.274 mV/ns) | 19.7 mV | — |

**Where the 72 ns go.** `n1` idles at VDPWR − 15 mV: with `vcap` below `vthr`, M1b carries almost none of the tail current, so M2b (trying to source the mirror current) sits in triode. The pair is in weak inversion, so `n1` starts to leave the rail about 220 ns (60 mV) before the crossing and is 0.14 V down at the crossing. From there the only current that pulls `n1` down is the M1b − M2b imbalance, which grows with the overdrive (0.274 mV/ns):
- 0 → 56 ns: `n1` 1.645 → 1.28 V. M3 is still off (|V_GS| below its threshold).
- 56 → 72 ns: `n1` 1.28 → 1.07 V. M3 conducts but needs V_SG ≈ 0.73 V to beat MNB4's 5.54 µA.
- 64 → 72 ns: `n2` rises from 0.1 V; the strong-nfet inverter trips at about 0.5 V and `cmp_raw` rises at 71.8 ns.

The total swing on `n1` from idle to the flip is 0.72 V, of which only the last ≈ 8 ns is stage 2 and the inverters.

## 2. Delay or offset: three thresholds, two slopes

**Bench.** `tb_cmp_slopes.sch`: nine `cmp_tbcopy` (one `cmp2s` with MNB3 / MNB4 4/8 × 4 and 40 fF on each pin), each on its own `cmp_tbbias` (1.386 µA into `nfet_01v8` 4/8). Rows: `vthr` = V_EB3 0.7096, V_REF′ 0.9605, V_REF 1.2432 V. Columns: full slope 0.274 V/µs and half slope 0.137 V/µs (both start 0.4 V under), and s/20 = 0.0137 V/µs (15 mV under). Static offset Vos: `.dc` sweep of the slow copy's `vcap` across its threshold in 5 µV steps, trip at `cmp_raw` = 0.9 V. Runner `slopes2.py` (also runs the same deck with all nine copies on one shared diode); output `simulation/slopes2/summary.md`. tt, 25 °C, 1.80 V.

t0 = t_d − Vos/s; r = (t0(s/2) + 11.5 ns) / (2 (t0(s) + 11.5 ns)).

**Each copy on its own diode (as on chip):**

| Threshold | t_d full (ns) | t_d half (ns) | Vos, DC (mV) | t0 full (ns) | t0 half (ns) | r | r from raw t_d |
|---|---|---|---|---|---|---|---|
| V_EB3 0.7096 V | 74.15 | 86.30 | −0.041 | 74.30 | 86.60 | 0.572 | 0.571 |
| V_REF′ 0.9605 V | 72.95 | 84.13 | −0.052 | 73.14 | 84.51 | 0.567 | 0.566 |
| V_REF 1.2432 V | 71.76 | 82.45 | −0.060 | 71.98 | 82.89 | 0.565 | 0.564 |

- r 0.565–0.572 (expected 0.55–0.58). Systematic Vos −0.04 to −0.06 mV (limit 0.5 mV). t0 spread over the three thresholds 2.3 ns (limit 3 ns); t_d(V_EB3) − t_d(V_REF) = +2.4 ns.
- The nominal offset is so small that removing it moves r by only 0.001. Its weight: 1 mV of offset would add 3.65 ns at full slope and 7.3 ns at half slope and move r by ≈ 0.018 (≈ 0.23 K at 0.83 K per unit k), which is why r is formed from t0.
- The s/20 ramp is not an offset meter here: it trips 0.9–1.1 mV past `vthr` (t_d 64–80 ns × 13.7 µV/ns) while the DC trip is −0.05 mV. Even at s/20 the trip carries a dynamic lag, so the offset comes from the `.dc` sweep (as in the spec's `tb_cmp_dc`).

**All nine copies on one shared diode (bench artifact):**

| Threshold | t_d full (ns) | t_d half (ns) | t_d s/20 (ns) | r |
|---|---|---|---|---|
| V_EB3 | 71.03 (−3.1) | 86.48 (+0.2) | 103.0 (+22.5) | 0.594 |
| V_REF′ | 69.95 (−3.0) | 84.90 (+0.8) | 99.5 (+27.8) | 0.593 |
| V_REF | 69.04 (−2.7) | 83.51 (+1.1) | 96.3 (+32.2) | 0.591 |

The DC currents are the same either way (each sink still mirrors 1.386 µA × 4). What changes is the transient: a copy that flips swings its `n2` rail to rail, and MNB4's gate–drain capacitance kicks the gate node `nb` up (own diode: copy 1's `nb` 0.681 → 0.719 V at its own flip; shared: 0.681 → 0.706 V). On a shared `nb` every other copy's tail and stage-2 sink currents rise for as long as `nb` takes to settle, so the copies that decide after a neighbour's flip are sped up (full slope, −3 ns) or held back (s/20 copies, which trip within 13 ns of each other, +22 to +32 ns). r moves by +0.025 (≈ 0.3 K). Benches give each copy its own bias diode.

## 3. Corners and headroom

**Bench.** `tb_cmp_corners.sch`: six `cmp_tbcopy` (three thresholds × full and half slope), each on its own `cmp_tbbias`; thresholds and slope are `.param` values. Per copy: t_d, and V_DS − V_dsat of M1a, M1b, M2b, M3 and MNB3 at the moment `n2` crosses 0.9 V on the ramp. Per threshold: the DC trip (Vos). Runner `corner3.py`: tt, ss, ff, sf, fs × −20 / 25 / 100 °C × 1.71 / 1.89 V; at each temperature the thresholds, the slope and the 4/8 diode current follow the frozen `bgr` at tt (V_REF 1.2391 / 1.2432 / 1.2441 V, V_EB3 0.7868 / 0.7096 / 0.5745 V, V_REF′ 0.9995 / 0.9605 / 0.8895 V, I_PTAT/2 1.197 / 1.386 / 1.668 µA). Output `simulation/corner3/{all.csv, summary.md}`. In this PDK `sf` = fast NMOS / slow PMOS.

**1.71 V** (1.89 V within 0.8 ns and 0.005 in r of these):

| Corner | T (°C) | t_d V_EB3 (ns) | t_d V_REF (ns) | EB3 − REF (ns) | r V_EB3 | r V_REF | Least margin at the flip |
|---|---|---|---|---|---|---|---|
| tt | −20 | 80.0 | 77.4 | +2.5 | 0.572 | 0.565 | MNB3 at V_EB3, +157 mV |
| tt | 25 | 74.3 | 72.0 | +2.3 | 0.571 | 0.564 | MNB3 at V_EB3, +85 mV |
| tt | 100 | 67.9 | 63.9 | +4.0 | 0.570 | 0.554 | MNB3 at V_EB3, −39 mV |
| ss | −20 | 84.6 | 81.9 | +2.7 | 0.574 | 0.566 | M1b at V_REF, +130 mV |
| ss | 25 | 79.1 | 76.5 | +2.6 | 0.576 | 0.568 | MNB3 at V_EB3, +67 mV |
| ss | 100 | 74.2 | 69.3 | +4.9 | 0.581 | 0.563 | MNB3 at V_EB3, −56 mV |
| ff | −20 | 75.0 | 72.9 | +2.2 | 0.567 | 0.561 | MNB3 at V_EB3, +176 mV |
| ff | 25 | 69.1 | 67.0 | +2.0 | 0.563 | 0.557 | MNB3 at V_EB3, +104 mV |
| ff | 100 | 60.8 | 57.4 | +3.4 | 0.552 | 0.539 | MNB3 at V_EB3, −21 mV |
| sf | −20 | 80.9 | 79.0 | +1.9 | 0.568 | 0.557 | M1b at V_REF, +50 mV |
| sf | 25 | 76.1 | 74.1 | +2.1 | 0.572 | 0.562 | M1b at V_REF, +62 mV |
| sf | 100 | 71.0 | 68.0 | +3.0 | 0.575 | 0.562 | MNB3 at V_EB3, −19 mV |
| fs | −20 | 77.2 | 75.0 | +2.2 | 0.568 | 0.563 | MNB3 at V_EB3, +135 mV |
| fs | 25 | 70.1 | 67.9 | +2.2 | 0.562 | 0.556 | MNB3 at V_EB3, +63 mV |
| fs | 100 | 61.4 | 55.6 | +5.8 | 0.554 | 0.533 | MNB3 at V_EB3, −57 mV |

**Over all 30 points (three thresholds, both supplies):** t_d 55.2–84.6 ns (spec ≤ 100 ns). r 0.532–0.581; spread at one temperature ±0.009 (−20 °C), ±0.011 (25 °C), ±0.024 (100 °C). t_d(V_EB3) − t_d(V_REF) +1.9 to +5.8 ns, largest change between 1.71 and 1.89 V at one corner and temperature 0.8 ns. Systematic Vos −0.20 to +0.11 mV.

**The two ends of the threshold range.**
- High end (V_REF, cold, 1.71 V, slow PMOS): at the flip `n1` must sit at VDPWR − V_SG(M3 at 5.54 µA) while the tail sits at V_REF − V_GS(M1b). At sf / −20 °C / 1.71 V that leaves M1b V_DS = 0.809 − 0.711 = 0.098 V, margin +50 mV (the spec's limit). At V_EB3 the tail is 0.39 V lower (margin +425 mV).
- Low end (V_EB3 at 100 °C, 0.5745 V): the tail falls to ≈ 0.2 V and MNB3 (`bgr`'s tail sink) is in triode at every corner (−17 to −57 mV), so the tail current drops and the V_EB3 delay grows. That is the rise of t_d(V_EB3) − t_d(V_REF) from +2.3 ns at 25 °C to +4.0 ns at 100 °C at tt (spec R13: +1.7 ns), and +5.8 ns at fs (+1.9 ns about the tt curve; R13 row: ≤ 1 ns), and the r spread at 100 °C.

**M3 at the spec's original 3/1** (sf, −20 °C, 1.71 V):

| M3 | Threshold | t_d (ns) | t_d half (ns) | r | `n1` at the flip | Tail at the flip | Margin M1a / M1b (mV) |
|---|---|---|---|---|---|---|---|
| 12/1 (adopted) | V_EB3 | 80.9 | 93.7 | 0.568 | 0.791 V | 0.323 V | +597 / +425 |
| 12/1 (adopted) | V_REF | 79.0 | 89.4 | 0.557 | 0.809 V | 0.711 V | +202 / +50 |
| 3/1 | V_EB3 | 80.5 | 95.4 | 0.548 | 0.580 V | 0.321 V | +595 / +215 |
| 3/1 | V_REF | 95.3 | 111.0 | 0.531 | 0.716 V | 0.699 V | +190 / −36 |

With M3 3/1, M3 needs more V_SG, `n1` has to fall into the tail, M1b leaves saturation at V_REF (−36 mV) and the V_REF delay grows by 16.3 ns: t_d(V_EB3) − t_d(V_REF) = −14.8 ns instead of +1.9 ns. M1a (drain on the diode node `nd`) stays saturated.

**In kelvin** (periods built from t0 at each corner, the two-slope extraction with the tt r(T) of V_REF = 0.5656 / 0.5644 / 0.5545, the one-point trim at 25 °C, and the tt curve the μ→T fit carries removed): the corner residual is ≈ ±0.24 K at 100 °C (ff +0.24, ss −0.22) and ≈ ±0.10 K at −20 °C. Without the extraction the delay costs −4.3 to −8.7 K.

**Against the spec rows.**

| Row | Limit | Result | |
|---|---|---|---|
| t_d | ≤ 100 ns | 55.2–84.6 ns | pass |
| r spread at one T (corners, VDD) | ≤ ±0.03 | ±0.009 / ±0.011 / ±0.024 at −20 / 25 / 100 °C | pass |
| Δt_d(EB3 − REF) supply dependence | none | ≤ 0.8 ns | pass |
| Δt_d drift −20…100 °C about the tt curve (tt: +1.7 ns from 25 to 100 °C) | ≤ 1 ns | ss +0.6, ff −0.3, sf −0.8 / −1.1, fs +1.9 / +1.7 ns (1.71 / 1.89 V) | **exception** |
| V_DS − V_dsat at the flip | ≥ 50 mV | M1b +50 mV (sf, −20 °C, 1.71 V, V_REF); MNB3 −17 to −57 mV (V_EB3 at 100 °C, all corners) | **exception** |
| Systematic Vos | ≤ 0.5 mV | −0.20 to +0.11 mV | pass |

**Documented exception (accepted).** At 100 °C the V_EB3 threshold (0.5745 V) leaves `bgr`'s tail sink MNB3 in triode at every corner. MNB3 belongs to the frozen and laid-out `bgr`, and lifting the tail from the comparator side would take a pair 4–6 times wider (weak inversion: ≈ 25 mV per doubling of W). The consequences are the fs / sf Δt_d drift beyond 1 ns and the wider r spread at 100 °C. Through the whole extraction (two-slope with the tt r(T), 25 °C trim, tt curve in the μ→T fit) the corners leave ≈ ±0.24 K at 100 °C and ≈ ±0.10 K at −20 °C, the size of the r-model (0.07 K) and Δt_d-drift (0.18 K) budget rows together. The total budget stays at ≈ ±1.32 / ±0.93 °C. Comparator sizes unchanged (set C).

## 4. Offset Monte Carlo

**Bench.** `tb_cmp_mc.sch`: one `cmp_tbcopy` on its own `cmp_tbbias`, corner `tt_mm`. Runner `mc4.py`: 200 chips (8 decks, seeds 101–108; `reset` = new mismatch draw per chip). Per chip at −20 / 25 / 100 °C, with the thresholds and the diode current of the frozen `bgr` at that temperature: DC trip across V_REF, then across V_EB3, on the same mismatch draw (`.dc` of `vcap`, ±5 mV, 20 µV steps; Vos = trip − threshold). At 25 °C also the operating point with `vcap` = `vthr` = V_REF: ΔVth of M1a − M1b and M2a − M2b, gm of M1b and M2b. A nominal `tt` deck gives the systematic part. Output `simulation/mc4/{summary.md, chips.csv}`.

| T (°C) | Threshold | Nominal Vos (mV) | MC mean (mV) | MC σ (mV) | max \|Vos\| (mV) |
|---|---|---|---|---|---|
| −20 | V_REF | −0.050 | −0.088 | 1.007 | 3.87 |
| −20 | V_EB3 | −0.030 | −0.070 | 1.012 | 3.87 |
| 25 | V_REF | −0.070 | −0.092 | 0.989 | 3.83 |
| 25 | V_EB3 | −0.045 | −0.070 | 0.996 | 3.83 |
| 100 | V_REF | −0.070 | −0.088 | 0.985 | 3.81 |
| 100 | V_EB3 | +0.010 | −0.018 | 1.002 | 3.79 |

σ(Vos) 0.985–1.012 mV against the ≤ 1 mV row: on the line (with N = 200 the σ estimate carries about ±10 % at 95 %). The budget rows already assume 1 mV: common Vos 0.24 K/mV → 0.24 K (1σ) before the trim; 0.060 K/mV at 100 °C after the 25 °C trim → 0.18 K (3σ). The common Vos moves 25 → 100 °C by +0.005 mV mean, σ 0.012 mV.

**Offset difference on the same chip**, ΔVos = Vos(V_EB3) − Vos(V_REF):

| T (°C) | Mean (mV) | σ (mV) |
|---|---|---|
| −20 | +0.018 | 0.015 |
| 25 | +0.022 | 0.018 |
| 100 | +0.069 | 0.030 |

Drift of ΔVos from 25 °C (the part the trim cannot remove; row 3σ ≤ 0.2 mV): to −20 °C mean −0.004 mV, 3σ 0.037 mV (0.020 K at 0.55 K/mV); to 100 °C mean +0.047 mV (systematic, carried by the μ→T fit), 3σ 0.053 mV (0.029 K). Pass with a factor of 4–5. The larger spread at 100 °C follows section 3: at V_EB3 the tail sink MNB3 is in triode there, so the tail current and the pair's operating point differ more between the two thresholds.

**Where the offset comes from** (25 °C, V_REF):
- σ(ΔVth) of the pair M1a − M1b 0.749 mV (W L = 105 µm²; ≈ 5.4 mV·µm per device), of the load M2a − M2b 1.420 mV (W L = 128 µm²; Pelgrom with the spec's 10.89 mV·µm per `pfet_01v8_lvt`: 15.4 / √128 = 1.36 mV).
- Fit over the 200 chips: Vos = 0.999 · (−ΔVth_M1) + 0.411 · ΔVth_M2, residual σ 0.035 mV. gm(M2b) / gm(M1b) at the operating point: 0.468.
- Hand RSS: √(0.749² + (0.468 · 1.420)²) = 1.00 mV against the MC σ 0.989 mV.

## 5. Reset switch and pedestal

**Device.** MRST = `nfet_01v8` W 6 L 0.5 × 2 (12/0.5 in two fingers), drain on `vcap`, source and body on VGND, gate `rst`.

**Bench.** `tb_rsw.sch`: four copies of MRST. MRON (gate VDPWR, drain forced to 10 mV) → R_on. MOFF (gate 0, drain 1.3 V) → leakage. MPED on C_osc = 5.06 pF, gate falling VDPWR → 0 in t_f, no charging current → the pedestal 40 ns after the edge. MCOV on 5.06 pF, gate stepping 0.25 V → 0 (no channel) → the overlap capacitance. Runner `rsw5.py`: tt, ss, ff, sf, fs × −20 / 25 / 100 / 125 °C × 1.71 / 1.80 / 1.89 V with t_f = 2 ns, and a t_f sweep at tt, 25 °C, 1.80 V. Output `simulation/rsw5/{grid.csv, edge.csv, summary.md}`.

| Row | Limit | Result | |
|---|---|---|---|
| R_on (guaranteed −20…100 °C, 1.71–1.89 V) | ≤ 280 Ω at ss, 100 °C, 1.71 V | 178 Ω tt 25 °C; worst 256 Ω (ss, 100 °C, 1.71 V); 7 R_on C = 9.08 ns | pass |
| Leakage at 125 °C (drain 1.3 V) | ≤ 1 nA | ≤ 0.463 nA (sf, 1.71 V) | pass |
| Pedestal | ≤ 1 mV | −4.75 to −6.02 mV at a 2 ns gate fall | **fails as written** |

**Device numbers** (tt, 25 °C): V_th 0.629 V; C_gg (on, V_DS = 0) 45.0 fF; C_ov (gate–drain overlap, from the 0.25 V sub-threshold step) 3.93 fF = 0.33 fF/µm. A 0.5 V step reads 6.4 fF: it already catches weak-inversion charge.

**Pedestal against the gate fall time** (tt, 25 °C, 1.80 V):

| t_f (ns) | 0.05 | 0.1 | 0.2 | 0.5 | 1 | 2 | 5 | 10 | 20 | 50 | 100 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| pedestal (mV) | −6.59 | −6.55 | −6.47 | −6.24 | −5.89 | −5.30 | −4.16 | −3.24 | −2.52 | −1.90 | −1.58 |

**Hand.**
- Overlap: 3.93 fF × 1.8 V / 5.06 pF = 1.40 mV (full gate swing). With a slow edge only the swing after the switch has opened couples (≈ V_th): 3.93 fF × 0.63 V / 5.06 pF ≈ 0.5 mV, which a slow edge cannot remove.
- Channel charge: (C_gg − 2 C_ov) × (1.8 V − V_th) = 37.1 fF × 1.17 V = 43.5 fC; half on C_osc → 4.3 mV.
- Fast edge, sum: 4.3 + 1.4 = 5.7 mV against −6.6 mV simulated at 0.05 ns.

Even a 100 ns fall, ten times the whole reset pulse, leaves −1.6 mV; the pulse is ≈ 10 ns, so the edge can only be a few ns and the pedestal sits near −4 to −5 mV.

**Spread** (2 ns edge): at one temperature the corners and the three supplies stay within ±0.25 mV (−20 °C), ±0.31 mV (25 °C), ±0.35 mV (100 °C), ±0.36 mV (125 °C) of tt. The tt value moves −5.02 / −5.30 / −5.69 / −5.80 mV at −20 / 25 / 100 / 125 °C and ≈ −2.8 mV per V of supply. Both trends are systematic and common to the two thresholds.

**Pedestal row reworded (spec §12e R19).** The systematic pedestal goes into the μ→T fit; the row now binds its spread about the tt value at one temperature (corners, 1.71–1.89 V): ≤ ±1 mV. Measured ±0.25–0.36 mV at a 2 ns fall, ≈ 0.02 K at 100 °C after the trim (0.060 K/mV). The 2 ns edge here is an ideal source; the real fall time comes from the one-shot's last driver (section 6).

## 6. Self-timed one-shot

**Cells.** `dly5.sch/.sym`: five inverters, `nfet_01v8` 0.42/2.3 + `pfet_01v8` 1/2.3, `y` = NOT `a` delayed. `oneshot.sch/.sym` (pins `cmp_raw osc_en osc_enb vcap rst VDPWR VGND`): `buf_2` on `cmp_raw` → `ck`; `dfrtp_1` with D = VDPWR, CLK = `ck`, RESET_B = `rb`, Q = `rst`; `dly5` from `rst` to `db`; `and2_1` `rb` = `db` · `osc_en`; `or2_1` `swp` = `rst` + `osc_enb`; `inv_1` → `swn`; last driver MDP `pfet_01v8` 2/0.15 and MDN `nfet_01v8` 0.42/1.5 → `sw`; MRST `nfet_01v8` 6/0.5 × 2 from `vcap` to VGND.

**Bench.** `tb_reset.sch`: two `oneshot` copies, each on its own 5.06 pF. `osc_en` rises at 50 ns; 100 µA for 62.6 ns charges `vcap` to ≈ 1.23 V; `cmp_raw` rises at 400 ns, 5 ns wide (copy 1) or 40 ns wide (copy 2). Runner `reset6.py`: tt, ss, ff, sf, fs × −20 / 25 / 100 °C × 1.71 / 1.80 / 1.89 V; R_on per point from `simulation/rsw5/grid.csv`. Output `simulation/reset6/{all.csv, summary.md}`. Widths at VDD/2; `sw` fall 90 → 10 %.

| | tt, 25 °C, 1.80 V | All 45 points |
|---|---|---|
| `rst` width, `cmp_raw` 5 ns / 40 ns | 11.21 / 11.21 ns | 8.38 (ff, −20 °C, 1.89 V) – 15.42 ns (ss, 100 °C, 1.71 V); the two widths differ by ≤ 0.006 ns |
| `sw` high (switch on) | 12.64 ns | 9.35–17.76 ns |
| `sw` fall time | 2.10 ns | 1.43–3.48 ns |
| t_logic (`cmp_raw` → `sw`, both at VDD/2) | 0.66 ns | 0.53–0.91 ns |
| `sw` high / (R_on · C) | 14.0 | ≥ 10.8 (ff, 100 °C, 1.89 V); 13.6 at the worst R_on (ss, 100 °C, 1.71 V); limit 7 |
| Pedestal with the real edge | −5.00 mV | −4.43 to −5.56 mV; about tt at one temperature ±0.5 mV (row ±1 mV) |
| `rst` again after the pulse (retrigger) | none | none |

- The `rst` width does not depend on the `cmp_raw` width: the flop takes only the rising edge, and the delay line ends the pulse.
- The delay line tracks the switch: where R_on is largest (ss, 100 °C, 1.71 V: 256 Ω) the switch stays on longest (17.8 ns), so the ratio never falls below 10.8. Over the full grid the `rst` width spans 8.4–15.4 ns, wider than the 10–12.5 ns of the five-point dry run; the ratio is the requirement and it holds.
- The tt pedestal moves −4.92 / −5.00 / −5.13 mV at −20 / 25 / 100 °C, the same as with the 2 ns ideal edge of section 5.
- Dead time per period at tt: t_d (71.8 ns) + t_logic (0.66 ns) + switch on (12.64 ns) ≈ 85 ns, against the 81 ns estimate (t_d + 11.5 ns); the two-slope extraction measures it per chip.

## 7. Threshold mux

**Cell.** `thrmux.sch/.sym` (pins `vref veb3 thr_sel thr_selb vthr VDPWR VGND`): two transmission gates, `nfet_01v8_lvt` 2/0.5 + `pfet_01v8_lvt` 4/0.5, from `vref` and from `veb3` to `vthr`. `thr_sel` = 0 puts `vref` on `vthr`, 1 puts `veb3`. Gate drive: cross-coupled `nor2_1` pair (`xn1` → `sref`, `xn2` → `seb`, each output into the other's input), so one enable rises only after the other has fallen; `inv_1` `xi1`, `xi2` give `srefb`, `sebb` for the PMOS gates.

**Bench.** `tb_thrmux.sch`: (A) a standard TG (`nfet_01v8` 2/0.5 + `pfet_01v8` 4/0.5, the sizes frozen in `bgr`) and an lvt TG, both fully on, 10 mV across, common mode swept 0.5–1.3 V → R_on; (B) an lvt TG off between the V_REF and V_EB3 levels → leakage; (C) `thrmux` with `vref` = V_REF behind 204 kΩ and a 2 pF decap, `veb3` = V_EB3 behind 9.2 kΩ, 0.5 pF on `vthr`; `thr_sel` rises at 1 µs and falls at 3 µs. Runner `mux7.py`: tt, ss, ff, sf, fs × −20 / 25 / 100 °C × 1.71 / 1.80 / 1.89 V, V_REF / V_EB3 = the frozen `bgr` values at T. Output `simulation/mux7/{all.csv, summary.md, ron_tt_25_1.8.txt, ron_ss_-20_1.71.txt}`.

| Row | Limit | Result | |
|---|---|---|---|
| lvt TG R_on, 0.5–1.3 V | ≤ 10 kΩ at ss, −20 °C, 1.71 V | 3.22 kΩ max at tt, 25 °C, 1.80 V (at 1.10 V); worst 6.10 kΩ at 0.98 V (ss, −20 °C, 1.71 V); ≤ 6.05 kΩ at 0.96 V | pass |
| lvt TG off-leakage | ≤ 0.1 nA at 100 °C | ≤ 0.005 nA (all 45 points) | pass |
| Break-before-make | no overlap | 50 % gaps ≥ 0 ps to V_EB3 (0 ps at ff, 100 °C, 1.89 V), ≥ +60 ps back to V_REF; charge through the closing TG at the 0 ps point 0.07 fC | pass |
| `vthr` settling to 0.1 mV | inside the 8-period discard (≥ 36 µs) | to V_EB3 48–58 ns; to V_REF 3.54–3.76 µs | pass |

**Standard TG, for comparison.** Worst R_on 1216 kΩ at 1.02 V (ss, −20 °C, 1.71 V); at 0.96 V (V_REF′) up to 451 kΩ, above 100 kΩ at 6 of 45 points; tt, 25 °C, 1.80 V peaks at 86 kΩ at 1.06 V. Every point exceeds 10 kΩ somewhere in 0.5–1.3 V. The nfet conducts below ≈ VDD − V_thn, the pfet above ≈ |V_thp|; with V_thn ≈ 0.85 V (body effect included) and |V_thp| ≈ 1.0 V the two windows leave a gap near 0.95–1.0 V, widest cold, slow and at low supply. V_REF′ (0.89–1.00 V) sits in it. The lvt thresholds (≈ 0.55 / 0.52 V) close the gap.

**Notes.**
- The 0 ps gap is a 50 % crossing tie, not a short: each device turns on from its own source voltage (V_EB3 for the nfet, V_REF for the pfet), not from VDD/2, so the closing and opening devices do not conduct together.
- Back to V_REF, `vthr` (0.5 pF at V_EB3) shares charge with the 2 pF decap: `vref` dips 91–138 mV and recovers through 204 kΩ (τ ≈ 0.5 µs), hence the 3.5–3.8 µs. The REF TG's own channel charge lifts `vref` by +2.2 mV as it opens. Both settle inside the discard.
- The same standard TG sizes are frozen in `bgr` on `ich` (`XS_ichon_n/p`) and on `i3` (`XS_i3on_n/p`). Both pass a current from a PMOS source, not a voltage: the source pushes its current through any R_on, and the source-side node (`ichb`, `i3b`) rises until the pfet conducts. `i3on` is on only while `vref` sits at V_REF (1.24 V, outside the gap). `ichon` crosses the gap with the REF ramp; that lifts `ichb` (≈ 30 fF), ≤ 1e-4 of T_REF (spec §12e R4), checked again on the extracted `bgr` in `tb_osc`.

## 8. `osc_core` on stand-in sources

**Cell.** `osc_core.sch/.sym` (pins `vref veb3 thr_sel thr_selb osc_en osc_enb ib_cmp1 ib_cmp2` | `vcap cmp_raw rst VDPWR VGND`): C_osc (ideal 5.06 pF here; the MIM array replaces it on the frozen `bgr`), `thrmux` (`xmux`), `cmp2s` (`xcmp`), `oneshot` (`xos`). `vcap` is the C_osc top plate, the reset drain and the comparator's `vcap` input; `ich` from `bgr` lands on it.

**Bench.** `tb_osc_si.sch`: `vref` = V_REF behind 204 kΩ with 2 pF, `veb3` = V_EB3 behind 9.2 kΩ, ideal I_ch into `vcap`, MNB3 / MNB4 (4/8 × 4, 40 fF each) on their own 4/8 diode fed I_PTAT/2. `osc_en` at 2 µs; 12.5 REF periods, then `thr_sel` → EB for 14.5 periods. Runner `osc8.py`: tt, 1.80 V, −20 / 25 / 100 °C, full slope (I_ch = I_PTAT/2) and half slope (I_PTAT/4), frozen V_REF, V_EB3, I_PTAT at T. T_REF = mean of the last 6 REF periods, T_EB = mean of EB periods 9–12. In one REF and one EB period: `vcap` crosses `vthr` (t_c), `cmp_raw` rises, the reset gate `sw` rises and falls → t_d, t_logic, switch-on time, τ = `sw` fall − t_c; `vthr` at t_c; `vcap` minimum after release. Output `simulation/osc8/{summary.md, all.json}`.

| T (°C) | slope | T_REF (µs) | C·V_REF/I | extra (ns) | T_EB (µs) | C·V_EB3/I | extra (ns) | μ | μ0 = 1 − V_EB3/V_REF |
|---|---|---|---|---|---|---|---|---|---|
| −20 | full | 5.5728 | 5.2365 | 336.2 | 3.5947 | 3.3250 | 269.7 | 0.35495 | 0.36504 |
| −20 | half | 11.0607 | 10.4730 | 587.7 | 7.1106 | 6.6500 | 460.6 | 0.35713 | 0.36504 |
| 25 | full | 4.8430 | 4.5403 | 302.8 | 2.8273 | 2.5915 | 235.8 | 0.41622 | 0.42923 |
| 25 | half | 9.6057 | 9.0805 | 525.1 | 5.5792 | 5.1829 | 396.3 | 0.41917 | 0.42923 |
| 100 | full | 4.0392 | 3.7735 | 265.8 | 1.9397 | 1.7425 | 197.2 | 0.51978 | 0.53821 |
| 100 | half | 8.0034 | 7.5469 | 456.5 | 3.8084 | 3.4851 | 323.4 | 0.52415 | 0.53821 |

f_REF = 179.4 / 206.5 / 247.6 kHz at −20 / 25 / 100 °C (spec R12/R16: 179 / 206 / 246).

**Dead time in the loop** (full slope, REF / EB): t_d 80.3 / 82.3, 74.2 / 76.1, 65.3 / 69.2 ns; t_logic 0.4–0.6 ns; switch on 11.5 / 12.6 / 14.2 ns; τ 92.3 / 94.4, 87.4 / 89.2, 79.9 / 83.8 ns at −20 / 25 / 100 °C. Half slope: τ(REF) 103.6 / 97.6 / 87.4 ns. τ(EB) − τ(REF) = +1.8 to +3.9 ns (full), +4.1 to +7.7 ns (half).

**Where the rest goes** (25 °C, full slope; the other points follow the same pattern). Extra = T − C_osc·V/I − τ: 215.4 ns at REF, 146.6 ns at EB. Three parts:
- **The threshold moves.** `vthr` at the crossing sits +3.49 mV above V_REF and +0.46 mV above V_EB3 (12.7 / 1.7 ns of ramp). The only thing on `vthr` besides the mux is M1a's gate: as `vcap` reaches `vthr` the pair's tail rises and couples charge onto `vthr`, which the 204 kΩ (9.2 kΩ) source drains slowly (quickly). Range +3.2 to +4.0 mV at REF, full slope; +2.3 to +2.9 mV at half slope.
- **Extra capacitance on `vcap`, proportional to the threshold.** Split on the threshold `vcap` actually meets: C_lin = 149–155 fF (2.9–3.1 % of C_osc) at every point: the M1b gate, the MRST drain and wiring. 134 ns at REF, 76 ns at EB.
- **A fixed charge.** Q0 = 90–100 fC, the same at both thresholds: 68.5 ns, equal to a common offset V_o = 17.4–19.2 mV. About 20 fC of it is the pedestal (`vcap` minimum −3.3 to −4.2 mV after release); the other ≈ 75 fC (≈ 14.5 mV) is the fixed part of the comparator's input gate charge (spec R15 hand: 63 fC, 12.5 mV).

**Effect on μ** (25 °C, full): μ is 3.03 % under μ0. C_lin cancels (it scales both periods like C_osc). τ gives −1.86 % (ε = τ·I/(C·V)); the fixed offset gives −1.46 %; the `vthr` shift widens V_REF − V_EB3 by 3.0 mV. Over the six points μ sits 2.2–3.4 % under μ0.

**Two-slope extraction** (spec M6 step 2; r_loop = τ_half/(2 τ_full) at V_REF, measured in the loop):

| T (°C) | r_loop | τ measured (REF, full) | t_d + 11.5 ns | τ extracted | τ extracted, `vthr` shift removed | μ0 extracted | μ0 | μ0 ext / μ0 − 1 | −V_o/(V + V_o) |
|---|---|---|---|---|---|---|---|---|---|
| −20 | 0.561 | 92.3 | 91.8 | 77.6 | 87.4 | 0.35996 | 0.36504 | −1.39 % | −1.38 % |
| 25 | 0.559 | 87.4 | 85.7 | 77.2 | 83.1 | 0.42296 | 0.42923 | −1.46 % | −1.44 % |
| 100 | 0.547 | 79.9 | 76.8 | 74.4 | 77.2 | 0.52953 | 0.53821 | −1.61 % | −1.49 % |

- The fixed offset is untouched by the extraction (like a static Vos it has r = 1): μ0 extracted = ΔV/(V_REF + V_o) to within 0.02 % at −20 and 25 °C, 0.12 % at 100 °C. It is the same on every chip to first order, so the μ→T fit carries it; its spread belongs to the "Comparator Vos + V_res" row.
- **The extracted τ misses the check (within 3 ns of t_d + 11.5 ns) by 5–15 ns.** The `vthr` shift depends on the slope (3.49 mV full, 2.55 mV half at 25 °C), so part of it reads as delay; removing it by hand brings τ_ext to within 3–5 ns. With the ramp-bench r = 0.565 instead of r_loop: τ_ext 77.5–78.3 ns, μ0 within 0.0004.
- After `thr_sel` the first EB period is short (−760 to −1880 ppm, the period cut by the switch); from the second period on, EB periods sit within ±40 ppm of the settled value. The 8-period discard covers it.
- **Check reworded (spec §12e R20).** The extracted τ is a model parameter (firmware uses it only through the same formula), so the check is on μ0: extracted μ0 within 0.15 % of ΔV/(V_REF + V_o), met at all three temperatures (0.02 / 0.02 / 0.12 %); τ is logged. The `vthr` shift at the crossing is measured again on the frozen `bgr` (section 9).

## 9. The loop on the frozen `bgr`

**Cell change.** C_osc in `osc_core` is now the MIM array: `XCosc` = `cap_mim_m3_1` W 25 L 25 MF 4 (5.06 pF), top plate on `vcap`, bottom plate on VGND. Section 8 ran with an ideal 5.06 pF.

**Bench.** `tb_osc.sch`: frozen `bgr` (x1) + `osc_core` (x2). `bgr` in state A: `ich_sel` 0 (`ich_on` = VDPWR), `i3_sel` 0 (`i3_on` = VDPWR), chop A (`swa` = VDPWR, `chop` = 0, `chopb` = VDPWR); `iptat_mon` held at 0.7 V. 2 pF decap on `vref` (the tile's V_REF decoupling), 40 fF wire on `ib_cmp1` and `ib_cmp2`. Supply 0 → VDD in 1 µs, `osc_en` at 120 µs, 12.5 REF periods, `thr_sel` → EB for 14.5 periods. Runner `osc9.py`: tt 1.80 V at −20 / 25 / 100 °C, ss −20 °C 1.71 V, fs 100 °C 1.71 V; adds 30 fF from `ichb` to VGND inside `bgr` (spec R4). "Rest" = mean over the 20 µs before `osc_en`; "running" = mean over the REF phase after 3 periods (V_EB3: over EB periods 9–13); ripple = peak-to-peak over the last REF period. Differences formed inside ngspice (≈ 1 µV resolution). Output `simulation/osc9/{summary.md, all.json}`.

**Does the oscillator disturb the bandgap?**

| Point | V_REF rest (V) | V_REF running − rest | V_REF ripple p-p | V_EB3 in EB − rest | `nb` rest (V) | `nb` running − rest | `nb` ripple p-p | I_DD rest / running (µA) |
|---|---|---|---|---|---|---|---|---|
| tt −20 °C 1.80 V | 1.23914 | −14 µV | 16.1 mV | −70 µV | 0.6909 | −0.036 mV | 42.1 mV | 26.3 / 26.4 |
| tt 25 °C 1.80 V | 1.24324 | −20 µV | 16.7 mV | −72 µV | 0.6809 | −0.048 mV | 46.7 mV | 30.5 / 30.6 |
| tt 100 °C 1.80 V | 1.24413 | −30 µV | 18.0 mV | −57 µV | 0.6686 | −0.076 mV | 54.5 mV | 36.7 / 36.9 |
| ss −20 °C 1.71 V | 1.23956 | −10 µV | 15.7 mV | −65 µV | 0.7079 | −0.030 mV | 41.7 mV | 26.5 / 26.6 |
| fs 100 °C 1.71 V | 1.24436 | −29 µV | 17.1 mV | −45 µV | 0.6965 | −0.075 mV | 52.5 mV | 36.8 / 37.0 |

- **V_REF moves −10 to −30 µV when the oscillator starts (check: < 50 µV): pass.**
- `ib_cmp2` is MNB4's drain; its rail-to-rail swing at each decision and reset couples through MNB4's gate–drain capacitance onto `nb`, which kicks 42–55 mV peak-to-peak once per period. `nb` also biases MNB1 (the diode), MNB2 (the op-amp's MREF), MNB3 (the comparator tail) and MSU3 (the startup sense). The kick is brief and nearly symmetric: the mean of `nb` moves less than 0.08 mV.
- The `vref` node itself ripples 16–18 mV peak-to-peak per REF period (the comparator input charge through the mux, and the reset). V_EB3 sits 45–72 µV lower while the EB phase runs (≈ 5e-5 in μ, ≈ 0.04 K, the same every conversion).
- The oscillator adds 0.1–0.2 µA to the supply current.

**The loop.**

| Point | T_REF (µs) | f_REF (kHz) | spec ± 5 % | T_EB (µs) | μ | μ_DC = 1 − V_EB3/V_REF | μ / μ_DC − 1 |
|---|---|---|---|---|---|---|---|
| tt −20 °C 1.80 V | 5.6075 | 178.3 | 179 (−0.4 %) | 3.5926 | 0.35934 | 0.36504 | −1.56 % |
| tt 25 °C 1.80 V | 4.8855 | 204.7 | 206 (−0.6 %) | 2.8322 | 0.42028 | 0.42923 | −2.09 % |
| tt 100 °C 1.80 V | 4.0880 | 244.6 | 246 (−0.6 %) | 1.9485 | 0.52336 | 0.53821 | −2.76 % |
| ss −20 °C 1.71 V | 5.5780 | 179.3 | 179 (+0.2 %) | 3.5773 | 0.35869 | 0.36480 | −1.68 % |
| fs 100 °C 1.71 V | 4.0829 | 244.9 | 246 (−0.4 %) | 1.9456 | 0.52348 | 0.53781 | −2.66 % |

- **f_REF within 0.6 % of the spec at every point: pass.**
- μ sits 1.6–2.8 % under μ_DC (stand-in, section 8: 2.8 / 3.0 / 3.4 %). Against the stand-in at 25 °C, T_REF is 0.88 % longer and T_EB 0.17 % longer: P4's finite output resistance lowers I_ch as `vcap` rises, which slows the REF ramp more than the EB ramp and gives back ≈ 0.9 % of μ. It is the same on every chip to first order (the μ→T fit carries it).

**Dead time** (REF / EB): τ 92.9 / 94.6, 87.9 / 89.5, 80.6 / 84.3 ns (tt −20 / 25 / 100 °C), 100.7 / 102.7 ns (ss −20 °C 1.71 V), 73.0 / 78.7 ns (fs 100 °C 1.71 V); t_d 57.2–87.2 ns, switch on 11.5–15.4 ns. `vcap` minimum after release −2.8 to −4.0 mV.

**The `vthr` shift on the real `vref` (spec R20).** At the crossing `vthr` sits +3.07 / +3.33 / +3.79 mV above the running V_REF (tt −20 / 25 / 100 °C), +3.13 mV (ss), +3.56 mV (fs); at V_EB3 +0.46 to +0.57 mV. `vthr` − `vref` at that instant is only +0.08 to +0.12 mV: the shift lives on the `vref` node itself, as on the stand-in. Stand-in (section 8): +3.22 / +3.49 / +3.96 mV and +0.40 to +0.52 mV. **The shift does not grow on the frozen `bgr`; no `vthr` decap.**

**Settling.** REF periods within ±45 ppm of each other. After `thr_sel` the first EB period is cut short (−320 to −1850 ppm), the second is within +260 ppm, and from the third on within ±40 ppm: the 8-period discard covers it.
- **`ib_cmp2` wire (spec §12e R21).** The direct hookup stays; the `ib_cmp2` route is shielded with VGND and kept away from `nb`, `vpg`, `vref`, `ibias` and `su` in layout. The extracted run re-checks the V_REF move.

## 10. The control toggles, through `swdrv`

**Cell.** `swdrv.sch/.sym` (pins `ich_sel i3_sel chop_sel` | `ich_on ich_onb ich_dump i3_on i3_onb i3_dump swa swb chop chopb VDPWR VGND`). `ich_sel` and `i3_sel`: `inv_1` + cross-coupled `nor2_1` pair (`on` / `dump`, break before make) + `inv_1` for the TG's PMOS gate (`onb`). `chop_sel`: `inv_1`; `nor2_1` pair → `swa` / `swb` (op-amp input switches, break before make); `nand2_1` pair → `chop` / `chopb` (op-amp chop switches, make before break). Nets joined by label.

**10a. Gaps and overlaps.** `tb_swdrv.sch`: all three selects from one source through `buf_1` (0 → VDD at 5 ns, back at 25 ns), 50 fF on every output. Runner `sw10.py`: tt, ss, ff, sf, fs × −20 / 25 / 100 °C × 1.71 / 1.80 / 1.89 V. Output `simulation/sw10/{all.csv, summary.md}`. All at VDD/2:

| Quantity | Must be | Min (ns) | at | Max (ns) |
|---|---|---|---|---|
| `on` fall → `dump` rise (`ich`, `i3`) | > 0 | 0.703 | fs 100 °C 1.89 V | 1.431 |
| `onb` rise (TG fully off) → `dump` rise | > 0 | 0.273 | ff 100 °C 1.89 V | 0.703 |
| `dump` fall → `on` rise | > 0 | 0.720 | fs 100 °C 1.89 V | 1.467 |
| `dump` fall → `onb` fall (TG starts to open) | > 0 | 1.090 | ff 100 °C 1.89 V | 2.244 |
| `swa` fall → `swb` rise, and back | > 0 | 0.699 | fs 100 °C 1.89 V | 1.425 |
| `chop` / `chopb` overlap, both directions | > 0 | 0.356 | ff −20 °C 1.89 V | 0.668 |
| select edge → last output (`dump` rise) | – | 0.962 | ff 100 °C 1.89 V | 1.803 |

Every gap and overlap has the right sign at all 45 points.

**10b. The toggles on the frozen `bgr`.** `tb_osc_tog.sch`: `bgr` + `osc_core` + `swdrv`; `ich_sel`, `i3_sel`, `chop_sel`, `thr_sel` are pwl sources; 2 pF decap on `vref`, 40 fF on each comparator sink, 30 fF on `ichb` (R4). Runner `tog10.py`: tt, 25 °C, 1.80 V, `osc_en` at 120 µs, then 16 steps of 13.5 periods, one control changed per step:
`i3_sel` 0: A full REF → A full EB → B full EB → B full REF → B half REF → B half EB → A half EB → A half REF; `i3_sel` 1: A half REF → A half EB → B half EB → B half REF → B full REF → B full EB → A full EB → A full REF.
The run writes `rst`, `vref`, `veb3` and `vpg` to a binary raw file; the 220 `rst` edges come from it by linear interpolation at VDD/2 (`.meas` keeps 7 digits, 0.1 ns at 1 ms). Periods after each change are compared with the mean of periods 9–12. Output `simulation/tog10/{summary.md, all.json, tog.raw}`.

**Settling after each change** (first complete period after the change, ppm against settled; node = period-mean deviation in period 1):

| Change | Steps | Period 1 | Back within 10 ppm by period | What moves |
|---|---|---|---|---|
| `chop_sel` | 3, 7, 11, 15 | +635, +314, +22, +1880 ppm | 4, 3, –, 3 | the bandgap loop: `vpg` +69 / +34 / – / +212 µV (mirror currents drop), `vref` −589 / −285 / – / −529 µV |
| `thr_sel` REF → EB | 2, 6, 10, 14 | −1422, −1706, +8, +73 ppm | 3, 2, –, 2 | `veb3` −512 / −361 µV as the mux hands it the comparator input; `vref` −176 → −31 → −2 µV when the comparator leaves it |
| `thr_sel` EB → REF | 4, 8, 12, 16 | −4, −15, +3, −53 ppm | –, 1, 1, 2 | `vref` +7 / 0 / +2 / −16 µV |
| `ich_sel` | 5, 13 | −7, +1 ppm | 1, 3 | `vref` +25 / +4 µV |
| `i3_sel` | 9 | 0 ppm | 1 | nothing left by the first full period: `vref` moves 1.243 → 0.961 V with τ ≈ 0.4 µs (≈ 204 kΩ × 2 pF), inside the cut period |

- Every transient is gone by period 4; the 8-period discard covers it. **μ settled to 1e-5 by period 9 after each change: pass**, with the floor below.
- **Floor (recorded):** in six steps (1, 4, 6, 7, 8, 10; `i3_sel` 0 mostly) the periods carry a ±10–40 ppm period-to-period wobble that does not decay. It is the same at edge thresholds 0.5 / 0.9 / 1.3 V, so it is not the edge interpolation; the solver steps at the edges differ there (74–92 ps) while the clean steps repeat (73 ps). Its 4-period mean moves ≤ 17.5 ppm, ≤ 1.0e-5 in μ. Origin open (solver step pattern or a period-to-period interaction with the bandgap loop); re-checked with a tighter tolerance in the freeze run.

**μ per state and χ:**

| `i3_sel` | chop | μ full | μ half |
|---|---|---|---|
| 0 | A / B | 0.420279 / 0.420271 | 0.422867 / 0.422874 |
| 1 | A / B | 0.272665 / 0.272665 | 0.274808 / 0.274811 |

Two-slope μ0 (r = 0.565, section 2): 0.426278 / 0.426305 (A / B), chop average 0.426291 (μ_DC 0.42923); μ0′ 0.277642 / 0.277650, average 0.277646 (μ_DC′ 0.27984). Chop difference −0.003 mV equivalent (no mismatch in a nominal run). χ = 10(1 − μ0)/μ0 − 5(1 − μ0′)/μ0′ − 1/3 = **0.1163 against χ_nom 0.0970 (`pvt8/i3_table.csv`, tt 1.80 V 25 °C): +0.0192, inside the 0.02 limit with 4 % margin.** With r = 0.559: 0.1164.
- χ cancels a common offset (ΔV′ = ρΔV): the 0.69 % / 0.78 % shortfalls of μ0 and μ0′ alone would move χ by +0.160 and −0.142. What is left (+0.019) comes from terms that are not a common offset: P4's output resistance (a V-dependent ramp current) and the `vthr` shift at V_REF (R20). They are the same on every chip to first order; the trim comparison (spec §4 step 14) uses the chip's own trim value, which carries them.
- **Follow-up (spec §12e R22).** The 16-step run is repeated at −20 and 100 °C with the tables (section 11): χ in the loop beside χ_nom at three temperatures, and one wobbling step at a tighter solver tolerance.

## 11. Tables, noise, resolution, χ in the loop

**11a. `tadd_table.csv` and `rcoef_table.csv`.** Runner `tables11.py`: `tb_cmp_corners` with the frozen `bgr` values at each point (`docs/mu_dc.csv`; V_REF′ and V_EB3′ from `pvt8/i3_table.csv`), t_logic and t_rst from the section 6 bench; tt, ss, ff, sf, fs × −40 / −20 / 25 / 100 / 125 °C × 1.71 / 1.80 / 1.89 V = 75 points per threshold (REF, EB, REF′), each at s and s/2; r from the true delay (t0 with Vos from the DC trip, R18). Output `simulation/tables11/` and `docs/` (`tadd_table.csv` 450 rows, `rcoef_table.csv` 225 rows).

| Threshold | r(T) line, least squares over all 75 points | line vs per-T mean, max | spread about the per-T mean, max | tt 1.80 V vs line, max |
|---|---|---|---|---|
| REF | 0.56027 − 0.1277e-3 · T[°C] | 0.0037 (25 °C) | ±0.0187 (125 °C) | +0.0064 |
| EB | 0.56858 − 0.0400e-3 · T[°C] | 0.0012 | ±0.0150 (125 °C) | +0.0039 |
| REF′ | 0.56376 − 0.1370e-3 · T[°C] | 0.0036 | ±0.0194 (125 °C) | +0.0059 |

- **Line residual ≤ 0.01: pass** (≤ 0.0037 against the per-T centre). **Spread ≤ ±0.03 at each T: pass** (REF ±0.0062–0.0076 at −40…25 °C, ±0.0159 at 100 °C, ±0.0187 at 125 °C). The largest |r − line| over all 75 points, 0.0227 (REF), is the two together. tt r 0.545–0.565 (band 0.58 ± 0.04).
- Hand cost of the spread (Appendix A, R12 scaling with t_add ≈ 81 ns: 3.3 K per unit δk at 100 °C): REF ±0.0159 at 100 °C → δk ≈ 0.078 → ≈ 0.22 K after the trim; ±0.0062 at −20 °C → ≈ 0.04 K. Inside the r-model row the totals already carry (≈ 0.25 / 0.06 K for the dry run's ±0.018 / ±0.009).
- t_add at full slope, REF, min / max over corners and VDD: 83.1 / 97.2 ns at −20 °C, 78.0 / 93.0 at 25, 68.9 / 87.6 at 100 (tt 89.7 / 85.1 / 78.7 ns: ≤ 90 ns nominal over −20…100 °C; tt 92.1 ns at −40 °C).

**11b. Comparator noise at the trip point.** `tb_cmp_noise.sch`: a copy of `cmp2s` with its input held at the trip point (found by a 1 µV `.dc` step), `.noise` at `n1`, 200 points per decade. Runner `noise11.py`, tt 1.80 V. Output `simulation/noise11/{summary.md, all.json}`. σ_cross = v_n(0.1–1000 MHz) / s.

| T (°C) | threshold | A0 at `n1` | `n1` −3 dB (MHz) | e_n 1 kHz / 100 kHz (nV/√Hz) | v_n 0.1–1000 MHz (µV) | v_n 1–100 kHz (µV) | σ_cross full / half slope (ns) |
|---|---|---|---|---|---|---|---|
| −20 | REF | 77.2 | 3.12 | 39.9 / 25.9 | 57.1 | 8.3 | 0.241 / 0.483 |
| −20 | EB | 85.4 | 3.01 | 39.8 / 25.7 | 55.2 | 8.2 | 0.233 / 0.466 |
| 25 | REF | 80.3 | 3.16 | 42.4 / 28.3 | 73.4 | 9.1 | 0.268 / 0.536 |
| 25 | EB | 88.3 | 2.93 | 42.4 / 28.0 | 65.9 | 9.0 | 0.240 / 0.481 |
| 100 | REF | 77.4 | 3.05 | 47.3 / 32.6 | 130.4 | 10.4 | 0.395 / 0.791 |
| 100 | EB | 83.9 | 2.72 | 47.9 / 32.7 | 73.8 | 10.4 | 0.224 / 0.448 |

- **Crossing jitter ≤ 0.54 ns: pass**, 0.22–0.27 ns at five points and 0.395 ns at 100 °C REF. At that point the static trip point sits on a gain peak at `n1` (520 at 2.2 MHz, ≈ 200 at 25 °C), which a moving ramp passes through rather than sits on; the density × noise-bandwidth estimate gives 0.22–0.24 ns at all six points. 0.395 ns is carried as the worst case.
- Half slope doubles σ_cross; the half-slope phases are twice as long, and 11c counts them that way.
- The 1–100 kHz band (8–10 µV, ≈ 0.03 ns at full slope) does not average down with M and goes into the floor in 11c.

**11c. Resolution vs M.** `res_vs_m.py`: f_cnt 75 MHz; quantization 1/√6 count rms per period pair; jitter = σ_cross from 11b with P4's thermal noise (0.37 ns per REF ramp, hand, scaled by √(ramp time)); floor = 0.015 K (mirror and op-amp 1/f, hand) with the comparator's 1–100 kHz band → 0.0154 K. tt 25 °C periods. Output `simulation/res11/{summary.md, res_vs_tconv.png}`.

| M | fast t_conv (ms) | quantization (K) | jitter (K) | floor (K) | fast total (K) | full t_conv (ms) | full total (K) |
|---|---|---|---|---|---|---|---|
| 16 | 0.19 | 0.0558 | 0.0161 | 0.0154 | 0.0601 | 1.11 | 0.0758 |
| 64 | 0.56 | 0.0139 | 0.0081 | 0.0154 | 0.0223 | 3.33 | 0.0273 |
| 128 | 1.05 | 0.0070 | 0.0057 | 0.0154 | 0.0178 | 6.30 | 0.0205 |
| 256 | 2.04 | 0.0035 | 0.0040 | 0.0154 | 0.0163 | 12.22 | 0.0176 |
| 1024 | 7.96 | 0.0009 | 0.0020 | 0.0154 | 0.0155 | 47.79 | 0.0158 |

- **Resolution ≤ 0.03 K at M = 256: pass**, 0.0163 K fast (2.04 ms), 0.0176 K full (12.2 ms); with the 100 °C REF jitter (0.395 ns) 0.0166 / 0.0185 K. The floor is the largest term from M ≈ 128 up; beyond M = 256 each doubling of the time buys ≤ 0.001 K.
- Hand estimate from the spec budgets (0.5 ns per crossing, 0.015 K floor, section 9 periods): N_REF 93,811, N_EB 54,374, one count 0.0074 K, quantization 0.0035 K, jitter 0.0051 K, total 0.0162 K, floor largest.

**11d. The period wobble (section 10b floor).** `wob11.py`: state A, full slope, REF, tt 25 °C 1.80 V, 17 periods, default tolerances against `.option reltol=1e-4`. Output `simulation/wob11/`.

| Tolerance | time points | period-to-period step, rms | 4-period means, spread | mean period |
|---|---|---|---|---|
| default | 1,150,037 | 33.7 ppm | 16.4 ppm | 4.885528 µs |
| reltol = 1e-4 | 1,152,529 | 0.5 ppm | 0.8 ppm | 4.885757 µs (+46.8 ppm) |

- **The wobble is the solver, not the circuit**: it drops 70× at the tighter tolerance with the same number of time points. In μ: ≈ 1e-5 at default tolerances (16.4 ppm × T_EB/T_REF), ≈ 5e-7 at reltol = 1e-4.
- The +46.8 ppm shift of the mean period is mostly common to both thresholds: μ0 from the reltol = 1e-4 runs of 11e agrees with the default-tolerance runs of 10b and 11e to ≤ 1.5e-5 (≈ 0.01 K).
- Rule from here on: freeze-grade loop runs use `.option reltol=1e-4` (no runtime cost).

**11e. χ in the loop at three temperatures.** `tog10.py` at −20 and 100 °C, the same 16 steps as 10b. Output `simulation/tog10_-20/`, `simulation/tog10_100/`.

| T (°C) | μ0 chop | μ0′ chop | χ | χ_nom (`i3_table.csv`, tt 1.80 V) | χ − χ_nom |
|---|---|---|---|---|---|
| −20 | 0.363559 | 0.226057 | 0.0542 | 0.1265 | **−0.0723** |
| 25 | 0.426291 | 0.277646 | 0.1163 | 0.0970 | +0.0192 |
| 100 | 0.532536 | 0.374146 | 0.0810 | 0.0647 | +0.0163 |

**Why −20 °C is different.** Runner `chi11.py`: one control state per run (−20 / 25 / 100 °C × `i3_sel` × slope × threshold, chop A, reltol = 1e-4, 0 V source in series with `bgr`'s `vcap` pin to read I_ch), each period split into ramp, comparator delay, logic and reset. Output `simulation/chi11*/`.
- Node voltages, comparator delays, I_ch at low `vcap` and the charge per ramp are the same in both `i3_sel` modes. What differs is the full-slope ramp current near the top: I_full / (2·I_half) dips from ≈ 0.9 V, by −11.7 ‰ at 1.00 V at −20 °C (−8.4 ‰ at 25 °C), and recovers above 1.05 V. This is spec R4: in full slope `ichb` lifts above `vcap` while the frozen std `ich` TG crosses its dead zone; in half slope P4b is dumped and the gate is out of the path.
- V_REF ≈ 1.24 V: the ramp passes through the dip and trips at the normal slope. V_REF′ = 1.000 / 0.961 / 0.889 V at −20 / 25 / 100 °C: at −20 °C the ramp trips at the bottom of the dip. The error sits in the full-slope period only, which the two-slope formula reads as delay and multiplies by k ≈ 1.3 instead of removing.

| `chi11.py` variant (chop A) | χ − χ_nom, −20 °C | 25 °C | 100 °C | μ0, −20 / 25 / 100 °C |
|---|---|---|---|---|
| frozen `bgr`, tt 1.80 V | −0.0717 | +0.0201 | +0.0176 | 0.363566 / 0.426293 / 0.532554 |
| `ich` TG → lvt (diagnostic) | +0.0267 | +0.0250 | – | 0.363160 / 0.425799 / – |
| `ich` TG → ideal 500 Ω switch (diagnostic) | +0.0168 | +0.0164 | +0.0102 | 0.363928 / 0.426632 / 0.532960 |
| frozen `bgr`, ss 1.71 V (R4 check point) | −0.1136 | – | – | 0.363129 / – / – |

- With an ideal switch the two-slope χ stays at +0.010…+0.017 at all three temperatures: the −20 °C miss is the gate. At the slow corner it grows to −0.114.
- **Cost on the main reading** (frozen against ideal switch): μ0 −3.62e-4 / −3.39e-4 / −4.06e-4 at −20 / 25 / 100 °C = −0.251 / −0.235 / −0.281 K (at 1.443e-3 per K). R4's hand bound (≤ 1e-4 of T_REF) understated the size. The one-point trim takes the common part; what changes with temperature is ≤ 0.046 K over −20…100 °C (−0.016 K at −20 °C and −0.046 K at 100 °C after a 25 °C trim), and it is the same on every chip to first order, so the simulated μ→T curve of the frozen design carries it.
- **Half-slope-only check (firmware option, no circuit change).** τ_h = k·(1/μ_full − 1/μ_half)·(T_REF − T_EB)_half from the normal-mode phases of the same conversion; 1/μ0′ = 1/μ′_half − τ_h / (T′_REF − T′_EB)_half; four `i3_sel` = 1 phases (chop × threshold, half slope) instead of eight. χ − χ_nom: +0.0325 / +0.0214 / +0.0069 at −20 / 25 / 100 °C (toggle runs, chop average); chop A, frozen +0.0071 at 100 °C, with the ideal switch +0.0316 / +0.0215 / +0.0070 (the gate is out of this path); chop A at ss 1.71 V −20 °C +0.0330. Smooth in T and the same at the slow corner.
- **Decision (spec §12e R23):** firmware uses the half-slope-only check and compares χ with χ_loop(T̂) = χ_nom(T̂) + Δ_half(T̂) from `docs/chi_loop_table.csv` (tt rows from the toggle runs, chop average; the ss row is chop A only), and with the chip's trim value at the same T̂ bin. Four check phases: ≈ 6.8 ms with discards, a full conversion with the check ≈ 19 ms. No circuit change.

## 12. Freeze

**12a. Netlists and consistency.** `osc_core.sch` and `swdrv.sch` exported with xschem in batch mode, PDK environment loaded, to `simulation/osc_core.spice` and `simulation/swdrv.spice`: every device model resolved, exact device names (`sky130_fd_pr__*`, `sky130_fd_sc_hd__*`, `sky130_fd_pr__cap_mim_m3_1`).
- The cell bodies inside the loop decks (`tb_osc.spice`, `tb_osc_tog.spice`: `osc_core`, `thrmux`, `cmp2s`, `oneshot`, `dly5`, `swdrv`) are identical to the export, line for line.
- The `bgr` body and its sub-cells (`bg_core`, `ota2s`, `bg_mirror`, `bg_rrow`, `bg_pnp`, `bg_su`) in the loop decks are identical to the frozen M5 netlist; every hash in `freeze_m5.txt` still matches.
- `swdrv` pin directions tidied for the freeze: the 10 outputs were drawn with `iopin` while `swdrv.sym` marks them `out` (xschem printed an "Unmatched … pin direction" error per pin, plus "open net: VDPWR / VGND"). They are now `opin`; the re-exported netlist differs only in the 10 `*.opin` comment lines, and netlisting prints no warnings. The standard cells take their supplies through attributes; every cell is on VDPWR and VGND.

**12b. P4's ramp error on the frozen `bgr` (δμ_ramp).** Runner `lam12.py`: the M5 bench `tb_bg_pvt.spice` (frozen `bgr`) with the `ich` pin on a swept source, `.dc` 0 → 1.30 V in 10 mV steps, `ich_sel` 0 (full slope) and 1 (half); tt, ss, ff, sf, fs × −20 / 25 / 100 °C × 1.71 / 1.80 / 1.89 V; V_REF and V_EB3 per point from `docs/mu_dc.csv`. With t(V) = ∫₀^V dv / I(v), μ = 1 − t(V_EB3)/t(V_REF) against μ0 = 1 − V_EB3/V_REF; the two-slope value uses r = 0.565. DC only (no comparator, delay or reset). Output `simulation/lam12/{all.csv, summary.md}` and the I(V) curves per point (`<corner>_<VDD>_<T>/{full,half}.txt`).

| Corner | VDD (V) | ramp error after the two-slope extraction, −20 / 25 / 100 °C (1e-3 in μ) | left after the 25 °C trim and the tt curve, −20 / 100 °C (K) |
|---|---|---|---|
| tt | 1.71 | +3.69 / +3.54 / +3.03 | -0.055 / +0.036 |
| tt | 1.80 | +3.80 / +3.58 / +3.01 | +0.000 / +0.000 |
| tt | 1.89 | +3.88 / +3.59 / +3.00 | +0.045 / -0.017 |
| ss | 1.71 | +3.58 / +3.48 / +3.00 | -0.082 / +0.062 |
| ss | 1.80 | +3.72 / +3.53 / +2.99 | -0.025 / +0.016 |
| ss | 1.89 | +3.82 / +3.56 / +2.98 | +0.026 / -0.008 |
| ff | 1.71 | +3.79 / +3.60 / +3.06 | -0.028 / +0.015 |
| ff | 1.80 | +3.88 / +3.62 / +3.04 | +0.024 / -0.012 |
| ff | 1.89 | +3.94 / +3.62 / +3.02 | +0.061 / -0.024 |
| sf | 1.71 | +3.64 / +3.51 / +3.01 | -0.067 / +0.046 |
| sf | 1.80 | +3.76 / +3.55 / +3.00 | -0.009 / +0.005 |
| sf | 1.89 | +3.86 / +3.57 / +2.99 | +0.041 / -0.015 |
| fs | 1.71 | +3.70 / +3.57 / +3.05 | -0.067 / +0.027 |
| fs | 1.80 | +4.00 / +3.60 / +3.03 | +0.125 / -0.005 (sweep not clean, excluded) |
| fs | 1.89 | +3.91 / +3.61 / +3.02 | +0.051 / -0.019 |

- **Systematic part.** At tt 1.80 V the ramp error is +3.80 / +3.58 / +3.01e-3: it falls by 0.79e-3 from −20 to 100 °C (−0.55 K), because P4's λ_eff falls from ≈ 0.028 to ≈ 0.020 V⁻¹ as T rises (half slope alone: +4.00 → +3.04e-3; I(1.25 V)/I(0.25 V) − 1 = −2.4 % at 25 °C). The hand model (spec Appendix A, "nearly constant") assumed a constant λ. Full slope also carries the R4 gate's DC dip (full +4.15 vs half +4.00e-3 at −20 °C). This part is the same on every chip to first order: the μ→T fit carries the tt curve, and M8's model integrates I_ch(v, T) from these curves.
- **What is left after the 25 °C trim and the tt curve:** −0.082…+0.061 K at −20 °C and −0.024…+0.062 K at 100 °C over 5 corners × 1.71–1.89 V (−1.2…+0.9e-4 and −0.4…+0.9e-4 in μ), set more by VDD than by corner. Against ≤ 1.5e-4 (0.1 K): inside.
- **fs, 1.80 V, −20 °C** does not give a clean DC sweep: the current steps up and down by ≈ 0.3 % along the sweep in both slope states and in both sweep directions (the other 44 points are monotonic, except that fs 1.71 V, −20 °C rises by 0.5 % above 1.19 V at full slope, where the gate PMOS takes over: the R4 dip recovering). Its neighbours at 1.71 and 1.89 V bracket it; it is left out of the ranges above (with its value, −20 °C would read +0.125 K).
- **Against the loop runs** (section 11e, tt): half slope within 0.1e-3 of this DC value (+4.08 / +3.73 / +3.13e-3 in the loop); full slope 0.25–0.44e-3 above it, the dynamic part of the R4 dip, carried the same way.
- A first pass switched the slope state with `alter` after the full sweep; at fs, −20 °C the half sweep then started from a wrong operating point. The runner now uses one deck per slope state (each `.dc` starts from its own operating point with the nodesets); the three fs −20 °C points and tt 1.80 V −20 °C were re-run that way (tt reproduced to every printed digit), and the other 41 points, all monotonic, keep their first-pass curves.

**12c. Freeze record.** `docs/freeze_m6.txt`: PDK and simulator versions, the `osc_core` and `swdrv` pin lists, and SHA-256 of the six cells (`.sch` and `.sym`), the two exported netlists, the two bench helper cells, 12 benches, 16 runners, and the files handed to M8 (`tadd_table.csv`, `rcoef_table.csv`, `chi_loop_table.csv`, `simulation/lam12/all.csv` with the P4 I(V) curves beside it). 50 hashes; they verify with `sha256sum -c`, and every hash in `freeze_m5.txt` still verifies.
- Spec changes made during M6: §12e R12–R24 (R18, R19 and R20 as documented exceptions or reworded rows; R23 the half-slope χ check; R24 the δμ_ramp row). The M6 done-when list in the spec is ticked or annotated; three items move to M7: the run on the extracted `bgr` (tile PEX), the `osc_out` toggle (`readout_glue`), and the digital logic with the 18 tie-offs.
- **M6 is frozen.**

## 13. Layout: C_osc, the V_REF decap, `cmp2s`, the threshold mux and the one-shot

*Cells in `mag/`; each `*_arr` cell is scripted (`gen_*.tcl`), its parent cell holds the routing. Checks: Magic DRC (`drc.sh`), KLayout `sky130A_mr.drc` with FEOL, BEOL and offgrid, LVS (`lvs.sh`).*

**Floor plan of the left band** (tile x 7–89 µm, between the left VGND stripe and the middle VDPWR stripe): the digital cells along the top under the pins (`readout_glue` with the 18 ties, then `ring3`, then `swdrv` at the height of bgr's `chop`/`chopb` pins), the threshold mux and the V_REF decap below them, then `cmp2s` (mirrored, so `cmp_raw` leaves at its left end), the one-shot under it, and C_osc at the bottom right. The one-shot (27.7 µm) and C_osc (55.3 µm) do not fit side by side in the 82 µm band, so the one-shot sits above C_osc's left part, its `vcap` pin and the reset switch over C_osc's `vcap` bus. The analog nets from bgr (`vref`, `veb3`, `ib_cmp1`, `ib_cmp2`) leave bg_core's left edge and run along the strip under ota2s (tile y 0–11.7 µm, empty on met1–met3); `ib_cmp2` in its own shielded lane, ≥ 2 µm from `vref` (spec R21). The control lines to bgr's switch pins cross ota2s on met4 (they only change between conversions).
- `vcap` cannot stay short at both ends: P4's drain is bgr's `ich` pin at tile (224, 118) µm. The route goes down the channel between ota2s and bg_core on met4 and along the bottom strip on met3, ≈ 270 µm, ≈ 40–55 fF (hand). Wire capacitance is linear, so it cancels in μ. The comparator and the reset switch sit at C_osc.

**13a. `osc_cosc` (C_osc).** 4 × `cap_mim_m3_1` W = L = 25 µm (the same unit cell as Cc), 2 × 2 at a pitch of 27.16 × 26.0 µm on one met3 sheet 54.32 × 51.4 µm. Bottom plates (met3) = VGND, top plates (met4) = `vcap` (spec B15). The top plates are joined by a met4 bridge between the rows in each column and a riser per column to a met4 bus above the array, where the comparator sits; the units' own met4 strips on their right edges are VGND, so the plates cannot be joined sideways. Pins: `vcap` (met4, the bus's left end), VGND (met3 tab on the right).
- Magic DRC 0, KLayout 0, LVS 4 → 1 device, 2 nets.
- Extraction (`cthresh 0`): the met3 sheet has 36.6 fF to the substrate, the `vcap` side 12.1 fF (the bus and risers; a bare unit's top side has 2.6 fF). With the plates the other way round, `vcap` would carry the sheet's 37 fF to the substrate and the substrate noise of the digital cells with it.
- Magic adds the met4–met3 overlap capacitance (84 aF/µm²) over the MIM area as well: 55.2 fF per unit, 230 fF between `vcap` and VGND for the cell, on top of the device model. The MIM top plate sits between met4 and the bottom plate and is the same net as met4, so this part is likely counted twice. It has to be settled before the extracted C(`vcap`) is compared with the 5.06–5.3 pF row; the same applies to Cc.

**13b. `vref_decap` (2 pF on V_REF).** 2 × `cap_mim_m3_1` W = L = 22.17 µm: 2.00 fF/µm² × 22.17² + 0.19 fF/µm × 4 × 22.17 = 999.9 fF each at tt, 2.000 pF in total, the value every M6 bench used. Two units because a MIM side is limited to 30 µm (one square would need 31.6 µm). 1 × 2 on a met3 sheet 48.66 × 22.57 µm (VGND), risers to a met4 bus under the array. Pins: `vref` (met4, the bus's left end), VGND (met3 tab). Magic DRC 0, KLayout 0, LVS 2 → 1 device against `lvs_cells/vref_decap.spice`; the tile-level schematic takes the same device line (`XCdec vref VGND sky130_fd_pr__cap_mim_m3_1 W=22.17 L=22.17 MF=2`).

**13c. `cmp2s`.** 70.3 × 24.0 µm.
- Input pair: one row of 12 `nfet_01v8_lvt` fingers (W 10, L 1.75) in the order A B B A A B B A A B B A (A = M1a, gate `vthr`; B = M1b, gate `vcap`). Both devices have their centroid on the row centre, and each has one finger at a row end. The `vthr` gates are strapped above the row and the `vcap` gates below it, so the two inputs sit on opposite sides of the pair; the `vcap` strap faces C_osc.
- Load: one row of 16 `pfet_01v8_lvt` fingers (W 4, L 4) above the pair, in the same order (A = M2a, B = M2b); all 16 gates on one strap, which the nd bus joins to nd (the diode).
- M3 (3 fingers), the skewed inverter (MIP W 0.42 L 1 over MIN W 2 L 0.15) and `inv_1` on the right. `inv_1`'s n-well is merged with MIP's and tapped by MIP's ring; a VGND met1 rail runs under the cell.
- Pins: `vthr`, `vcap`, `ib_cmp1`, `ib_cmp2`, VDPWR (met2), `cmp_raw`, VGND (met1).
- Magic DRC 0; KLayout 0 (892 mcon, 276 via1, 32 via2 cuts). LVS against the frozen `cmp2s`: "Circuits match uniquely", 8 devices (12 → 2 `nfet_01v8_lvt`, 19 → 3 `pfet_01v8_lvt`, MIP, MIN, `inv_1`), 10 nets, 0 property errors.

**13d. `lvs.sh`.** It now takes the schematic from the first frozen netlist that has the cell (`bgr.spice`, then `osc_core.spice`) and includes the `sky130_fd_sc_hd` SPICE library when that netlist uses hd cells. Every cell checked before still matches (`ota2s_pair`, `ota2s`, `bg_core`, `bgr`).

**13e. `thrmux`.** 13.1 × 16.3 µm, scripted complete (`gen_thrmux.tcl`).
- One standard-cell row: tap, the cross-coupled `nor2_1` pair, two `inv_1`, with 0.92 µm gaps for the pin wiring. Above it the four lvt switches, gates contacted from below and driven straight up from their cell outputs. The cell inputs go down to two met3 lines under the row that close the cross-coupling.
- Outputs `vthr`, `vref`, `veb3` on met3 lines above the switches, pins at the left edge; `thr_sel`, `thr_selb` met2 at the bottom; VDPWR, VGND on the rails.
- Magic DRC 0; KLayout 0 (108 mcon, 26 via1, 14 via2 cuts). LVS against the frozen `thrmux`: "Circuits match uniquely", 8 devices, 11 nets, 0 property errors.
- **Break-before-make** (`xschem/simulation/tb_thrmux_bbm.spice`; tt, 25 °C, `thr_selb` from an `inv_1`, `vref` 1.254 V behind 204 kΩ with 2 pF, `veb3` 0.710 V behind 9.2 kΩ, 0.5 pF on `vthr`). On `thr_sel` 0 → 1 the gates cross 0.9 V in the order `sref` +51 ps, `srefb` +161 ps, `seb` +195 ps, `sebb` +252 ps after `thr_sel`: both `vref` switches open before either `veb3` switch closes.
  - Charge that flows from `vref` to `veb3` while both paths conduct: 0.001 fC (peak 0.08 µA). A plain transmission-gate mux with the same switches, driven straight from `thr_sel`/`thr_selb`: 1.2 fC (peak 21.5 µA), i.e. 0.6 mV on the 2 pF decap.
  - The EB → REF switch draws 231 fC from the decap in either mux (`vthr`'s 0.5 pF charge-sharing with it): `vref` dips by 110 mV and recovers with τ = 0.41 µs, inside the 8-period discard. The REF → EB switch moves `vref` by < 1 mV.

**13f. `oneshot` and `dly5`.** 27.7 × 12.0 µm, scripted complete (`gen_oneshot.tcl` builds both cells).
- `dly5` (19.2 × 5.5 µm, its own cell as in the netlist): five columns at a 3.73 µm pitch, each a `pfet_01v8` W 1 L 2.3 above an `nfet_01v8` W 0.42 L 2.3 with one met1 gate link; neighbouring guard rings share their sides. The chain runs right to left (input `a` at the right, output `y` at the left). VGND and VDPWR met1 buses along the bottom and top tie the rings.
- Standard-cell row above `dly5`: tap, `and2_1`, `buf_2`, `dfrtp_1`, `or2_1`, `inv_1`, tap. `ck`, the flop's D tie and `swp` are li1 bridges between abutting cells; Q → `or2_1`.A is a met1 bar. `rb`, `rst` → `dly5`.a and `swn` run on met2 tracks between the row and `dly5`.
- Reset driver at the right: MDN under MDP (gates linked in met1, `sw` on a met2 column), then MRST (2 fingers W 6 L 0.5). Its middle strip is `vcap` (a via1 column, met2 out to the right edge); the outer strips go straight down to the VGND bus, which continues to the right edge so that the reset current loop (≈ 5 mA at the worst-case R_on, hand) can close on C_osc's VGND sheet in the assembly.
- Pins: `cmp_raw`, `osc_en`, `osc_enb`, `rst` met2 on the top edge; `vcap` met2 on the right edge; VDPWR, VGND met1 at the left. Only li1–met2 inside, so met3 and met4 are free over the cell.
- Magic DRC 0 (both cells); KLayout 0 (269 mcon, 35 via1 cuts). LVS against the frozen netlist: `dly5` 10 devices, 8 nets; `oneshot` 9 devices (MRST 2 → 1, MDN, MDP, five hd cells, `dly5`), 13 nets; "Circuits match uniquely", 0 property errors.

**13g. `osc_core`.** 82 × 110 µm (frame = tile − (7, 12) µm; `mk_osc_core.tcl` places the cells, `osc_core.mag` holds the routing). C_osc at (26.6, 0.5), the one-shot at (4.9, 55.0), `cmp2s` mirrored at (72.155, 69.4), `thrmux` at (3.0, 97.5).
- `vcap`: the one-shot's `vcap` pin and the `cmp2s` `vcap` strap each go up a 2 × 2 via stack to met4 and down onto C_osc's met4 bus. The reset current takes only the one-shot's link: ≈ 2 Ω (via2 and via3, 2 × 2 cuts each, plus 6 squares of met4; hand). The `cmp2s` link feeds a gate only.
- `cmp_raw`: 13 µm of met3 from the one-shot's input up over the comparator's inverter end to its output. `vthr`: ≈ 60 µm of met3, out of the mux's `vthr` line at its right end, down between the mux and the decap, along y 93 above the comparator and down onto its `vthr` pin. On that last stretch it crosses the load tracks, `n1` among them: ≈ 0.05 fF, so `n1`'s ≈ 1 V swing at the decision puts ≈ 0.02 mV on `vthr` with the decap behind it (hand), against the 4.5 mV kickback the decap is sized for.
- VDPWR: the comparator's M3 supply bus (met3) continues down to the one-shot's VPWR rail and, on met4, up to the mux's VPWR rail. VGND: the one-shot's VGND bus drops onto C_osc's VGND sheet beside MRST, so the reset current loop (top plate → MRST → bottom plate) closes within a few µm instead of through the shared ground; a met1 column at x 0–0.8 joins the VGND rails of the one-shot, the comparator and the mux, for the left VGND stripe. That return adds ≈ 2 Ω (hand); with the one-shot's own wiring the reset path gains ≈ 6 Ω against the 24 Ω between the 256 Ω worst-case R_on and its 280 Ω limit.
- Pins (frozen order): `vref`, `veb3` (met3, the mux's left edge), `thr_sel`, `thr_selb` (met2, the mux's bottom), `osc_en`, `osc_enb`, `rst` (met2, the one-shot's top edge), `ib_cmp1`, `ib_cmp2` (met2, on `cmp2s`), `vcap` (met4, the right end of C_osc's bus), `cmp_raw` (met3), VDPWR (met2, the right end of the comparator's supply track), VGND (met1 column).
- Magic DRC 0; KLayout 0. LVS against the frozen `osc_core`: "Circuits match uniquely", 4 devices (`thrmux`, `cmp2s`, `oneshot`, the MIM 4 → 1), 14 nets, 0 property errors.
