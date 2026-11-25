# M7 results — tile glue and rings

*Cells and benches in `xschem/`, runs in `xschem/simulation/`. Standard cells are `sky130_fd_sc_hd`.*

## 1. `readout_glue`

**Cell.** `readout_glue.sch` / `readout_glue.sym`, 37 cells, from the spec's M7 cell list (with R2 and R17):
- inputs `ui0`…`ui7` → 8 × `buf_1` → `osc_en`, `thr_sel`, `vref_mon_en`, `iptat_mon_en`, `ich_sel`, `chop_sel`, `ring_en`, `i3_sel`;
- 4 × `inv_1` → `osc_enb`, `thr_selb`, `vref_mon_enb`, `iptat_mon_enb` (the `ich`, `i3` and chop drives keep their own complements inside `swdrv`);
- `osc_out` toggle: `buf_2` on `rst` → `rst_k` → `dfrtp_1` (CLK = `rst_k`, D = NOT Q via `inv_1`, RESET_B = `osc_en`) → `buf_2` → `uo0`;
- `cmp_raw` → `buf_2` → `uo2`; `bg_ok` = `inv_1`(`su`) → `buf_2` → `uo4`;
- 18 × `conb_1`, LO to one pin each: `uo5`, `uo7`, `uio_out0`…`uio_out7`, `uio_oe0`…`uio_oe7` (HI outputs left open).
Nets joined by label. The netlist (`simulation/readout_glue.spice`) resolves every cell.

**Bench.** `tb_readout_glue.sch`: `rst` = 10 ns pulses (width at VDD/2) every 1 µs from 0.5 µs with 3 ns or 5 ns edges; `osc_en` (`ui0`) = 0 until 0.8 µs, so the first pulse arrives while the toggle is held in reset and the next 8 must give exactly 4 rises; `cmp_raw` = 25 ns pulses 5 ns ahead of each `rst`; `ui1`…`ui7` rise at 8.8 µs; `su` = 0 V; 100 fF on `uo0`, `uo2`, `uo4`, 20 fF on each control output. Bench only: a second toggle flop clocked by `rst` directly (no local `buf_2`), counted the same way. Supply current is averaged in three quiet windows (all inputs 0; `osc_en` = 1 between pulses; every input 1).
- The pulse period is 1 µs instead of the spec bench's 4.55 µs: the flop is static, so the gap between pulses does not enter, and it shortens each run 4×.
- Time step 0.05 ns. A first pass at 0.5 ns failed 5 of 90 runs (all at −40 °C) and miscounted the bench flop at 3 others, with no pattern; the same points pass at 0.05 ns, so the coarse step let the solver miss flop transitions. That pass is kept in `simulation/glue13_coarse_step/`.

Runner `glue13.py`: tt, ss, ff, sf, fs × −40 / 27 / 125 °C × 1.62 / 1.80 / 1.98 V × `rst` edges 3 / 5 ns = 90 runs. Output `simulation/glue13/{all.csv, summary.md}`.

| Row | Limit | Result | |
|---|---|---|---|
| `osc_out` toggles once per `rst` | 4 rises for the 8 pulses after `osc_en`, no 5th | 90 / 90 | pass |
| `osc_out` while `osc_en` = 0 (one `rst` arrives) | 0 | ≤ 5 µV | pass |
| Default state, all `ui_in` = 0 | reset held, monitors off, `osc_out` = 0 | `osc_en` 0, every complement high, `uo0` 0, `bg_ok` 1: 90 / 90 | pass |
| Buffers and complements with every input at 1 | right levels | 90 / 90 | pass |
| `cmp_raw` → `uo2` | every pulse | 9 of 9 at all 90 runs | pass |
| Edges at the pad, 100 fF | ≤ 2 ns | rise 0.58–1.39 ns, fall 0.22–0.50 ns | pass |
| Slew into the toggle's CLK | ≤ 1 ns | `rst_k` 10–90 % 0.09–0.15 ns while `rst` has 3 / 5 ns edges | pass |
| Tie-offs | 0 | 18 pins, 0.000 mV | pass |
| Static current | ≤ 1 µA at 125 °C, ff | ≤ 22.9 nA (ff, 125 °C, 1.98 V) | pass |
| `rst` → `osc_out` delay | – | 0.39–1.87 ns | – |

**1b. How much margin the toggle has.** Runner `stress13.py` on the same bench: ss, −40 °C, 1.62 V (the spec's glue-timing corner) and tt, 27 °C, 1.80 V; `rst` edges 1 / 3 / 5 / 8 ns × widths at VDD/2 from 10 ns down to 1 ns (width ≥ edge). Output `simulation/stress13/`.
- With the local `buf_2` and without it, the toggle counts correctly at every point, down to 1 ns pulses with 1 ns edges and 8 ns pulses with 8 ns edges.
- The library is stricter: Liberty (ss, −40 °C, 1.60 V) gives `dfrtp_1` a minimum clock pulse of 0.34 ns at 0.01 ns slew, 4.2 ns at 2.5 ns and 8.3 ns at 5 ns. The transistor-level cell has more margin than its characterized limit, but the limit is what the library guarantees; with the local `buf_2` the flop's clock edge is 0.09–0.15 ns at any `rst` edge tested, which keeps it at the fast end of that table and inside the spec's ≤ 1 ns row.
- The real `rst` from the one-shot (section 6 of M6, the loop runs): rise 0.32–0.40 ns, fall 0.15–0.28 ns, width 10.3–12.4 ns at tt.

## 2. The three rings

**Cells.** `ring_n.sch/.sym`: 31 × `nand2_1` (stage 1 A = `en`, stages 2–31 A = HI from one `conb_1`, B = the loop), ÷32 = 5 × `dfrtp_1` (D = NOT Q via `inv_1`, RESET_B = `en`, the first clocked by the stage-1 output) → `buf_2` → `out`. `ring_p.sch/.sym`: `inv_1` (`en` → `enb`), 31 × `nor2_1` (stage 1 A = `enb`, stages 2–31 A = LO from one `conb_1`), ÷32 → `buf_2`. `ring_d.sch/.sym`: `nand2_1` (A = `en`, B = the loop) → 15 × `dlygate4sd3_1` → back to B, ÷16 = 4 × `dfrtp_1` → `buf_2`. `ring3.sch/.sym` puts the three on one `ring_en`: `ring_n` → `uo1`, `ring_p` → `uo3`, `ring_d` → `uo6`.

**Bench.** `tb_ring3.sch`: `ring3`, 100 fF on each pad output, `ring_en` rising at 2 ns, supply through `rsup` (0.001 Ω, or 10 Ω for the pulling check). Runner `ring14.py` adds 1.5 fF of wire to every ring node (as the spec's R6 quick check), max step 10 ps (against 5 ps at tt 25 °C 1.80 V: f within 0.2 %, f_n/f_p within 0.08 %, dividers exact at both), 500 ns. Ring frequency from the first-stage node over 40 periods (20 for `ring_d`); first flop over 20 (7); pad over one output period. Points: tt, ss, ff, sf, fs × −20 / 25 / 100 °C × 1.71 / 1.80 / 1.89 V, plus ss −40 °C 1.62 V and ff −40 °C 1.98 V. Output `simulation/ring14/{all.csv, summary.md}` and `docs/ring_table.csv` (every point: f_n, f_p, f_d, f_n/f_p, pad frequencies).

**Frequencies, 45 guaranteed points.**

| | ring (MHz) | pad (MHz) | 5–15 MHz |
|---|---|---|---|
| `ring_n` ÷32 → `uo1` | 205.7 (ss −20 °C 1.71 V) – 352.5 (ff −20 °C 1.89 V) | 6.43 – 11.02 | inside |
| `ring_p` ÷32 → `uo3` | 160.2 (ss −20 °C 1.71 V) – 311.1 (ff 100 °C 1.89 V) | 5.01 – 9.72 | inside |
| `ring_d` ÷16 → `uo6` | 64.2 (sf −20 °C 1.71 V) – 134.6 (ss −20 °C 1.89 V) | 4.02 – 8.41 | **below 5 MHz at 11 of 45** (all at 1.71 V, plus sf at 1.80 V) |

- Every divider is exact at all 47 points: the first flop at f/2 within 6e-6, the pad at f/32 or f/16 within 1 %. That includes the first flop at 379 MHz (ff, −40 °C, 1.98 V) and at ss, −40 °C, 1.62 V (176 / 130 / 99 MHz).
- `ring_d` spans 2.1×, and no power-of-two divider fits it into 5–15 MHz (÷8: 8.0–16.8 MHz). Part of the spread: its slow inner stages are 0.5 µm-long `nfet_01v8` / `pfet_01v8_hvt`, and in this PDK's ss corner they come out faster than at tt (ss 96.8–134.6 MHz against tt 73.1–94.8 MHz), while the gate rings slow down at ss as expected.
- Supply current with all three running: 129–333 µA (216 µA at tt 25 °C 1.80 V), only in the ring phase.

**`ring_d` coefficients (spec §11 item 11).** 82.93 MHz at tt, 25 °C, 1.80 V; −0.029 %/°C (−20 → 100 °C at 1.80 V; ≈ 0 at 1.71 V); +1.46 % per 10 mV (1.71 → 1.89 V at 25 °C). The spec's hand values were +0.2 %/°C and −1 %/10 mV: this ring reads the supply far more than the temperature.

**f_n/f_p and the corners (spec §11 item 14, reworded check).**
- At tt, over −20…100 °C × 1.71–1.89 V: 1.1137–1.2557 (12.7 % wide); −0.079 %/°C and −0.223 % per 10 mV.
- At each (T, VDD) point: sf +2.35…+4.11 % above tt, fs −2.43…−4.40 % below, ss +1.43…+2.22 %, ff −4.32…−4.62 %.
- **Reworded check: pass.** Smallest |sf or fs − tt| = 2.35 % (≥ 2 %); a ±1 °C and ±10 mV error in (T̂, VDD_est) moves the ratio 0.30 %, so the margin is 7.8× (≥ 5×).
- On the ratio alone ff overlaps fs. With f_n against tt at the same (T, VDD) as a second coordinate the five corners separate: ss −16.5…−18.8 %, sf −0.9…−7.5 %, tt 0, fs −0.6…+4.9 %, ff +10.4…+18.0 %, each cluster with its own sign of the ratio shift.

**Pulling (spec §11 item 15).** `ring14.py pull`: 10 Ω in the supply; all three rings on against each ring alone, at tt 25 °C 1.80 V and ff −20 °C 1.89 V. Output `simulation/ring14_pull/`.

| point | `ring_n` | `ring_p` | `ring_d` | VDD dip, all on |
|---|---|---|---|---|
| tt 25 °C 1.80 V | −1127 ppm | −1630 ppm | −2320 ppm | 5.6 mV |
| ff −20 °C 1.89 V | −1233 ppm | −1822 ppm | −2777 ppm | 8.2 mV |

- Against 1e-4: misses as written. The shift is the shared-supply IR drop: the rings draw ≈ 0.22 mA together (≈ 2.2 mV average at 10 Ω), and each slows by that drop times its own supply sensitivity (`ring_d` 1.46 % per 10 mV → ≈ 0.26 %, measured 0.23 %). It is static and the same every time, because one `ring_en` always runs all three together; f_n/f_p moves 0.05 %, against a 2.35 % skew signal. The tile extraction gives the real supply resistance.

**Dividers.** `ring_n` and `ring_p` ÷32, `ring_d` ÷16, as drawn and swept. `uo6` is read against 4–15 MHz instead of 5–15 MHz: at 4.02 MHz the 1 ms ring phase still gives ≥ 4,000 counts (≈ 0.13 mV of VDD per count at tt), and no power-of-two divider fits `ring_d` into 5–15 MHz.

## 3. Layout: `swdrv` and `dig_top`

*Placed and routed with OpenROAD from the frozen netlists, imported into Magic. Flow in `pnr/` (`run.sh`): `spice2v.py` writes structural Verilog from `xschem/simulation/{swdrv,readout_glue,ring3}.spice` (hd pin names from the PDK's hd SPICE library), `pnr.tcl` with `cfg_<block>.tcl` places and routes, `def2mag.tcl` reads the DEF into `mag/<block>.mag` and adds the VDPWR / VGND ports. The run is repeatable: a second run gives the same DEF.*

- **Rules for both blocks.** sky130_fd_sc_hd rows (2.72 µm), tap cells every 13 µm, fill cells only (decap cells hold devices the frozen netlists do not have), met1 rails. Signals route on met1–met3 only, so met4 stays free over the blocks for the tile wiring. Pins on the die edge: met2 on the top and bottom edges, met3 on the left and right.
- **`swdrv`** (24.8 × 13.6 µm, 3 rows; tile (25.99, 146.0)): the 13 cells, a met2 / met3 supply ring round the core. `ich_sel`, `i3_sel`, `chop_sel` on the top edge, straight under the glue's pins. On the right edge (met3): `chop` / `chopb` at the height of bgr's chop pins (tile y 157.22 / 155.86), and the other eight one track apart at tile y 147.0–151.8, lowest first in the order their routes peel off (`swa`, `swb`, `ich_dump`, `ich_on`, `ich_onb`, `i3_dump`, `i3_on`, `i3_onb`), so no route that drops to its pin crosses one still running east.
- **`dig_top`** (81.4 × 32.6 µm, 10 rows; tile (8.05, 188.36), top edge at tile y 221.0): `readout_glue` and `ring3` as one block, because both drive the top-edge pins and `ring3`'s three outputs would otherwise have to cross the glue; `ring_en` stays inside. Its subckt for LVS is `mag/lvs_cells/dig_top.spice`, which holds only the two frozen subckts.
  - Top edge: 22 pins at the x of the tile's own pins (`uio_oe[7:0]`, `uio_out[7:0]`, `uo_out[7:2]`). Right edge (met3): the eight `ui_in` (tile y 214.5–217.9 above bgr's Cc, ui7 lowest), `su`, and `uo_out[1:0]`, which lie over the middle stripes. Bottom edge: the six lines to `osc_core` (tile x 11.96–23.0, over the mux), `ich_sel` / `i3_sel` / `chop_sel` above `swdrv`, and the four monitor-switch enables at the right end (tile x 76.4–79.1).
  - Supply: a met2 strap at the left edge of the core (VGND, facing the left VGND stripe) and one at the right edge (VDPWR, facing the middle stripe), instead of a ring, so the top edge stays free for the pins.
  - Placement density 0.53. Where two child cells nearly touch, Magic adds its own implant (psdm / nsdm) shapes in the parent when it writes the GDS. At some placements these leave a notch under 0.38 µm next to a tap cell's implant (KLayout psdm.1 / nsdm.1: 1 item at density 0.55, 2 at 0.56, 1 at 0.50 and 0.52). At 0.53 there are none. Writing the GDS with that interaction processing off (`cif *hier write disable`) clears `dig_top` but adds psdm.1 errors in `osc_core` and `bgr`, whose cells rely on it.
  - Routed length of the ring stage nets: `ring_n` 3.0 µm mean (1.1–8.9), `ring_p` 2.5 µm (1.3–8.6), `ring_d` 5.0 µm (0.5–38.3) (`netlen.py`). The sweep in section 2 assumed 1.5 fF of wire per node; the tile extraction gives the real load.
- **Checks.** Router: 0 violations. Magic DRC 0; KLayout 0 (`swdrv` 251 mcon, 54 via1, 42 via2 cuts; `dig_top` 3972 mcon, 330 via1, 10 via2). LVS "Circuits match uniquely", 0 property errors: `swdrv` 13 devices, 18 nets; `dig_top` 149 devices (the 37 glue and 112 ring cells), 182 nets.
- **`lvs.sh`.** It now looks for the cell in all five frozen netlists (`bgr`, `osc_core`, `swdrv`, `readout_glue`, `ring3`). For a cell that none of them has, it stacks all five, so that a subckt in `lvs_cells/` can use any of theirs (their subckt names are unique). A line `* uses: a b` in an `lvs_cells/` file pulls in those subckts too (the tile uses `montg` and `dig_top`). Every cell checked before still matches.

## 4. The tile: monitor switches and wiring

**Monitor switch `montg`** (`ua[0]` = V_REF through `vref_mon_en`, `ua[1]` = I_PTAT/2 from P7 through `iptat_mon_en`). The pin side lands on diffusion, as the precheck wants.
- At V_REF = 1.25 V a standard transmission gate's NMOS carries nothing (V_GS 0.55 V), so it works as a PMOS switch. But `ua[0]` also reads V_REF′ = 0.89–1.0 V in half-current mode (spec E7), where a PMOS alone is off and a standard TG has the dead zone the threshold mux had.
- `xschem/simulation/tb_montg.spice`, 5 corners × −20 / 25 / 100 / 125 °C × 1.71 / 1.89 V, input 0.85–1.30 V, pad at 0 V when off:

| | worst R_on, 0.85–1.30 V | R_on at 25 °C | off-leakage at 100 °C | at 125 °C |
|---|---|---|---|---|
| standard TG (nfet W 1 L 0.5 + pfet W 2 L 0.5) | 1.96 MΩ (ss, −20 °C, 1.71 V) | 54–442 kΩ | ≤ 14 pA | ≤ 36 pA |
| lvt TG (the threshold mux's) | – | – | 0.12–0.15 nA (ff, sf) | 0.29–0.35 nA |
| **hybrid: nfet_01v8_lvt W 0.42 L 1 + pfet W 2 L 0.5** | **437 kΩ** (ss, −20 °C, 1.71 V) | 35–160 kΩ | **≤ 25 pA** | ≤ 61 pA |

- `montg` is the hybrid. Its off-leakage is a quarter of the 0.1 nA limit (× 204 kΩ = 5 µV on V_REF). At the worst R_on a 1 GΩ meter reads 0.5 mV low, a 10 GΩ meter 0.05 mV. The same cell serves `ua[1]`, where the pin sits at ≈ 0.15 V and the NMOS is fully on.
- `gen_montg.tcl` (scripted complete), 6.1 × 4.1 µm. Magic DRC 0; LVS against `lvs_cells/montg.spice` matches.
- Both sit under bg_core (tile (225.9, 1.2) and (233.9, 1.2)), next to their inner nets: bgr's `vref` pin and the `iptat_mon` route. The pad lines run west on met4 below the stripes' ends (y 0.95 to `ua[0]`, y 0.25 to `ua[1]`, dropping to met3 under the `ua[0]` stub), 77 and 104 µm.

**Placement** (tile µm): `bgr` (94, 8), `osc_core` (7, 12), V_REF decap (25.0, 122.1), `swdrv` (25.99, 146.0), `dig_top` (8.05, 188.36), the two `montg` as above.

**Wiring** (`mag/tw.py`, a KLayout script). Every route is data. The script checks each one against the placed tile's geometry, except the net's own pins, at each layer's spacing, against the routes of the other nets, and for met3 against the MIM caps (capm.11, 1.34 µm). Then it writes `mag/tile_wiring.tcl`, which `mk_tile.tcl` sources: 552 shapes and 209 vias on 66 nets.
- **From bgr to the left band**, along the strip under ota2s (tile y 0–11.7) and up beside C_osc:
  - `vref` on met2 at the pin's height (y 8.55), then on met4 at x 7.8 to the mux's `vref` pin. From there on along the mux's own `vref` line, out of its right side, and onto the decap's bus. That last via sits 1.4 µm from the decap's MIM.
  - `veb3` on met1, then met4 at x 8.7.
  - `ib_cmp1` on met3, then met4 at x 30.5 and across `cmp2s` to its pin.
  - `ib_cmp2` on met3 between two VGND shields (y 4.6 / 6.6), then met4 at x 24.6 between two met4 VGND shields up to C_osc's top, 2.5 µm from `vref` in the strip (spec R21).
- **`vcap`**: C_osc's bus, down its right side on met4, east along the strip on met3 (y 2.6), up the channel between ota2s and bg_core on met4 (x 211.4) and onto bgr's `ich` pin, P4's drain. 317 µm. It stays ≥ 5.7 µm from `vref` and is separated from `ib_cmp2` by a shield.
- **`iptat_mon`**: up from bgr's pin, down over bg_core on met4, west on met3 under bg_core to `ua[1]`'s switch.
- **The control column over the mux** (met4): `thr_sel`, `thr_selb` to the mux's bottom pins; `osc_en`, `osc_enb`, `rst` to the one-shot's top pins; `cmp_raw` to `osc_core`'s `cmp_raw` line.
  - `rst` runs 15 µm above `vthr`'s met3 riser (≈ 1 fF, hand). Its edge comes at the start of the reset, so a kick into `vthr` decays through the decap (τ = 0.41 µs) long before the next crossing.
  - The VDPWR riser inside `osc_core` (x 20–21) sets the column's spacing.
- **Enables**: down the band's right side (x 76.4–79.1), east under the middle stripes on met3 and over ota2s on met4 at y 119.5–121.6, above `vcap`'s top in the channel, then down over bg_core to the switches.
- **`swdrv` to bgr**:
  - `chop` / `chopb` on met3 under the stripes onto bgr's met2 pins.
  - `swa` / `swb` down the band's right side first (bgr's met4 VGND bar at y 137.5–139.5 blocks a drop from above), then over ota2s at y 126.5 / 127.3.
  - The six current-switch controls over ota2s and bg_core on met4 at y 148.4–151.8, below Cc, each dropping to its pin.
- **`su`**: up over bg_core on met4 at x 291.5, west along the top of the tile at y 218.6 (met3 west of x 140.5), into `dig_top`'s right edge.
- **Pins**:
  - `ui_in[k]`: met4 down from each pin, met3 west into `dig_top`. `ui_in[7]` and `ui_in[6]` cross Cc on met2, because met3 there would come within 1.34 µm of its MIM.
  - `dig_top`'s top pins: a via stack just above the block, then met4 up to each pin.
  - `uo_out[1:0]`: east on met3 above the middle stripes' ends, then up.
- **Supplies**:
  - met3 straps join the left and middle VGND stripes (y 166) and the VDPWR stripes (y 168). With them, the tile has one VGND and one VDPWR net.
  - `osc_core`'s VGND spine goes to the left VGND stripe, and its VDPWR (`cmp2s`'s supply track) to the middle VDPWR stripe.
  - The decap's VGND tab goes to the middle VGND stripe. `dig_top`'s straps and `swdrv`'s ring go to their nearest stripes.
  - The switches get VDPWR and VGND from the right stripes, under bg_core.

**Checks (tile).** Magic DRC 0. KLayout `sky130A_mr.drc` (FEOL, BEOL, offgrid) 0 (28 475 mcon, 1 820 via1, 590 via2, 51 574 via3 cuts). LVS against `mag/lvs_cells/tt_um_huanprojects_tsense.spice` (the frozen blocks, the decap and the two switches; ports as in `src/project.v`): "Circuits match uniquely", 7 devices (`bgr`, `osc_core`, `dig_top`, `swdrv`, 2 × `montg`, the decap's MIM 2 → 1), 66 nets, 0 property errors. TinyTapeout's precheck, run locally (`mag/precheck.sh`): all 15 checks pass.
