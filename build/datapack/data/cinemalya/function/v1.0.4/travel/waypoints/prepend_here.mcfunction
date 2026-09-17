
#> cinemalya:v1.0.4/travel/waypoints/prepend_here
#
# @executed	as the player
#
# @within	cinemalya:v1.0.4/travel/from_waypoints
#
# @description		Complete a single-waypoint path by starting it where the player currently stands.
#

data modify storage cinemalya:work wp set value {pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}
data modify storage cinemalya:work wp.pos set from entity @s Pos
data modify storage cinemalya:work wp.rot set from entity @s Rotation
function cinemalya:v1.0.4/travel/waypoints/raise_eyes
data modify storage cinemalya:work args.waypoints prepend from storage cinemalya:work wp

