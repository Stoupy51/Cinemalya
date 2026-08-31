
#> cinemalya:v1.0.2/travel/frames/main
#
# @within	cinemalya:v1.0.2/travel/start
#
# @input storage	cinemalya:work samples, cinemalya:work rot_samples : the dense polyline
# @output storage	cinemalya:work frames : one entry per playback step
# 
# @description		Walk the waypoints segment by segment, giving each one as many frames as its own
# 				duration buys. Doing it here means playback never computes anything: it just pops.
#

data modify storage cinemalya:work frames set value {points:[],rotations:[]}
scoreboard players operation #last_seg cinemalya.data = #segments cinemalya.data
scoreboard players remove #last_seg cinemalya.data 1
scoreboard players set #seg cinemalya.data 0

# Frames left to spend across every remaining segment. Raising the smoothing keeps a normal travel well
# clear of it, so this only ever bites on per waypoint durations, which no earlier total can bound.
scoreboard players set #budget cinemalya.data 1200
function cinemalya:v1.0.2/travel/frames/segment_loop

