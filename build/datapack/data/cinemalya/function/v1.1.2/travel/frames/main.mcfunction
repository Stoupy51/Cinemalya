
#> cinemalya:v1.1.2/travel/frames/main
#
# @within	cinemalya:v1.1.2/travel/start
#
# @input storage	cinemalya:work samples, cinemalya:work rot_samples, cinemalya:work lengths, cinemalya:work bounds
# @input score		#shared_length, #shared_count cinemalya.data
# @output storage	cinemalya:work frames : one entry per playback step
# 
# @description		Walk the travel one frame at a time. Each frame works out how far along the path it
# 				should be, then lands between the two samples around that distance. Time is counted
# 				in hundredths of a frame, so a segment may end between two frames. Doing it here
# 				means playback never computes anything: it just pops.
#

data modify storage cinemalya:work frames set value {points:[],rotations:[]}
scoreboard players operation #last_seg cinemalya.data = #segments cinemalya.data
scoreboard players remove #last_seg cinemalya.data 1

## The segments without a duration of their own share theirs in proportion to their length,
## so the camera keeps one speed through every waypoint between them
scoreboard players operation #shared_time cinemalya.data = #duration cinemalya.data
scoreboard players operation #shared_time cinemalya.data *= #shared_count cinemalya.data
scoreboard players operation #shared_time cinemalya.data /= #segments cinemalya.data
scoreboard players operation #shared_time cinemalya.data /= #smoothing cinemalya.data
execute if score #shared_time cinemalya.data matches ..0 run scoreboard players set #shared_time cinemalya.data 1
scoreboard players operation #shared_time cinemalya.data *= #100 cinemalya.data
execute if score #shared_length cinemalya.data matches ..0 run scoreboard players set #shared_length cinemalya.data 1
scoreboard players operation #pace cinemalya.data = #shared_time cinemalya.data
scoreboard players operation #pace cinemalya.data *= #10000 cinemalya.data
scoreboard players operation #pace cinemalya.data /= #shared_length cinemalya.data
scoreboard players set #shared_done cinemalya.data 0
scoreboard players set #shared_spent cinemalya.data 0

## Start before the first segment, on the first sample interval
scoreboard players set #seg cinemalya.data -1
scoreboard players set #seg_end cinemalya.data 0
scoreboard players set #time cinemalya.data 0
execute store result score #l1 cinemalya.data run data get storage cinemalya:work bounds[0]
execute store result score #from_length cinemalya.data run data get storage cinemalya:work lengths[0]
execute store result score #to_length cinemalya.data run data get storage cinemalya:work lengths[1]
function cinemalya:v1.1.2/travel/frames/load_interval

# Frames left to spend. Raising the smoothing keeps a normal travel well clear of it,
# so this only ever bites on per waypoint durations, which no earlier total can bound.
scoreboard players set #budget cinemalya.data 600
function cinemalya:v1.1.2/travel/frames/frame

