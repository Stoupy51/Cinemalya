
#> cinemalya:v1.0.3/playback/release
#
# @executed	at @s
#
# @within	cinemalya:v1.0.3/playback/finish
#
# @description		Drop the player where the camera stopped, at their feet rather than their eyes,
# 				give them their gamemode back, then let other datapacks react.
#

execute at @s run tp @a[tag=cinemalya.temp,limit=1] ~ ~-1.6 ~ ~ ~
execute at @s positioned ~ ~-1.6 ~ run function cinemalya:v1.0.3/playback/restore_gamemode
execute at @s positioned ~ ~-1.6 ~ as @a[distance=0,tag=cinemalya.temp,limit=1] at @s run function #cinemalya:v1/signals/on_finish

