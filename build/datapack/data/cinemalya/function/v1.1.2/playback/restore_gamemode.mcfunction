
#> cinemalya:v1.1.2/playback/restore_gamemode
#
# @executed	at @s & positioned ~ ~-1.6 ~
#
# @within	cinemalya:v1.1.2/playback/release [ at @s & positioned ~ ~-1.6 ~ ]
#			cinemalya:v1.1.2/playback/stop_one
#
# @description		Put the player back in whatever gamemode they were in when the cinematic started.
#

execute if entity @s[tag=cinemalya.keep_gamemode] run return 0

# As the rider: a gamemode set by anyone else is announced in their chat
execute if entity @s[tag=cinemalya.was_survival] as @a[distance=0,tag=cinemalya.temp,limit=1] run gamemode survival @s
execute if entity @s[tag=cinemalya.was_adventure] as @a[distance=0,tag=cinemalya.temp,limit=1] run gamemode adventure @s
execute if entity @s[tag=cinemalya.was_creative] as @a[distance=0,tag=cinemalya.temp,limit=1] run gamemode creative @s

