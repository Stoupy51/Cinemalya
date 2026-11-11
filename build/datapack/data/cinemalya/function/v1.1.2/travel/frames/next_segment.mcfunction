
#> cinemalya:v1.1.2/travel/frames/next_segment
#
# @within	cinemalya:v1.1.2/travel/frames/frame
#			cinemalya:v1.1.2/travel/frames/next_segment
#
# @description		Move on to the segment #time falls in, skipping any too short to hold a frame.
#

scoreboard players add #seg cinemalya.data 1
execute if score #seg cinemalya.data >= #segments cinemalya.data run return 0
scoreboard players operation #seg_start cinemalya.data = #seg_end cinemalya.data
scoreboard players operation #l0 cinemalya.data = #l1 cinemalya.data
data remove storage cinemalya:work bounds[0]
execute store result score #l1 cinemalya.data run data get storage cinemalya:work bounds[0]
scoreboard players operation #seg_length cinemalya.data = #l1 cinemalya.data
scoreboard players operation #seg_length cinemalya.data -= #l0 cinemalya.data

scoreboard players operation #n cinemalya.data = #seg cinemalya.data
scoreboard players add #n cinemalya.data 1
execute store result storage cinemalya:work sel.i int 1 run scoreboard players get #n cinemalya.data
function cinemalya:v1.1.2/travel/frames/read_duration with storage cinemalya:work sel
scoreboard players operation #seg_end cinemalya.data = #seg_start cinemalya.data
scoreboard players operation #seg_end cinemalya.data += #seg_span cinemalya.data
function cinemalya:v1.1.2/travel/frames/segment_ease

execute if score #time cinemalya.data > #seg_end cinemalya.data run function cinemalya:v1.1.2/travel/frames/next_segment

