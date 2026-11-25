# one-time: create the routing cell bg_pnp.mag holding only its scripted array
load bg_pnp
box 0um 0um 0um 0um
getcell bg_pnp_arr
save bg_pnp
quit -noprompt
