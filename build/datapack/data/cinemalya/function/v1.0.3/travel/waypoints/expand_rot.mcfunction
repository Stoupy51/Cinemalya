
#> cinemalya:v1.0.3/travel/waypoints/expand_rot
#
# @within	cinemalya:v1.0.3/travel/waypoints/expand with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - index of the waypoint to expand
#

$data modify storage cinemalya:work args.waypoints[$(i)].rot set value [0.0f,0.0f]
$execute store result score #n cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].args[3] 1000
$execute store result storage cinemalya:work args.waypoints[$(i)].rot[0] float 0.001 run scoreboard players get #n cinemalya.data
$execute store result score #n cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].args[4] 1000
$execute store result storage cinemalya:work args.waypoints[$(i)].rot[1] float 0.001 run scoreboard players get #n cinemalya.data

