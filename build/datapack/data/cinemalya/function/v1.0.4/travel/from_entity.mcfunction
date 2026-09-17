
#> cinemalya:v1.0.4/travel/from_entity
#
# @executed	as & at the player
#
# @within	cinemalya:v1.0.4/api/launch_at_entity {with:$(with)}
#
# @args		with (unknown)
#
# @input macro		with : compound - see the launch_at_entity documentation in the README
# 
# @description		Fly the player from where they stand to another entity's position and rotation.
#

$data modify storage cinemalya:work args set value $(with)
function cinemalya:v1.0.4/travel/defaults
function cinemalya:v1.0.4/travel/waypoints/start_here
function cinemalya:v1.0.4/travel/waypoints/target_from_entity
function cinemalya:v1.0.4/travel/start

