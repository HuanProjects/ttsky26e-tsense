# one-time: create the routing cell bg_mirror.mag holding only the scripted array (the routing goes here).
# `child 0 0` puts the array's origin on this cell's origin, so the array's coordinates are this cell's coordinates.
load bg_mirror
box 0um 0um 0um 0um
getcell bg_mirror_arr child 0 0
save bg_mirror
quit -noprompt
