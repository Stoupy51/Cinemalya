
#> cinemalya:v1.0.2/travel/attach
#
# @executed	as the cinematic entity
#
# @within	cinemalya:v1.0.2/travel/spawn
#
# @description		Bind the launching player to this cinematic and hand them over to the camera.
#

execute unless entity @s[tag=cinemalya.keep_gamemode] run function cinemalya:v1.0.2/travel/remember_gamemode
scoreboard players operation @p[tag=cinemalya.temp] cinemalya.id = @s cinemalya.id
gamemode spectator @p[tag=cinemalya.temp]
spectate @s @p[tag=cinemalya.temp]

