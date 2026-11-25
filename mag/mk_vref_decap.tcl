# one-time: create the routing cell vref_decap.mag holding only its scripted array
# (`child 0 0`: the array's origin on the cell's origin, so the array's coordinates are the cell's coordinates).
load vref_decap
box 0um 0um 0um 0um
getcell vref_decap_arr child 0 0
save vref_decap
quit -noprompt
