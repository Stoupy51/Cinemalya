
#> cinemalya:v1.0.1/travel/control/mid_point
#
# @within	cinemalya:v1.0.1/travel/control/arc
#
# @output storage	cinemalya:work mid : the raised, optionally sidestepped midpoint of the travel
# 
# @description		Place the arc's control point halfway along the travel, above the higher of the
# 				two ends, and pushed sideways by a fraction of half the distance covered.
#

## Both ends, in thousandths of a block
execute store result score #sx cinemalya.data run data get storage cinemalya:work args.waypoints[0].pos[0] 1000
execute store result score #sy cinemalya.data run data get storage cinemalya:work args.waypoints[0].pos[1] 1000
execute store result score #sz cinemalya.data run data get storage cinemalya:work args.waypoints[0].pos[2] 1000
execute store result score #tx cinemalya.data run data get storage cinemalya:work args.waypoints[-1].pos[0] 1000
execute store result score #ty cinemalya.data run data get storage cinemalya:work args.waypoints[-1].pos[1] 1000
execute store result score #tz cinemalya.data run data get storage cinemalya:work args.waypoints[-1].pos[2] 1000
scoreboard players operation #dx cinemalya.data = #tx cinemalya.data
scoreboard players operation #dx cinemalya.data -= #sx cinemalya.data
scoreboard players operation #dz cinemalya.data = #tz cinemalya.data
scoreboard players operation #dz cinemalya.data -= #sz cinemalya.data

## Halfway on the horizontal plane
data modify storage cinemalya:work mid set value [0.0d,0.0d,0.0d]
scoreboard players operation #mx cinemalya.data = #dx cinemalya.data
scoreboard players operation #mx cinemalya.data /= #2 cinemalya.data
scoreboard players operation #mx cinemalya.data += #sx cinemalya.data
scoreboard players operation #mz cinemalya.data = #dz cinemalya.data
scoreboard players operation #mz cinemalya.data /= #2 cinemalya.data
scoreboard players operation #mz cinemalya.data += #sz cinemalya.data
execute store result storage cinemalya:work mid[0] double 0.001 run scoreboard players get #mx cinemalya.data
execute store result storage cinemalya:work mid[2] double 0.001 run scoreboard players get #mz cinemalya.data

## Above whichever end is higher
scoreboard players operation #my cinemalya.data = #sy cinemalya.data
execute if score #ty cinemalya.data > #my cinemalya.data run scoreboard players operation #my cinemalya.data = #ty cinemalya.data
execute store result score #n cinemalya.data run data get storage cinemalya:work args.arc_height 1000
scoreboard players operation #my cinemalya.data += #n cinemalya.data
execute store result storage cinemalya:work mid[1] double 0.001 run scoreboard players get #my cinemalya.data

## Sidestep, so the camera sweeps around the travel instead of flying straight down it
execute store result score #side cinemalya.data run data get storage cinemalya:work args.arc_side 1000
execute if score #side cinemalya.data matches 0 run return 0
function cinemalya:v1.0.1/travel/control/side_amount

# A travel straight up or down has no direction to sidestep from, and facing its own position would fail
execute if score #amount cinemalya.data matches 0 run return 0
execute summon item_display run function cinemalya:v1.0.1/travel/control/side_offset with storage cinemalya:work forward

