
#> cinemalya:v1.0.3/playback/stop_for_player
#
# @executed	as the player
#
# @within	cinemalya:v1.0.3/playback/stop
#			cinemalya:v1.0.3/playback/stop_silent
#
# @description		A player who never rode a cinematic has no id at all, and copying an unset score
# 				leaves #player_id on its previous value, which would target somebody else's camera.
#

execute unless score @s cinemalya.id = @s cinemalya.id run return 0
scoreboard players operation #player_id cinemalya.id = @s cinemalya.id
tag @s add cinemalya.temp
execute as @e[type=item_display,tag=cinemalya.cinematic,predicate=cinemalya:has_same_id] run function cinemalya:v1.0.3/playback/stop_one
tag @s remove cinemalya.temp

