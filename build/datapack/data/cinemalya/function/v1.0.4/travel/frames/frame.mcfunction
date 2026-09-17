
#> cinemalya:v1.0.4/travel/frames/frame
#
# @within	cinemalya:v1.0.4/travel/frames/frame_loop
#
# @description		Map this frame's position within its segment onto a sample of the dense polyline.
#

## Progress through the segment, in ten thousandths, bent by the easing curve
scoreboard players operation #p cinemalya.data = #f cinemalya.data
scoreboard players operation #p cinemalya.data *= #10000 cinemalya.data
scoreboard players operation #p cinemalya.data /= #seg_frames cinemalya.data
function cinemalya:v1.0.4/travel/frames/ease

## Progress through the whole curve, then the nearest sample to it
scoreboard players operation #g cinemalya.data = #seg cinemalya.data
scoreboard players operation #g cinemalya.data *= #10000 cinemalya.data
scoreboard players operation #g cinemalya.data += #p cinemalya.data
scoreboard players operation #g cinemalya.data /= #segments cinemalya.data
scoreboard players operation #g cinemalya.data *= #last cinemalya.data
scoreboard players add #g cinemalya.data 5000
scoreboard players operation #g cinemalya.data /= #10000 cinemalya.data
execute if score #g cinemalya.data > #last cinemalya.data run scoreboard players operation #g cinemalya.data = #last cinemalya.data

execute store result storage cinemalya:work sel.i int 1 run scoreboard players get #g cinemalya.data
function cinemalya:v1.0.4/travel/frames/append with storage cinemalya:work sel

scoreboard players add #f cinemalya.data 1
function cinemalya:v1.0.4/travel/frames/frame_loop

