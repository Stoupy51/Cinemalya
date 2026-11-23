
#> cinemalya:v1.1.3/playback/release
#
# @executed	at @s
#
# @within	cinemalya:v1.1.3/playback/finish
#
# @description		Drop the player where the camera stopped, at their feet rather than their eyes,
# 				give them their gamemode back, then let other datapacks react.
#

execute if entity @s[tag=cinemalya.protect] run effect clear @a[tag=cinemalya.temp,limit=1] minecraft:resistance
execute if entity @s[tag=cinemalya.ride] run ride @a[tag=cinemalya.temp,limit=1] dismount
execute if entity @s[tag=cinemalya.ride] at @s run tp @a[tag=cinemalya.temp,limit=1] ~ ~-0.6 ~ ~ ~
execute unless entity @s[tag=cinemalya.ride] at @s run tp @a[tag=cinemalya.temp,limit=1] ~ ~-1.6 ~ ~ ~
function cinemalya:v1.1.3/playback/restore_gamemode
execute as @a[tag=cinemalya.temp,limit=1] at @s run function #cinemalya:v1/signals/on_finish

