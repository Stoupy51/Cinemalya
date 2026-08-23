
#> cinemalya:v1.0.0/travel/waypoints/raise_eyes
#
# @within	cinemalya:v1.0.0/travel/waypoints/target_here
#			cinemalya:v1.0.0/travel/waypoints/start_here
#			cinemalya:v1.0.0/travel/waypoints/prepend_here
#			cinemalya:v1.0.0/travel/waypoints/target_from_entity
#			cinemalya:v1.0.0/intro/read_shot
#			cinemalya:v1.0.0/intro/one_player
#
# @description		Lift the pending waypoint from the feet to the eyes, so the camera never starts inside the ground.
#

execute store result score #n cinemalya.data run data get storage cinemalya:work wp.pos[1] 1000
scoreboard players add #n cinemalya.data 1600
execute store result storage cinemalya:work wp.pos[1] double 0.001 run scoreboard players get #n cinemalya.data

