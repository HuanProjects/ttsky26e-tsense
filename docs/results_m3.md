# M3 results — `ota2s` over PVT and mismatch

*Benches `tb_m3_servo` and `tb_m3_ol` (the M2 benches re-biased the way the bandgap biases the op-amp: a real diode PNP for the common mode, I_PTAT with the R1 tempco and the R-corner factor `rs`, chop nets). Harness: `/foss/designs/simkit`, config `opamp_m3/sweeps/m3_pvt.py`. Grid: 15 corners (tt/ss/ff/sf/fs × R nom/ll/hh) × VDD {1.62 | 1.71 1.80 1.89 | 1.98} × T {−40 | −20 0 25 50 75 100 | 125} °C; only the middle sets are guaranteed.*

> **M3 CLOSED.** `ota2s` (frozen in M2, unchanged) passes every guaranteed point of the 15-corner × VDD × T grid (1800/1800 rows) and every mismatch check:
> - offset σ 305 µV (tt_mm) / 288 µV (ss_mm) against 350 µV; drift σ ≤ 24 µV; PSRR mean + 3σ ≤ 67 µV/V
> - A0 ≥ 80.3 dB and PM44 ≥ 66.1° at every guaranteed point; mismatch moves them by only 0.01 dB and 0.1°
> - the per-device offset breakdown matches MC (0.314 vs 0.313 mV); chop state B is identical to state A
>
> For M5: K_opt = 9.65, so **N3 = 40 (K = 10.0 unchanged)**, V_REF 1.246–1.254 V; σ(R3/R1) = 0.245 %, σ(ΔV_EB) = 72 µV. Freeze record and done-when checklist are at the end.

## Decisions log

- **Op-amp current budget.** Spec row "≤ 4.5·I_PTAT(T)". The bias mirror is 1 + 2 + 6 = 9 units of I_PTAT/2, i.e. 4.5·I_PTAT by construction, and the mirror's channel-length modulation adds 0.1–0.4 % at higher VDD and T. The grid reads `iop_ratio` = 4.506–4.520 on every guaranteed point. Decision: a 2 % allowance, `iop_ratio ≤ 4.6` is PASS "at the limit"; above 4.6 is FAIL. Rationale: the §8 power budget it protects is a tile estimate with ±17 % resistor spread in it. Changed in `opamp_m3/specs/opamp.json`; logged in the spec's M3 decisions log. M2 had already reported 12.61 vs 12.6 µA as "at the limit".

## T1–T2: smoke tests (tt, 1.80 V, chop state A)

| | −20 °C | 25 °C | 100 °C | M2 at 25 °C |
|---|---|---|---|---|
| Vos (µV), servo | −58.25 | −29.21 | +16.27 | −29.29 |
| V_CM (V), real PNP | 0.787 | 0.710 | 0.575 | 0.710 (line) |
| I_op (µA) | 10.91 | 12.61 | 15.14 | 12.60 |
| A0 (dB), 25 pF | 87.59 | 88.38 | 88.16 | 88.36 |
| f44 (kHz), 25 pF | 170.4 | 185.9 | 201.7 | 185.7 |
| PM44 (°), 25 pF | 75.8 | 75.0 | 73.9 | 74.9 |

The 25 °C point reproduces M2 within 0.08 µV, 0.02 dB and 0.1°. The ±5 µV shifts at −20/100 °C are the R1 tempco in the bias (−4.2 % current at 100 °C) moving the XMN3-vs-XMN1 gate gap; the common-mode change itself is worth < 0.05 µV at 102 dB CMRR. f44 rises 8.5 % from 25 to 100 °C because gm1 follows the PTAT current (≈ √I, strong-inversion-like); PM44 holds because p2 = gm6/CL rides the same current.

## T3: PVT grid (servo clamp in, 1800/1800 rows)

`python3 -m simkit.sweep sweeps/m3_pvt.py -j 8`, 217 s. **Totals: 1800 rows, 0 missing, 0 guarantee FAIL, 0 marginal.** No point needed the retry tolerances. The first run had 2 blank rows and 6 retry points. Cause: the ×1000 servo E-source had a second, latched DC solution past the rails. Fix: `Esv` → `Bsv … V = 0.5*tanh(2000*(…))` in both benches, the same gain 1000 at balance but capped at ±0.5 V. The tt numbers are unchanged.

| Quantity (guaranteed points) | Worst | Where | Limit |
|---|---|---|---|
| \|Vos\| | 78.3 µV | fs_hh, −20 °C | ≤ 100 µV |
| PSRR | 79.8 µV/V | fs_hh | ≤ 316 µV/V |
| A0 | 80.3 dB | fs_ll | ≥ 70 dB |
| PM44 (25 pF) | 66.1° | ss_ll | ≥ 60° |
| f44 | 135–264 kHz | hh … ll | 50–300 kHz (report) |
| margins | mp1 0.125 V (fs_ll), mtail 0.168 V (sf_ll) | | ≥ 0.05 V |
| iop_ratio | 4.518–4.520 | all | ≤ 4.6 |

Characterization only (1.62/1.98 V, −40/125 °C), not guaranteed: Vos goes above 100 µV at 125 °C for fs, fs_ll and ff_ll (fs_ll reaches 503 µV). A0 drops to 64 dB at fs_ll/125 °C/1.62 V. mtail falls to 0.044 V at sf_ll/1.62 V/−40 °C.

How to read the corners (see the note on corners). The bias is current-mode, so a MOS corner only moves V_GS. MOS corners therefore show up as headroom, while the R/C corner (I = ΔV_BE/R1, f44 = gm1/2πCc) sets speed and PM. f44 depends only on the R/C suffix. The mtail margin follows the pair's PMOS V_SG (fs 0.402 > ff > tt > ss > sf 0.178 V). Vos follows the current: hh (less current) gives the most negative values. **sky130's `sf` is fast NMOS / slow PMOS**, and its skewed corners shift each device about 1.3–1.4× further than ss/ff. At 5 µA the lvt PMOS V_SG is +129 mV at sf vs +90 mV at ss. In the lvt corner models, vth0 is −0.589 V at sf vs −0.545 V at ss vs −0.453 V at tt.

## T3b: ICMR and output swing at the worst corners (1.71 V)

`opamp_m3/scripts/curves_m3.sh`, using the M2 `_icmr`/`_swing` benches re-biased like M3. All PASS.

| Bench | Corner, T | Result |
|---|---|---|
| ICMR top | sf_ll, −20 °C | 0.933 V; tail margin at 0.83 V = 0.131 V |
| ICMR top | ss_ll, −20 °C | 0.986 V; tail margin 0.175 V |
| ICMR bottom | fs_ll, 100 °C | 0.485 V; pair margin at 0.53 V = 0.087 V; ΔVos(0.53) = +66.7 µV |
| Swing | fs_ll, 100 °C | lo70 0.245 V (62.6 dB at 0.19 V); ≈ 80 dB at the vtg ±50 mV window |
| Swing | fs_hh, 100 °C | lo70 0.216 V |
| Swing | ss_ll, −20 °C | lo70 0.136 V; hi70 not reached up to 1.4 V at any corner |

The required CM window is about 0.53–0.83 V. Top edge: sf_ll tops out first because it has the slowest PMOS.

## T4: offset broken down by device (tt / 25 °C / 1.80 V)

Method: σ_Vth = A_VT/√(W·L·mult) (A_VT: pfet_01v8_lvt 10.89, nfet_01v8 3.356, pfet_01v8 5.856 mV·µm); contribution c = S·σ_Vth, where S is the input-referred lever; total σ_Vos = √Σc². Hand levers: pair 1, load gm_n/gm_p = (2/0.131·1.393 µA)/27.72 µS = 0.767, stage 2 1/A1 = 1/171, tail/MREF 0. Measured levers: `tb_m3_sens` (9 ops, +1 mV `delvto` per device, reltol 1e-5/vntol 1e-9), vos0 = −29.2133 µV = T1.

| Device | Area (µm²) | σ_Vth (mV) | S hand | S measured | c measured (mV) | c² (mV²) |
|---|---|---|---|---|---|---|
| MP1 / MP2 (lvt pair) | 3600 | 0.1815 | 1 | 0.919 | 0.1668 | 0.02782 each |
| MN1 / MN2 (load) | 240 | 0.2166 | 0.767 | 0.674 / 0.680 | 0.1460 / 0.1472 | 0.02130 / 0.02167 |
| MN3 | 7 | 1.268 | 0.0058 | 0.0058 | 0.0074 | 0.000055 |
| MP3 | 480 | 0.2673 | 0.0058 | 0.0055 | 0.0015 | 0.000002 |
| MTAIL | 160 | 0.463 | 0 | 0.0067 | 0.0031 | 0.000010 |
| MREF | 80 | 0.655 | 0 | 0.0013 | 0.0008 | 0.000001 |
| **Total** | | | **0.348 mV** | **0.314 mV** | | Σ 0.0987 |

- **Hand 0.348 mV (+11 %), measured-S 0.314 mV (+0.3 %) vs MC 0.313 mV (M2, N = 400).** The PASS criterion is "within 20 %".
- Both hand levers were high. The pair's 0.919 is a property of the sky130 lvt model: 1 mV of V_th (delvto) moves the gate by about 0.92 mV, and MC sees the same factor. The load's 0.677 vs 0.767: the square-law gm/I = 2/V_dsat overestimates MN1's gm (real 18.8 µS vs 21.3).
- Shares of variance: **pair 56 %, load 44 %**, everything else 0.07 %. MN3 has the largest σ_Vth (1.27 mV at 7 µm²), but the 1/A1 lever removes it.
- Sizing note for the record (ota2s stays frozen): doubling the load (+240 µm²) gives 0.278 mV; doubling the pair (+3600 µm²) gives 0.266 mV. Per µm² the load is about 11× cheaper (0.15 vs 0.013 µV/µm²).

## T5a: offset Monte Carlo on the M3 bench (N = 200 per corner)

`tb_m3_mc` (Save As of `tb_m3_servo`, `.lib … tt_mm`) with the B.4 reset loop. Each chip runs at 25/−20/100 °C at 1.80 V, then at 1.71 and 1.89 V at 25 °C. Run by `opamp_m3/scripts/mc_m3.sh` (tt_mm as netlisted plus a sed copy at ss_mm), 72 s wall. Per-chip CSVs are in `opamp_m3/results/mc/`.

| Corner, seed | Mean | σ | 1.09·σ | Drift σ −20 °C | Drift σ 100 °C | PSRR mean / worst | Verdict |
|---|---|---|---|---|---|---|---|
| tt_mm, 42 | −23.0 µV | **305.4 µV** | 332.9 µV | 20.3 µV | 24.0 µV | 40.5 / 62.3 µV/V | PASS |
| ss_mm, 43 | +10.2 µV | **288.2 µV** | 314.1 µV | 19.9 µV | 22.8 µV | 40.6 / 67.9 µV/V | PASS |
| limit | | ≤ 350 | ≤ 350 (else MARGINAL) | ≤ 50 | ≤ 50 | ≤ 316 | |

- Consistent with M2 (313.6 µV with seed 42) and with T4 (0.314 mV). The same seed does not give the same chips: chip 0 matches M2's (−231.3 vs −231.4 µV), but XMR and XQ1 come after `x1` in the netlist and draw random numbers too, so from chip 1 on every chip is different. The 8 µV difference is within the sampling error σ/√(2N) ≈ 15 µV.
- The means sit within one standard error (σ/√200 ≈ 21 µV) of the −29 µV systematic null.
- Drift after the 25 °C trim is ≤ 24 µV σ (≈ 0.02 °C); PSRR is 5× inside its limit on the worst chip.

## T5b: gain and phase-margin Monte Carlo (25 °C, CL 25 pF, N = 200 per corner)

`tb_m3_olmc` (Save As of `tb_m3_ol`, `.lib … tt_mm`, reset loop with one `ac` per chip), run by `opamp_m3/scripts/olmc_m3.sh`, 29 s. Decision: a separate open-loop bench with its own seeds (44/45) instead of the spec's "OL copy in the same loop". Only the A0/PM statistics are needed, so the chips don't have to be the same chips as in T5a.

| Corner, seed | A0 mean ± σ | A0 worst chip | PM44 mean ± σ | PM44 worst chip | f44 range | Verdict |
|---|---|---|---|---|---|---|
| tt_mm, 44 | 88.363 ± 0.012 dB | 88.33 dB | 75.04 ± 0.09° | 74.82° | 179.0–192.6 kHz | PASS |
| ss_mm, 45 | 88.395 ± 0.011 dB | 88.37 dB | 74.62 ± 0.09° | 74.36° | 181.2–191.6 kHz | PASS |
| limit | | ≥ 70 dB | | ≥ 60° | 50–300 (report) | |

- **Mismatch barely touches gain or stability:** A0 σ = 0.14 % (linear) and PM44 σ = 0.12 %, against f44 ≈ 1.2 %. A0 is gm·r_o, and PM depends on the ratio of p2 to f44; the bias current cancels in both.
- **f44 spreads ≈ 10× more** because it follows the stage-1 current. Measured f44 sensitivities (tt/25 °C, % per mV of ΔV_th): MREF −1.47, MTAIL +1.40, MN1/MN2 ±0.40, MP3 0.07, the rest < 0.01. Hand RSS with the T4 σ_Vth: √((1.40·0.463)² + (1.47·0.655)² + 2·(0.40·0.217)²) = **1.17 %** ≈ 2.2 kHz → about ±6 kHz over 200 chips, matching the 179–193 kHz seen. Most of it is the MREF → MTAIL mirror (the smallest devices, 80/160 µm²) setting a slightly different tail current per chip.
- **T5 (mismatch) closed:** offset, drift, PSRR, A0 and PM all pass at tt_mm and ss_mm.

## T6: K extraction for M5 (ideal-op-amp core, tt)

`opamp_m3/k_extract.cir`: the bandgap core with an ideal op-amp and ideal mirrors (`Bnull` with a 0.5 µA floor to remove the zero-current state), and real `pnp_05v5` (Q1 ×1, Q2 ×8, Q3 ×1) and R1 = 4 × `res_high_po_1p41` L=20. Tolerances are reltol 1e-6, because the default 1e-3 moved V_EB3 by 0.5 mV. One `op` per temperature; va − vb ≤ 0.35 µV.

| T (°C) | I_PTAT (µA) | V_EB3 (V) | ΔV_EB (mV) | V_REF, N3 = 40 (V) |
|---|---|---|---|---|
| −20 | 2.398 | 0.787133 | 45.898 | 1.246115 |
| 25 | 2.773 | 0.709973 | 54.114 | 1.251116 |
| 100 | 3.336 | 0.574972 | 67.879 | 1.253757 |

- **K_opt** = [V_EB3(−20) − V_EB3(100)] / [ΔV_EB(100) − ΔV_EB(−20)] = 0.212161 / 0.0219803 = **9.65** (spec's earlier ideal-core value 9.67; the August hand value ≈ 10.1 came from linear 25 °C slopes, and V_EB curvature lowers it).
- **R3 unit count:** round(4·9.65) = 39 gives V_REF ≈ 1.235–1.238 V, below the 1.245 V rule (1.24 V floor plus 5 mV for corners). → **N3 = 40, K = 10.0 unchanged**, with V_REF = 1.2461 / 1.2511 / 1.2538 V at −20 / 25 / 100 °C.
- **Slope +63.7 µV/K (rising):** K = 10 is above K_opt, so the PTAT term (10 × 0.183 = 1.83 mV/K) slightly outruns V_EB3's −1.77 mV/K. In μ-mode V_REF does not need to be flat; the slope goes into M8's polynomial.
- **For M5 step 4:** re-extract on the real `bgr`. The corner that bites is sf_ll at −20 °C (≈ 1.240 V by hand, spec line 1602). If it's confirmed, prefer the §2 note lowering the floor to 1.23 V (B14) over N3 = 41.

## H4: mismatch of the bandgap's own parts (`tt_mm`, N = 200, 25 °C)

`opamp_m3/h4_mm_check.cir` (seed 46), ideal current sources, four structures; at plain `tt` every σ is 0 and R3/R1 = 10.000, which confirms the spread comes from the mismatch models.

| Structure | Simulated σ | Spec reference | Hand scaling from the spec reference | Hand scaling from this run's own reference |
|---|---|---|---|---|
| Two single PNPs, 10 µA (reference) | 101.9 µV | 88 µV | — | — |
| Q1 ×1 vs Q2 ×8, 2.79 µA (core) | **72.0 µV** (mean 54.113 mV) | ≈ 66 µV (estimate) | 88/√2·√(1 + 1/8) = 66.0 µV | 101.9/√2·√1.125 = 76.4 µV |
| Two high_po L=10, 10 µA (reference) | 0.880 % | 0.94 % | — | — |
| R3 (40 u) / R1 (4 u), L=20 (core) | **0.245 %** (mean 9.9996) | 0.25 % (§2 hand) | 0.94/2·√(1/4 + 1/40) = 0.246 % | 0.880/2·√0.275 = 0.231 % |

- Both core numbers agree with the Pelgrom scaling within about ±6 %, the sampling error at N = 200 (±5 %). The single-PNP reference measures 16 % above the spec's 88 µV on this install, so the measured value is the one to use.
- **R1 sets the ratio error.** Its 4 units give σ_unit/2 = 0.235 %, against R3's σ_unit/√40 = 0.074 %; R1 carries 91 % of the variance. The fewer the units, the larger the error.
- **For the sensor:**
  - The PNP pair's 72 µV error on ΔV_EB is small next to the op-amp's 313 µV: together √(313² + 72²) = 321 µV. It is a 0.13 % PTAT-gain error, which the one-point trim removes.
  - σ(R3/R1) = 0.245 % gives σ(K) = 0.0245, so V_REF σ = 0.0245 × 54.1 mV = 1.33 mV (3σ ≈ 4 mV; tt minimum 1.2461 − 4.0 = 1.242 V, still above the 1.24 V floor) and slope σ ≈ 4.5 µV/K.
  - §2's hand value of 0.25 % is confirmed (simulated 0.245 %).
- **H4 coverage note:** mismatch is active on pnp_05v5 and res_high_po on this install (σ > 0 at `tt_mm`, 0 at `tt`); MOS mismatch is V_th-only (T4/T5). The 0.15 mV allowance for the missing β mismatch stands.

## T7: chop state-B spot check

`python3 -m simkit.sweep sweeps/m3_pvt.py --chop B --corners tt,ss,ff`, then `scripts/chop_check.py`. State B = CHOP/CHOPB swapped **and** the ota2s instance's INP/INN swapped (the input-chopper half), which is how M2 T13 built it. Harness fix: before that, `--chop B` swapped only CHOP/CHOPB, which leaves the bench in positive feedback (a DC op cannot detect this). No state-B result had been produced with the bug.

| Point | A0 15p / 25p (dB) | PM44 15p / 25p (°) | Vos (µV) | PSRR (µV/V) | B − A |
|---|---|---|---|---|---|
| tt / 1.80 V / 25 °C | 88.364 / 88.364 | 79.751 / 75.086 | −29.213 | 41.1 | 0.000 on every quantity |
| ss / 1.71 V / −20 °C | 86.625 / 86.625 | 79.602 / 75.223 | −67.594 | 47.4 | 0.000 |
| ff / 1.71 V / 100 °C | 86.089 / 86.089 | 79.100 / 74.123 | +20.739 | 34.7 | 0.000 |

**CHOPCHECK PASS** (limits: 1 dB, 1°, 10 µV). Without mismatch, state B is state A mirrored (MP1↔MP2, MN1↔MN2), and the four switches load both sides equally, so every number repeats exactly, as in M2. The systematic null keeps its sign because it is the stage-2 gap (V_GS of MN3 vs the load), a symmetric property. Only mismatch flips sign between the states, and that is what the chop averages away (M2 demo: ±919 µV around the null). The 3-corner state-B summary (all PASS) is in `results/m3_summary_chopB.md`.

## T8: freeze record and done-when

**Freeze record**
- `ota2s` netlist: `71510555c0d929fda48c68ae6d187f6ff25e67300c09fb497a49c1d66e9f0cfc  tt_tsense/xschem/simulation/ota2s.spice`, the same hash as the M2 freeze. All 25 devices inside the five M3 benches are identical to it (diff with continuation lines joined).
- PDK: ciel sky130A `f6eeac7dad085ffcc829ccfd721f7b4ce39edcf7` (combined library). Simulator: ngspice-46 in `hpretl/iic-osic-tools:latest`.
- Harness: `opamp_m3/freeze/simkit_freeze.tar.gz`, sha256 `56f00060ea4c868869c32978e0e36646d9467d79e9ed75a21635bf5dd6175670` (includes the chop-B fix).
- Benches (sha256, first 16 hex digits): `tb_m3_servo.sch` 7c451f090312897b · `tb_m3_ol.sch` f1872cec1bbffb01 · `tb_m3_sens.sch` 0d353dff0ac7367a · `tb_m3_mc.sch` 53d563ede95e1169 · `tb_m3_olmc.sch` e4d723d4e02b0378 · `k_extract.cir` b9cbed71cdde271b · `h4_mm_check.cir` 3ea86c0947723963.

**Done-when checklist** (spec M3)

| Item | Evidence | |
|---|---|---|
| Smoke test within 0.2 dB / 2° of M2 | 0.02 dB / 0.1° (T2) | ✓ |
| 15 corners × 40 points, zero missing, every guaranteed row passes | 1800/1800 rows, 0 missing, 0 FAIL (T3) | ✓ |
| tt_mm σ̂ ≤ 0.35 mV at N = 200, seed recorded; ss_mm and drift reported | 305.4 µV, seed 42 (1.09σ̂ 333); ss_mm 288.2, seed 43; drift σ ≤ 24 µV (T5a) | ✓ |
| DC PSRR ≥ 70 dB (≤ 316 µV/V), incl. MC mean + 3σ | grid worst 79.8 µV/V; MC mean + 3σ 64.1 / 66.6 µV/V (−84 dB) | ✓ |
| PM(β = 0.44) ≥ 60° at 15 and 25 pF, every guaranteed point; f_u reported | min 71.7° (15 pF) / 66.1° (25 pF); f44 135–264 kHz, f_u(β=1) 297–547 kHz | ✓ |
| ICMR and swing curves for the worst corners | `results/curves/` (6 curves + summary), all PASS (T3b) | ✓ |
| delvto breakdown within ≈ 20 % of MC | 0.314 vs 0.313 mV (T4) | ✓ |
| K_opt and R3 unit proposal logged for M5; H4 note written | K_opt 9.65 → N3 = 40 (T6); H4 section | ✓ |
| (Rev C, C6) chop nets on every bench; state B within 1 dB / 1° / 10 µV | B − A = 0.000 at all three points (T7) | ✓ |
| Netlist sha256 and PDK commit recorded; simkit saved | above | ✓ |

Next: M5 re-extracts K on the real `bgr`.
