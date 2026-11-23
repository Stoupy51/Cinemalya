
#> cinemalya:v1.1.3/playback/land_jump
#
# @executed	at @s
#
# @within	cinemalya:v1.1.3/playback/count_pop {i:$(i)}
#
# @args		i (unknown)
#
# @input macro		i : int - the cinematic id
# 
# @description		Restore the glide, hold the camera for the ticks the jump asked for, then arm the next jump if any.
#

execute store result entity @s teleport_duration int 1 run scoreboard players get @s cinemalya.smoothing
$execute store result score @s cinemalya.delay run data get storage cinemalya:work paths.i$(i).cuts[0].delay
$data remove storage cinemalya:work paths.i$(i).cuts[0]
$execute store result score @s cinemalya.cut run data get storage cinemalya:work paths.i$(i).cuts[0].at

