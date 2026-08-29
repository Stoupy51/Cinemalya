
#> cinemalya:v1.0.1/playback/restore_gamemode
#
# @executed	at @s & positioned ~ ~-1.6 ~
#
# @within	cinemalya:v1.0.1/playback/release [ at @s & positioned ~ ~-1.6 ~ ]
#			cinemalya:v1.0.1/playback/stop_one
#
# @description		Put the player back in whatever gamemode they were in when the cinematic started.
#

execute if entity @s[tag=cinemalya.keep_gamemode] run return 0
execute if entity @s[tag=cinemalya.was_survival] run gamemode survival @a[distance=0,tag=cinemalya.temp,limit=1]
execute if entity @s[tag=cinemalya.was_adventure] run gamemode adventure @a[distance=0,tag=cinemalya.temp,limit=1]
execute if entity @s[tag=cinemalya.was_creative] run gamemode creative @a[distance=0,tag=cinemalya.temp,limit=1]

