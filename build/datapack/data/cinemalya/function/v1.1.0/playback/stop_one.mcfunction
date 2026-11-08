
#> cinemalya:v1.1.0/playback/stop_one
#
# @executed	as @e[type=item_display,tag=cinemalya.cinematic,predicate=cinemalya:has_same_id]
#
# @within	cinemalya:v1.1.0/playback/stop_for_player [ as @e[type=item_display,tag=cinemalya.cinematic,predicate=cinemalya:has_same_id] ]
#

execute if score #restore cinemalya.data matches 1 run function cinemalya:v1.1.0/playback/restore_gamemode
execute if score #restore cinemalya.data matches 0 run function cinemalya:v1.1.0/playback/carry_gamemode
function cinemalya:v1.1.0/playback/kill

