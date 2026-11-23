
#> cinemalya:v1.1.3/travel/protect
#
# @executed	as the cinematic entity
#
# @within	cinemalya:v1.1.3/travel/attach
#
# @description		Make the rider immune to damage for as long as the cinematic can last, plus a margin.
# 				The effect is cleared when it ends, which also clears a resistance the player already had.
#

tag @s add cinemalya.protect
execute store result score #protect_ticks cinemalya.data run data get storage cinemalya:work frames.points
scoreboard players operation #protect_ticks cinemalya.data *= #smoothing cinemalya.data
scoreboard players operation #protect_ticks cinemalya.data += #hold_total cinemalya.data
scoreboard players operation #protect_ticks cinemalya.data /= #20 cinemalya.data
scoreboard players add #protect_ticks cinemalya.data 3
execute store result storage cinemalya:work sel.seconds int 1 run scoreboard players get #protect_ticks cinemalya.data
function cinemalya:v1.1.3/travel/protect_rider with storage cinemalya:work sel

