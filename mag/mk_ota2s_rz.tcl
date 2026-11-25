# one-time: create the routing cell ota2s_rz.mag holding only its scripted array
# (`child 0 0`: the array's origin on the cell's origin, so the array's coordinates are the cell's coordinates).
load ota2s_rz
box 0um 0um 0um 0um
getcell ota2s_rz_arr child 0 0
save ota2s_rz
quit -noprompt
