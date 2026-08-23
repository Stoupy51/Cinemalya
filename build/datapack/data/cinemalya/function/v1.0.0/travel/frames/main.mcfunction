
#> cinemalya:v1.0.0/travel/frames/main
#
# @within	cinemalya:v1.0.0/travel/start
#
# @input storage	cinemalya:work samples, cinemalya:work rot_samples : the dense polyline
# @output storage	cinemalya:work frames : one entry per playback step
# 
# @description		Walk the waypoints segment by segment, giving each one as many frames as its own
# 				duration buys. Doing it here means playback never computes anything: it just pops.
#

data modify storage cinemalya:work frames set value {points:[],rotations:[]}
scoreboard players set #seg cinemalya.data 0
function cinemalya:v1.0.0/travel/frames/segment_loop

