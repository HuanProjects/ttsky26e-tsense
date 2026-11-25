# dig_top: readout_glue (37 cells) + ring3 (112 cells) in one block, 10 rows. Placed in the tile at (8.05, 188.36),
# so its top edge is at tile y 221.0 and its pins on the top edge sit at the x of the tile's own pins:
# die x = tile x - 8.05 (uio_oe[k] = 50.14 - 2.76 k, uio_out[k] = 72.22 - 2.76 k, uo_out[k] = 94.30 - 2.76 k).
# uo_out[0] and [1] lie over the middle stripes, so those two leave on the right edge with the eight ui_in inputs
# (tile y 213.2 .. 220.0, above bgr's Cc), and su, which arrives along the top of the tile from bg_core.
# Bottom edge: the six lines to osc_core over the mux (tile x 11.96 .. 23.0), ich_sel / i3_sel / chop_sel straight above
# swdrv's inputs, and the four monitor-switch enables at the right end (tile x 76.4 .. 79.1), for the run to bg_core.
set DIE_W 81.42
set DIE_H 32.64
set MX 0.92
set MY 2.72
set DENSITY 0.53
set PDN straps
set STRAP_W 1.6
set PINS {
  {uio_oe7  top met2 22.77} {uio_oe6  top met2 25.53} {uio_oe5  top met2 28.29} {uio_oe4  top met2 31.05}
  {uio_oe3  top met2 33.81} {uio_oe2  top met2 36.57} {uio_oe1  top met2 39.33} {uio_oe0  top met2 42.09}
  {uio_out7 top met2 44.85} {uio_out6 top met2 47.61} {uio_out5 top met2 50.37} {uio_out4 top met2 53.13}
  {uio_out3 top met2 55.89} {uio_out2 top met2 58.65} {uio_out1 top met2 61.41} {uio_out0 top met2 64.17}
  {uo7 top met2 66.93} {uo6 top met2 69.69} {uo5 top met2 72.45} {uo4 top met2 75.21}
  {uo3 top met2 77.97} {uo2 top met2 80.73}
  {ui7 right met3 24.82} {ui6 right met3 25.50} {ui5 right met3 26.18} {ui4 right met3 26.86}
  {ui3 right met3 27.54} {ui2 right met3 28.22} {ui1 right met3 28.90} {ui0 right met3 29.58}
  {uo0 right met3 30.94} {uo1 right met3 31.62}
  {thr_sel       bottom met2  3.91} {thr_selb      bottom met2  5.29} {osc_en        bottom met2  8.05}
  {cmp_raw       bottom met2  9.43} {osc_enb       bottom met2 13.57} {rst           bottom met2 14.95}
  {ich_sel       bottom met2 24.15} {i3_sel        bottom met2 29.67} {chop_sel      bottom met2 35.19}
  {vref_mon_en   bottom met2 68.31} {vref_mon_enb  bottom met2 69.23} {iptat_mon_en  bottom met2 70.15}
  {iptat_mon_enb bottom met2 71.07}
  {su right met3 30.26}
}
