
#> cinemalya:v1.1.2/travel/frames/walk
#
# @within	cinemalya:v1.1.2/travel/frames/frame
#			cinemalya:v1.1.2/travel/frames/walk
#
# @description		Drop the samples behind the camera until the interval ahead holds the distance #s.
#

data remove storage cinemalya:work samples[0]
data remove storage cinemalya:work rot_samples[0]
data remove storage cinemalya:work lengths[0]
scoreboard players operation #from_length cinemalya.data = #to_length cinemalya.data
execute store result score #to_length cinemalya.data run data get storage cinemalya:work lengths[1]
execute if score #to_length cinemalya.data < #s cinemalya.data if data storage cinemalya:work lengths[2] run return run function cinemalya:v1.1.2/travel/frames/walk
function cinemalya:v1.1.2/travel/frames/load_interval

