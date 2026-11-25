# M8 results — the whole tile: antenna, extraction, post-layout runs

*The tile is `mag/tt_um_huanprojects_tsense.mag` with the wiring of `mag/tw.py`. Checks run in `mag/` (`ant.sh`, `pex.sh`, `rledger.py`); the bench is `xschem/tile15.py`, which drives the tile at its pins and writes to `xschem/simulation/tile15/`. "Schematic" below is the tile's LVS netlist (`mag/lvs_cells/tt_um_huanprojects_tsense.spice` on the five frozen netlists); "extracted" is the flat extraction of the layout.*

## 1. Antenna

**Check.** `mag/ant.sh`: Magic's `antennacheck` on the tile, run the way the PDK's `check_antenna.py` runs it. TinyTapeout's precheck has no antenna check for sky130. Rules from `sky130A.tech`: partial model (each metal layer is judged while it is etched), sidewall area against gate area, limit 400 for met1–met3 and for met4–met5, raised when a diffusion is on the net.

**First run: 4 violations, all on met3, all on input pins.**

| pin | gate | met3 from the pin's via to `dig_top` (µm) | ratio (limit 400) |
|---|---|---|---|
| `ui_in[0]` | `readout_glue` `xbi0` (`buf_1`) | 49.2 | 485.9 |
| `ui_in[1]` | `xbi1` | 46.4 | 418.7 |
| `ui_in[2]` | `xbi2` | 43.6 | 422.6 |
| `ui_in[3]` | `xbi3` | 40.9 | 402.9 |

- A `buf_1` input is 0.197 µm² of gate (nfet 0.52 × 0.15, pfet 0.79 × 0.15). One µm of met3 wire is 1.69 µm² of sidewall, about 8.6 per µm against that gate, so 46 µm reaches the limit. `ui_in[4]` and `ui_in[5]` (38.1 and 35.4 µm) passed with little room; `ui_in[6]` and `ui_in[7]` cross Cc on met2 and reach `dig_top` with 2 µm of met3.
- **Why only the inputs.** An input pin is driven from outside the tile, and that driver's diffusion joins the net through met4 and the layers above. While met3 is etched, the tile's met3 wire hangs on the gate alone. Every other long line in the tile starts at a diffusion inside it (the monitor enables with 340 µm of met4, `su`, the control lines over `ota2s`), so its charge has a path and the limit is higher.

**Fix: a 2 µm met4 bridge in each of the six met3 input lines** (`ui_in[0]`…`ui_in[5]`), just east of the middle stripes at x = 97 + k … 99 + k µm for `ui_in[k]`, one µm apart per track so the via pads keep 0.3 µm. When met3 is etched, only the piece from the bridge to `dig_top` (7.7–12.7 µm) is on the gate; the rest of the line joins when met4 is etched, through 2 µm of bridge and the 7–10 µm pin stub.
- It is a change of route data in `tw.py` only: 588 shapes and 221 cuts (was 552 and 209). No cell and no netlist changes; the spec's `diode_2` would have added a cell to the frozen glue.
- **After: 0 violations.** Magic DRC 0, KLayout `sky130A_mr.drc` 0 (via3 cuts 51 586), tile LVS "Circuits match uniquely", local precheck 15 of 15.

## 2. Extraction

**Flow.** `mag/pex.sh`: the tile is flattened in Magic, extracted (`extract all`), and written twice: devices only (`pex/<cell>.lvs.spice`) and with every parasitic capacitor (`pex/<cell>.pex.spice`). Capacitance only; section 3 has the resistances. Flattening first means a wire of one block that runs over another block is extracted against it.
- **The flat netlist is the right circuit:** netgen against the schematic gives "Circuits match uniquely" (1 099 devices after parallel merging, 565 nets), and the tile has no separate substrate port (every region is tapped).
- 1 335 devices, 7 342 capacitors, 7.77 pF in all (2.82 pF of it from VDPWR to the substrate, mostly n-well).

**A trap in the output step.** `ext2spice lvs` followed by `ext2spice cthresh 0` (the recipe of the image's `iic-pex.sh`) leaves the hierarchy switch on. With it on, this Magic (8.3.678) writes no substrate capacitance for a net it does not count as connected at the top level: 225 nets of the tile, nearly all of them nets that end on a gate. `vcap` read 0.04 fF to VGND instead of 280 fF, `vref` 0.18 instead of 154 fF, `vpg` nothing instead of 117 fF. `pex.sh` adds `ext2spice hierarchy off`, and then the netlist carries what the `.ext` file holds. The check is the sum of the node capacitances in the `.ext` file against the netlist.

**The MIM overlap that Magic counts twice.** Over a MIM capacitor Magic adds the met4-to-met3 overlap (84 aF/µm²) between the two plate nets, on top of the device. The top plate (`capm`) lies between the two metals and is the same net as the met4 above it, so that capacitance is not there. Measured on the bare unit cells through `pex.sh`: 55.23 fF per 25 × 25 µm unit, 43.70 fF per 22.17 µm unit. `tile15.py` takes it out of the three capacitors it lands in:

| MIM | plate nets | extracted (fF) | removed (fF) | left (fF) |
|---|---|---|---|---|
| C_osc, 4 units | `vcap` – VGND | 280.31 | 220.92 | 59.39 |
| V_REF decap, 2 units | `vref` – VGND | 154.23 | 87.40 | 66.83 |
| Cc, 8 units | `cz` – `vpg` | 465.49 | 441.83 | 23.66 |

**Wiring capacitance of the analog nets** (fF, after that correction; device capacitances are in the models, not here):

| net | to VGND | to VDPWR | to other nets | total | largest couplings |
|---|---|---|---|---|---|
| `vcap` | 59.4 | 10.7 | 29.1 | **99.2** | `ib_cmp1` 7.0, `vref` 6.2, comparator `n1` 5.4, `vref_mon_en` 1.7, `vthr` 1.1, `ichb` 1.0 |
| `vthr` | 11.2 | 2.4 | 22.9 | 36.5 | comparator `nd` 8.0, `ib_cmp1` 5.3, `vref` 2.4, `n1` 1.5, `veb3` 1.3, `rst` 1.1 |
| `vref` | 66.8 | 19.2 | 51.6 | 137.6 | `vb` 15.4, `veb3` 12.2, `vcap` 6.2, `ichb` 2.5, `vthr` 2.4, `vpg` 1.4 |
| `veb3` | 30.8 | 5.0 | 21.0 | 56.8 | `vref` 12.2, `ib_cmp1` 3.7 |
| `ib_cmp1` | 26.7 | – | 49.2 | 75.9 | `ib_cmp2` 9.0, `vcap` 7.0, IBIAS 6.4, `vthr` 5.3 |
| `ib_cmp2` | 57.4 | 3.5 | 16.1 | 77.0 | `ib_cmp1` 9.0, `nb` 1.5, `n1` 1.1, IBIAS 0.5, `vref` 0.4 |
| comparator `n1` / `nd` | 1.8 / 12.9 | 9.7 / 34.0 | 24.8 / 26.7 | 36.3 / 73.6 | each other 11.6 |
| `vpg` | 116.8 | 441.0 | 57.9 | 615.7 | `cz` 23.7, IBIAS 7.8, `vb` 4.9, `va` 3.4 |
| `nb` | 66.6 | 4.7 | 11.9 | 83.2 | `ib_cmp1` 2.1, `iptat_mon` 1.6, `ib_cmp2` 1.5 |
| `ichb` / `i3b` | 13.7 / 7.9 | 4.8 / 6.7 | 8.0 / 12.0 | 26.5 / 26.6 | – |
| `va` / `vb` | 17.9 / 22.9 | 16.3 / 14.8 | 34.8 / 54.7 | 68.9 / 92.3 | each other 21.8 |

- **C(`vcap`).** The four MIM units are 5.06 pF in the model and the wiring adds 0.099 pF: 5.16 pF, inside the spec's 5.06–5.3 pF row. With the overlap left in it would read 5.38 pF. The wiring part is 2 % of the capacitor and linear, so it scales both periods alike.
- **`ichb`** carries 26.5 fF; the M6 loop runs assumed 30 fF there (spec R4).
- **`vpg`** gains 0.62 pF on a 16.06 pF gate line (3.8 %), 0.44 pF of it to VDPWR from the met1 plates over the mirror channels (results_m5 section 14 estimated 7 fF per finger, 0.2 pF).
- **The couplings the layout notes asked about:**
  - `rst` over `vthr`'s riser: 1.14 fF (hand: ≈ 1 fF).
  - `vcap` along the bottom strip: nothing above 0.6 fF to a line that moves during a conversion, apart from the comparator's own nodes; `vref_mon_en` (1.7 fF) is static.
  - `ib_cmp2` between its shields: 57.4 fF to VGND, and 1.5 fF to `nb`, 0.5 fF to IBIAS, 0.4 fF to `vref`, nothing to `vpg` or `su` (spec R21's list).
- **One coupling that was not in any schematic run: `vcap` – `vref`, 6.2 fF,** inside `bgr`, where P4's and P3's drain lines share the mirror's channels. `vref` has 204 kΩ behind it, so the ramp on `vcap` lifts it by C · R · slope = 6.2 fF × 204 kΩ × 0.27 V/µs ≈ 0.35 mV while the ramp runs, in the REF period only. Section 5 measures +0.36 mV at 25 °C.

## 3. Resistance of the tile routes

`mag/rledger.py` reads the route data of `tw.py`: each shape counts as length ÷ width squares of its layer (met1, met2 0.125 Ω/sq; met3, met4 0.047 Ω/sq), one via per stack level (via1 4.5 Ω, via2 and via3 3.41 Ω). All shapes of a net are taken in series, so a route with side branches reads high.

| net | length by layer (µm) | wire + vias (Ω) | carries | what it costs |
|---|---|---|---|---|
| `vref` | met2 229, met4 116, met3 11 | 87 | no DC (gates, the decap) | 0.17 ns against the 2 pF decap |
| `veb3` | met1 213, met4 113 | 82 | no DC | under 1 % of Q3's 9.4 kΩ |
| `ib_cmp1` / `ib_cmp2` | met3 221 / 235, met4 105 / 86 | 52 / 52 | 5.5 µA each | 0.29 mV on the drain of a current sink |
| `vcap` | met4 197, met3 125 | 38 | I_ch 1.39 µA | 52 µV between P4's drain and the capacitor; P4 is a current source |
| `iptat_mon` | met4 114, met3 43 | 34 | 1.39 µA when on | same |
| `su` | met4 315, met3 52 | 56 | no DC | – |
| `ua[0]` / `ua[1]` pad lines | met4 80 / 106 | 16 / 31 | – | against a 35–437 kΩ switch |
| `rst`, `cmp_raw`, `osc_en`, `thr_sel` | met4 83–117 | 24–35 | logic | under 1 ps into 20 fF |
| monitor enables | met4 ≈ 320 | 61 | static | – |

- The reset loop stays local to `osc_core` (≈ 6 Ω against 24 Ω of headroom, results_m6 section 13g); the tile adds nothing to it.
- Ground: `osc_core` returns to the left VGND stripe through two met1 links and 2 × 2 stacks (under 2 Ω, ≈ 12 µA: 24 µV). `bgr` returns to the right stripe. A difference between the two grounds adds to both thresholds alike, like the fixed offset V_o of results_m6 section 8.

## 4. The bench, and the schematic tile against the frozen blocks

**Bench.** `xschem/tile15.py` builds one deck around the tile and nothing inside it is forced: VDPWR, the eight `ui_in` as sources, 100 fF on each `uo_out`, 20 fF on each `uio` output, `ua[0]` through 500 Ω and 5 pF into a 1 GΩ meter (pull-down cut), `ua[1]` through 500 Ω and 5 pF into 100 kΩ. The same deck takes either netlist.

**Run length.** The whole tile at a 0.2 ns step costs 6 ms per step from the schematic and 18 ms from the extraction (1 335 devices, 4 255 capacitors once the zero-valued ones are dropped): hours per run. Three things bring a run to 20–50 minutes without touching the analog path:
- a DC start: the supply is at its value from t = 0. Every flop and latch in the tile is held by an input that is 0, so the operating point is the started one and no other;
- the 816 transistors of the three rings left out (`schq`, `pexq`; their nets become VGND in the parasitics). `ring_en` is 0 through a conversion;
- in `pexq`, couplings under 0.05 fF moved to VGND on both sides, so every net keeps its total: 1 109 capacitors, 870 of them couplings.
- `tile15.py prep` checks `pexq`'s devices against `schq` in netgen: "Circuits match uniquely".

**The tile netlist is the frozen design.** Driven only at its pins, every input 0 at the start:
- DC start, tt 1.80 V: V_REF 1.23914 / 1.24324 / 1.24412 V and V_EB3 0.78681 / 0.70961 / 0.57452 V at −20 / 25 / 100 °C, the values of `mu_dc.csv`, from both netlists (the extraction reads 10 µV higher at −20 and 100 °C). `bg_ok` = VDPWR, `osc_out` = 0, the tied outputs ≤ 0.009 mV.
- Supply current at rest 25.1 / 29.1 / 35.0 µA: 52 µW at 25 °C, 63 µW at 100 °C (limit 100 µW). Running adds 0.1–0.4 µA.
- The loop from the schematic tile (tt 1.80 V, −20 / 25 / 100 °C): f_REF 179.4 / 205.9 / 246.1 kHz; μ 1.55 / 2.07 / 2.73 % under μ_DC; t_d 78.5 / 72.6 / 63.9 ns; `rst` 10.4 / 11.2 / 12.5 ns wide; `vthr` at the REF crossing +3.07 / +3.33 / +3.80 mV above resting V_REF. Section 9 of results_m6: 179 / 206 / 246 kHz, 1.6 / 2.1 / 2.8 %, +3.07 / +3.33 / +3.79 mV.
- Two-slope μ0 (r = 0.565): 0.363648 / 0.426397 / 0.532706, against 0.363566 / 0.426293 / 0.532554 in results_m6 section 11e (+0.8…+1.5e-4). Those runs carried 30 fF on `ichb` (spec R4) and held `iptat_mon` at 0.7 V; the schematic side here has neither, and the extraction has the real 26.5 fF.
- Bandgap loop, tt 25 °C, monitor off: f_u 230.7 kHz, PM 87.4°, GM 16.2 dB (results_m5 section 6b: 230.2 kHz, 87.9°, 16.15 dB with P7 parked on an ideal source).

## 5. The oscillator: extracted against schematic

`tile15.py mu`: DC start, `osc_en` at 3 µs, 8.5 REF periods (the last 5 measured), `thr_sel` → EB for 11.5 periods (periods 6–10 measured), 0.2 ns step, `reltol` = 1e-4, state A, `schq` and `pexq`. tt 1.80 V at −20 / 25 / 100 °C at both slopes; ss −20 °C 1.71 V and fs 100 °C 1.71 V at full slope. Output `simulation/tile15/mu.md`, `mu.json`.

**Full slope** (schematic → extracted):

| point | T_REF (µs) | f_REF (kHz) | t_d, REF (ns) | dead time, REF (ns) | dead time, EB (ns) | `rst` width (ns) | μ | Δμ |
|---|---|---|---|---|---|---|---|---|
| tt −20 °C 1.80 V | 5.5745 → 5.7216 | 179.4 → 174.8 | 78.5 → 98.0 | 90.7 → 113.1 | 92.5 → 115.0 | 10.4 → 12.5 | 0.359372 → 0.358439 | −9.3e-4 |
| tt 25 °C 1.80 V | 4.8568 → 4.9855 | 205.9 → 200.6 | 72.6 → 89.3 | 85.9 → 105.4 | 87.6 → 107.2 | 11.2 → 13.4 | 0.420336 → 0.419221 | −1.12e-3 |
| tt 100 °C 1.80 V | 4.0640 → 4.1725 | 246.1 → 239.7 | 63.9 → 77.2 | 78.8 → 95.1 | 82.4 → 99.1 | 12.5 → 14.8 | 0.523494 → 0.522007 | −1.49e-3 |
| ss −20 °C 1.71 V | 5.5454 → 5.6930 | 180.3 → 175.7 | 82.8 → 102.6 | 98.5 → 122.2 | 100.6 → 124.3 | 13.3 → 16.1 | 0.358753 → 0.357713 | −1.04e-3 |
| fs 100 °C 1.71 V | 4.0585 → 4.1662 | 246.4 → 240.0 | 54.6 → 66.6 | 70.8 → 86.0 | 76.3 → 92.0 | 13.4 → 16.0 | 0.523686 → 0.522258 | −1.43e-3 |

*Dead time = from `vcap` crossing `vthr` to the reset switch opening (t_d + logic + switch-on time): the t_add of `tadd_table.csv`.*

- **Periods are 2.64–2.67 % longer**: about 2 % from the wiring on `vcap` (99 fF on 5.06 pF) and 0.4 % from the dead time. f_REF 174.8 / 200.6 / 239.7 kHz.
- **The dead time grows by 15–24 ns (21–25 %).** The comparator takes 12.0–19.8 ns of it, the logic 0.5–0.8 ns, the switch-on time 2.2–3.0 ns (the delay line's nodes carry wiring too, so `rst` is 12.5–16.1 ns wide).
- **Against the R12 rows:** t_d ≤ 100 ns holds at tt (98.0 / 89.3 / 77.2 ns) and misses at ss −20 °C 1.71 V by 2.6 ns (REF) and 4.7 ns (EB). t_add ≤ 90 ns nominal misses: 113.1 / 105.4 / 95.1 ns at −20 / 25 / 100 °C.
- EB − REF dead time: +1.9 / +1.8 / +4.0 ns at tt (schematic +1.8 / +1.7 / +3.6) and +6.0 ns at fs 100 °C (schematic +5.6): the R18 exception, 0.1–0.5 ns larger.
- Raw μ at full slope sits 0.9–1.5e-3 lower (−0.65 / −0.77 / −1.03 K at −20 / 25 / 100 °C). It is the same on every chip, and it is why the curve and the tables firmware uses must come from the extracted netlist.
- `vthr` at the REF crossing: +3.34 / +3.69 / +4.28 mV above resting V_REF, that is +0.27 / +0.36 / +0.48 mV more than the schematic: the `vcap` – `vref` coupling of section 2 (hand 0.35 mV). At the EB crossing nothing changes (+0.39…+0.52 mV in both).
- V_REF with the oscillator running, against rest: −13 / −26 / −51 µV at tt (schematic −1 / −3 / −9 µV), −46 µV at fs 100 °C, +1 µV at ss −20 °C; −2…+8 µV at half slope. R21's line is 50 µV: the 100 °C point sits on it. `nb` ripple 42.4 / 46.8 / 54.1 mV p-p (schematic 40.6 / 45.3 / 53.4).
- Settling after `thr_sel`: the first EB period is 1.1–3.0e-3 short, the second within 2.4e-4, the third within 4e-5, the rest within 2.2e-5 (row: μ inside 1e-4 within 8 periods).
- `osc_out`: one edge per `rst` pulse in all 16 runs, 0.9–1.6 ns after it (schematic 0.5–1.1 ns). Reset pedestal: `vcap` minimum −2.8…−4.2 mV, within 0.05 mV of the schematic at every point.
- `ua[0]` with its switch off: 2.2–2.8 pA into the meter at −20 and 25 °C, 6.9–10.9 pA at 100 °C (limit 0.1 nA). `ua[1]`: under 0.2 pA.

**Half slope and the two-slope result** (tt 1.80 V, `ich_sel` = 1; schematic → extracted):

| T (°C) | μ, half slope | dead time, REF, half slope (ns) | r, REF | r, EB | μ0 (r = 0.565) | Δμ0 | as K | minus the 25 °C value (K) |
|---|---|---|---|---|---|---|---|---|
| −20 | 0.361220 → 0.360528 | 101.5 → 130.7 | 0.560 → 0.578 | 0.572 → 0.589 | 0.363648 → 0.363277 | −3.7e-4 | −0.26 | +0.025 |
| 25 | 0.422952 → 0.422139 | 96.0 → 121.0 | 0.558 → 0.574 | 0.570 → 0.584 | 0.426397 → 0.425991 | −4.1e-4 | −0.28 | 0 |
| 100 | 0.527461 → 0.526421 | 86.2 → 106.7 | 0.547 → 0.561 | 0.566 → 0.577 | 0.532706 → 0.532266 | −4.4e-4 | −0.31 | −0.023 |

*r = half-slope dead time ÷ (2 × full-slope dead time); 1/μ0 = 1/μ_half − k (1/μ_full − 1/μ_half), k = r/(1 − r).*

- **The two-slope extraction takes the extra delay out.** With one r for both netlists, μ0 moves by −3.7…−4.4e-4, nearly the same at the three temperatures. **After a one-point trim at 25 °C the layout leaves +0.025 K at −20 °C and −0.023 K at 100 °C** (spec M8 row: PEX delta ≤ 0.2 K after the trim: pass, 8× inside). Against the frozen M6 values, which already carried 30 fF on `ichb`, the extraction sits at −2.9 / −3.0 / −2.9e-4.
- The spec M9 row, |Δμ(25 °C)| ≤ 1.5e-4 between extraction and schematic with no trim, misses: −4.1e-4 in μ0, −1.1e-3 in the raw full-slope μ.
- **r is 0.012–0.018 higher in the layout** (REF 0.561–0.578, EB 0.577–0.589; band 0.58 ± 0.04). Extra capacitance on `n1` adds a part of the delay that grows as the slope falls. `rcoef_table.csv`, `tadd_table.csv`, `chi_loop_table.csv` and the μ→T curve are schematic values; the firmware constants have to be regenerated from the extracted netlist.

## 6. Which wiring slows the comparator

`tile15.py sens`: `pexq` at tt, 25 °C, 1.80 V, REF, full slope, with the wiring capacitance of one group of nets taken out at a time (every capacitor with a terminal on the net). Output `simulation/tile15/sens.md`.

| wiring removed | removed (fF) | t_d (ns) | logic (ns) | switch on (ns) | dead time (ns) | change (ns) |
|---|---|---|---|---|---|---|
| nothing | 0 | 89.2 | 1.14 | 15.0 | 105.4 | – |
| `n1`, stage 1's output | 36.3 | 71.9 | 1.13 | 15.0 | 88.0 | **−17.4** |
| `nd`, stage 1's diode side | 73.6 | 81.4 | 1.14 | 15.0 | 97.5 | −7.9 |
| `ib_cmp2`, stage 2's output (the bias wire) | 77.0 | 84.1 | 1.14 | 15.0 | 100.2 | −5.2 |
| `ib_cmp1`, the tail (the bias wire) | 75.9 | 87.0 | 1.14 | 15.0 | 103.2 | −2.2 |
| the inverter node and `cmp_raw` | 20.2 | 88.7 | 1.10 | 15.0 | 104.8 | −0.6 |
| the one-shot's nodes and `rst` | 48.7 | 89.2 | 0.84 | 12.65 | 102.7 | −2.7 |
| all six | 298.5 | 66.6 | 0.79 | 12.65 | 80.1 | −25.3 |
| the `vcap` – `vref` coupling alone | 6.2 | 89.2 | 1.15 | 15.0 | 105.4 | 0 (T_REF −6.7) |

- **36 fF on `n1` is 17.4 of the 19.5 ns.** `n1` idles at VDPWR and must fall ≈ 0.65 V before M3 conducts, on a current that starts at zero at the crossing, so every fF there is slow charge. Its 36 fF: 11.6 to `nd`, 9.7 to VDPWR, 5.4 to `vcap`, 4.8 to `ib_cmp1`. Most of it is the A B B A A B B A interleave of the pair and load rows, where the drains of the two sides lie next to each other: the price of the common-centroid layout that holds σ(Vos).
- `nd` costs 7.9 ns, `ib_cmp2` 5.2 ns (57 of its 77 fF is the shield of spec R21), the one-shot's wiring 2.7 ns (its switch-on time returns to the schematic's 12.65 ns).
- The parts do not add (35.9 ns summed, 25.3 ns together), as expected of a delay that grows more slowly than the charge the stage must move.
- With all six removed t_d is 66.6 ns, under the schematic's 72.6 ns. The schematic gives every finger its own drain and source junction; in the layout neighbours share them.
- The `vcap` – `vref` coupling shortens T_REF by 6.7 ns when removed: 6.0 ns as 6.2 fF less load on a 5.16 pF node, 0.7 ns as the lift of `vref`. The dead time does not change.

## 7. Every input pin in turn

`tile15.py modes`: tt, 25 °C, 1.80 V, 1 ns step, one run from the DC start; `schq` and `pexq`. Output `simulation/tile15/modes.md`.

| phase | `ui_in` | T, schematic (µs) | T, extracted (µs) | V_REF, extracted (V) | V_EB3 (V) | `vcap` peak, extracted (V) | I_DD, extracted (µA) |
|---|---|---|---|---|---|---|---|
| REF | 0x01 | 4.8569 | 4.9856 | 1.2431 | 0.7096 | 1.268 | 29.4 |
| EB (`thr_sel`) | 0x03 | 2.8154 | 2.8956 | 1.2431 | 0.7095 | 0.732 | 29.6 |
| half slope (`ich_sel`) | 0x11 | 9.5999 | 9.7975 | 1.2430 | 0.7096 | 1.258 | 29.3 |
| chop state B (`chop_sel`) | 0x21 | 4.8569 | 4.9856 | 1.2431 | 0.7096 | 1.268 | 29.4 |
| half current (`i3_sel`) | 0x81 | 3.7789 | 3.8831 | 0.9605 | 0.6917 | 0.986 | 29.4 |

- Every pin does what `docs/info.md` says. Half slope: the period is 1.977× (schematic) and 1.965× (extracted) the full-slope one, and the overshoot above the threshold halves. State B: the same period within 7 ppm (no mismatch in a nominal run). Half current: V_REF′ 0.9605 V and V_EB3′ 0.6917 V (results_m6 section 11e: 0.961 V).
- The 1 ns run gives the same periods as the 0.2 ns runs of section 5 (4.9856 against 4.9855 µs).
- `osc_out`: one edge per `rst` pulse; one more when `osc_en` falls while the output is high (the toggle is reset). No pulse after `osc_en` falls. `bg_ok` stays high through every switch.
- **`vref_mon_en` (0x04):** `ua[0]` reads 1.24296 V on the 1 GΩ meter with V_REF at 1.24299 V, which is 0.25 mV under its resting value: the meter's 1.24 nA through the 204 kΩ behind `vref`. Closing the switch onto the pad's 5 pF pulls V_REF down to 0.37–0.39 V for a moment (charge sharing with the 2 pF decap); it is back within the 20 µs phase and `bg_ok` does not move. Not a pin to touch during a conversion.
- **`iptat_mon_en` (0x08):** 140.38 mV across 100 kΩ, 1.4038 µA; I_DD rises from 29.10 to 30.51 µA.

## 8. The bandgap loop

`tile15.py stb`: the Middlebrook double injection of results_m5 section 6 at the same break (the `ota2s` output against the gate line), on two copies of the whole tile, from the schematic and from the full extraction. In the flat netlist the break moves MP3 (6 fingers), MN3 and the 8 Cc units onto the op-amp side. State A, every input 0, or `iptat_mon_en` = 1 with `ua[1]` into 100 kΩ. Output `simulation/tile15/stb.md`.

| corner, VDD | T (°C) | f_u (kHz), sch → ext | PM (°) | GM (dB) |
|---|---|---|---|---|
| tt 1.80 V | −20 | 209.7 → 206.5 | 89.7 → 88.1 | 16.5 → 17.4 |
| tt 1.80 V | 25 | 230.7 → 226.7 | 87.4 → 85.6 | 16.2 → 17.1 |
| tt 1.80 V | 100 | 258.8 → 253.5 | 84.1 → 82.1 | 15.8 → 16.7 |
| ss 1.80 V | −20 | 208.5 → 205.4 | 89.4 → 87.9 | 16.7 → 17.6 |
| ss 1.80 V | 100 | 257.9 → 252.8 | 83.8 → 81.9 | 16.0 → 16.9 |
| ff 1.80 V | −20 | 210.8 → 207.6 | 90.0 → 88.4 | 16.2 → 17.2 |
| ff 1.80 V | 100 | 259.3 → 253.9 | 84.4 → 82.4 | 15.6 → 16.5 |
| sf 1.71 V | 100 | 253.6 → 248.7 | 83.6 → 81.7 | 16.3 → 17.3 |
| ff 1.89 V | 100 | 262.5 → 257.0 | 84.5 → 82.5 | 15.3 → 16.3 |

*Monitor off. With the monitor on: f_u +0.3…+0.4 %, PM +0.3°, GM −0.4 dB in both netlists.*

- **Extracted, over the 18 points: PM 81.7–88.7°, f_u 205.4–258.0 kHz, GM 15.9–17.6 dB** (rows: PM ≥ 60°, 50–350 kHz, GM ≥ 10 dB). The layout costs 1.6–2.0° of phase margin and 1.5–2.1 % of f_u, and gives 0.9–1.0 dB of gain margin; T0 and the operating point do not move (V_REF within 10 µV, va − vb 29.5 µV).
- The 0.62 pF added to the gate line (section 2) is the f_u loss; 3.8 % more load on the op-amp's output.

## 9. Supply ramps

`tile15.py startup`: VDPWR from 0 to 1.62 V, every input 0, the whole tile from the schematic and from the full extraction (rings included). Output `simulation/tile15/startup.md`.

| corner, T | ramp | V_REF at the end (V), sch / ext | V_REF inside 1 % for good (sch / ext) | V_REF peak (V) | `bg_ok` |
|---|---|---|---|---|---|
| tt 27 °C | 1 µs | 1.24236 / 1.24236 | 12.8 / 12.1 µs after the ramp | 1.340 / 1.337 | high 1.2 / 1.5 µs after the ramp |
| ss −40 °C | 1 µs | 1.23639 / 1.23640 | 38.7 / 32.3 µs after | 1.424 / 1.441 | 1.7 / 2.0 µs after |
| ff 125 °C | 1 µs | 1.24029 / 1.24030 | 7.0 / 7.2 µs after | 1.369 / 1.363 | 0.6 / 0.7 µs after |
| tt 27 °C | 10 ms | 1.24236 / 1.24236 | 1.06 ms before the ramp ends (VDPWR 1.45 V) | 1.243 / 1.243 | follows VDPWR from below 0.81 V |
| ss −40 °C | 10 ms | 1.23639 / 1.23640 | 1.30 / 1.29 ms before (1.41 V) | 1.242 / 1.246 | from VDPWR = 0.98 / 1.00 V |
| ff 125 °C | 10 ms | 1.24029 / 1.24030 | 0.74 ms before (1.50 V) | 1.241 / 1.241 | follows VDPWR from below 0.81 V |

- **Row: V_REF within 1 % no later than 100 µs after the ramp: pass at all six points in both netlists** (worst 38.7 µs schematic, 32.3 µs extracted, at ss −40 °C). No stuck state; the end values agree within 10 µV. Supply current at the end 29.2 / 23.6 / 36.7 µA at 1.62 V.
- `osc_out` stays under 45 mV through every ramp (`osc_en` = 0 holds the toggle in reset).
- **`bg_ok` says the bias is running, not that V_REF has arrived.** In a slow ramp it is high from VDPWR ≈ 0.8–1.0 V, while V_REF reaches its 1 % band at 1.41–1.50 V. After a fast ramp it leads V_REF by 6–37 µs. The 1 ms wait in `docs/info.md` covers both.

## 10. The rings with the extracted wiring

`tile15.py rings`: the full extraction, DC start with `ring_en` = 0, `ring_en` up at 1 ns, 10 ps step, 560 ns; each pad's frequency from its last two rising edges. Output `simulation/tile15/rings.md`. "Table" is `docs/ring_table.csv`, the schematic sweep of results_m7 section 2 with 1.5 fF per stage net.

| point | `uo_out[1]`, ring_n ÷32 (MHz), table → extracted | `uo_out[3]`, ring_p ÷32 | `uo_out[6]`, ring_d ÷16 | f_n / f_p | I_DD (µA) |
|---|---|---|---|---|---|
| tt 25 °C 1.80 V | 8.767 → 7.510 | 7.405 → 6.624 | 5.183 → 3.366 | 1.184 → 1.134 | 270 |
| ff −20 °C 1.89 V | 11.017 → 9.559 | 9.555 → 8.643 | 7.067 → 4.653 | 1.153 → 1.106 | 352 |
| ss −20 °C 1.71 V | 6.427 → 5.443 | 5.007 → 4.426 | 6.878 → 4.333 | 1.284 → 1.230 | 204 |
| sf −20 °C 1.71 V | 7.309 → 6.307 | 5.591 → 5.004 | 4.016 → 2.567 | 1.307 → 1.260 | 202 |

- **The rings are slower than the table, not faster:** ring_n by 13–15 %, ring_p by 10–12 %, ring_d by 34–37 %. The wiring between stages is what the sweep assumed (median 1.7 / 1.4 / 1.6 fF per stage net of ring_n / ring_p / ring_d, against 1.5 fF). The rest is inside the cells: the library's SPICE netlists carry no capacitor at all, and the extraction has the cells' own wiring (346 internal nets, 0.54 fF median). `dlygate4sd3_1` has three internal nodes on L = 0.5 µm devices, so the delay ring loses most.
- **Pads:** `uo_out[1]` 5.44–9.56 MHz, inside 5–15 MHz at the four points. `uo_out[3]` 4.43–8.64 MHz: under 5 MHz at ss −20 °C 1.71 V. `uo_out[6]` 2.57–4.65 MHz: under the 4 MHz of spec R25 at tt and at sf −20 °C 1.71 V. The highest pad is 9.56 MHz, so the 15 MHz side and the 33 MHz pad limit are far away.
- Counts in a 1 ms ring phase: at least 4 400 on `uo_out[3]`; 2 570–4 650 on `uo_out[6]`, which is 0.27–0.15 mV of VDD per count at ring_d's 1.46 % per 10 mV.
- **f_n / f_p is 3.6–4.2 % lower than the table at every point**, as large as the sf / fs signal it is read for (2.4–4.4 %). `ring_table.csv` has to be regenerated from the extracted netlist before firmware classifies a corner with it.
- Supply current with the three rings running: 202–352 µA (270 µA at tt, 216 µA in the schematic sweep).

## 11. Against the spec rows

| row (spec chapter) | limit | result | |
|---|---|---|---|
| Antenna (M9) | 0 violations | 0 after the six input bridges (4 before) | pass |
| Flat extraction is the circuit (M9 LVS) | match, no substrate port | "Circuits match uniquely", none | pass |
| C(`vcap`) (M8) | 5.06–5.3 pF | 5.16 pF | pass |
| Power (M8, M9) | ≤ 100 µW | 52 µW at 25 °C, 63 µW at 100 °C, both netlists | pass |
| Tied outputs, `bg_ok` (M9 `tb_top_static`) | < 1 mV; VDPWR | ≤ 0.009 mV; VDPWR | pass |
| `osc_out` toggles once per `rst`; `rst` width follows the delay line (M8 G1) | – | 16 of 16 runs; 12.5–16.1 ns extracted | pass |
| Settling after `thr_sel` (M8) | μ inside 1e-4 within 8 periods | inside 4e-5 from the third | pass |
| PEX delta after the trim (M8) | ≤ 0.2 K | +0.025 K at −20 °C, −0.023 K at 100 °C (two-slope μ0) | pass |
| Post-layout μ against schematic, no trim (M9) | \|Δμ(25 °C)\| ≤ 1.5e-4 | −4.1e-4 two-slope, −1.12e-3 raw | **miss** |
| t_d (R12) | ≤ 100 ns | tt 98.0 / 89.3 / 77.2 ns; ss −20 °C 1.71 V 102.6–104.7 ns | **miss at the slow corner** |
| t_add, nominal (R12) | ≤ 90 ns | 113.1 / 105.4 / 95.1 ns | **miss** |
| EB − REF delay (R18 exception) | +1.9…+5.8 ns accepted | +1.8…+6.0 ns | 0.2 ns over |
| r band (M6) | 0.58 ± 0.04 | 0.561–0.589 | pass |
| V_REF move when the oscillator runs (R21) | ≤ 50 µV | −51 µV at tt 100 °C full slope, less elsewhere | on the line |
| Bandgap loop (M9) | PM ≥ 60°, f_u 50–350 kHz | 81.7–88.7°, 205–258 kHz | pass |
| Startup (M9) | V_REF within 1 % ≤ 100 µs; 1 µs and 10 ms ramps | ≤ 32.3 µs extracted, ≤ 38.7 µs schematic | pass |
| Monitor switch leakage (M9) | ≤ 0.1 nA at 100 °C | 10.9 pA | pass |
| Ring pads (R25) | `uo_out[1]`, `[3]` 5–15 MHz; `uo_out[6]` 4–15 MHz | 5.44–9.56; 4.43–8.64; 2.57–4.65 MHz at four points | **`[3]` and `[6]` under their windows**; pad limit far |

- Not run here: the count model against these transients (M8's "model matches the transient" row; the model does not exist yet), the corner grid and Monte Carlo on the extracted netlist (M8 gate G2), and the firmware tables from the extracted netlist (sections 5 and 10).

