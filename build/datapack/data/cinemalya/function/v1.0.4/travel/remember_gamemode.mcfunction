
#> cinemalya:v1.0.4/travel/remember_gamemode
#
# @executed	as the cinematic entity
#
# @within	cinemalya:v1.0.4/travel/attach
#
# @description		Store the player's gamemode on the entity, so it survives them disconnecting mid-flight.
#

execute if entity @p[tag=cinemalya.temp,gamemode=survival] run tag @s add cinemalya.was_survival
execute if entity @p[tag=cinemalya.temp,gamemode=adventure] run tag @s add cinemalya.was_adventure
execute if entity @p[tag=cinemalya.temp,gamemode=creative] run tag @s add cinemalya.was_creative

