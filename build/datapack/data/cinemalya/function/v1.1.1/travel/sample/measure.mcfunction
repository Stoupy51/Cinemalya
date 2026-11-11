
#> cinemalya:v1.1.1/travel/sample/measure
#
# @within	cinemalya:v1.1.1/travel/sample/main
#
# @output storage	cinemalya:work lengths : the arc length from the start to every sample, in hundredths of a block
# @output storage	cinemalya:work bounds : the same at every waypoint
# @output score		#shared_length, #shared_count cinemalya.data : the length and number of segments without a duration
# 
# @description		Every sample interval also counts one hundredth, so a camera turning on the spot still
# 				moves through its samples instead of sitting on a path of length zero.
#

data modify storage cinemalya:work measure set from storage cinemalya:work samples
data modify storage cinemalya:work lengths set value [0]
data modify storage cinemalya:work bounds set value [0]
scoreboard players set #length cinemalya.data 0
scoreboard players set #bound_length cinemalya.data 0
scoreboard players set #shared_length cinemalya.data 0
scoreboard players set #shared_count cinemalya.data 0
scoreboard players set #root cinemalya.data 1
scoreboard players set #i cinemalya.data 0
scoreboard players set #k cinemalya.data 0
function cinemalya:v1.1.1/travel/sample/next_bound
execute store result score #prev_x cinemalya.data run data get storage cinemalya:work measure[0][0] 100
execute store result score #prev_y cinemalya.data run data get storage cinemalya:work measure[0][1] 100
execute store result score #prev_z cinemalya.data run data get storage cinemalya:work measure[0][2] 100
execute if data storage cinemalya:work measure[1] run function cinemalya:v1.1.1/travel/sample/measure_step

