
#> cinemalya:v1.2.1/travel/waypoints/seat
#
# @within	cinemalya:v1.2.1/travel/waypoints/fill with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - index of the waypoint to lower
# 
# @description		A rider's eyes sit 1.02 blocks over the camera, so every waypoint goes down by that much
# 				and the view stays where the waypoint was placed.
#

$execute store result score #n cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].pos[1] 1000
scoreboard players remove #n cinemalya.data 1020
$execute store result storage cinemalya:work args.waypoints[$(i)].pos[1] double 0.001 run scoreboard players get #n cinemalya.data

