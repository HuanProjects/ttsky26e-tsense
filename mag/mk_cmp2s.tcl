# one-time: create the routing cell cmp2s.mag holding only its scripted array
# (`child 0 0`: the array's origin on the cell's origin, so the array's coordinates are the cell's coordinates).
load cmp2s
box 0um 0um 0um 0um
getcell cmp2s_arr child 0 0
save cmp2s
quit -noprompt
