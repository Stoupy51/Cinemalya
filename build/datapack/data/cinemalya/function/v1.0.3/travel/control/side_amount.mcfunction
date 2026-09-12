
#> cinemalya:v1.0.3/travel/control/side_amount
#
# @within	cinemalya:v1.0.3/travel/control/mid_point
#
# @output storage	cinemalya:work forward : macro arguments for the sidestep
# 
# @description		Half of the dominant horizontal offset, scaled by arc_side. The camera swings
# 				towards the outside of the turn, so it keeps the destination in frame.
#

## Magnitude of the travel, on whichever horizontal axis dominates
scoreboard players operation #adx cinemalya.data = #dx cinemalya.data
execute if score #adx cinemalya.data matches ..-1 run scoreboard players operation #adx cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #adz cinemalya.data = #dz cinemalya.data
execute if score #adz cinemalya.data matches ..-1 run scoreboard players operation #adz cinemalya.data *= #-1 cinemalya.data
scoreboard players operation #amount cinemalya.data = #adx cinemalya.data
execute if score #adz cinemalya.data > #adx cinemalya.data run scoreboard players operation #amount cinemalya.data = #adz cinemalya.data
scoreboard players operation #amount cinemalya.data /= #2 cinemalya.data
scoreboard players operation #amount cinemalya.data *= #side cinemalya.data

## Which way to swing, following the direction the camera is already turning
scoreboard players operation #yaw_diff cinemalya.data = #last_yaw cinemalya.data
execute store result score #n cinemalya.data run data get storage cinemalya:work args.waypoints[0].rot[0] 1000
scoreboard players operation #yaw_diff cinemalya.data -= #n cinemalya.data

data modify storage cinemalya:work forward set value {amount:0.0d,turn:90,tx:0.0d,ty:0.0d,tz:0.0d}
execute store result storage cinemalya:work forward.amount double 0.000001 run scoreboard players get #amount cinemalya.data
execute if score #yaw_diff cinemalya.data matches 0.. run data modify storage cinemalya:work forward.turn set value -90
data modify storage cinemalya:work forward.tx set from storage cinemalya:work args.waypoints[-1].pos[0]
data modify storage cinemalya:work forward.ty set from storage cinemalya:work mid[1]
data modify storage cinemalya:work forward.tz set from storage cinemalya:work args.waypoints[-1].pos[2]

