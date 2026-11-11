
#> cinemalya:v1.1.1/travel/attach
#
# @executed	as the cinematic entity
#
# @within	cinemalya:v1.1.1/travel/spawn
#
# @description		Bind the launching player to this cinematic and hand them over to the camera.
#

execute unless entity @s[tag=cinemalya.keep_gamemode] run function cinemalya:v1.1.1/travel/remember_gamemode
scoreboard players operation @p[tag=cinemalya.temp] cinemalya.id = @s cinemalya.id

# As the player: a gamemode set by anyone else is announced in their chat
execute as @p[tag=cinemalya.temp] run gamemode spectator @s
spectate @s @p[tag=cinemalya.temp]

