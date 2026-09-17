
#> cinemalya:v1.0.4/travel/control/collect_one
#
# @within	cinemalya:v1.0.4/travel/control/collect_loop
#

execute store result storage cinemalya:work sel.i int 1 run scoreboard players get #w cinemalya.data
function cinemalya:v1.0.4/travel/control/collect with storage cinemalya:work sel
scoreboard players add #w cinemalya.data 1
function cinemalya:v1.0.4/travel/control/collect_loop

