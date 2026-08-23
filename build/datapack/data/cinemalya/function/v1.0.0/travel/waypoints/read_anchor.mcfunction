
#> cinemalya:v1.0.0/travel/waypoints/read_anchor
#
# @within	cinemalya:v1.0.0/travel/waypoints/target_here
#
# @output storage	cinemalya:work wp : the anchor as a waypoint
#

data modify storage cinemalya:work wp set value {pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}
data modify storage cinemalya:work wp.pos set from entity @e[type=marker,tag=cinemalya.anchor,limit=1] Pos
data modify storage cinemalya:work wp.rot set from entity @e[type=marker,tag=cinemalya.anchor,limit=1] Rotation

