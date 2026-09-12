
#> cinemalya:v1.0.3/travel/frames/read_ease
#
# @within	cinemalya:v1.0.3/travel/frames/segment_ease with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - the waypoint this segment arrives at
#

data remove storage cinemalya:work sel.ease_linear
$data modify storage cinemalya:work sel.ease_linear set from storage cinemalya:work args.waypoints[$(i)].ease
execute if data storage cinemalya:work sel{ease_linear:"linear"} run scoreboard players set #ease cinemalya.data 0
execute if data storage cinemalya:work sel{ease_linear:"ease_in"} run scoreboard players set #ease cinemalya.data 1
execute if data storage cinemalya:work sel{ease_linear:"ease_out"} run scoreboard players set #ease cinemalya.data 2
execute if data storage cinemalya:work sel{ease_linear:"ease_in_out"} run scoreboard players set #ease cinemalya.data 3

