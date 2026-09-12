
#> cinemalya:v1.0.3/travel/control/main
#
# @within	cinemalya:v1.0.3/travel/start
#
# @output storage	cinemalya:work control, cinemalya:work rot_control
# 
# @description		Two waypoints get a bezier bending through an arc point, more get a catmull-rom
# 				passing through every one of them. The caller can force either with `spline`.
#

data modify storage cinemalya:work control set value {points:[],step:1.0d}
data modify storage cinemalya:work rot_control set value {points:[],step:1.0d}

## Pick the curve
scoreboard players set #curve cinemalya.data 0
execute if score #segments cinemalya.data matches 2.. run scoreboard players set #curve cinemalya.data 1
execute if data storage cinemalya:work args{spline:"bezier"} run scoreboard players set #curve cinemalya.data 0
execute if data storage cinemalya:work args{spline:"catmull_rom"} run scoreboard players set #curve cinemalya.data 1

execute if score #curve cinemalya.data matches 0 run function cinemalya:v1.0.3/travel/control/arc
execute if score #curve cinemalya.data matches 1 run function cinemalya:v1.0.3/travel/control/through

