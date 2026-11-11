
#> cinemalya:v1.1.2/travel/waypoints/normalize
#
# @within	cinemalya:v1.1.2/travel/start
#
# @output score		#segments cinemalya.data
# 
# @description		Give every waypoint a rotation, and unwrap the yaws so the camera always turns the
# 				short way round instead of spinning most of a circle.
#

## One segment per gap between waypoints
execute store result score #count cinemalya.data run data get storage cinemalya:work args.waypoints
scoreboard players operation #segments cinemalya.data = #count cinemalya.data
scoreboard players remove #segments cinemalya.data 1
execute if score #segments cinemalya.data matches ..0 run scoreboard players set #segments cinemalya.data 1

## Seed the running rotation, so a waypoint without one simply keeps the previous heading
data modify storage cinemalya:work last_rot set value [0.0f,0.0f]
execute unless score #mode cinemalya.data matches 2 run data modify storage cinemalya:work last_rot set from entity @s Rotation
execute if data storage cinemalya:work args.waypoints[0].rot run data modify storage cinemalya:work last_rot set from storage cinemalya:work args.waypoints[0].rot
execute store result score #last_yaw cinemalya.data run data get storage cinemalya:work last_rot[0] 1000

scoreboard players set #w cinemalya.data 0
function cinemalya:v1.1.2/travel/waypoints/normalize_loop

