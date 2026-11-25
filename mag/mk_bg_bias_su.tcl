# one-time: create the routing cells bg_bias.mag and bg_su.mag, each holding only its scripted array
# (`child 0 0`: the array's origin on the cell's origin, so the array's coordinates are the cell's coordinates).
load bg_bias
box 0um 0um 0um 0um
getcell bg_bias_arr child 0 0
save bg_bias
load bg_su
box 0um 0um 0um 0um
getcell bg_su_arr child 0 0
save bg_su
quit -noprompt
