
#> cinemalya:v1.0.3/playback/finish
#
# @executed	at @s
#
# @within	cinemalya:v1.0.3/playback/pop
#
# @description		The path ran out: put the rider down and dispose of the camera.
#

execute unless entity @s[tag=cinemalya.detached] run function cinemalya:v1.0.3/playback/release
function cinemalya:v1.0.3/playback/kill

