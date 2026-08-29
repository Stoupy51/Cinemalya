
#> cinemalya:v1.0.1/travel/waypoints/fill
#
# @within	cinemalya:v1.0.1/travel/waypoints/normalize_one with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - index of the waypoint to complete
# 
# @description		Inherit the missing rotation and duration, then unwrap this waypoint's yaw.
#

$execute if data storage cinemalya:work args.waypoints[$(i)].args run function cinemalya:v1.0.1/travel/waypoints/expand with storage cinemalya:work sel
$execute if data storage cinemalya:work args.waypoints[$(i)].at run function cinemalya:v1.0.1/travel/waypoints/resolve_at with storage cinemalya:work sel
$execute unless data storage cinemalya:work args.waypoints[$(i)].rot run data modify storage cinemalya:work args.waypoints[$(i)].rot set from storage cinemalya:work last_rot
$execute unless data storage cinemalya:work args.waypoints[$(i)].duration store result storage cinemalya:work args.waypoints[$(i)].duration int 1 run scoreboard players get #share cinemalya.data

## Keep the yaw within half a turn of the previous one (a 350 degree spin becomes a 10 degree one)
$execute store result score #yaw cinemalya.data run data get storage cinemalya:work args.waypoints[$(i)].rot[0] 1000
scoreboard players operation #diff cinemalya.data = #yaw cinemalya.data
scoreboard players operation #diff cinemalya.data -= #last_yaw cinemalya.data
execute if score #diff cinemalya.data matches 180000.. run scoreboard players remove #yaw cinemalya.data 360000
execute if score #diff cinemalya.data matches ..-180000 run scoreboard players add #yaw cinemalya.data 360000
$execute store result storage cinemalya:work args.waypoints[$(i)].rot[0] float 0.001 run scoreboard players get #yaw cinemalya.data
scoreboard players operation #last_yaw cinemalya.data = #yaw cinemalya.data
$data modify storage cinemalya:work last_rot set from storage cinemalya:work args.waypoints[$(i)].rot

