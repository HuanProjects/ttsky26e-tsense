# M2 results — `ota2s` two-stage op-amp

*M2 CLOSED. The cell is frozen (8 pins, sha256 below), every bench passes, and H1 items 1 and 2 are below. Benches run at tt, 25 °C, 1.80 V, state A, unless a row says otherwise. Every number comes from the logs in `xschem/simulation/`.*

## Summary against the spec targets and the scratch run (done-when: "within 10%, or explain")

| Parameter | Target | Yours | Spec scratch | Δ vs scratch | Verdict |
|---|---|---|---|---|---|
| Pair size, gm/Id | WL ≥ 2,300 µm², L ≥ 4, W/L ≥ 50 | 3,600 µm², L = 6, W/L = 100; gm/Id = 19.9 V⁻¹ | 3,600 µm²; 19.7 V⁻¹ | +1% | PASS |
| σ(Vos), `tt_mm`, pooled N = 400 | ≤ 0.35 mV; MARGINAL if 1.09·σ̂ > 0.35 | **313.3 µV**; 1.09·σ̂ = 341.5 µV | 305 µV (291 / 319) | +2.7% | **PASS** |
| Systematic Vos, 25 °C | ≤ 0.1 mV | **−29.3 µV** | −31 µV (27 °C) | −5.5% | **PASS** |
| Null at −20 / 25 / 100 °C | ≤ 0.1 mV each | −59.8 / −29.3 / +20.9 µV | −63 / −31 / +18 µV (1.71 V) | −5% / −5% / +16% ¹ | PASS |
| Drift σ at −20 / 100 °C (pooled) | ≤ 50 µV | 20.9 / 25.6 µV | 21–26 µV | within | **PASS** |
| A0 | ≥ 70 dB | **88.4 dB** | 87.5 dB (27 °C, 1.71 V) | +0.9 dB | **PASS** |
| ICMR at 1.71 V | covers 0.53–0.83 V | 0.366 V (ff/100 °C) to 1.002 V (ss/−20 °C) | 0.365 / 1.002 V | 0% | **PASS** |
| Output swing | A ≥ 70 dB over 0.19–0.95 V | ≥ 70 dB from 0.130–0.188 V up to > 1.40 V | same | 0% | **PASS** |
| PSRR, DC, in-context | ≥ 70 dB (≤ 316 µV/V) | **41.2 µV/V = 87.7 dB** | 41 µV/V (88 dB) | +0.5% | **PASS** |
| CMRR, DC | ≥ 70 dB (≤ 42 µV for the 25→100 °C CM fall) | from `_icmr`: worst 57 µV/V = **84.9 dB** (ff/100 °C); 102 dB at tt | ≥ 73.8 dB (fs/100 °C) | different corner ² | **PASS** |
| f44 / PM44 at β = 0.44, 25 pF | 50–300 kHz / ≥ 60° | **185.7 kHz / 74.9°** (15–30 pF: 188–184 kHz, 79.6–72.7°) | 185 kHz / 73.6° | +0.4% / +1.8% | **PASS** |
| Settling 0.1%, β = 0.44, 25 pF | ≤ 10 µs, overshoot ≤ 10% | **5.05 µs** (1 mV) / 5.03 µs (100 mV), 0% | 5.7 µs, 0% | −11% ³ | **PASS** |
| Noise, 0.5–250 Hz | ≤ 6 µV rms | **3.40 µV rms** | 3.77 µV rms | −10% ⁴ | **PASS** |
| Supply current, 25 °C | ≤ 12.6 µA | 2.79 + 8.41 + 1.40 = **12.60 µA** | 2.8 + 8.4 + 1.4 µA | 0% | PASS (at the limit) |
| Chop states (Rev C, C2) | B within 10 µV / 1° of A; leakage ≤ 100 pA per junction | identical; 67 pA per junction | – | – | **PASS** (Step 12) |

**Explained differences**
1. **Null at 100 °C, +16%:** 20.9 vs 18 µV is a 3 µV absolute difference, far below the 100 µV
   limit. The scratch ran at 1.71 V and was referenced to 27 °C; these benches run at 1.80 V, referenced to 25 °C.
2. **CMRR:** M2 didn't build a separate CMRR bench. The DC CMRR comes from the `_icmr` sweep: ΔVos / ΔV_CM between 0.71 and 0.53 V. The scratch's worst
   corner, fs/100 °C, wasn't run here; it goes to M3's corner grid.
3. **Settling, −11% (faster):** checked on a copy. It isn't the supply (5.06 µs at 1.71 V / 27 °C), the temperature, or the Cc–Rz order (5.06 µs with
   the scratch's x1–Cc–Rz–OUT order). What's left is the scratch deck's hand-written, pre-dummy subcircuit. The difference goes in the safe direction, and the
   ≤ 10 µs line holds with 2× margin; M3 re-measures across PVT.
4. **Noise, −10% (lower):** the scratch servo (gain 1) let the replica's own 1/f noise into the input, about 1.5 µV of it. This bench AC-grounds the target
   with `Cvp vpgt 0 1T` (see `_noise` below).

## Nominal operating point and polarity — T5/T6

`tb_ota2s_op` (servo holds OUT at the replica gate voltage, 0.548 V). This run predates the dummies: the null here is −28.5 µV, and T11 moved it by 0.8 µV.

| Device | Role | V_SD or V_DS (V) | V_dsat (V) | Margin (V) | I_D (µA) |
|---|---|---|---|---|---|
| XMTAIL | tail source | 0.576 | 0.094 | 0.482 | 2.787 |
| XMP1 / XMP2 | input pair (lvt) | 0.563 / 0.558 | 0.046 | 0.517 / 0.512 | 1.393 |
| XMN1 / XMN2 | mirror load | 0.661 / 0.666 | 0.131 | 0.530 / 0.535 | 1.393 |
| XMP3 | stage-2 load | 1.252 | 0.094 | 1.158 | 8.408 |
| XMN3 | stage-2 amplifier | 0.548 | 0.101 | 0.447 | 8.408 |

Nodes: d1 = 0.6608 V, x1 = 0.6658 V, tail = 1.2237 V. gm1 = 27.72 µS and R_x1 = 6.18 MΩ, so A1 = gm1·R_x1 ≈ 171.
**Polarity (`tb_ota2s_pol`):** sweeping the differential input drives OUT from 0.035 V to 1.789 V, and OUT rises when vid rises → **PASS**. INP is the
non-inverting input: the x1 lane has two sign flips (T3).

## Systematic offset across temperature and the stage-2 W — T7

`tb_ota2s_temp`: CM = V_EB(T) = 0.710 − 1.846 mV/K·(T − 25), PTAT bias, replica target. Pre-dummy runs.

| XMN3 W | −20 °C | 25 °C | 100 °C | Worst \|Vos\| | Gap x1 − d1 at 25 °C |
|---|---|---|---|---|---|
| 6 µm (re-run on the frozen cell, copy) | −123.8 µV | −94.4 µV | −57.4 µV | 123.8 µV ✗ | +16.16 mV |
| **7 µm (chosen)** | −59.8 µV | −28.5 µV | +20.9 µV | 59.8 µV | +5.02 mV |
| 8 µm (logged as `temp_w6.log`) ⁵ | −14.2 µV | +22.4 µV | +79.7 µV | 79.7 µV | −3.16 mV |

W = 6 fails at −20 °C (−124 µV). W = 8 passes but reaches +80 µV at 100 °C. W = 7 has the smallest worst case (±60 µV): its drift is centred.
After the dummies (T11): −59.75 / −29.29 / +20.93 µV.
5. **The `temp_w6.log` run was W = 8**, confirmed by re-running W = 6 / 7 / 8 on a copy of the frozen cell. The logged −20 and 100 °C nulls and
   all three gaps match W = 8 to 0.01 µV / 0.01 mV. The 25 °C null differs by 4 µV, which is solver tolerance at the middle point of the loop (the same
   effect T11 saw); the gap there is identical. Physics check: x1 sits at MN3's V_GS, so a narrower MN3 has a larger V_GS and a bigger gap. W = 6 gives
   +16.2 mV, W = 7 gives +5.0 mV and W = 8 gives −3.2 mV.

## PSRR — T8

`tb_ota2s_vdd` (in-context: OUT tracks VDD the way the gate line does).

| VDD | 1.71 V | 1.80 V | 1.89 V |
|---|---|---|---|
| Null vid | −33.18 µV | −28.46 µV | −25.77 µV |
| OUT | 0.458 V | 0.548 V | 0.638 V |

Slope (−25.77 + 33.18) µV / 0.18 V = **41.2 µV/V → 87.7 dB**. In °C: 41.2 µV/V × 0.69 °C/mV = 0.028 °C per volt of supply, against ≤ 1 °C/V.

## Stability and compensation — T9

`tb_ota2s_ol`: AC-open servo (Lsv/Csv), β = 0.44 through Bdn in the tran bench, source impedances RsA 9.2 kΩ / RsB 28.7 kΩ.

- **Uncompensated (T9b):** A0 88.36 dB, f44 1.71 MHz, **PM44 −90.9°**, so it oscillates. There are two high-impedance nodes: x1 (6.2 MΩ, ~1 pF) and OUT (~1.1 MΩ, CL).
- **Compensated (T9c):** Cc = 8 × `cap_mim_m3_1` 25×25 = 10.1 pF, Rz = 6 × `res_high_po_1p41` L = 20 = 29.3 kΩ. A0 88.36 dB, f44 188.4 kHz, PM44 79.2° at CL 16 pF.
- **Rz sweep at CL 15 / 20 / 25 / 30 pF (T9d–e), PM44:**

| Rz units (kΩ) | 15 pF | 20 pF | 25 pF | 30 pF | LHP zero (hand) |
|---|---|---|---|---|---|
| 4 (19.5) | 73.7° | 71.4° | 69.2° | 67.1° | 1.28 MHz |
| 5 (24.4) | 76.7° | 74.4° | 72.2° | 70.0° | 0.91 MHz |
| **6 (29.3, chosen)** | 79.7° | 77.3° | 75.1° | 72.9° | 0.71 MHz |
| 8 (39.0) | 85.6° | 83.1° | 80.7° | 78.4° | 0.49 MHz |

Choice: **6 units**. PM44 at 30 pF is 72.9°, clearing the ≥ 68° tt rule by 4.9°. That rule leaves room for the ≈ 8° the corners cost (spec: 73.6 → 65.3° at ff_ll/100 °C). Its cost is +0.5 µs
of settling against 5 units (T10). Zero: 1/(2π·Cc·(Rz − 1/gm6)), with 1/gm6 = 7.2 kΩ.

## Settling — T10

`tb_ota2s_tran`: β = 0.44 loop closed with `Bdn`, CL 25 pF, 0.1% band.

| Rz | 1 mV step | 100 mV step | Overshoot |
|---|---|---|---|
| 5 units | 4.56 µs | 4.42 µs | 0% |
| **6 units** | **5.05 µs** | **5.03 µs** | 0% |

The step gain is 2.2725 = 1/0.44. The 100 mV step settles as fast as the 1 mV step, so it isn't slew-limited: SR = 2.8 µA / 10.1 pF ≈ 0.28 V/µs, against the
≈ 0.26 V/µs a 227 mV output step needs in one τ. Larger Rz settles slower (overdamping), which is the price paid for phase margin.

## Dummies — T11

All six dummy groups follow the M4 strip map: XDP (lvt W25 L6 ×8, tail/VDPWR), XDNA (W6 L20 ×2 on d1), XDNB (W6 L20 ×2 on x1), XDB (W20 L4 ×2, VDPWR), and
XRD1/XRD2 (res L = 20, VGND). The cell then has 21 devices before the chop switches.
Effect: null −59.75 / −29.29 / +20.93 µV, a change of ≤ 0.8 µV, below ngspice's 1 µV `vntol`, so W = 7 holds. PM44 79.70 / 77.32 / 75.03 / 72.85°, a change of −0.02°.

## Monte Carlo offset — T12

`tb_ota2s_mc`: corner `tt_mm` (mismatch only), 200 chips per seed, each chip run at 25, −20 and 100 °C. `reset` runs before *every* sample: the spec's
Appendix B.4 loop skips it on sample 0, which draws that chip before `setseed` and makes the run non-reproducible.

| Seed | Mean | σ | 1.09·σ | Drift σ, −20 °C | Drift σ, 100 °C |
|---|---|---|---|---|---|
| 42 | −55.0 µV | 313.6 µV | 341.8 µV | 21.9 µV | 27.1 µV |
| 7 | −6.7 µV | 313.0 µV | 341.2 µV | 19.7 µV | 24.1 µV |
| **pooled, N = 400** | **−30.8 ± 15.7 µV** | **313.3 µV** | **341.5 µV** | **20.9 µV** | **25.6 µV** |

- **PASS:** σ̂ ≤ 0.35 mV and 1.09·σ̂ ≤ 0.35 mV (not MARGINAL); drift ≤ 50 µV. The pooled mean is consistent with the −29 µV design null (standard error σ/√400).
- **Where the σ comes from:** the Pelgrom pair-alone estimate is 257 µV, so the mirror load adds √(313.3² − 257²) ≈ 179 µV.
- **In °C:** the 3σ chip is 0.94 mV × 0.69 °C/mV ≈ 0.65 °C at 100 °C after the trim. This is the budget row the static chop (Step 12) removes.

## Step 12 — chop switches (Rev C, C2), T13

**Symbol pin order:** `INP INN OUT VDPWR VGND IBIAS CHOP CHOPB`

**Switches:** four gate-only `nfet_01v8` W=6 L=0.5. SD1/SD2 pick the diode (MN1 or MN2, gate line `g12`); SG1/SG2 pick
stage 2's input (x1 or d1 → `g3`); the Rz–Cc chain starts on `g3`.
**States:** A = CHOP 0 V / CHOPB 1.8 V (the Rev B wiring; drawn in every bench). B = CHOP 1.8 V / CHOPB 0 V (made by `sed` on
the netlist, which swaps instance slots 1↔2 and 7↔8).

| Check | State A | State B | Switch-free (T11 `dum_*`) | Pass line | Verdict |
|---|---|---|---|---|---|
| Null `vid`, −20 / 25 / 100 °C (µV) | −59.757 / −29.292 / +20.936 | identical | −59.754 / −29.290 / +20.928 | B within 10 µV of A | **PASS** (Δ = 0.000 µV) |
| `gap` = x1 − d1, −20 / 25 / 100 °C (mV) | +9.415 / +5.017 / −3.507 | −9.415 / −5.017 / +3.507 | +9.414 / +5.016 / −3.509 | flips (diode moves) | as expected |
| PM44 at 15 / 20 / 25 / 30 pF (°) | 79.56 / 77.17 / 74.88 / 72.68 | identical | 79.70 / 77.32 / 75.03 / 72.85 | B within 1° of A | **PASS**; switch cost −0.14…−0.17° |
| f44 at 25 pF (kHz) | 185.68 | 185.68 | 185.76 | – | – |
| R_on SD1 / SG1, 25 °C (Ω) | 825 / 838 | – | – | hand 790 (1.80 V) | within 6% |
| R_on SD1 / SG1, 125 °C (Ω) | 1088 / 1070 | – | – | – | – |
| Off-switch leakage, 125 °C | 133 pA per switch = 67 pA per junction (1.3 pA at 25 °C) | – | – | ≤ 100 pA per junction, ≤ 10 µV input-referred | **PASS** on intent |
| Mismatch demo: `delvto` = +1 mV on MP1, `vid` at −20 / 25 / 100 °C (µV) | −974.80 / −948.39 / −901.93 | +855.29 / +889.81 / +943.84 | average −59.75 / −29.29 / +20.95 | average = the null | **PASS** (±919 µV cancels to ≤ 0.02 µV) |

**Notes**
- **R_on is outside the Miller loop.** The loop is g3 → Rz → Cc → OUT → MN3 → g3; SG1/SG2 sit in series with stage 1's
  current-source output. An ideal resistor in place of SG1 costs 0.015 / 0.08 / 0.45° of PM44 at 1 k / 5 k / 30 kΩ (25 pF), while
  +30 kΩ on Rz gives +16°. The −0.15° switch cost is junction and overlap capacitance on x1/d1/g3. (This corrects the T13a hand
  estimate and spec lines 826/1025/1610, fixed.)
- **Leakage is symmetric.** Four switch junctions sit on each side (d1/g12 and x1/g3), so the current imbalance is ≈ 0: the null at
  100 °C moved 0.008 µV against the switch-free cell. Worst case if fully unbalanced: 266 pA / gm1 (31 µS) ≈ 8.6 µV ≈ 0.006 °C.
  The spec line was reworded from "per switch" to "per junction, input-referred ≤ 10 µV".
- **The null does not flip; mismatch does.** The −29 µV null is a design property (stage-2 sizing), identical in the mirrored
  circuit; the 1 mV `delvto` mismatch flips sign between the states, so the A/B average returns the null.
- **`delvto` +1 mV** lowers MP1's |Vth| by exactly 1.000 mV but moves `inn` by 0.919 mV: in BSIM4 the drain current is not a pure
  function of V_SG − V_th. The size doesn't matter for the chop, only that it is equal and opposite.

## Freeze

    53456d6e9bdee9f3d054f9588a20a1cdecc054e1f9e549f0d11c5ecf5f689c57  ota2s.sch
    fbd79179752714fcf99e4e73f6bd63736a67956f7697cefc057ae80a7a92540c  ota2s.sym
    71510555c0d929fda48c68ae6d187f6ff25e67300c09fb497a49c1d66e9f0cfc  simulation/ota2s.spice
    open_pdks f6eeac7dad085ffcc829ccfd721f7b4ce39edcf7
    pins: INP INN OUT VDPWR VGND IBIAS CHOP CHOPB

## `_icmr` — input common-mode range, T14

Bench `tb_ota2s_icmr.sch` (Save As of `_temp`): ideal `Vcmx` swept 0.10–1.40 V in 5 mV steps, servo on, state A, `reltol=1e-5 vntol=1e-9`.
Edge = the CM where a margin (V_SD − V_dsat) hits 50 mV. Needed band: 0.53–0.83 V (V_EB at 2.79 µA over 125…−40 °C).

| Corner | ICMR (V) | Tail margin at 0.83 V | Pair margin at 0.53 V | ΔVos 0.53 / 0.83 vs 0.71 (µV) | Spec scratch | Verdict |
|---|---|---|---|---|---|---|
| tt, 25 °C, 1.71 V | 0.169 – 1.153 | 310 mV | 353 mV | −1.34 / −0.07 | – | reference |
| **ss, −20 °C, 1.71 V** | < 0.10 – **1.002** | 187 mV | 474 mV | −0.86 / −0.41 | top 1.002 | **PASS** |
| **ff, 100 °C, 1.71 V** | **0.366** – 1.343 | 464 mV | 187 mV | +10.29 / −1.86 | bottom 0.365 | **PASS** |
| ss, −40 °C, 1.62 V (char) | < 0.10 – 0.879 | 89 mV | 488 mV | −0.59 / −2.52 | top 0.879, 89 mV | reported |

**Notes**
- **Hand model vs sim.** CM_top = VDD − V_SG − V_dsat,tail − 50 mV and CM_bot = V_GS,MN1 + V_dsat,pair + 50 mV − V_SG. At tt (V_SG 0.498, V_dsat
  0.094/0.046, d1 0.661) that gives 1.068 / 0.259 V; at ss/−20 (V_SG 0.636, V_dsat,tail 0.080), 0.944 V. The sim edges are wider because the pair's
  body is on VDPWR: as the CM rises, the tail moves toward the body, |Vth| drops and V_SG shrinks (ss/−20: CM 0.71 → 1.00 takes |Vth| 0.736 → 0.676 V
  and V_SG 0.636 → 0.579 V). With V_SG taken at the edge, the hand top is 1.001 V against 1.0016 simulated.
- **Worst real point.** At −40 °C the CM really is ≈0.83 V, the coldest PMOS has the largest V_SG, and 1.62 V is the lowest supply. That's the thinnest
  margin anywhere: 89 mV of tail margin (39 mV above the floor). Report-only; spec §1 had expected it to fail.
- **CM-induced offset.** Worst 10.3 µV (ff/100 °C at 0.53 V, where the pair margin is smallest) × 0.69 °C/mV ≈ 0.007 °C, against the 0.1 mV (0.07 °C) limit.

## `_swing` — output swing (gain vs OUT), T15

Bench `tb_ota2s_swing.sch` (Save As of `_temp`, replica MR deleted): ideal `Vtgt` on `vpgt` swept 0.05–1.40 V in 5 mV steps, servo forces OUT = Vtgt,
`reltol=1e-6 vntol=1e-10`, state A. Gain A_dB = −20·log₁₀|d(vid)/d(Vout)|. Needed: A ≥ 70 dB over the gate-line range 0.19–0.95 V.

| Corner | A at 0.55 V | 70 dB low edge | 70 dB high edge | A at 0.19 / 0.95 V | ΔVos 0.28→0.91 V | vpg there (hand) → A | Verdict |
|---|---|---|---|---|---|---|---|
| tt, 27 °C, 1.80 V | 88.39 dB | 0.147 V | > 1.40 V | 77.0 / 90.0 dB | −25.1 µV | ≈0.55 V → 88.4 dB | **PASS** |
| ss, −20 °C, 1.71 V | 87.90 dB | 0.130 V | > 1.40 V | 78.9 / 89.2 dB | −26.2 µV | ≈0.39 V → 86.2 dB | **PASS** |
| ff, 100 °C, 1.71 V | 86.08 dB | **0.188 V** | > 1.40 V | **70.3** / 88.1 dB | −33.6 µV | ≈0.56 V → 86.2 dB | **PASS** (1.5 mV at 0.19 V) |

Spec scratch: A ≥ 70 dB from 0.130–0.188 V up to > 1.40 V — matches. ss/−40 °C/1.62 V does not converge at these tolerances; the swing row doesn't list it
(the 1.62 V point is reported in `_icmr`).

**Notes**
- **Hand gain** (tt/27/1.80, OUT 0.55): A1 = gm1·R_x1 = 27.83 µS × 6.17 MΩ = 171.7; A2 = gm(MN3)·R_out = 138.6 µS × 1.105 MΩ = 153.2; A = 26,300 = 88.4 dB (sim 88.39).
- **Low edge = MN3 leaving saturation.** At OUT = 0.15 V MN3's V_DS is 48 mV above its V_dsat (0.102 V); its g_ds rises 0.85 → 6.65 µS, A2 falls to 20,
  A to 70.7 dB. The edge is highest at ff/100 °C: PTAT stage-2 current (≈10.5 µA) and hot mobility give MN3 the largest V_dsat.
- **The thin ff/100 °C margin is at a voltage that corner never uses.** vpg = VDD − V_SG(P1–P3); from M5's V_SG numbers (1.249 V at 27 °C, ±1.2 mV/K,
  ff −11 mV) vpg ≈ 0.56 V at ff/100 °C/1.71 V, where A = 86 dB. vpg only approaches the low end at cold/ss/low VDD (≈0.39 V at ss/−20 °C/1.71 V, 86 dB;
  lo70 there is 0.130 V). M3 checks exactly this: ≥ 70 dB over vtg ± 50 mV at every guaranteed point (spec line 1001).
- **Finite-gain offset.** ΔVos over 0.28→0.91 V ≈ 0.63 V / A ≈ 25 µV (hand 24 µV at tt). On one chip vpg moves ≈0.2 V over temperature → ≈8 µV ≈ 0.005 °C.

## `_noise` — input-referred noise, T16

Bench `tb_ota2s_noise.sch` (Save As of `_ol`): `noise v(out) Vac`, tt, 25 °C, 1.80 V, CL 16 pF, state A, source impedances RsA 9.2 kΩ (Q1 r_e) and
RsB 28.7 kΩ (R1 + Q2 r_e) included. **Fixture fix:** `Cvp vpgt 0 1T`. Without it the servo (×1000) amplifies the replica MR's own noise into INN
and the band reads 1541 µV rms. With it the DC point is unchanged (OUT 0.548211 V, null −29.29 µV).

| Quantity | Result | Pass line / hand | Verdict |
|---|---|---|---|
| Noise, 0.5–250 Hz | **3.40 µV rms** | ≤ 6 µV rms (spec scratch 3.77, which included the replica at servo gain 1) | **PASS** |
| Noise, 0.1 Hz–1 kHz | 4.52 µV rms | – | – |
| Spot noise 1 / 10 / 100 Hz | 1051 / 402 / 161 nV/√Hz | – | 1/f region |
| Spot noise 1 k / 10 k / 100 kHz | 78.9 / 58.3 / 56.7 nV/√Hz | white floor, hand 54 nV/√Hz | 4% from hand |
| In °C | 3.40 µV × 3.05 °C/mV = **0.010 °C rms** | op-amp share 0.018 °C of the ≤ 0.1 °C rms resolution spec | – |

**Notes**
- **Hand white floor:** 4kT·(9.2 + 28.7) kΩ → 25 nV/√Hz, plus four stage-1 devices at 2qI each referred through gm1: 4·2q·1.393 µA / (27.71 µS)² → 48 nV/√Hz;
  total 54 nV/√Hz, which is 0.86 µV rms over 250 Hz.
- **1/f dominates the band:** white = 56.7 nV/√Hz × √249.5 Hz = 0.90 µV; 1/f = √(3.40² − 0.90²) = 3.28 µV, i.e. **93% of the noise power**. The flicker corner
  (1/f part = white part) is ≈1 kHz, above the band's 250 Hz top, so the whole band is in 1/f territory. The slope is shallower than pure 1/f (2.6× per decade in
  amplitude vs √10 = 3.2×).
- Above ≈100 kHz the input-referred noise rises again as the open-loop gain falls (stage-2 noise referred to the input). That's outside the band.
- The static chop's A/B average also cancels the slow part of this 1/f noise in the full conversion, the same way it cancels offset. The 2 ms fast mode doesn't get that help.

## H1 item 1 — `trim_check` (verify-first 3)

Files: `/foss/designs/budget/trim_check.cir`, `tc_{nom,p1,m1,ptat}.cir`, `trim_check.py`, `trim_check.log`. Nullor PTAT core (ideal op-amp and mirrors),
real `pnp_05v5_W3p40L3p40` (Q1, Q2 ×8, Q3) and `res_high_po_1p41` strings (R1 = 4 units, R3 = 40, K = 10). Op-amp offset δ injected at node B;
`dc temp 100 −20 −5`; μ = 1 − V_EB3/V_REF; 3rd-order μ→T fit on the nominal chip (residual 0.074 K); trims applied at 25 °C.

Nominal at 25 °C: μ = 0.4326, dμ/dT = 1.434×10⁻³ /K, I_PTAT = 2.773 µA, V_REF = 1.2512 V, V_EB3 = 0.7100 V.

| δ | Untrimmed, −20 / 25 / 100 °C (K) | Offset-type trim, −20 / 100 °C (K) | Gain-type trim, −20 / 100 °C (K) |
|---|---|---|---|
| +1 mV constant | +3.546 / +3.036 / +2.279 | +0.510 / −0.756 | +0.959 / −1.505 |
| −1 mV constant | −3.492 / −3.069 / −2.445 | −0.422 / +0.624 | −0.895 / +1.411 |
| **±1 mV, average** | **3.05 at 25 °C** | **0.47 / 0.69** | **0.93 / 1.46** |
| PTAT, 1 mV at 25 °C | +3.011 / +3.036 / +2.863 | −0.024 / −0.173 | +0.429 / −0.927 |

**Verdict: the spec table reproduces to the last digit, so Rev B item B6 is adopted.** The offset-type trim leaves 2.0–2.1× less error than the gain-type trim
(0.47/0.69 vs 0.93/1.46 K per mV). These are the 3.05 and 0.69 °C/mV used throughout `results_m2.md`.

**Notes**
- **Hand model:** dμ/dδ = −a/V_REF + V_EB3·(K + a)/V_REF², with a = n·U_T/ΔV_EB = 26.6/55.3 = 0.48. That gives 4.37×10⁻³ per mV → / 1.434×10⁻³ = 3.05 K/mV at 25 °C.
  The sensitivity scales with V_EB3 (CTAT), so a constant δ's error shrinks as the chip heats up, and an offset-type trim fits that shape better than a
  kelvin-proportional (gain-type) one. Scaling by V_EB3 alone gives 0.36/0.60 vs 0.82/1.37 K. The sim is 15–30% higher in absolute value, but the ratio holds.
- **PTAT δ nearly vanishes after the offset trim**, because δ ∝ T while the sensitivity ∝ V_EB3 falls. Using the constant-δ sensitivities: −20 °C: 3.52 × 253/298 = 2.99 K;
  100 °C: 2.36 × 373/298 = 2.96 K; 25 °C: 3.05 K. That's nearly flat, so subtracting the 25 °C value removes almost all of it.
- **Measurement-method error:** the 3rd-order μ→T map has a 0.074 K residual (largest near 75 °C) that shows up identically in every case; it's the small
  bumps in the curves. The ±1 mV average cancels it. Measured against the nominal chip's own reading instead, the PTAT offset-trim row is −0.014/−0.101 K
  and the constant ±1 mV rows are unchanged. `budget.py` should use that form.

## H1 item 2 — `budget.py` (analytic error budget, spec Appendix A)

Files: `/foss/designs/budget/budget.py`, `budget_alloc.log`, `budget_m2.log`, `budget_mc.png`. Every Appendix A row is a function (allocation × the
sensitivity left after the 25 °C offset trim). Random rows add in RSS, plus 0.30 K linear (curvature 0.15, supply 0.09, TC 0.06). The H1 sensitivities come from the
`trim_*.txt` files, and the op-amp offset from the 400 `_mc` chips (design null subtracted). A 10⁵-chip Monte Carlo runs on the model.

| Scenario | RSS −20 / 100 °C (K) | Total −20 / 100 °C | Spec |
|---|---|---|---|
| Rev A: hand sensitivities, no drift rows | 0.59 / 0.98 | ±0.89 / ±1.28 °C | ±0.9 / ±1.3 ✓ |
| Rev B: H1 sensitivities + drift rows | 0.76 / 1.10 | ±1.06 / ±1.40 °C | ±1.1 / ±1.4 ✓ |
| Rev B, β allowance PTAT-type | 0.73 / 1.05 | ±1.03 / ±1.35 °C | – |
| Rev B, op-amp from the M2 chips (RSS) | 0.71 / 1.05 | ±1.01 / ±1.35 °C | – |
| **Rev B, op-amp from the M2 chips (per-chip MC)** | **0.78 / 1.11** | **±1.08 / ±1.41 °C** | – |
| Rev C: static chop + two-slope | 0.45 / 0.70 | ±0.75 / ±1.00 °C | ±0.8 / ±1.0 ✓ |

Rows match Appendix A.2 within 0.02 K, except the op-amp drift at −20 °C: 0.27 K with the 26 µV allocation (hand 0.25), 0.22 K measured.

**Finding: the offset and its drift are correlated.** corr(Vos25, ΔVos) = +0.61 at −20 °C and −0.62 at 100 °C: each chip's offset grows about 4% of itself when cold and shrinks about 5% when hot.
Post-trim error at 100 °C = 2.362·Vos(100) − 3.053·Vos(25) ≈ (2.362 × 0.949 − 3.053)·Vos25 = −0.81·Vos25, against −0.69 for a constant offset. So the measured
σ (313.9 µV, 10% under the 350 µV allocation) doesn't shrink the op-amp contribution: per-chip MC 0.62 / 0.83 K vs the allocation's 0.60 / 0.81 K. It does not drop by that 10 %:
it rose 2–3%. The RSS of independent rows (1.05 K) is optimistic; the per-chip MC (1.11 K, ±1.41 °C) is the honest number. Still inside ±2.0 °C, and the chop cancels both.
