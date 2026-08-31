
#> cinemalya:v1.0.2/playback/kill
#
# @executed	at @s
#
# @within	cinemalya:v1.0.2/playback/tick
#			cinemalya:v1.0.2/playback/finish
#			cinemalya:v1.0.2/playback/stop_one
#
# @description		Dispose of the camera and the path it was flying, keeping #entities in step.
#

scoreboard players remove #entities cinemalya.data 1
execute store result storage cinemalya:work sel.i int 1 run scoreboard players get @s cinemalya.id
function cinemalya:v1.0.2/playback/clear_path with storage cinemalya:work sel
kill @s

