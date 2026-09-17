
#> cinemalya:v1.0.4/travel/waypoints/override_rotation
#
# @within	cinemalya:v1.0.4/travel/waypoints/target_here
#			cinemalya:v1.0.4/travel/waypoints/target_from_coords
#			cinemalya:v1.0.4/travel/waypoints/target_from_entity
#
# @description		Apply the caller's yaw and pitch on top of whatever rotation the target had.
#

execute if data storage cinemalya:work args.yaw store result score #n cinemalya.data run data get storage cinemalya:work args.yaw 1000
execute if data storage cinemalya:work args.yaw store result storage cinemalya:work wp.rot[0] float 0.001 run scoreboard players get #n cinemalya.data
execute if data storage cinemalya:work args.pitch store result score #n cinemalya.data run data get storage cinemalya:work args.pitch 1000
execute if data storage cinemalya:work args.pitch store result storage cinemalya:work wp.rot[1] float 0.001 run scoreboard players get #n cinemalya.data

