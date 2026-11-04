
#> cinemalya:v1.1.0/travel/frames/frame
#
# @within	cinemalya:v1.1.0/travel/frames/main
#			cinemalya:v1.1.0/travel/frames/frame
#
# @description		Emit the frame one frame later than the previous one, then the next.
#

scoreboard players add #time cinemalya.data 100
execute if score #time cinemalya.data > #seg_end cinemalya.data run function cinemalya:v1.1.0/travel/frames/next_segment
execute if score #seg cinemalya.data >= #segments cinemalya.data run return 0

## Progress through the segment, in ten thousandths, bent by the easing curve
scoreboard players operation #p cinemalya.data = #time cinemalya.data
scoreboard players operation #p cinemalya.data -= #seg_start cinemalya.data
scoreboard players operation #p cinemalya.data *= #10000 cinemalya.data
scoreboard players operation #p cinemalya.data /= #seg_span cinemalya.data
execute unless score #ease cinemalya.data matches 0 run function cinemalya:v1.1.0/travel/frames/ease

## Distance along the path, then the sample interval holding it
scoreboard players operation #s cinemalya.data = #seg_length cinemalya.data
scoreboard players operation #s cinemalya.data *= #p cinemalya.data
scoreboard players operation #s cinemalya.data /= #10000 cinemalya.data
scoreboard players operation #s cinemalya.data += #l0 cinemalya.data
execute if score #to_length cinemalya.data < #s cinemalya.data if data storage cinemalya:work lengths[2] run function cinemalya:v1.1.0/travel/frames/walk
function cinemalya:v1.1.0/travel/frames/land

scoreboard players remove #budget cinemalya.data 1
execute if score #budget cinemalya.data matches 1.. run function cinemalya:v1.1.0/travel/frames/frame

