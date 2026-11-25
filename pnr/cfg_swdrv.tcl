# swdrv: 13 cells (5 inv_1, 6 nor2_1, 2 nand2_1), three rows. Placed in the tile at (25.99, 146.0).
# Inputs on the top edge, straight under readout_glue's ich_sel / i3_sel / chop_sel pins (tile x 32.2, 37.72, 43.24).
# chop / chopb on the right edge (met3), at the height of bgr's pins (tile y 157.22 / 155.86, bgr chop 157.0..157.8,
# chopb 155.5..156.3), east under the middle stripes and down to bgr's met2 pins. The other eight outputs on met3, one
# track apart, at tile y 147.0..151.8: east under the stripes, then on met4 over ota2s below Cc to bgr's switch pins,
# lowest first in the order they peel off (swa, swb in the band; ich_dump, ich_on, ich_onb, i3_dump, i3_on, i3_onb).
set DIE_W 24.84
set DIE_H 13.60
set MX 4.14
set MY 2.72
set DENSITY 0.6
set PINS {
  {ich_sel  top    met2  6.21}
  {i3_sel   top    met2 11.73}
  {chop_sel top    met2 17.25}
  {chop     right  met3 11.22}
  {chopb    right  met3  9.86}
  {swa      right  met3  1.02}
  {swb      right  met3  1.70}
  {ich_on   right  met3  3.06}
  {ich_onb  right  met3  3.74}
  {ich_dump right  met3  2.38}
  {i3_on    right  met3  5.10}
  {i3_onb   right  met3  5.78}
  {i3_dump  right  met3  4.42}
}
