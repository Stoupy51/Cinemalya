
#> cinemalya:v1.0.2/travel/waypoints/read_ahead
#
# @executed	positioned ^ ^ ^1
#
# @within	cinemalya:v1.0.2/travel/waypoints/look_ahead [ positioned ^ ^ ^1 ]
#

data modify storage cinemalya:work ahead set value {x:0.0d,y:0.0d,z:0.0d}
data modify storage cinemalya:work ahead.x set from entity @s Pos[0]
data modify storage cinemalya:work ahead.y set from entity @s Pos[1]
data modify storage cinemalya:work ahead.z set from entity @s Pos[2]
kill @s

