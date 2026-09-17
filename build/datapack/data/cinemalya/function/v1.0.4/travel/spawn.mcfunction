
#> cinemalya:v1.0.4/travel/spawn
#
# @executed	as the freshly summoned item_display & at the launch position
#
# @within	cinemalya:v1.0.4/travel/start
#
# @description		Register the cinematic, store its path, then attach the player to it.
#

## Identity and conventions
scoreboard players add #next_id cinemalya.id 1
scoreboard players operation @s cinemalya.id = #next_id cinemalya.id
scoreboard players add #entities cinemalya.data 1
tag @s add cinemalya.cinematic
tag @s add smithed.entity
tag @s add smithed.strict
tag @s add global.ignore
tag @s add global.ignore.kill
execute if score #precise cinemalya.data matches 1 run tag @s add cinemalya.precise
function cinemalya:v1.0.4/travel/tags/main

## Timing state, and the client-side interpolation that hides the per-frame jumps
scoreboard players operation @s cinemalya.smoothing = #smoothing cinemalya.data
scoreboard players set @s cinemalya.frame 0
execute store result score @s cinemalya.delay run data get storage cinemalya:work args.delay
execute store result entity @s teleport_duration int 1 run scoreboard players get #smoothing cinemalya.data

## Start on the first waypoint, holding an item that renders nothing
data modify entity @s Pos set from storage cinemalya:work args.waypoints[0].pos
data modify entity @s Rotation set from storage cinemalya:work args.waypoints[0].rot
data modify entity @s item set value {id:"minecraft:stone",count:1,components:{"minecraft:item_model":"minecraft:air"}}
execute if data storage cinemalya:work args.particle run function cinemalya:v1.0.4/travel/set_particle

## Give this cinematic its own slot in the path storage
execute store result storage cinemalya:work sel.i int 1 run scoreboard players get @s cinemalya.id
function cinemalya:v1.0.4/travel/store_path with storage cinemalya:work sel

## Attach the player, unless this is a free flying camera
execute if score #mode cinemalya.data matches 2 run tag @s add cinemalya.detached
execute if score #mode cinemalya.data matches 1 run tag @s add cinemalya.keep_gamemode
execute unless score #mode cinemalya.data matches 2 run function cinemalya:v1.0.4/travel/attach

