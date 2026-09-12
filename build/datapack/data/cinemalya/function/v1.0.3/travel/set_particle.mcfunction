
#> cinemalya:v1.0.3/travel/set_particle
#
# @executed	as the cinematic entity
#
# @within	cinemalya:v1.0.3/travel/spawn
#
# @description		Remember the particle to trail behind the camera. The tag keeps playback from reading NBT for nothing.
#

tag @s add cinemalya.particle
data modify entity @s item.components."minecraft:custom_data".particle set from storage cinemalya:work args.particle

