
#> cinemalya:v1.1.0/playback/carry_gamemode
#
# @executed	as @e[type=item_display,tag=cinemalya.cinematic,predicate=cinemalya:has_same_id]
#
# @within	cinemalya:v1.1.0/playback/stop_one
#
# @description		The rider is still a spectator and the camera is about to be killed: park the gamemode it remembered on the player,
# 				so that a cinematic launched right after still knows what to give back.
#

execute if entity @s[tag=cinemalya.was_survival] run tag @a[tag=cinemalya.temp,limit=1] add cinemalya.carry_survival
execute if entity @s[tag=cinemalya.was_adventure] run tag @a[tag=cinemalya.temp,limit=1] add cinemalya.carry_adventure
execute if entity @s[tag=cinemalya.was_creative] run tag @a[tag=cinemalya.temp,limit=1] add cinemalya.carry_creative

