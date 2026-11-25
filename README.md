![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg)

# BJT temperature sensor for Tiny Tapeout (sky130)

An analog project for [Tiny Tapeout](https://tinytapeout.com) on the SkyWater 130 nm open PDK: a temperature sensor in one 2x2 analog tile (335 × 226 µm), running from the 1.8 V supply alone. Target shuttle: Tiny Tapeout SKY 26e.

The sensor turns temperature into the ratio of two oscillator periods, so the reading does not depend on the absolute value of any capacitor, current or resistor on the chip. A microcontroller counts the two periods and computes the temperature.

- **Datasheet:** [docs/info.md](docs/info.md) (how it works, pins, how to test)
- **Status:** layout complete; DRC, LVS and antenna clean; Tiny Tapeout precheck passing; post-layout simulation done. Not measured on silicon yet.

## How it works, in short

1. **Bandgap core.** Two substrate PNPs at a 1 : 8 area ratio give a voltage difference ΔV_EB that is proportional to absolute temperature. A two-stage op-amp with static chopping holds it across a resistor, which sets a PTAT current. A PMOS mirror copies that current into a third PNP and a 10× resistor, giving V_EB3 (falls with temperature) and V_REF = V_EB3 + 10·ΔV_EB (nearly flat).
2. **Oscillator.** A copy of the PTAT current charges a 5 pF capacitor; a comparator resets it at a threshold. The threshold is V_REF or V_EB3, chosen by one input pin.
3. **Ratio.** μ = 1 − T_EB / T_REF = 10·ΔV_EB / V_REF. Capacitor, current and resistor value cancel.
4. **Self-checks.** A half-slope mode measures the comparator's delay on each chip, the chop swaps the op-amp's inputs to cancel its offset, a half-current mode checks the output mirror, and three ring oscillators give a digital estimate of supply and process corner.

## Pins

| Pin | Name | Function |
|---|---|---|
| ui[0] | `osc_en` | start the oscillator |
| ui[1] | `thr_sel` | threshold: 0 = V_REF, 1 = V_EB3 |
| ui[2] | `vref_mon_en` | V_REF to ua[0] |
| ui[3] | `iptat_mon_en` | half the PTAT current out of ua[1] |
| ui[4] | `ich_sel` | half charging current (delay measurement) |
| ui[5] | `chop_sel` | op-amp chop state |
| ui[6] | `ring_en` | start the three ring oscillators |
| ui[7] | `i3_sel` | half current in the output branch (mirror check) |
| uo[0] | `osc_out` | toggles once per oscillator period |
| uo[1], uo[3], uo[6] | `ringn_out`, `ringp_out`, `ring_out` | divided ring outputs |
| uo[2] | `cmp_raw` | raw comparator output |
| uo[4] | `bg_ok` | bias currents running |
| ua[0], ua[1] | `vref_mon`, `iptat_mon` | analog monitors |

## Simulated performance

| | Value | From |
|---|---|---|
| Supply | 1.8 V (checked over 1.71–1.89 V) | – |
| Temperature range | −20 to 100 °C | – |
| Supply current at 25 °C | 29 µA (52 µW) | post-layout |
| μ at 25 °C, slope | 0.4292, 1.443 × 10⁻³ per K | schematic, DC |
| Oscillator frequency, V_REF threshold | 175 / 201 / 240 kHz at −20 / 25 / 100 °C | post-layout |
| Conversion time | about 2 ms (256 periods on each threshold) | post-layout |
| Resolution | 0.016 K rms at 256 periods | schematic and noise model |
| Predicted inaccuracy after a one-point trim (3σ) | ±1.3 °C at 100 °C, ±0.9 °C at −20 °C; target ±2 °C | schematic: corners, supply, Monte Carlo |
| Shift caused by the layout, after the trim | +0.03 K at −20 °C, −0.02 K at 100 °C | post-layout against schematic |
| Op-amp | 88 dB gain; input offset σ = 0.31 mV over 400 Monte Carlo runs | schematic |
| Bandgap loop | phase margin 82–89°, crossover 205–258 kHz | post-layout |
| Startup | V_REF within 1 % less than 40 µs after a 1 µs supply ramp | post-layout |

## What is in the repository

| Folder | Contents |
|---|---|
| `docs/` | `info.md` is the datasheet. `results_m2.md` … `results_m8.md` are the results, block by block: the op-amp (m2, m3) and its layout (m4), the bandgap (m5), the oscillator and comparator (m6), the digital glue, rings and tile assembly (m7), and the whole-tile checks with extraction (m8). `freeze_*.txt` hold the hashes of the frozen cells; the CSV files are tables for the readout firmware. |
| `xschem/` | Schematics and symbols, testbenches (`tb_*`), and the Python runners that sweep them. `xschem/simulation/` holds the frozen netlists. |
| `mag/` | The Magic layout: cells, the scripts that generate the matched arrays (`gen_*.tcl`) and assemble the blocks (`mk_*.tcl`), the tile wiring as data (`tw.py`), and the check scripts. |
| `pnr/` | The OpenROAD flow for the two small digital blocks. |
| `gds/`, `lef/`, `src/`, `info.yaml` | What Tiny Tapeout builds the project from. |

The results files refer to a design specification ("spec", with section and R numbers). That document is not part of this repository.

## Reproducing the checks

Tools: the [IIC-OSIC-TOOLS](https://github.com/iic-jku/IIC-OSIC-TOOLS) container, release 2026.07 (Magic 8.3.678, KLayout 0.30.9, ngspice 46, netgen), with sky130A from open_pdks `f6eeac7d`. The scripts expect the repository at `/foss/designs/tt_tsense`.

In `mag/`:

```
./drc.sh tt_um_huanprojects_tsense      # Magic DRC
./lvs.sh tt_um_huanprojects_tsense      # netgen LVS against the frozen netlists
./ant.sh                                # Magic antenna check
./precheck.sh <tt-support-tools>        # Tiny Tapeout's precheck, run locally
./pex.sh                                # flat extraction (capacitance) of the tile
```

In `xschem/`, after `pex.sh`: `python3 tile15.py prep`, then `mu`, `sens`, `modes`, `stb`, `startup` or `rings` for the whole-tile simulations of `docs/results_m8.md`. Each of the other runners names its testbench in its header.

## Not done yet

- No silicon measurements. Every number above is simulation.
- Process corners and Monte Carlo have been run on the schematic. On the extracted layout only the typical corner and a handful of corner points have been run.
- The firmware tables in `docs/*.csv` come from the schematic. The layout slows the comparator by about 17 ns and the rings by 10–37 %, so the tables have to be regenerated from the extracted netlist before the readout firmware uses them (see `docs/results_m8.md`, sections 5 and 10).
- The readout firmware for the demo board is not written yet.

## License and credits

Apache-2.0, see [LICENSE](LICENSE). The repository started from Tiny Tapeout's analog template; `mag/tt_analog_2x2.def`, the workflow files and parts of `mag/mk_tile.tcl` come from [tt-support-tools](https://github.com/TinyTapeout/tt-support-tools) and the template. Devices and standard cells are from the SkyWater sky130 PDK.
