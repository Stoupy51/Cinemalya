
#> cinemalya:v1.0.0/travel/frames/read_ease
#
# @within	cinemalya:v1.0.0/travel/frames/segment_ease with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - the waypoint this segment arrives at
#

$execute if data storage cinemalya:work args.waypoints[$(i)]{ease:"linear"} run scoreboard players set #ease cinemalya.data 0
$execute if data storage cinemalya:work args.waypoints[$(i)]{ease:"ease_in"} run scoreboard players set #ease cinemalya.data 1
$execute if data storage cinemalya:work args.waypoints[$(i)]{ease:"ease_out"} run scoreboard players set #ease cinemalya.data 2
$execute if data storage cinemalya:work args.waypoints[$(i)]{ease:"ease_in_out"} run scoreboard players set #ease cinemalya.data 3

