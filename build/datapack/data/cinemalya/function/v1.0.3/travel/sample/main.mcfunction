
#> cinemalya:v1.0.3/travel/sample/main
#
# @within	cinemalya:v1.0.3/travel/start
#
# @output storage	cinemalya:work samples, cinemalya:work rot_samples
# @output score		#frames, #last cinemalya.data
# 
# @description		Sample the curve into a dense polyline, comfortably finer than the frames that
# 				will be picked out of it. Easing then only has to choose which sample to land on.
#

## How many frames the travel gets, and how densely to sample for them
scoreboard players operation #frames cinemalya.data = #duration cinemalya.data
scoreboard players operation #frames cinemalya.data /= #smoothing cinemalya.data
execute if score #frames cinemalya.data matches ..0 run scoreboard players set #frames cinemalya.data 1
scoreboard players operation #samples cinemalya.data = #frames cinemalya.data
scoreboard players operation #samples cinemalya.data *= #4 cinemalya.data
execute if score #samples cinemalya.data matches ..32 run scoreboard players set #samples cinemalya.data 32
execute if score #samples cinemalya.data matches 400.. run scoreboard players set #samples cinemalya.data 400

## Sampling step, in millionths, spread over the whole curve
# The floor is what keeps the sampler terminating: Bookshelf reads the step back as an int, so a smaller
# one arrives as zero, never advances, and recurses on the same point until the watchdog kills the server.
scoreboard players operation #step cinemalya.data = #segments cinemalya.data
scoreboard players operation #step cinemalya.data *= #1000000 cinemalya.data
scoreboard players operation #step cinemalya.data /= #samples cinemalya.data
execute if score #step cinemalya.data matches ..1000 run scoreboard players set #step cinemalya.data 1000
execute store result storage cinemalya:work control.step double 0.000001 run scoreboard players get #step cinemalya.data
data modify storage cinemalya:work rot_control.step set from storage cinemalya:work control.step

execute if score #curve cinemalya.data matches 0 run function cinemalya:v1.0.3/travel/sample/bezier
execute if score #curve cinemalya.data matches 1 run function cinemalya:v1.0.3/travel/sample/catmull_rom

## Land exactly on the destination, whatever the sampler's own last step happened to be
data modify storage cinemalya:work samples append from storage cinemalya:work args.waypoints[-1].pos
data modify storage cinemalya:work rot_samples append from storage cinemalya:work args.waypoints[-1].rot

## Trust the sampler's output length rather than the requested step
execute store result score #last cinemalya.data run data get storage cinemalya:work samples
scoreboard players remove #last cinemalya.data 1
execute if score #last cinemalya.data matches ..0 run scoreboard players set #last cinemalya.data 0

