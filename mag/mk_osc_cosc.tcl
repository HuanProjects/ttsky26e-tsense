# one-time: create the routing cell osc_cosc.mag holding only its scripted array
# (`child 0 0`: the array's origin on the cell's origin, so the array's coordinates are the cell's coordinates).
load osc_cosc
box 0um 0um 0um 0um
getcell osc_cosc_arr child 0 0
save osc_cosc
quit -noprompt
