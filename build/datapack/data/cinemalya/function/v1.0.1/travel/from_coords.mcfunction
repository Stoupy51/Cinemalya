
#> cinemalya:v1.0.1/travel/from_coords
#
# @executed	as & at the player
#
# @within	cinemalya:v1.0.1/api/launch {with:$(with)}
#
# @args		with (unknown)
#
# @input macro		with : compound - see the launch documentation in the README
# 
# @description		Fly the player from where they stand to the given coordinates.
# 				x/y/z are where the player ends up standing, not where the camera stops.
#

$data modify storage cinemalya:work args set value $(with)
function cinemalya:v1.0.1/travel/defaults
function cinemalya:v1.0.1/travel/waypoints/start_here
function cinemalya:v1.0.1/travel/waypoints/target_from_coords
function cinemalya:v1.0.1/travel/start

