
#> cinemalya:v1.0.4/playback/pop
#
# @executed	at @s
#
# @within	cinemalya:v1.0.4/playback/advance with storage cinemalya:work sel
#
# @args		i (unknown)
#
# @input macro		i : int - the cinematic id
# 
# @description		Take the next frame off this cinematic's path and move onto it. Popping keeps the
# 				work per tick constant no matter how long the path is.
#

$data modify entity @s Pos set from storage cinemalya:work paths.i$(i).points[0]
$data remove storage cinemalya:work paths.i$(i).points[0]
$data modify entity @s Rotation set from storage cinemalya:work paths.i$(i).rotations[0]
$data remove storage cinemalya:work paths.i$(i).rotations[0]
execute if entity @s[tag=cinemalya.particle] run function cinemalya:v1.0.4/playback/particle
$execute unless data storage cinemalya:work paths.i$(i).points[0] run function cinemalya:v1.0.4/playback/finish

