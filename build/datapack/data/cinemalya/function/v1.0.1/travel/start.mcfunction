
#> cinemalya:v1.0.1/travel/start
#
# @executed	as & at the player,or anywhere at all for a detached camera
#
# @within	cinemalya:v1.0.1/travel/from_coords
#			cinemalya:v1.0.1/travel/from_entity
#			cinemalya:v1.0.1/travel/from_here
#			cinemalya:v1.0.1/travel/from_waypoints
#
# @description		Build the path, then summon the display entity that carries the player along it.
#

# The waypoint count drives three separate loops, so an oversized path is refused rather than truncated
execute store result score #count cinemalya.data run data get storage cinemalya:work args.waypoints
execute if score #count cinemalya.data matches 129.. run return fail

# One cinematic per player: a second launch replaces the first instead of fighting over the camera
execute unless score #mode cinemalya.data matches 2 run function cinemalya:v1.0.1/playback/stop_silent

## Build the path
function cinemalya:v1.0.1/travel/waypoints/normalize
function cinemalya:v1.0.1/travel/control/main
function cinemalya:v1.0.1/travel/sample/main
function cinemalya:v1.0.1/travel/frames/main

## Hand over to the entity, tagging the player so the summoned entity can find them
execute unless score #mode cinemalya.data matches 2 run function #cinemalya:v1/signals/on_launch
execute unless score #mode cinemalya.data matches 2 run tag @s add cinemalya.temp
execute summon item_display run function cinemalya:v1.0.1/travel/spawn
execute unless score #mode cinemalya.data matches 2 run tag @s remove cinemalya.temp

