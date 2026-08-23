
#> cinemalya:v1.0.0/travel/waypoints/resolve_at
#
# @within	cinemalya:v1.0.0/travel/waypoints/fill with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - index of the waypoint whose `at` string needs resolving
# 
# @description		Run the caller's coordinate string through `execute positioned` from the anchor, so
# 				`~`, `^` and plain numbers all mean exactly what they would in the original command.
#

$data modify storage cinemalya:work one_at.at set from storage cinemalya:work args.waypoints[$(i)].at
execute as @e[type=marker,tag=cinemalya.anchor,limit=1] at @s run function cinemalya:v1.0.0/travel/waypoints/resolve_at_run with storage cinemalya:work one_at
$data modify storage cinemalya:work args.waypoints[$(i)].pos set from storage cinemalya:work resolved

