
#> cinemalya:v1.2.1/travel/start
#
# @executed	as & at the player,or anywhere at all for a detached camera
#
# @within	cinemalya:v1.2.1/travel/from_coords
#			cinemalya:v1.2.1/travel/from_entity
#			cinemalya:v1.2.1/travel/from_here
#			cinemalya:v1.2.1/travel/from_waypoints
#
# @description		Build the path, then summon the display entity that carries the player along it.
#

# The waypoint count drives three separate loops, so an oversized path is refused rather than truncated
execute store result score #count cinemalya.data run data get storage cinemalya:work args.waypoints
execute if score #count cinemalya.data matches 129.. run return run tellraw @s[type=player] {text:"Cinemalya: a path takes at most 128 waypoints",color:"red"}

# One cinematic per player: a second launch replaces the first instead of fighting over the camera
execute unless score #mode cinemalya.data matches 2 run function cinemalya:v1.2.1/playback/stop_silent

## Build the path, cut where a waypoint is reached by teleport
scoreboard players set #pieces cinemalya.data 1
execute if data storage cinemalya:work args.waypoints[{tp:true}] run function cinemalya:v1.2.1/travel/pieces/count
execute if score #pieces cinemalya.data matches 9.. run return run tellraw @s[type=player] {text:"Cinemalya: a path takes at most 8 pieces, which is 7 teleports",color:"red"}
function cinemalya:v1.2.1/travel/waypoints/normalize
scoreboard players set #launch_budget cinemalya.data 60000
scoreboard players set #frame_offset cinemalya.data 0
scoreboard players set #first_at cinemalya.data 1
scoreboard players set #hold_total cinemalya.data 0
scoreboard players set #wp_offset cinemalya.data 0
execute if score #pieces cinemalya.data matches 2.. run function cinemalya:v1.2.1/travel/pieces/main
execute if score #pieces cinemalya.data matches 1 run function cinemalya:v1.2.1/travel/control/main
execute if score #pieces cinemalya.data matches 1 run function cinemalya:v1.2.1/travel/sample/main
execute if score #pieces cinemalya.data matches 1 run function cinemalya:v1.2.1/travel/frames/main

## Hand over to the entity, tagging the player so the summoned entity can find them
execute unless score #mode cinemalya.data matches 2 run function #cinemalya:v1/signals/on_launch
execute unless score #mode cinemalya.data matches 2 run tag @s add cinemalya.temp
execute summon item_display run function cinemalya:v1.2.1/travel/spawn
execute unless score #mode cinemalya.data matches 2 run tag @s remove cinemalya.temp

