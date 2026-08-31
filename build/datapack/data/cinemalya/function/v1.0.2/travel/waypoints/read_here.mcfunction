
#> cinemalya:v1.0.2/travel/waypoints/read_here
#
# @executed	as a throwaway marker freshly summoned on the caller's position
#
# @within	cinemalya:v1.0.2/travel/waypoints/target_here
#			cinemalya:v1.0.2/intro/start
#
# @input storage	cinemalya:work ahead : the point to face, from look_ahead
# @output storage	cinemalya:work wp : the caller's own position and rotation, as a waypoint
#

function cinemalya:v1.0.2/travel/waypoints/face_ahead with storage cinemalya:work ahead
data modify storage cinemalya:work wp set value {pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}
data modify storage cinemalya:work wp.pos set from entity @s Pos
data modify storage cinemalya:work wp.rot set from entity @s Rotation
kill @s

