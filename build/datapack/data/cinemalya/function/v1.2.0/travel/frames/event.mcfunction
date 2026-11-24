
#> cinemalya:v1.2.0/travel/frames/event
#
# @within	cinemalya:v1.2.0/travel/frames/main with storage cinemalya:work sel
#			cinemalya:v1.2.0/travel/frames/land_event with storage cinemalya:work sel
#			cinemalya:v1.2.0/travel/pieces/single with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - the waypoint in the list being built
# @input score		#event_at cinemalya.data : the number of the pop landing on that waypoint
# @input score		#event_wp cinemalya.data : the waypoint's index in the whole path
# 
# @description		Record that this waypoint fires its `function` and the on_waypoint signal when reached.
#

data modify storage cinemalya:work frames.events append value {at:0,wp:0}
execute store result storage cinemalya:work frames.events[-1].at int 1 run scoreboard players get #event_at cinemalya.data
execute store result storage cinemalya:work frames.events[-1].wp int 1 run scoreboard players get #event_wp cinemalya.data
$data modify storage cinemalya:work frames.events[-1].function set from storage cinemalya:work args.waypoints[$(i)].function

