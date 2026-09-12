
#> cinemalya:v1.0.3/travel/waypoints/target_from_coords
#
# @executed	as the player
#
# @within	cinemalya:v1.0.3/travel/from_coords
#
# @description		Close the waypoint list on the coordinates the caller asked for, at eye height.
#

data modify storage cinemalya:work wp set value {pos:[0.0d,0.0d,0.0d],rot:[0.0f,0.0f]}
execute store result score #n cinemalya.data run data get storage cinemalya:work args.x 1000
execute store result storage cinemalya:work wp.pos[0] double 0.001 run scoreboard players get #n cinemalya.data
execute store result score #n cinemalya.data run data get storage cinemalya:work args.y 1000
scoreboard players add #n cinemalya.data 1600
execute store result storage cinemalya:work wp.pos[1] double 0.001 run scoreboard players get #n cinemalya.data
execute store result score #n cinemalya.data run data get storage cinemalya:work args.z 1000
execute store result storage cinemalya:work wp.pos[2] double 0.001 run scoreboard players get #n cinemalya.data

# The player keeps looking the same way unless the caller said otherwise
data modify storage cinemalya:work wp.rot set from entity @s Rotation
function cinemalya:v1.0.3/travel/waypoints/override_rotation
data modify storage cinemalya:work args.waypoints append from storage cinemalya:work wp

