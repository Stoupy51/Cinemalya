
#> cinemalya:v1.0.0/travel/defaults
#
# @within	cinemalya:v1.0.0/travel/from_coords
#			cinemalya:v1.0.0/travel/from_entity
#			cinemalya:v1.0.0/travel/from_waypoints
#
# @output score		#duration, #smoothing, #mode, #ease cinemalya.data
# 
# @description		Complete the caller's arguments so the rest of the pipeline never tests for absence.
#

## Optional arguments
execute unless data storage cinemalya:work args.duration run data modify storage cinemalya:work args.duration set value 60
execute unless data storage cinemalya:work args.smoothing run data modify storage cinemalya:work args.smoothing set value 2
execute unless data storage cinemalya:work args.delay run data modify storage cinemalya:work args.delay set value 0
execute unless data storage cinemalya:work args.arc_side run data modify storage cinemalya:work args.arc_side set value 0.0
execute unless data storage cinemalya:work args.arc_height run data modify storage cinemalya:work args.arc_height set value 20.0
execute unless data storage cinemalya:work args.tags run data modify storage cinemalya:work args.tags set value []

## Easing curve
scoreboard players set #ease cinemalya.data 0
execute if data storage cinemalya:work args{ease:"ease_in"} run scoreboard players set #ease cinemalya.data 1
execute if data storage cinemalya:work args{ease:"ease_out"} run scoreboard players set #ease cinemalya.data 2
execute if data storage cinemalya:work args{ease:"ease_in_out"} run scoreboard players set #ease cinemalya.data 3

## What to do with the player's gamemode (0 = remember and restore, 1 = leave alone, 2 = no player at all)
scoreboard players set #mode cinemalya.data 0
execute if data storage cinemalya:work args{gamemode:"keep"} run scoreboard players set #mode cinemalya.data 1
execute if data storage cinemalya:work args{gamemode:"none"} run scoreboard players set #mode cinemalya.data 2

## Timing, clamped so a zero can never divide anything later on
execute store result score #duration cinemalya.data run data get storage cinemalya:work args.duration
execute store result score #smoothing cinemalya.data run data get storage cinemalya:work args.smoothing
execute if score #duration cinemalya.data matches ..0 run scoreboard players set #duration cinemalya.data 1
execute if score #smoothing cinemalya.data matches ..0 run scoreboard players set #smoothing cinemalya.data 1

