
#> cinemalya:v1.0.1/playback/particle
#
# @executed	at @s
#
# @within	cinemalya:v1.0.1/playback/pop
#

data modify storage cinemalya:work trail set from entity @s item.components."minecraft:custom_data"
execute at @s run function cinemalya:v1.0.1/playback/spawn_particle with storage cinemalya:work trail

