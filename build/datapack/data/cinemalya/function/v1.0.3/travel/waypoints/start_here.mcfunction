
#> cinemalya:v1.0.3/travel/waypoints/start_here
#
# @executed	as the player
#
# @within	cinemalya:v1.0.3/travel/from_coords
#			cinemalya:v1.0.3/travel/from_entity
#			cinemalya:v1.0.3/travel/from_here
#
# @description		Open the waypoint list on the player's own eyes.
#

data modify storage cinemalya:work args.waypoints set value []
data modify storage cinemalya:work wp set value {pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}
data modify storage cinemalya:work wp.pos set from entity @s Pos
data modify storage cinemalya:work wp.rot set from entity @s Rotation
function cinemalya:v1.0.3/travel/waypoints/raise_eyes
data modify storage cinemalya:work args.waypoints append from storage cinemalya:work wp

