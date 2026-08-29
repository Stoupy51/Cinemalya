
#> cinemalya:v1.0.1/travel/tags/main
#
# @executed	as the cinematic entity
#
# @within	cinemalya:v1.0.1/travel/spawn
#
# @description		Apply every tag the caller asked for on top of the conventional ones.
#

execute store result score #tag_count cinemalya.data run data get storage cinemalya:work args.tags
execute if score #tag_count cinemalya.data matches 33.. run scoreboard players set #tag_count cinemalya.data 32
scoreboard players set #t cinemalya.data 0
function cinemalya:v1.0.1/travel/tags/loop

