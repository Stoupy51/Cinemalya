
#> cinemalya:v1.1.1/travel/frames/read_duration
#
# @within	cinemalya:v1.1.1/travel/frames/next_segment with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - the waypoint this segment arrives at
# @output score		#seg_span cinemalya.data : how long the segment lasts, in hundredths of a frame
#

$execute store result score #seg_span cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].duration
execute if score #seg_span cinemalya.data matches 0 run return run function cinemalya:v1.1.1/travel/frames/shared_span
scoreboard players operation #seg_span cinemalya.data /= #smoothing cinemalya.data
execute if score #seg_span cinemalya.data matches ..0 run scoreboard players set #seg_span cinemalya.data 1
scoreboard players operation #seg_span cinemalya.data *= #100 cinemalya.data

