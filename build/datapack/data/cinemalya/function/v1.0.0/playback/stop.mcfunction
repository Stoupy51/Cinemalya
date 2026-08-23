
#> cinemalya:v1.0.0/playback/stop
#
# @executed	as the player
#
# @within	cinemalya:v1.0.0/api/stop {with:$(with)}
#
# @args		with (unknown)
#
# @input macro		with : compound - {restore: bool}, whether to hand the gamemode back (default: true)
# 
# @description		End the cinematic the player is riding, if any. The player is left exactly where
# 				the camera was, so the caller decides where they actually belong.
#

$data modify storage cinemalya:work stop set value $(with)
scoreboard players set #restore cinemalya.data 1
execute if data storage cinemalya:work stop{restore:false} run scoreboard players set #restore cinemalya.data 0
function cinemalya:v1.0.0/playback/stop_for_player

