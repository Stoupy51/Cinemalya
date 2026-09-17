
#> cinemalya:v1.0.4/travel/waypoints/resolve_at
#
# @within	cinemalya:v1.0.4/travel/waypoints/fill with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - index of the waypoint whose `at` string needs resolving
# 
# @description		Run the caller's coordinate string through `execute positioned` from a marker standing
# 				where the caller was, so `~`, `^` and plain numbers all mean exactly what they would
# 				in the original command. Waypoints written that way are rare, so the marker is paid
# 				for here rather than once per launch.
#

$data modify storage cinemalya:work one_at.at set from storage cinemalya:work args.waypoints[$(i)].at
function cinemalya:v1.0.4/travel/waypoints/look_ahead
execute summon marker run function cinemalya:v1.0.4/travel/waypoints/resolve_at_anchor
$data modify storage cinemalya:work args.waypoints[$(i)].pos set from storage cinemalya:work resolved

