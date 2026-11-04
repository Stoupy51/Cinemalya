
#> cinemalya:v1.1.0/travel/frames/load_interval
#
# @within	cinemalya:v1.1.0/travel/frames/main
#			cinemalya:v1.1.0/travel/frames/walk
#
# @description		Read the interval between the first two samples left as a start and a step per axis,
# 				in thousandths, so every frame landing in it costs no storage read.
#

execute store result score #from_x cinemalya.data run data get storage cinemalya:work samples[0][0] 1000
execute store result score #from_y cinemalya.data run data get storage cinemalya:work samples[0][1] 1000
execute store result score #from_z cinemalya.data run data get storage cinemalya:work samples[0][2] 1000
execute store result score #from_yaw cinemalya.data run data get storage cinemalya:work rot_samples[0][0] 1000
execute store result score #from_pitch cinemalya.data run data get storage cinemalya:work rot_samples[0][1] 1000
execute store result score #step_x cinemalya.data run data get storage cinemalya:work samples[1][0] 1000
execute store result score #step_y cinemalya.data run data get storage cinemalya:work samples[1][1] 1000
execute store result score #step_z cinemalya.data run data get storage cinemalya:work samples[1][2] 1000
execute store result score #step_yaw cinemalya.data run data get storage cinemalya:work rot_samples[1][0] 1000
execute store result score #step_pitch cinemalya.data run data get storage cinemalya:work rot_samples[1][1] 1000
scoreboard players operation #step_x cinemalya.data -= #from_x cinemalya.data
scoreboard players operation #step_y cinemalya.data -= #from_y cinemalya.data
scoreboard players operation #step_z cinemalya.data -= #from_z cinemalya.data
scoreboard players operation #step_yaw cinemalya.data -= #from_yaw cinemalya.data
scoreboard players operation #step_pitch cinemalya.data -= #from_pitch cinemalya.data
scoreboard players operation #interval cinemalya.data = #to_length cinemalya.data
scoreboard players operation #interval cinemalya.data -= #from_length cinemalya.data

