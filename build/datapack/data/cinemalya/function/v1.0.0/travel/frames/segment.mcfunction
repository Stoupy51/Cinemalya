
#> cinemalya:v1.0.0/travel/frames/segment
#
# @within	cinemalya:v1.0.0/travel/frames/segment_loop
#
# @description		Emit every frame belonging to the segment that ends on waypoint #seg + 1.
#

## This segment's own share of the travel, in frames
scoreboard players operation #n cinemalya.data = #seg cinemalya.data
scoreboard players add #n cinemalya.data 1
execute store result storage cinemalya:work sel.i int 1 run scoreboard players get #n cinemalya.data
function cinemalya:v1.0.0/travel/frames/read_duration with storage cinemalya:work sel
scoreboard players operation #seg_frames cinemalya.data /= #smoothing cinemalya.data
execute if score #seg_frames cinemalya.data matches ..0 run scoreboard players set #seg_frames cinemalya.data 1

scoreboard players set #f cinemalya.data 1
function cinemalya:v1.0.0/travel/frames/frame_loop

scoreboard players add #seg cinemalya.data 1
function cinemalya:v1.0.0/travel/frames/segment_loop

