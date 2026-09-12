
#> cinemalya:v1.0.3/travel/waypoints/expand
#
# @within	cinemalya:v1.0.3/travel/waypoints/fill with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - index of the waypoint to expand
# 
# @description		Unpack the flat `args` form of a waypoint into `pos`, `rot` and `duration`.
# 				Everything goes through a score, so writing plain integers works as well as decimals.
#

$data modify storage cinemalya:work args.waypoints[$(i)].pos set value [0.0d,0.0d,0.0d]
$execute store result score #n cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].args[0] 1000
$execute store result storage cinemalya:work args.waypoints[$(i)].pos[0] double 0.001 run scoreboard players get #n cinemalya.data
$execute store result score #n cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].args[1] 1000
$execute store result storage cinemalya:work args.waypoints[$(i)].pos[1] double 0.001 run scoreboard players get #n cinemalya.data
$execute store result score #n cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].args[2] 1000
$execute store result storage cinemalya:work args.waypoints[$(i)].pos[2] double 0.001 run scoreboard players get #n cinemalya.data

# The rotation and the duration are optional tail elements, so a three element form still inherits them
$execute if data storage cinemalya:work args.waypoints[$(i)].args[4] run function cinemalya:v1.0.3/travel/waypoints/expand_rot with storage cinemalya:work sel
$execute if data storage cinemalya:work args.waypoints[$(i)].args[5] store result storage cinemalya:work args.waypoints[$(i)].duration int 1 run data get storage cinemalya:work args.waypoints[$(i)].args[5]

