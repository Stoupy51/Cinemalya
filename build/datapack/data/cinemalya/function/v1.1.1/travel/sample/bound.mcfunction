
#> cinemalya:v1.1.1/travel/sample/bound
#
# @within	cinemalya:v1.1.1/travel/sample/measure_step
#			cinemalya:v1.1.1/travel/sample/bound
#
# @description		Record the arc length at waypoint #k, then look for the next one, which may share this sample.
#

execute store result storage cinemalya:work sel.i int 1 run scoreboard players get #k cinemalya.data
function cinemalya:v1.1.1/travel/sample/count_shared with storage cinemalya:work sel
data modify storage cinemalya:work bounds append value 0
execute store result storage cinemalya:work bounds[-1] int 1 run scoreboard players get #length cinemalya.data
scoreboard players operation #bound_length cinemalya.data = #length cinemalya.data
function cinemalya:v1.1.1/travel/sample/next_bound
execute if score #next cinemalya.data <= #i cinemalya.data run function cinemalya:v1.1.1/travel/sample/bound

