
#> cinemalya:v1.0.0/travel/waypoints/normalize
#
# @within	cinemalya:v1.0.0/travel/start
#
# @output score		#segments, #share cinemalya.data
# 
# @description		Give every waypoint a rotation and a duration, and unwrap the yaws so the camera
# 				always turns the short way round instead of spinning most of a circle.
#

## One segment per gap between waypoints, each getting an equal share of the total by default
execute store result score #count cinemalya.data run data get storage cinemalya:work args.waypoints
scoreboard players operation #segments cinemalya.data = #count cinemalya.data
scoreboard players remove #segments cinemalya.data 1
execute if score #segments cinemalya.data matches ..0 run scoreboard players set #segments cinemalya.data 1
scoreboard players operation #share cinemalya.data = #duration cinemalya.data
scoreboard players operation #share cinemalya.data /= #segments cinemalya.data
execute if score #share cinemalya.data matches ..0 run scoreboard players set #share cinemalya.data 1

## Relative waypoint coordinates resolve against wherever the caller was executing
function cinemalya:v1.0.0/travel/waypoints/open_anchor

## Seed the running rotation, so a waypoint without one simply keeps the previous heading
data modify storage cinemalya:work last_rot set value [0.0f,0.0f]
execute unless score #mode cinemalya.data matches 2 run data modify storage cinemalya:work last_rot set from entity @s Rotation
execute if data storage cinemalya:work args.waypoints[0].rot run data modify storage cinemalya:work last_rot set from storage cinemalya:work args.waypoints[0].rot
execute store result score #last_yaw cinemalya.data run data get storage cinemalya:work last_rot[0] 1000

scoreboard players set #w cinemalya.data 0
function cinemalya:v1.0.0/travel/waypoints/normalize_loop
function cinemalya:v1.0.0/travel/waypoints/close_anchor

