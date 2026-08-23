
#> cinemalya:v1.0.0/travel/from_here
#
# @executed	as the player,positioned & rotated wherever the caller aimed
#
# @within	cinemalya:v1.0.0/api/launch_here {with:$(with)}
#
# @args		with (unknown)
#
# @input macro		with : compound - see the launch_here documentation in the README
# 
# @description		Fly the player to the execution position and rotation, so the destination can be
# 				written with `~` and `^` coordinates. A command block never needs absolute numbers.
#

$data modify storage cinemalya:work args set value $(with)
function cinemalya:v1.0.0/travel/defaults
function cinemalya:v1.0.0/travel/waypoints/start_here
function cinemalya:v1.0.0/travel/waypoints/target_here
function cinemalya:v1.0.0/travel/start

