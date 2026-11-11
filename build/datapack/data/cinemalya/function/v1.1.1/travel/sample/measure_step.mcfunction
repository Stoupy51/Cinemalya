
#> cinemalya:v1.1.1/travel/sample/measure_step
#
# @within	cinemalya:v1.1.1/travel/sample/measure
#			cinemalya:v1.1.1/travel/sample/measure_step
#

execute store result score #delta_x cinemalya.data run data get storage cinemalya:work measure[1][0] 100
execute store result score #delta_y cinemalya.data run data get storage cinemalya:work measure[1][1] 100
execute store result score #delta_z cinemalya.data run data get storage cinemalya:work measure[1][2] 100
scoreboard players operation #delta_x cinemalya.data -= #prev_x cinemalya.data
scoreboard players operation #delta_y cinemalya.data -= #prev_y cinemalya.data
scoreboard players operation #delta_z cinemalya.data -= #prev_z cinemalya.data
scoreboard players operation #prev_x cinemalya.data += #delta_x cinemalya.data
scoreboard players operation #prev_y cinemalya.data += #delta_y cinemalya.data
scoreboard players operation #prev_z cinemalya.data += #delta_z cinemalya.data
scoreboard players operation #delta_x cinemalya.data *= #delta_x cinemalya.data
scoreboard players operation #delta_y cinemalya.data *= #delta_y cinemalya.data
scoreboard players operation #delta_z cinemalya.data *= #delta_z cinemalya.data
scoreboard players operation #sq cinemalya.data = #delta_x cinemalya.data
scoreboard players operation #sq cinemalya.data += #delta_y cinemalya.data
scoreboard players operation #sq cinemalya.data += #delta_z cinemalya.data
execute if score #sq cinemalya.data matches 1.. run function cinemalya:v1.1.1/travel/sample/root
scoreboard players add #length cinemalya.data 1
data modify storage cinemalya:work lengths append value 0
execute store result storage cinemalya:work lengths[-1] int 1 run scoreboard players get #length cinemalya.data

data remove storage cinemalya:work measure[0]
scoreboard players add #i cinemalya.data 1
execute if score #next cinemalya.data <= #i cinemalya.data run function cinemalya:v1.1.1/travel/sample/bound
execute if data storage cinemalya:work measure[1] run function cinemalya:v1.1.1/travel/sample/measure_step

