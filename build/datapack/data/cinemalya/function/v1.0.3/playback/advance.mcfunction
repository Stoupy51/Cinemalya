
#> cinemalya:v1.0.3/playback/advance
#
# @executed	at @s
#
# @within	cinemalya:v1.0.3/playback/tick
#			cinemalya:v1.0.3/playback/at_player
#
# @description		Burn a tick of the opening delay, or step onto the next frame once enough ticks
# 				have passed for the client to have finished interpolating the previous one.
#

# Hold still while the opening delay runs down
execute if score @s cinemalya.delay matches 1.. run return run scoreboard players remove @s cinemalya.delay 1

# Only move once per `smoothing` ticks
scoreboard players add @s cinemalya.frame 1
execute if score @s cinemalya.frame < @s cinemalya.smoothing run return 0
scoreboard players set @s cinemalya.frame 0

execute store result storage cinemalya:work sel.i int 1 run scoreboard players get @s cinemalya.id
function cinemalya:v1.0.3/playback/pop with storage cinemalya:work sel

