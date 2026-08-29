
#> cinemalya:v1.0.1/travel/from_waypoints
#
# @executed	as & at the player,or anywhere at all for a detached camera
#
# @within	cinemalya:v1.0.1/api/launch_path {with:$(with)}
#			cinemalya:v1.0.1/intro/one_player with storage cinemalya:input wrap
#
# @args		with (unknown)
#
# @input macro		with : compound - see the launch_path documentation in the README
# 
# @description		Fly along an explicit list of camera waypoints.
# 				A single waypoint is completed with the player's own position as the starting one.
#

$data modify storage cinemalya:work args set value $(with)
function cinemalya:v1.0.1/travel/defaults
execute unless data storage cinemalya:work args.waypoints[0] run return fail
execute unless data storage cinemalya:work args.waypoints[1] unless score #mode cinemalya.data matches 2 run function cinemalya:v1.0.1/travel/waypoints/prepend_here
execute unless data storage cinemalya:work args.waypoints[1] run return fail
function cinemalya:v1.0.1/travel/start

